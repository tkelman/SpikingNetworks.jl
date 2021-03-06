using SpikingNetworks
using Base.Test

parseParameters"""
τₘ = 20
τₑ = 5
τᵢ = 10
Vₜ = -50
Vᵣ = -60
Eₗ = -49
N=4000;M=4*N÷5
wₑ=spzeros(N,N)
wᵢ=spzeros(N,N)
wₑ[1:N,1:M]=sprand(N,M,0.02)*(60*0.27/10)
wᵢ[1:N,M+1:N]=sprand(N,N-M,0.02)*(-20*4.5/10)"""

parseEquations"""
dv/dt=(gₑ+gᵢ-(v-Eₗ))/τₘ
dgₑ/dt=-gₑ/τₑ
dgᵢ/dt=-gᵢ/τᵢ"""

net=init"""
N=N
v=Vᵣ+rand(N)*(Vₜ-Vᵣ)
gₑ=zeros(N)
gᵢ=zeros(N)
wₑ=wₑ
wᵢ=wᵢ"""

spike"v.>Vₜ"
reset"""
v[i]=Vᵣ"""

synapse"""
gₑ+=wₑ
gᵢ+=wᵢ"""

net.dt=0.1
@time run!(net,100/net.dt)