Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab1LBRw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 12:52:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65412 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab1LBRwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:52:24 -0500
Date: Fri, 2 Dec 2011 20:56:01 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Eric Anholt <eric@anholt.net>
Subject: 3.2-rc3+: [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
 elapsed... GPU hung
Message-ID: <20111202205601.115522b1@sf.home>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hxDncaSLdo+5RCmM+HMDyma"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hxDncaSLdo+5RCmM+HMDyma
Content-Type: multipart/mixed; boundary="MP_/7P+D6MDvabUSe5j7xKYK4Ba"

--MP_/7P+D6MDvabUSe5j7xKYK4Ba
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Recently I've started to get Black Screen after some
hours of work at

    00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960=
 Integrated Graphics Controller (rev 0c)

It's a laptop+attached VGA to it.
I've gathered 2 erors states fo 2 such blackouts.

vanilla kernel:
linux-3.2.0-rc3-00099-g883381d

gentoo's userland:
xorg-1.11.2
libdrm-2.4.27
xf86-video-intel-2.17.0

Attached dmesg_1.txt for second dump, but there is nothing fancy.
The issue renders even without suspend/resume cycles. It just takes
a lot of time (0.5-2 days).

Thanks!

--=20

  Sergei

--MP_/7P+D6MDvabUSe5j7xKYK4Ba
Content-Type: application/x-gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=dri_hung_0.gz

H4sICH9Q2E4AA2RyaV9odW5nXzAApJ1Lr+3GcUbn+hVnGA8MsPrdAjJwbCMWkDiCrUECwzD66Wig
a0SSA+ffZz/YZPGc5a2LZEPQvarNbvZuflysri6Wvvn2u/Hlm1hjYo42pbcf3oIxIW1vf/3hi69/
+dXbV7/68m37mymb+eLXX/3u/vdt/3zx9T9/80//8qdfX42/G5/6+P6t/eW778qn/vbDj9+P8t2X
X7y9/eKX3/zm0ddWZMumppvtq6/f9/mw/eZpMw+Tu9t++/tvfvVvv/313Txn8LPMrsyydzFvn2X/
+vd3Y9pExmb8Mv7ru5P9MP7r01+WzQ1/H9Qcn9r4w/bHt398M6nU+zfGlrblfnwp9y/L5sr9y9uf
edvOL83jS/NouD3/PL+0zy9beH7ZvP7SPbs17tmtsfpLv3+Z9i+j/jLcv1S/62mN+8nifrJLk7R/
uQ+zXYaZsT95TEq+zfLd/PxTTco+K+KfIxR3+fY5LXuXzz/Vt8952eJzXrZ4mRdx+1hlH6tcvvWX
wf6i/fjtf4+3P9j8x7vs7lPVb/a320eCTe5+pHkc/rZf9PzWv/3+x/95+/4p3b9+aqX95+iPxrLF
d419+vzGPeyNrYnh3s65z218m930etjlxZmNl9fDftU4uvhu2Jv//DPH9xMWts9v/LhbdON4HXZ9
Oez5etgvGt9m272esPbqOrfx+jq/arzl9vrM/aXCfuLMrxobsa/PPF41ftxtL2b7VePof0JhLxp7
X5/X2UUv9imu640x3/791cAfQ39xX81XMmmrsUkhGmr8H68u1/y/n/v2JMn/j4EP//pavzpz9D9x
Z71qvG3v7+l3QHj5m3N41/gKhFtXL4YdXqvsVeM8y3FmY1L6MNtBXl7ph0/waP6WJH8Uyq353xHp
2z88Hms3p+xnz4H010y89fRiGHE9RO6j+Hiv/P1h3JuLn/Vdc5HPPbcEWdP/5rYcPk7/q4HH8Fpy
rxr7xzP7cuYrFV81dtE9eSybSz4+hh0+/8I/PMV7c2/cTTYw4+bt65+89NvPnqRz+/Q/UUd9vSRd
f/LdhZCdw6G8bN7eP5g+NOfGX3/76dPtx9w81ocDtj0d+cvl2Na/np/blDy70gO4H/FuKp1S397u
nLtP5bvjrlnf38Zuby7cY9xy/Ot920eL6t67TJ83yurek/Wn2+0z9v23n/789vOf//ztzz/++Ke/
zPnD+PHuyf5tuZ1fHD18eZfW469uGd3dGOQ5ScuYdqPRxvZovn92o2z7kaL6lEef+20vy/jocx/S
YaQ+zaaM60jj6MhHnzc26bMb6tNuZKQ+bSLj0aedYxndtp/9/vHLePRpjDmOpD4djdNvZ/NwGI8+
bTyPPPrsN9Is46PP+xPHzGPqwt5nul/OtIx7n8+l5zKmvbmoIQUaZ1y/PavfHh99SptBH/noU8Te
IbKuUWzPI5NXxrSpI9c4k1NHtmXUfR7GR58xP/7D7MZM1z0/f7tN44afuYx0jXLbf+b9ItvdWJ7j
fFx3WYMvzz53t3AZqc9C81mf81nvUjsmpGp9rrNX6rPqPtd1b/TbG2m+JSBDW79d31yd+uzUZ6dx
dvrt4+jTzkPzw8GEjAQTMhoYJzFk0jgnjXO2jxMi2/ZxQmSDPmWDPoX4KQLzKXLe7/M0po8TIgK/
XS78DMvoPk6IGBon8VMsPDvkyc93E0L8FEt9Ovrtjubz5Kcd5TAufd4/O4JE83PhVzz16Wmcvp3N
3TKGU58hHcbV520SzyPX8+gOoXU5dn5eqChRs25N3ZOf24WKcuFnWkZgnSSaz7SPU+7/xGWk356A
dbLz8znJbRmBdUL8lEzXvQDrpADr5MLPuYzAOqn02ytd9wo+g1QaJ/FTiJ/S6Le302cYh0I6+AzS
wWcQ4qcQP2UozR8nGqrPQ7QnP/t2Htngclz4uS6H5qcs1V34uS7HhHGaDebT7Py8gMVswDqzAeuM
5qf4ZQTWGYH5NOR/GgOsMwaeR8bA88hofsp+wxoLzyND/qchfhoLzyPj4D4yDu4jo/1PqcsI95Hx
dI2In8aDz2A8aMkE0JIJWktjGUFLhvxPE2mckbQUSUuRtKT5adbZE2mJ+GkSjTOTljJpKZOWND/N
OrKQlgpdI/I/TSEtkf9pyP802v80cRlJS8RPQ/w05H+aRlrqpCXtf5qyjKQl4qcZNM5BWhqkJfI/
jean6ctIWiL/0xA/La3f7QZashtoyWp+2tWngJaswDWyxE8roCVrQEvWgJas5qc9jKAlS+t3S/y0
FrRkLWjJOtCS1fy0YRlBS5bW75b4aT1oyXrQkvWgJav5afMygpZsoGtE/LSRtBRJS5G0pPlpd7fQ
JtJSomtE/LSJtJRJS5m0pPlp5zKSlgpdI+KnLaSlQlqqpCXNT2eWkbRE/qclftpGWmqkpUZa0vx0
fhlJS+R/WuKnHaQlWr9bWr9bzU+3+0uW1u+W1u+W+Glp/e420JLbQEtO89PVZQQtOVq/O+KnE9CS
E9CSM6Alp/npxjKClhyt3x3x01nQkrOgJWdBS07z06+zO9CSo/inI346D1pyHrTkPGjJaX76dWQA
LblA14j46QJpKZKWImlJ89PHZSQt0frdET9dIi0l0lImLWl++rKMpCVavzvipyukpUJaKqQlzU/f
l5G0RPFPR/x0jbTUSEuNtKT5ucKSrpOWKP7piJ+uk5YGaWmQljQ/w2EkLU26RsRPN7WWjuYQ+/W0
fvcU//QU//QU//QnP2+PkcO44oqP/1rGo88zSOJp/e4NjfPk57mx4k9+nhsr/uTnubHiLex3eAv7
Hd7Cfoe3sN/hHex3eAf7Hd7Bfod3EAP05H96D/sdnuKfntbvntbvXvPTjmUEhnjyPz2t3z2t332E
eJ2P1Cfx0xM/Pfmf/ly/2772+Dz5n578T6/56dZvJ//TEz89+Z+e/E9f6N6k+Ken+Kcnfnripz/9
T9vLYQR+euKn1/x060jipyd+euKnJ376Jz/9fQM7nUbV54p/+kF9Ln7eI+SyP6D9zs89/2YZaZyT
9Enr90D8DMTPQPwMm9LnIlgQiCcHUawzx5HUJ/EznPw848lB8zMdRognB7P0qTZBwu5/XlAZdn5e
UBn29fsFlWHn5wWVYY9/XgAYaP8oHP7nvF3isIz02z3c78HD/R40P2NcRrjfQ6DrTv5nCHC/hwBM
DhGYHLT/GcsyApMD8TMQP0MCJocEfl1I4NcF7X/Gvozg1wXaPwrkf4YCfl0owKVQgEtB+5+Hkitw
KRA/A/EzVOBSaKSlRlrS/EyHkbRE+++B+Bk6aamTlgZp6cLPdcsM0tKga0T+Z5ikpUlamqClqPmZ
8jKCliLxM5L/GQW0FAW0FAW0FDU/0+6YRcpfipS/FGn/PRrQUrSgpWhBS1HvH6W5jKClSPvvkfgZ
HWgpOtBS9KClqPmZzTKClqKna0T8jAG0FANoKQbSkuZn9stIWop0jYifMZGWEmkpkZY0P/P+jIuZ
tJTpGhE/YyYt0f57pP33qPmZ6zKSlsj/jMTPWElLlbTUSEuan3ksI2mp0TUifsZOWuqkpU5a0vws
6+yDtET+ZyR+xklamqSlSVrS/Cz7kWkDLSXyPxPxM22gpSSgpSSgpaT5WeIygpYSrd8T8TMZ0FIy
oKVkQUtJ87OUZQQtJcpfSsTP5EBLyYGWkgMtJc3P0pcRtJRo/Z6InymAllIALaUAWkqan3X1GUlL
ka4R8TNF0lIiLSXSkuZnPYykJcr/TMTPlElLmbRUSEuanzUsI2mJ8j8T8TNV0lIlLVXSkuZnzctI
WqL8pUT8TJ201ElLnbSk+Vl3fykN0tKga0T8TIO0NElLk7Sk+VnnMoKWMq3fM/Ezb6ClvIGWsoCW
suZnM8sIWsq0fs/Ez2xAS9mAlrIBLWXNz+aXEbSUKX8pEz+zAy1lB1rKDrSUNT/b7i9lD1rKlL+U
iZ/Zg5ZyAC3lAFrKmp+tLiNpieKfmfiZI8Tnc4QYYKb1e6b4Z6b4Z6b8pXzy03ZzGCE+n0//8ww6
ZVq/Z4p/5pOfZ3w+n/w84/P55OcZn88V4vO5Qnw+V4jP5wrx+dwgPp8bxOdzg/h8bhCfz+R/5g7x
+Uzxz0zr90zr96z5GdeQaP2eyf/MtH7PtH7PFP/MFP8sxM9C/CzkfxYd/zyM5H8W8j+L5mecywj3
ZiF+FvI/C/mfxcC9WWj/vVD+UiF+FuJnOf1P29phBH4W4mfR/Ey7PgvxsxA/C/GzED9L2GBCKP5Z
aP+90P5RIX6Wk5+2pcO49Hn/+GU8+jxhVYifhfhZkmKdO4ynPo/XBMrBT/WaQDn4qSLkZefnBVYl
67j3mrqdnxdYlaJj6WkZ00cEFfI/y/I/5XaNxlhG+u3kfxbyP4v2P/vqk/zPQv5nIf+zdNISxT8L
8bNQ/lKh/M8ylJaOCzdIS4O0RPwstH9UJmlpqj6XlurJz3O3pVL+Z6X8z6rjn2Of+Ur5n5Xylyrt
H1XK/6yU/1kp/7Pq+Oc4jgQmV+JnJX5Wyv+slP9ZKf+z6vjniMsIz81K+0eV9t8r5X9Wyv+slP9Z
dfxzlGWE+6gSPyvxs1L+Z6X8z0r5n1XHP8cepqiU/1mJn5X8z0r5n5X23yvtv1cd/5yrT9p/r+R/
Vtp/r7T/Xin/s1L+Z9X8nIeRtET775XyPyvlf1bK/6yU/1m1/znDMpKWiJ+V+Fkp/7NS/mel/M+q
/c+5hykq5X9W4mel/M9K+Z+N8j8b5X82zc/ZlhG01Cj/sxE/G+V/Nsr/bJT/2TQ/51xG0FKj/M9G
/GyU/9ko/7NR/mdT/JTlXTTK/2yU/9mIn43yPxvlfzbK/2yKn7Ie0I3yPxv5n4342Sj/s1H+Z6P8
z6b4Kcsxa5T/2cj/bMTPRvmfjfI/G+V/NsVP2eoykpZo/d6In43yPxvlfzbK/2xVa2ksI2mJ9t8b
8bNR/mej/KVG+UtN8VNknZ3ylxr5n4342Sh/qVH+Z6P8z6b4KXIcSVoi/7MRP9skLU3QUt9AS13x
88ie6htoqdP+eyd+dgEtdXr/vdP7713xU6QsI2ip0/57J352ev+9W9BSt6ClbrWWdn+pO9BSp/33
TvzsDrTUKX+pU/5SV/yUtWzplL/Uaf+9Ez875S91yl/qlL/UFT/FHEbSEu2/d+Jnp/ylTvlLnfKX
uuKnmLCMpCXaf+/Ez075S53ylzrlL3XFTzG7v9Qpf6nT+r0TP/slf2k1b7DW7vT+Zqf1e6f1e6f4
Zz/5adshxQ5r7X76n+dau9P6vdP+UT/5eQaZ+8nPM8jcT36eQeY+ddxmDenJz2uQuU+I24wnP69B
5rFB3GZsSR3ZllH3uYwCOZCD/M+x+5+XIPOg/aNB6/dB6/eh+VmPI4Ehg/zPQev3Qev3YSGmOmj/
fRA/B/FzkP85zvX77bcfRrg3B/mfQ/Oz7k/DQf7nIH4O8j8H+Z8jwr05aP9o0P77IH4O4uc4/U9b
22EEfg7i59D+Zy3LCPwcxM9B/BzEz1EcTAi9/z4o/jlo/30QP8fJT1vTYVz6vH92Moxz/X7CahA/
B/FzNMW6Fe4bJz/PIPM4+KmCzOPgpwoyj52fF1iNofe51tTt/LzCauh9rgWrAftcg/zPsfzP+yWa
fRnpt5P/Ocn/nNr/tHUZwWeY5H9O8j+ngJYmxT8n8XPS/tGk/aOp3j+q7jCClqYFLU3i56T9o2lB
S9OpPtNhPPo8g8yT8pcm5S9NFf+U9VrQpPylSftHk/KXJuUvTcpfmpS/NFX8U9aLOZPylybxcxI/
J+UvTcpfmpS/NFX8U9xxJDw3J+UvTcpfmpS/NCl/aVL+0lTxT3FxGek+In5O4uek/KVJ+0eT9o+m
in+KK8tIWiJ+TvI/J+UvTcpfmpS/NLvW0k6wSflLk/zPSflLk/KXJuUvTcpfmoqf4lefkL/0qEr6
/uw348dxygb5S7JB/pJskL8km/I/xR/Gj1oSqv8pG/BTNshfkg3yl2SD/CXR9T/Fh2X8qCWh+p+y
wf67bJC/JBvsv8sG+++i63+Kz7sR9t9lg/132YCfssH+u2yQvyQb5C/JFrSW2jKSlmD/XTbgp2yR
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
YdD+/KD9ec//lPwG6Vki/z5IPwftzw84/x4GnH8Pnv8pOVuQniXaXxqknwPOv4cB59/DgPPvwfM/
JX/qpQHn38Og/aVB+jng/HsYcP49DDj/Hjz/U/K0IDxLk/aXJunnpPPvk86/Tzr/7vmfko8F4Vma
tL80ST8nnX+fdP590vl3z/+UIhaEZ2nS/tIk/Zx0/n3S+fdJ5989/1PKp16adP59kn+fpJ+Tzr9P
2v+ctP/p+Z9SqgXpWSL/Pkk/J+1/Ttr/nLT/6fmfUoYF6Vmi/aVJ+jlp/3PS/uek/U/P/5SyLUjP
Eu0vTdLPee1/2n8+rMfiOjzE/wzE/wyT+p+T+p+O/6m1vkHrL/3+z57Pb/357fAQ/zMQ/zNMz6+z
P3zT9T/fZrjjf36b4fPlz7tm+If/eTfDP/zPu8Pz4X/ezfB57c/bM//h113N8HXtz79B6AUtqj+N
/3k1w4n/GRb590X+3fM/Q/08Nov8+6L6k/ifYZF/X+/734MP0neSfi7Sz0X1p+N/as1vEH43F9Wf
y/OXqn2S6s9F+rmo/lxUf64Mv5uL5u+L+p+L9HORfjr+p1Z5g6Cfi/Rz+f35WiwI+rlIPxfp5yL9
/PA//1wQmr8v6n8umh8t0k/H/9SyLfi+/+j3f8mCrp/8XjrSz0X6uTy/Lr7B7/P5HuH58j/dEZ71
6qdrRxv/8xKrD//zFqsP//NuR3/4n7dYffiffySI6s+X/+kAdGGRf19Ufy6qP5evP5s9S1R/bqo/
N9WfH/7n/Sxt6n9u0k/if4ZN+5+O/6mlW1DgWdoCz9Im/dw0P9oKz5Ljf35HG/urn9/Rxqb9z037
n57/Ke39JPy+E/8zbJofbdr/3LT/uWn/0/M/pRULgiYT/zNs0s9N+5+b9j837X96/qe0T5ti0/7n
pv2lTfufm/Y/N+1/btr/9PxPacuC9HtE+rlJPzftf27a/9y0/+n5n/L+dtD+5yb93FR/btr/3LT/
uWn/0/E/f36kN0jPEtWfm+bvm/Y/N83fN83ft9NP6Z82xab5+6b5O/E/w6b5+6H9z0P7n57/Kb1Z
EJ4l4n+GQ/p5aP/z0P7nof1Pz/+UPi0Iz9Ih/Ty0/3lo//PQ/ueh/U/H//z5kY4F4Vk6NH8/pJ+H
9j8P7X8e2v/0/E8Znz/lh/Y/D+1/HtLPQ/ufh/Y/D+1/ev6njGRBepZo//OQfh7a/zy0/3lo/9Pz
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
KcT/FOJ/CvE/hfifQvxP8fxPXfavA/9TiP8pxP8U4n8K8T+F+J/i+Z+63k/Ss0TzI+J/CvE/hfif
QvxP8fxPXcWC9CxR/5P4n0L8TyH+pxD/Uzz/U9enXiL+pxD/U4j/KcT/FOJ/CvE/xfM/dS0LwrNE
/E8h/qcQ/1OI/ynE/xTP/1QbbRD/U4j/KcT/FOJ/CvE/hfif4vmfut8gPEvE/xTifwrxP4X4n0L8
T/H8T92feon4n0L8TyH+pxD/U4j/KcT/FM//1N0sSM8SzY+I/ynE/xTifwrxP8XzP3VPC9KzRPuf
xP8U4n8K8T+F+J/i+Z9qWzTE/xTifwrxP2XS/vyk/flJ+/Oe/6l2GG3S/jzxP2WSfk7an5+0Pz9p
f97zP9UOZE3an580f5+kn5P25yftz0/an59+f94OZE3an5+0/7lIPxftzy/an1+0P+/5n2oHshbt
zy+aHy3Sz0X784v2lxbtLy2/P28HshbtLxH/U4j/KYv2lxbtzy/an19OP+P7r9P+/KL5+yL9XLQ/
v2j+vmj+vpx+xu8n4Vki/qcQ/1MWzd8X7c8v2p/3/M9oB7IW7c8vmr8T/1MW7c8v2p9ftD/v+Z/R
DmQt2p8n/qcQ/1MW7c8v2p9ftD/v+Z/RDmQt2p9fNH9fpJ+L9ucX7c8v2p9fTj+jHchatD+/aH9+
kX4u2p9ftD+/aH9+Of2M4Q3Ss0T784v0c9P+/Kb9+U37857/Ge1A1qb9eeJ/CvE/ZdP+/Kb9+U37
857/Ge1A1qb9+U3z9036ua/9+fc/h721Tf59U/9z0/yI+J/i+J8a5Q3azsnv/5IF3+/8bn1s8u+b
+p+O//ldw3b8z+8atuN/ftewP/zPew37w/+817A//M976+PD/7zXsD/8z3vr48P/vNew9/X+uDcI
+yGb6k/jf15r2Jv6n5v8+yb/7vmfhu6XTf59U/25yb9v8u8f/uefR5Hm78T/lE36uan+dPxPjW+Q
6s9N9afnf9qLA2RT/blJPzfVn5vqzw//888FofkR8T+F+J+yST/Pt/5UnW8Q9POQfnr+p722QA7p
J/E/5ZB+HtLP8/KTgw/Sd9L8iPifQvxPOV/91HePxfifl1gdz18ysTqkn4f00/E/vytqjv/5PbFy
Xv10RJTz6qdbUTP+5yVWH/7nLVbG/7zE6sP/vMXqw/+8JehQ/Xms/vzPu0ftKpF/P1R/Hqo/Pf8z
fl5MKYfqz0P156H689D5o0P9z0P6SfxPIf6nHHf+6D3kdej80aHzR4f089D86Ax6lob7zvdZcueP
3nVH4n8K8T/F8z+j2n9O+0vE/xTifwrxP4X4n0L8T/H8z6hvEDSZ+J9C/E8h/qcQ//P39+SfH+kn
6Grvz0s5lfifSvxPJf6nEv9Tif+pxP/Ux/U/4+elnEr8TyX+pxL/U4n/qcT/VOJ/qud/xs9LOZX4
n0r8TyX+pxL/U4n/qcT/VM//jJ+XcirxP5X4n0r8TyX+pxL/U4n/qZ7/GT8v5VTifyrxP5X4n0r8
TyX+pxL/Uz3/M35eyqnE/1TifyrxP5X4n0r8TyX+p3r+Z/y8lFOJ/6nE/1TifyrxP5X4n0r8T/X8
z/h5KacS/1OJ/6nE/1TifyrxP5X4n+r5n/HzUk4l/qcS/1OJ/6nE/1TifyrxP9XzP+PnpZxK/E8l
/qcS/1MD7C9pgP0lDbC/pJ7/GZN9EvaXlPifGkg/A+wvaYD9JQ2wv6Se/xk/L+XUAPtLGqD+1ED6
GWB/SQPsL2mA/SUNTj/j56WcGmB/SQP4dw2knwH2lzTA/pIG2F9Sz/+Mn5dyaoD9JQ0wf9dA+hlg
f0kD7C9pgP0lDU4/7cCLBthfUuJ/KvE/NcD+kgbYX9IA+0sanH7G/AbpWYL6UwPpZ4D9JQ2wv6QB
9pc0OP2Mn5dyaoD9JSX+pxL/UwPsL2mA/SUNsL+knv8ZPy/l1AD7Sxpg/q7E/9QA+0saYH9JA+wv
qed/xs9LOVVgf0mJ/6nE/1SB/SUV2F9Sgf0l9fzP+HkppwrsL6nA/F2F9FNgf0kF9pdUYH9Jxeln
/LyUUwX2l1Rg/q5C+imwv6QC+0sqsL+k4vQzfl7KqQL7Syowf1ch/RTYX1KB/SUV2F9Sz/+Mn86e
CuwvKfE/lfifKrC/pAL7Syqwv6Se/xk/vTUV2F9Sgf6nCumnwP6SEv9Tif+pnv8ZP90tJf6nEv9T
if+pN//T/vOPfqb7k/Sd0P9UgfcfqcD7j1Tg/UcqTj9jt0/C+49UwL+rwPxIBd5/pALvP1KB9x+p
OP2Mn7V2FXj/kQr4dxXof6rA+49U4f1HqvD+I1Wnn/Gz1q4K7z9SJf+u0P9UhfcfqcL5TVU4v6nq
9DN+1tpV4fymKvl3hf6nKpzfVIXzm6pwflPV8efVCh5179/c8gbhHinMj1Rh/q7E/1Tif6qSfn74
n7+sLHHB/35nOz274Oc76xNDfIPf7xyfFQsl/qcS/1PV6Wf8rLWrwvlNdfxPdz2ru57fIOUO/U8l
/qcq6adS/ank3z/8zz/X86Of/afEavsN0nd6/Qyfv0dK+qlUfyr5dyX9dPxPPfMNuuv5/pzu/cXa
3yB9J9WfSv5dST+V9PPD//xzPff3eiZ9g5/vLE/QNyP//jj7+67k35X0U6/+pz2KH/28/kg5/uf3
esavfv58/Rt013O/Qcg9kn5G0k/ifyrxPzUK/ZyOH3L6G/z+nPH94Uk/I+kn8T+V+J8aqf788D/v
+278T09y0Jf/WZ8avsH3O4NtoynxP5X4nxp9/zNlC4IuOf6nu0oZdD7C+Xcl/qcS/1Mj6Wek+jOS
f//wP/9cz+p+j2RakL6zgi5F0s9I+hlJPyPpp+N/uuezgy45/udvdhak7yT9jKSfkfQzkn5++J9/
ruf8Xs+n2PWcoEtxgi5F0s9I+hmp/xmp/+n4n+56btKl7a7n95OUO+lnJP0k/qcS/1M//M/7en74
n7/Xc4TPeS59+Z+l/vw5ej/5/c6SPtczkX4S/1OJ/6mJ9DORfibST8f//M3OgvSdpJ/E/9RE+plI
PxPpp/E//3s97SpR/XnxP+33nfifmkg/E/U/E9Wfjv/prmeG33fH//zNzoL0naSfifQzkX4m0s9E
+pm++tnXY1epwu97qvD7nkg/if+pxP/URP3PRPrp+Z/v73ty+pnqG6TcST+J/6mJ9DORfibSz/TV
z/a9nvP7+36+n3S/7/b3PZF+JtLPRP3PRP3PRPqZNv2+O/1M309S7qSfifQzkX4m0s9M+pkffz2j
BeE78wO/78T/VOJ/qud/xg/ORTP1PzPpZxb4fXf8z9/sLEi5k34S/1OJ/6mZ9DOTfuavfrZqE7GX
/+l/3z3/8/19J/6nZtLPTP49k35m0k/H//z+vjv+5292FqTvJP3MpJ/E/1Tif6rjf7qfs8Lvked/
5u8n6TtJPzPpZyb9JP6nOv6n+9d9/SlvkL6T9JP4n0r8TyX+p2bSz0z6afzPq2/z8j/r7xmvNwh9
G+J/KvE/NZN/z+TfHf/TXU+nn2/fhvifSvxPzaSfmfQzk35m0s9C+lke//v+BuE7C+lnIf0k/qcW
OL+pxP/UQvpZSD+Lf//m9z+n7yT9LKSfxP9U4n9qIf0sTj/fVlIh/Sykn8T/VOJ/aiH9LHB+Uwvp
ZyH9LH5//huk3Ek/C+lnIf0k/qcW0s9C+un4n1q+n6TvJP0spJ+F9LOQfjr+p/vXST8L6Wch/Syk
n8T/1EL6WUg/C+lnIf0sTj+/DwPpJ/E/lfif6vif3753gf15dfxPdz1JP4n/qYX0s5B+FtLPQvpZ
SD8r6Wd1+qltWhC+s5J+Ev9TK+kn8T+1kn5W0s9K+un4n7/ZWZC+k/Szkn5W0s9K+llJP+tXP+ve
dj1JPyvpZyX9rKSfFc5vaoXzm1pJPyvpp+N/av0GKXfSz0r6WUk/K+lnJf2spJ/V6Wf9Buk7ST8r
6Wcl/ST+p1aaHxn/sz+xueDri7/zOM//PJ/3I2gl/aykn8T/VOJ/anXzo+9VmqDzFc4faaX5USX9
JP6nEv9TK9WfleZHdfvfI/vtIP28+J+vLpF+Ev9TK+lnJf1sND9y/M+vLjn+5292FqTvJP1spJ+N
9LORfn74n/f1NP7n7/XsWi0IuuT5n68uNdLPRvrZSD8b6afjf7rrGUGXHP/zNzsL0neSfjbSz0b1
ZyP/3kg/WwZdak4/2zdI30n62Ug/G+kn8T/V8T/dv17h973R/KiRfjbSz0b6SfxPJf6nNtLPD//z
rute/md9krxXvkNd10g/if+pxP/URvrZJl3PCXVdI/1spJ/E/1Tif2oj/Wykn430s23/+x4tSN9J
+kn8T22kn430s5F+dtLPTvrp+J/avkH6TtLPTvrZST876Wcn/exOP1ONFgT97KSfnfSzk3520s9O
+tlJPzvpZ3f62eUN0neSfnbSz076SfxP7bS/ZPzPn+v547Dteua3Xvr2Qzz/M9scoZN+dtJP4n8q
8T+1U/3Zqf50/M/f7CxI30n6SfxPJf6ndtLPTvrZu7+eb5C+k/aXiP+pxP/UTvrZST877S912l9y
/M/f7CxI30n62Uk/O+lnJ/3spJ/9q59F1huk33faX+qkn530s5N+dtLPQfo5aH/J8T9/s7MgfSfp
5yD9HKSfg/RzkH8fNH8fzr+P/AbpO0k/B+nnIP0k/qc6/qf712n/c9D8fZB+DtLPQfpJ/E8l/qcO
0s9B+5/ju//pHgba/xykn8T/VOJ/6iD9HJWuJ+1/Dqo/B+kn8T+V+J86SD8H6ecg/RxOP2VOC9J3
kn4S/1MH6ecg/Rykn4P0c5B+Ov7nb3YWpO8k/Rykn4P0c5B+DtLP8dXPvINdT9LPQfo5SD8H6ecg
/Rykn5P0c5J+TqefY79B+k7Sz0n6OUk/if+pk/Rzkn5Op58zv0H6TtLPSfpJ/E8l/qdOp5/ff530
c5J+TtLPSfpJ/E8l/qdO0s9J+jlJP1/+Z62/amZB0E/ifyrxP3WSfk7ST8f/dNeT9HOSfhL/U4n/
qZP0c5J+TtLPSfo5u/99rxak7yT9nKSfk/Rzkn5O0s9J+jlJPx3/8zc7C9J3kn5O0s9J+jlJPyfp
53T62bJdJdLPSfo5ST8n6eck/ST+py7Sz0X6uZx+zv0G6TtJPxfpJ/E/lfifukg/F+mn43/qen94
0s9F+kn8TyX+py7Sz0XzI+N/XnOEl//545TfPUDP/3znCMT/VOJ/6iL9XKSfjv/prhLtzy/anyf+
pxL/Uxfp5yL9XKSfi/Y/V/W/R9GC9J20P79IPxfp5yL9XKSfi/Y/F+3PO/7nb3YWpO8k/Vykn4v0
c5F+Lpq/r+/+Z47Driftzy/an1+kn4v0c5F+Ev9TF+1/LtqfX27/c30/Sd9J+rlIP4n/qcT/1E36
uR/QJcf/1F3fIH0n6SfxP5X4n7pJPzf1P43/GUucLvif7wzn1PPN6KufP/+PT71E/E8l/qdu0s9N
+un4n+4qUf1J/E8l/qdu0s9N+rlJP4n/qR/+p+jjr+dHP0MOxQXpOzPo0ib93KSfm/Rzk35u0s8P
//Ouk7fp5+850/e+O/1862Tif+om/ST+p27ST8f/dPfd62d+g/SdpJ/E/9RN+rlJP4n/qZv0c1/6
+QbpOyfdd9LPTfq5ST836eeH//nn+dzf5/NHrSxI30nzI+J/KvE/lfifSvxPPaSfh+ZHx+vn95P0
naSfxP9U4n/qIf08pJ/nOz/KLgh/Nw/Nj4j/qYf085B+HtLPD//zvu/G/0y/P5Od5zqkn4fOHx3S
z0P6eUg/D+nnofn7of2l4+bvR94gfSfpJ/E/9ZB+HtLPQ/pp/M+rnn/5n76e9/zPt54/pJ/E/1Ti
fyrxP/XD//xz3/v3vj/d7ibp5yH/TvxPJf6nvvzP31+D/AYnBCf9nKafv69k+Ab/W4fMEn67phZ8
f872vZ6kn8T/VOJ/6iH9PFR/Hjp/5Pifv0+LBek7ST+J/6mH9PP80c//s//32v/nf/2f/+d//9//
63/+53/+83+M//ecn9j/9b+e/+/6j3//95//+L+bhWLBf//t58MJDbX+Pglv8L//dh1tfT8JnLvn
AZ19PpzQ8PwHOhss6PJ5/6Gvz4+x2Xd+dDZc33lxmt7gv9f9uTmh2YL0cyrlrpQ7vCfpIU7o8+GE
/sk9Uu7J554sSLknyh109nky5Q6c0OfDCf2Te6bcC+UOOvt8OKF/ci+Ue/W5289ZKfdKuUOf9Hka
5Q46+3w4oX9yb5Q7cEKfB97z8Xw4oX9y75T78LkXC1Lug3KHOvV5JuUOnPrnwwn9k/uk3OE9cw9x
Qp8PJ/RP7oty3z73akHKfVPuoLPPc0jrQGefDyf0T+4Hcg/wno8nkH5+OKF37hcn1P6hEHzuzYKQ
ewiQe4A69QkC9504oc+HE3rnbpzQO3fgLD+B9PPDCf2Tu1Lu0efeLUi5R8odfP5jnNDrvgeoU58P
J/RP7slyD+f7SeDcPYH088MJ/ZN7ptyLz31YkHIvlDvUqc/NCbXcK/2clXKvlDu8J+khTujz4YT+
yb1R7t3nPi1IuXfKHXz+EwblDnXq8+GE/sl9UO6Tcif9/HBC/+Q+Kfflc18WpNwX5Q516vPhhP75
1z0n9P3Xv3Xqz7++LTjhXyf9DKSfgfQzHLieQvpJnNBHSD+F9FMu/TwWhOsppJ9C+ikCuRMn9BHS
TxHKnfRTSD+F9FNIP8XrZ3+DlDvpp5B+CumnkH4K6aeQfhIn9BHSTyH9FNJP8frZ7ZOkn0L6KaSf
QvoppJ9C+imkn0L6SZzQR0g/hfRTvH52+zlJP4X0kzihj5B+CumnkH4K6aeQfgrpp5B+CumneP3s
akHKnfSTOKHPzQm13OE9Sc+HE/on9025A2f5IU7o8+GE/sn9QO76+NyjBSF3fSB3hT7powFyJ07o
8+GE3rl/OKF37grv6XyU9PPDCb1zvzih7z+kPvdkQcpdKXfokz4aKXfy7x9O6J/cI+WeKHfSzw8n
9E/uiXLPPvdsQco9U+7QJ30+nNA//3qBmsFxQqNhcB/jhN7/Oumnkn4q6aeSfirpJ3FCHyX9VNJP
vfSzWpCuJ+mnkn4q6SdxQh8l/dRXP53nUtJPJf1U0k8l/dRLP5sFKXfST+KEPnrppz2fpJ9K+qmb
cif9JE7oo6SfSvoZL/3sFoTcI+kncUKfSPpJnNAnkn7GALlH0s9I+hlJPyPpZ7z0c1iQcif9JE7o
E0k/I+lnJP2MkXIn/SRO6BNJPyPpZ7z0c1qQcif9JE7oEwvlTv3PDyf0T+6Fcof3fDyR9PPDCf2T
e6Xcm899WZByb5Q7zJme2OH3PVL/88MJ/ZN7p9zhPfEPcUKfDyf0T+6Dcp8+921Byn1S7rAn+sRF
uVP/88MJ/ZP7otyBU/9E0s8PJ/RP7ptyPz73Y0HK/VDuMKd/Es2PEvn3RPOjRPOjRPMj4oQ+ieZH
ieZHyc+PxhuE3BPNj4gT+iSaHxEn9Ek0P0o0P0o0P0qkn4nmR4nmR8nPj4Z9kuZHieZHxAl9PpzQ
P/96hlrRcUJ//nV7QjLUion0kzihTyL9TKSfifQzkX4m0s9E+pm8fg61IF1P0s9E+plIPxPpZyL9
TKSfifSTOKFPIv1MpJ/J6+ew7yT9TKSfifQzLbrvpJ+J9NM4obU8+/tJ0s9E+plIPxPpZ/L6OZIF
KXfST+KEPvmB+55JPzPpp3FCr9wz6SdxQp9M+plJP/Oln/Zzkn5m0k/ihD5Z4b4TJ/TJpJ/GCb1z
J/3MpJ+Z9DOTfuZLP4sFKXfST+KEPpn0M5N+5ks/qwVBP3OhZ4n0M5N+Gif0vp6kn5n0M5N+ZtLP
fOlnsyBdT9JP4oQ+mfQzk35m0k/jhN65k34SJ/TJpJ+Z9DNf+tktSLmTfmbSz0z6SZzQJ5N+ZtLP
TPqZST8z6Wcm/cyXfg4LUu6kn8QJfQrVn4X0s5B+lrf+dP2lQvpJnNCnkH4W0s9y6ee0IOReSD+J
E/oU0k/ihD6F9LNQ/VlIPwvpZyH9LKSf5dLPZUHKnfSzkH4W2l8qND8qtL9UaH+p0P4ScUKfQvtL
hfaXit9fGtuClDvtLxEn9CmN7jv1PwvtLxXaXyq0v1RIPwvtLxXaXyp+f2kcC1LutL9EnNCn0P5S
of5nof2lQvtLhfaXiBP6FNpfKrS/VPz+0nyDlDvtLxEn9PlwQv/86wdqBscJ/fnX309CzVBJPyvp
ZyX9rOTfK+kncUKfSvpZST+r189pPyfpZyX9JE7oU8m/Eyf0qaSflfSzkn5W0s9K+llJP6vXz6kW
pNxJPyvpZ81030k/K+lnJf2spJ/ECX0q6Wcl/axeP6d9J+lnJf0kTuhTST+JE/pU0s9K+llJPyvp
ZyX9rKSf1evnTBak3Ek/iRP61Em5k35W0s9K+llJP4kT+lTSz0r6WS/9tN9N0s9K+llJPyvpZyX9
rJd+FguCfjbSz0b62Ug/G+lnI/0kTujTSD8b6We79LNaEK5nI/1spJ+N6k/ihD6N9LORfjbSz0b6
2Ug/G+lnu/SzWZByJ/0kTujTSD8b6Wcj/Wykn430kzihTyP9bKSf7dLPbkHKnfSTOKFPo/154oQ+
jfSzkX420s9G+tlIPxvpZ7v0c1iQcif9JE7o06j+bKSfjfSzkX420k/ihD6N9LORfrZLP6cFKXfS
z0b62Ug/G+lnu/RzWRD0s5N+dtLPTvrZST876SdxQp9O+tlJP/uln9uCcD076Wcn/exUfxIn9Omk
n530s5N+dtLPTvrZST/7pZ/HgpQ76SdxQp9O+tlJPzvpp3FCr55VJ/0kTujTST876Wf3+rneIOVO
+kmc0KeTfhIn9Omkn8YJvXMn/eykn530s5N+dq+fyz5J+tlJP4kT+nSqPzvpZyf9NE7onTvpJ3FC
n0762Uk/u9fPZT8n6Wcn/eykn/3Qfaf9pU7788YJvXIftD8/SD8H7c8P2p8ffn9+qQUh90H788QJ
fQadPxq0vzRof944oXfutD9PnNBn0P78oP354ffnl30n7c8P2p8nTugzaH+eOKHPoP1544TeudP+
/CD9HLQ/P2h/fvj9+ZUsSLnT/jxxQp8PJ/TPv16hZnCc0J9/3Z6QCjXDIP9OnNBnkH4O0s9B+jlI
Pwfp5yD9HJd+FgvS9ST9JE7oM0g/B+nnIP0cVH8O0k/ihD6D9HOQfo5LP6sFKXfSz0H6Oej8EXFC
n0H6Oej85iT9nKSfk/Rzkn7OSz+bBSH3SfpJnNBn0vmjSfo5ST8nnd+cpJ/ECX0m6eck/ZyXfnYL
Uu6kn8QJfT6c0D//egINcZzQn399WBA0ZFL9OUk/J9Wfk/z7pPqTOKHPpPpzUv05r/pzWpCuJ9Wf
xAl9JukncUKfSfo5yb9P0s9J+jlJPyfp57z0c1mQcif9JE7o8+GE/vnXJz1L0z9L24L0LNH8nTih
z6T5+6T9z0nz90nz90nz90nz9+nn7+tYkK4nzd+JE/os8u+L9HORf1+0v7TIvxMn9Fnk3xf59+X9
+36DkPsi/06c0OfDCf3zrys8S44T+vOvv5+EZ2nR/vwi/75of944off1pP154oQ+i/bnF+3PL78/
v+3npP35RfvzxAl9Fp0/WnT+aPnzR1stSNeTzh8t2l9adP7IOKH39aTzR8QJfRadP1p0/mj580fb
vpPOHy06f0Sc0GfR+SPihD6Lzh8tOr+56PzRovpz0fmjReePlj9/tJMFKXc6f0Sc0GfR+c1F+rno
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
a7Mg/W7S/L3Q/KjQ/N34n9df7UL1ZyH9LDR/LzR/L37+XrsF6R7R/L1Q/7PQ/J34n0L8T3n5n74G
qzR/J/6nEP9TiP8pF/+zDgtC7hXe3yHE/xTif4rxP686mfifQvxPIf6nEP9TLv5nnRaE57PS/Ij4
n0L8TzH+550R6SfxP4X4n0L8T7n4n3VZkO4R6SfxP6WSflbSz0r6WQs9n6SflfSzkn5W0s966ee2
IOV+6We2IOVO+lnf/SWfEelnJf2spJ+V9LNe+nksSM8n6Wcl/aykn5X2lyrpZyX9rKSflfSzev1s
b5DuEbz/XSrpZ4X3H4nxP69OfiX/Xqn+bFR/Nqo/m68/2/tJuEeN6s9G9Wej+VGj+VHz86MmFoTr
2Wh+1Eg/G+3PG//zqgAb7c83qj8b7c832p9vfn++qQXpetL+UiP9bKSfjfSzef1slhHpZ6P5O/E/
pdH8vdH8vdH8vdH8vdH8vdH8vfn5e0sWpOtJ8/dG/c9G+kn8T2mkn8b/vHMn/Wykn430s5F+Nq+f
zX5O0s9G+/ON9PPmf9p3kn8n/qcY//POnfbnif8pxP8U4n/Kxf9sxYKUO+3PE/9TiP8pxP+Ui//Z
qgXh96jD+9+F+J9C/E95+Z8li/skXE/ifwrxP4X4n3LxP1uzIFxP4n8K8T/l5n9mC9LPCfxPefmf
V+7U/yT+pxD/U4j/KRf/s3ULUu7w/mIh/qd0eH+xdNLPTvpp/M87d9LPTvrZST876We/9HNYkHIn
/eykn538O/E/pZN+dtLPTvrZST876Wcn/eyXfk4LUu6kn8T/lE7njzrpZyf97KSfxP8U4n9KJ/3s
pJ/90s9lQcqd9LOTfnbSz076OS793BYE/Rykn4P0c5B+DtLPQfo5SD8H6ecg/RyXfh4LwvUcpJ+D
9HPQ/GjQ/Gj4+VF/g3Q96fzRIP0cND8y/ud9PWl+NGh+NGh+NGh+NPz8qL+fpOtJ/n2Qfx/k343/
efUuBvn3Qf59kH8f5N+H9+/dfk7y74PmR4P08+Z/ZgvSz0nzI+N/3rnT/Ij4n0L8TyH+p1z8z64W
pNxpfkT8TxmL7jv590Hzo/Gdv7snmeZHg+ZHg+ZHg+ZHw8+Pun0nzY8GzY8G+fdJ+5/E/5RJ+5/z
gdwn7X9O8u+T/Psk/z69f+/JgpD7JP8+yb/f/M9sQfo5aX9pAj9EJs2PJvU/J+0vTdpfmn5/qdvP
SftLk/Y/J+nnzf+0+07156T9z5nh933S/H2Sfk7a/5y0/zn9/mcvFqTcaf9z0v7npP3P+e5/ul7l
pP3PSfo5af9z0v7n9PufvVoQ/h5NOn9E/E8h/qfML39+fD9J54+I/ynE/xTif8rF/+zNgnSP6PwR
8T+F+J/y5X9+eWtC/E8h/qcQ/1OI/ykX/7N3C8I9uvmfbxCu57rqz2xB+DkX1Z8L3n8ki+rPRfXn
ovpzUf25fP3ZhwUpd4Xnc5F+LtJP439eGrJIPxfp5yL9XKSf69LPaUF4PleC53ORfi7a/1zv/qf7
i7Bo/3ORf1+0/7lo/3P5/c++LEj3iM5vLqo/b/6nPZ+kn4v0c9H+/CL9XKSfi/RzkX6uSz+3BSl3
2p8n/qcQ/1OI/ykX/7MfC9KzRP6d+J9C/E95+Z/X9ST/TvxPIf6nEP9TLv7neIN0Pcm/E/9TFvn3
Rf59e/8+ggXhem7y75v0c5N+7gDXk/ifQvxP2aSfm/Rze/0c9nOSfm7y75v0c1P/c1P/c1P/c0fK
nfqfm/z7pv7npv7n9v3PoRak3Kn/uan+3NT/JP6nEP9TXv7nlTv1P4n/KcT/FOJ/ysX/HPad1P+8
+Z/2hFD/k/ifYvzPq1Il/qcQ/1OI/ynE/5SL/zmSBel3c9A9ov154n/KnlDbEP9TiP8pxP8U4n/K
xf8c9nPS+aOb//kG6XqSf9/k37f376NYkK4n8Zc2+fdD+/PG/7yuJ/E/hfifcmh//tD+/PH786Na
EK7nIX7dof3PQ/y6Q/790Pzd+J9X3/vQ/P2Qfh6avx+avx8/fx/NgpR7gt/3Q/P3Q/wQ439edfIh
fsgh/TzEDznEDzmeHzK6BeH5PAV+3w/p5wH+vBj/8+r9HuDPy6H68wB/Xg7w5+V4/vwYFqR71On5
JP28+Z92N2l+RPxPMf7n/XzS+SPifwrxP4X4n3LxP8e0IOV+9T/tblL/k/if8vI/L7Wh/ifxP4X4
n0L8T7n4n2NZkJ5P0k/if/6C6P/J6Cf4b82gxP9U4n8q8T+V+J968T/HtuC/90gf0E8l/qcS/1OJ
/6nE/9Qv/9PnDvqpxP9U4n8q8T/14n+OY0HKHfaXlPifevM/swXp5wT/rg/4dyX+pxL/U4n/qcT/
1Iv/Od8g5Q7+XYn/qcT/VOJ/6sX/nPZJmB/pA/N3Jf6nEv9Tn07XE+bvSvxPJf6nEv9TL/7ntJ8T
5u9K/E8l/qc+sL+kxP9U4n/qA/5dif+pxP9U4n8q8T/14n9OtSDlDv5dif+pN//Tcif9JP6nBtJP
4n8q8T+V+J9K/E+9+J/TvpP0M5B+Ev9Tg0DugfQzkH4G0s9A+hlIPwPpZyD9DF4/Z7Ig5U76GUg/
A+kn8T81kH4G0s9A+hlIPwPpZyD9DJd+2s9J+hlIP4n/qQHmRxqg/tQA/U8N0P/UAP1PJf6nBuh/
aoD+pwbf/5zFgpQ79D81QP9TA/h3DVB/agD/rmFS7uDfNZB+BvDvGsC/a/D+fVYLUu7g3zVA/ak3
/9Nyh/mRBtifV+N/3rnD/rwG0k+B/XkV2J9X8fvzs1kQchfYn1eB+bsKnD9S4n+qwPkjNf7nlbvA
+SMV0k+B80cqcP5IxZ8/mt2ClHuk3GF+pALzIxWYH6n4+dEcFoR6SWB+pEL6KaSfQvoppJ9C+imk
n0L6KZd+TgvS9ST9JP6nCtWfQvWnXPXnsiBdT6o/hfRTqP4Uqj+F6k/if6pQ/SlUf8pVf24L0vWk
+pP4n0r8TyX+p178z3ksSNcT5u9K/E8l/qcK8OuU+J9K/E8l/qcS/1Mv/ud6g3A9FebvSvxPVTi/
qQrnN1X9+c1ln4Tzm6qkn0r6qaSfSvqppJ/E/1TifyrxP/Xify77OUk/lfST+J+qpJ9K+qleP5da
kK4n6aeSfirpp5J+Kukn8T9VST+V9FO9fi77TtJPJf1U0k8l/VTST/X6uZIF6XqSfirpp5J+Kumn
kn4S/1OV9FNJP9Xr58oWpOtJ+qmknwrzd1WqP5X8u5J/V/LvxP9UJf+u5N/V+/dVLEi5k39X8u8K
83dVmL9r9PP3VS0Iz1KE+btG8u8R5u8aYf6uEebvGkk/I8zfNcL8XaOfv69mQbieEebvSvxPjTB/
10j+PcL8XSPM3zXC/F0jzN81wvxdI8zfNfr5++oWpNxh/q7E/9QI8yONMD/S6OdHa1iQniXgz2uE
+ZFGmB+p8T/rc6L7JF1P8u8R5kcaYX6k0c+P1rQgXU+YH2mE+ZFG0s9I+hlhfqTG/7xzh/mREv9T
I8yPNML8SKOfH61lQcod+EsaYX6kEc6/a4Tz7xr9+fe1LUjPEpx/10j1ZyT/bvzP3n9+Jb6fpOtJ
/j2Rf0/k35P37+tYEK5nuvy7WBCuZwL+khr/s6b9fUIS8Jc0Uf8zAX9JE/CXNHn+0n6DcI+Swj1K
pJ+J9NP4n3dGpJ+J9DORfibSz+T1c7+fpHtE+plIPxPpZyL9TF4/t10l0s9U6HqSfibST+N/Xs98
Iv1MpJ+J9DORfiavn1stSNcT+HWaSD8TnD9S43/WLOX7STh/pIn6nwn2PzXB/qcmv/+57Tth/1MT
nD/SRPVnov5nov5n8v3PnSxI13PT9aT+ZwJ+shr/876ewE/WRPVnovozUf2Zff25swXhemaqP4n/
qZnqz0z1Z6b6M1P9man+zFR/Zl9/7mJBuEeZ6k/if2qm+VEm/cykn8b/vGoG4n8q8T81k35m0s98
6We1IOVO+plJPzPsf2om/55h/1Mz7H9qhv1PzaSfGfY/NcP+p2a//7mbBSl32P/UDPufmmH/U43/
ef1uZtj/VOJ/aob9T82w/6nZ73/ubkH63RygdZnqzwznjzSTf8/AX1Ljf15/uTLwl5T4n5qp/sxU
f2Zff+5hQcqd+p+Z6s9M9afxP6/aJlP9SfxPJf6nEv9TL/7nnhaE57PA+U0l/qcS/1ON/zl+6vbv
J6n+JP6nEv9Tif+pF/9zLwvCPSqkn8T/1EL6WV7/vsV9kr6T9LOQfhbSz3Lp57Yg3SPY/9RC+lng
/KYa//Mno+/vUYHzm0r8Ty1wflMLnN/U4s9v7mNBukdUfxaqPwvN38s7f9/dfZK+k/qfhebvhebv
xc/fzxuke0T1Z6H6s8D5TTX+509G7veI9JP4n1poflRoflT8/OjYJ2l+VKj/Waj/WWh+VN750XG/
R6SfxP/UQvOjQvOj4udHRywI96gC/1OJ/6kVzr9rfc+/n+/vUSX9rKSfFc6/a4Xz71r9+fejFoR7
RPxPJf6nVtpfqu/+0unuk/SdpJ+V9pcq7S9Vv7907Dtpf4n4n0r8T62wP6/G//zJ6Pt7VEk/K+ln
Jf9eyb9X799PsiDdI6o/K9Wflfy78T9HfsR9kr6T9LOSf6/k36v37ydbkO4R9T8r1Z8V9ueV+J9a
qf9p/M+r+q3U/6xUf1bqf1bqf1bf/zzFgpQ79T+J/6n10s83SD8n6afxPy8fV0k/if+plfSzkn7W
Sz+rBSH3RvP3RvrZaP7eaP7e/Pz9NAvC71GD9xdrI//eaP5u/M/rejbST+J/aqP5e6P5e/Pz99Mt
SNeT5u+N5u+N6s9G9WcD/pIa//POHfhL2mj+3oC/pA34S9o8f+kMC1LuhXKn+rNR/5P4n9pIP9ur
n0PcJyl30s9G+tlIP9uln9OClDv1PxvpZ6P+Z4P3d2ij+rNR/dmo/9mo/9l8//MsC9LvJs3fif+p
xP/Ul//pdZ74n0r8TyX+pxL/Uy/+59kWpHsE/Hkl/qc24M+r8T+v3kWn+rOTfnbSz0762S/9PBaE
e9Rpf4n4n9pJP43/OXLf7pNwjzrpZyf97KSf3eln/v7ncI868Oe1k3524M+r8T/vjKj+7FR/duAn
awd+snbHT87vJ4GfrB3480r8T+3Ar9NO+tmBX6fG/7yfT+DXaaf9pU77S532l3rzudvPSftLHfjJ
SvxPJf6nGv/zzojm78T/VOJ/KvE/1fM/86MWpOeT9peI/6mdzh8R/1OJ/6nG/7yfZNJP4n8q8T+V
+J/q+Z/5/U7Sz076SfxP7aSfxv+8/iIM0s9B+jlIPwfp5wj++UwWhOdzUP1J/E8d1P8c1P8c8P44
Nf7nVa0NeH+cEv9Tif+pxP9Uz//M9tQR/1Nv/ucbpNyp/zmo/zmSf5aKBeFZGsCv00H+fVD/0/if
ozR3Pan/SfxPHdT/HNT/HNVfz2pBup6VrifVn+OaH9k9ovnRoPmR8T/v3Gl+RPxPHTQ/GjQ/GsPn
3ixIudP8aJB/H/D+Dh2kn4PmR8b/vHOn+RHxP3XQ/GjQ/Ghsn3u3IOUO7z/SQf59HLrvpJ+D9NP4
n1fuk/ST+J86ST8n6ee89HNYEHKfpJ+T9HMK3PdJ+jlJP43/eedO+kn8T52kn5P0c176OS1IuZN+
TtLPmeC+T6o/J/U/jf955079T+J/6qT+56T+5yw+92VByp32Pyf591npvlP9OeH9xWr8z8sXT3h/
sU7SzwnvL9YJ7y/W2X3u24KUe6fcqf68+Z9238m/E/9TX/7nlTvNj4j/qcT/VOJ/qud/5udYkHKn
/ifxP3Vuyp32lybtL81NudP+0iT9nLS/NGl/abn9pRzeIOR+8z/fIOS+aP9z0fxo0fx9Bch9Uf25
SD8Xzd8Xzd+X+tztkzR/X/D+TV00P7r5n9mC9HOSfzf+5507+fdF+rnIvy/y78v792D3iPz7Iv9O
/E8l/qcS/1M9/zMHtSDUyYv0k/ifukg/jf95ea5F+rlIPxfp5yL9XF4/g30n6eci/Vykn4v0k/if
ukg/jf955076uUg/F+nnIv1cXj9DsiDlTvpJ/E8l/qcS/1M9/zMHu0rk3xf5d+J/6qL6c5F/31R/
bqo/N9Wfm+rP7evPUCwI13NT/Un8T93ED9mkn5vqz03+fVP9SfxP3VR/bqo/t68/Q7Ug5U71J/E/
lfifSvxP9fzPHJoF4Vki/qcS/1M3+Xfjf97Xk/z7Jv++yb9v8u/b+/fQLUjXk/z7Jv++4f1HSvxP
Jf6nGv/zzp38O/E/lfifSvxP9fzPHIYFKXfy78T/1E3z903z9z39szQtSM8SvL9DN/n3Dfw6Nf7n
5Y828OuU+J9K/E8l/qd6/mcOy4J0PeH9HUr8Tz20/3lo//M8/npuC8L1PMQPOVR/Hqo/jf95PZ+H
6k/if+qh+vNQ/Xmu+vNYEK7nofqT+J96aH50qP48VH8a//P6G3eo/iT+px6qPw/Vn8fXn/IGKXeq
Pw/Vn4fmR4f089D8yPifd+40PzpUfx6aHx2aHx0/PxL7JM2PDrz/SA/Njw7N34n/qYfm74fOHx2a
vx+qPw/N3w/N38/0udvPSfP3Q+ePDs2PDukn8T+V+J9q/M87d9JP4n8q8T+V+J/q+Z9Z1IKUO/A/
lfifvwL1T0Y/wX/nhpH4n5H4n5H4n5H4n9HzP7PYdwK/Lj5Qf0bif8YH+HWR+J+R+J/R+J937rD/
GYn/GYn/GYn/GT3/M0uyIOUO/LpI/M/4gH7GB/QzPpd+2lUC/YwPvL84Ev8zPnD+KBr/0/92xAf2
P+MD/c/4wPmj+MD5o/hUfz2LBel6Qv0ZH6g/4wPz90j8z0j8z2j8zzt3mL9H4n9G4n9G4n9Gz//M
Ui1IucP8PRL/MxL/MxL/MxL/Mz6wvxSJ/xmJ/xmJ/xmJ/xk9/zNLsyDlDvyQSPzPSPzPSPzPSPzP
aPzPK3fif0bif0bif0bif8Zw6We3IORO/M9I/M9I/M9I/M9I/M9o/M87d9JP4n9G4n9G4n/GcOnn
sCDlTvpJ/M8YgL8Uif8Zif8ZX/6nc1KR+J+R+J+R+J+R+J/R8z+zTAtS7sBfisT/jAHqzxig/ozh
qj+XBeFvRwD+UiT+Zwykn8b/vK8n6Wcg/Qykn4H0M1z6uS1I1/PST/vtIP0MMH+PAc5vxgDz9xig
/owB5u8xwPw9Bj9/l2NBukcwf4/E/4wB+p8xkH4G6H/GAPufUaD/GQX6n1Gg/xkF+p9RfP9T3yDk
LtD/jMT/jALz9yiknwL9z2j8z0sVBfqfUaD/GQX6n1Gg/xnF9z/VPgn9zyjQ/4wC/c8oMH+PQvop
MH+Pxv+8c4f5exTof0aB+XsUmL9H8fN3tXsE8/cosD8fhepPgf35KBV0SWB/Pgr0P6PA/nwU2J+P
4vbns6oFQZcEzh9FAf8eBfqfUaD/GcX3P9Uygv5nlEHXE/qfUYCfHI3/eT8hwE+OQvWnAD8kCvBD
oix/PZMF6XoCPzkK+PcowF+KxP+MAuffowB/KQqcf49C9adC/zMq9D+j+v6nZgtC7grz96jQ/4wK
/c9o/E+/eRsV+p9RST8V+p9Rof8Z1fc/tVgQnk8F/lJUqj8Vzr9H43+OPLL7JNwjJf1UmB9FhflR
VD8/0mpBukew/xmV9FNhfhSN/+lPUEaF+VFU6H9GhflRVJgfRfXzI20WpHsE86OopJ8K+59Ryb8r
zI+i8T/vuwnzo6ikn0r6qaSfeulntyDlTvqppJ9K+qnv++P8bxzpJ/E/o5J+KumnXvo5LEjPJ/CX
opJ+KuwvRX33l47LCPaXIvE/I/E/I/E/o+d/Zp0WhHtE/M9I/M9I/M/45X9+z5VH4n9G4n9G4n9G
4n9Gz//MuiwI94j4n5H4nzGSfhL/MxL/M375nz530k/if0bif0bif8Z46ee2IOUO8/dI/M9I/M9I
/M8Yr/rzWJCeJao/if8Zif8Zjf95X0+qP4n/GYn/GYn/GT3/M8c3SNeT6k/if8ab/5ktSD8nnH+P
xv+8c4fz75H4n5H4n5H4n9HzP3N8P0m5w/n3SPzPGIE/HyP1PyOcf49xU+5w/j0S/zNGOP8eI5x/
j/H43O3nhPPvMcH595jIvyd4/3tMpJ+J9DORfibSz0T6mUg/E+ln8voZ1YKUO+lnIv1M5N8T+ffk
/Xu0jMi/3/xPsSDlDuffo/E/L9+R4Px7TNT/THD+PSY4/x5T9tczWZCuJ5x/j4nqT+J/RuJ/RuJ/
RuJ/RuJ/RuJ/RuJ/RuJ/xnTppz3zpJ+J9JP4nzHB/mdMpJ+J9DMBPzkm0s9E+plIPxPpZ7r0s1iQ
cif9TKSfifqfifqfyfc/Y7Ug/R5R/zORfiby78b/vK8n+fdE/j2Tf8/k37P377FZEK5nhv2lmMm/
Z+AvxQz8pZjFX89uQbieWeB6ZpofZZofGf/zup7E/4zE/4yZ5keZ5kfZz4/isCBdT5ofZep/5kS5
k35mmh8Z//POneZHxP+MmeZHmeZH2c+P4rQg5U7zo0zzo0zzo0zzo+znR3FZkJ4lmh9lmh9lmh/l
DjVDpvlRJv3MND/KND/Kfn4UtwXpetL8nfifMcP+fMywPx+z35+Px4J0Pan+zFR/Zqo/M9WfxP+M
xP+MmerPTPVn9vVneoNwPQvVn4Xqz0L+vVD9Waj+NP6nZ+bEQvVnofqzUP1ZqP4svv5M7ycp96v+
tIyo/vzwP/9kpNBjKdf+p2UE+5+xwPuPYoH3H8Xi3n+Uk/2c8P6jWEg/C+lnofqzUP1ZfP2Z1IJ0
PWH/MxL/MxbY/4zG/7yvJ+x/xkL6WUg/C+ln8fqZ7DtJPwvsf0bif0bif0bif0bP/8wpWZCu56Dr
Cfufkfif8cv/9NcTzh9F4n9G4n9G4n9Gz//MKVuQriecP4rE/4yF+p+F+p+F+p+F+p+F+p+F+p+F
+p+F+p/V9z9TsSDkXkk/K+lnJf2s5N8r6Wcl/aykn5X0s176WS0Iz2cl/15JPyu8/ygS/zNW6n9W
6n9W6n9W8u+V+p+V+p/V9z9TsyDlTv1P4n/GCvz5WKn+rLT/WQvlTvufxP+MlfY/K+1/Vr//mboF
KXfa/6w0P6q0/1lJPyvVn/Vbf273Scqd6s9K9Wel+rP6+jMNC1LuwA+JlfSz0v5Spf2lSvtLxP+M
lfx7Jf9evX9P04KkSzR/J/5nrOTfjf95zc4q+fdK/r2Rf2/k35v372lZEO5Ro/l7I//eaP7e3vm7
m282mr83mr83mr83mr83P39P24JwjxqcP4qN9LORf2/k35v37+lYkK4n7S818u+N9peM/3lfT9pf
aqSfjeZHjeZHzc+P8huk61lAl4j/GYn/GRvNj4j/GYn/GYn/GYn/GT3/M+f3k3SPqP9J/M/YqP/Z
SD8b9T8b9T8b9T8b9T8b9T8b9T+b739m+y2m/mej/mcj/bz5n3bfqf5s5N8b+fdG/r2Rfjby7438
e/P+PasFIfdO/p34n7FT/dmp/uxUf3aqPzvVn8T/jJ3qz071Z/f1Z7bvpPqzU/3Zqf7sNH/vpJ+d
6s9O9Wen+rNT/dmp/uxUf3Zff+ZkQcqd6s9O+tnp/BHxP2On+tP4n9euZqf6s5N+dqo/O9Wf3def
OVuQcqf6s1P92YEfEjvwQ2L3/JBcLAh/Ozrw5yPxP2Mn/TT+5/XXsJN+dtLPTvrZST/7pZ/VgnQ9
ST876Wcn/ST+Z+ykn8b/vHMn/eykn530s5N+9ks/mwUh90H6SfzPOEg/B+nnIP0cAXIfpJ/E/4yD
9HOQfo5LP7sFKXfST+J/xkH+fZB+DtLPQfufg/ST+J+R+J+R+J/x4n/mYUHKnfST+J9xkH8fpJ+D
9NP4n3fupJ+D9HOQfg7Sz3Hp57Qg5U76SfzPOEg/B+nnuPRzWRD0c5B+DtLPQfpp/M/r79Eg/ST+
Zxykn4P0c1z6uS1I15P0k/ifcZB+DtLPQfpp/M87d9JP4n/GQfo5SD/HpZ/HgpD7JP0k/mectL80
ST8n6afxP6/cJ+kn8T/jJP2cpJ/T62d5g5Q76SfxPyPxPyPxP+PF/yz2SdpfmrS/RPzPOGl/yfif
9/Wk/aVJ86NJ86NJ86Pp50fFfk6aH03aX5o0P5q0Pz9pf376/fmiFqTrWel6kn+f8P64aPzP+3rC
++PipP7npPnRpPnR9POjYt9J86Ob//kG6XoCPyRO4IfE6fkhJVmQrie8vyNO2p+fdP59Lvi7Oen8
O/E/46Tz75POv09//r2YLtH590nn34n/GSedf5/U/1x0/t34n1fui86/E/8zLjr/vuj8+/Ln30ux
IOS+6Pw78T/jovPvi/aXFu0vGf/zzp32l4j/GRf1Pxf1P5fvf5ZqQcqd9peI/xmJ/xmJ/xkv/mdp
FoTfo0X+nfifcVH9uaj+XFR/Lqo/F9Wfi+rP5evP0i1I15PqT+J/RuJ/RuJ/xov/WYYF6XpS/Un8
z7io/lzk3xfVn4vqz0X156L6c/n6s0wL0vWk+nNR/blIP4n/GRfVn4v8+6L6c1H9uaj+XFR/Ll9/
lmVByJ34n5H4n3HD+zej8T+vv9ob3r8ZN82PNu1/btr/3H7/s2wLwvO54f1HcZN+btLPDe/fjJv0
c5N+btLPTfq5L/08FqR7BPy6uEk/N82P9nd+9N0c2zQ/Iv5n3DQ/2jQ/2n5+9A3SPSL93KSfm+ZH
+31/nJuZbpofEf8zbpofbZofbT8/qu8n6R7R+U3if8YN/Lpo/M/rPOwGfl3cVH9uqj831Z/b159V
LEj3iM5vbqo/N9Wfxv+8JvWb9HOTfm6qPzfVn9vXn1UtSPeI9pc21Z+b+CHG/7y2KQ7p5yH9PMQP
OcQPOZ4fUu07iR9yyL8f8u8H3h8Xjf95cQ8O6ech/Tzw/rh44P1x8fj3x9VkQbhHh/Y/if8Zif8Z
z/v+OPcXlvifkfifkfifkfif8eJ/1mxBuke0P0/8z3io/jzv/tKXqB8P6ech/TxUfx6qP4+vP2ux
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
/aykn5X0s5J+1ks/uwUh90r6SfzPVOH9m6mSflbST+N/Xn83K+kn8T9TJf2spJ/10s9hQcqd9JP4
n6kCvy5V0s9K+lmp/1lJP4n/mSrpZyX9rJd+TgtS7qSfxP9MtdJ9J/9eqf9p/M9L6yr1P4n/mSr1
Pyv1P6vvf45lQcqd+p/E/0zE/0zE/0wX/3NsC8Lfjgr8+UT8z0T8z2T8zzqC0xDST+J/JuJ/JuJ/
pov/OY4F6XqSfhL/M1WqPyvpZyX9NP5n7W29n2ykn430s5F+NtLP5vVzvkHIvV36KRaE3BucP0rG
/7y2EBucP0qN/HuD80epwfmj1Pz5o/l+Ep7PRv3PRv69Uf+zUf+zUf+T+J+pUf+zUf+z+f7ntCtP
/c9G/c9G/c9G8/dG8/fm5+9TLUjXk/SzkX420s9G86NG+tlIPxvpZyP9bF4/p30n6SfxPxPxP1Oj
/c9G/c9G86P2zo9y+H6S5keN9LPR/KjR/Kj5+dFMFqTcaX5E/M/UqP/ZqP/ZaH7U3vlR/m5TNJof
NdLPRvOjRvOj7udHM1sQcu80PyL+Z+rU/+zU/+w0P+rv/Ch/t6c6zY861Z+d5ked5kfdz49msSDl
TvMj4n+mTv3PTvrZST97hGe+k3520s9O+tlJP/uln9WClDvpJ/E/U6f+Z6f+Z6f5US9032l+1Ek/
O82POs2Pup8fzWZByp3mR53mRx34yamTf+80P+qdcqf5USf97DQ/6jQ/6n5+NLsFKXeaH3WaHxH/
MxH/M3WaH/VFuZN+dtLPTvOjTvOj7udHc1iQcqf5Uaf5EfE/E/E/06D50Xgg90H6OUg/B82PBs2P
hp8fzWlByH3Q/GhQ/Un8z0T8zzRofmT8zzt30s9B+jlofjRofjT8/GguC1LuND8aND8i/mci/mca
ND8amXIn/Rykn4PmR4PmR8PPj+a2IOVO86NB8yPifybif6ZB/c/RKHfqfw7Sz0H9z0H9z+H7n/NY
kHKn/ifxP9Mg/z6o/hzk38ek3Mm/E/8zDfLvg/z78P59vUHKnfw78T/ToPNHg+rPQf59HMh9kn8n
/mea5N8n+ffp/fuyT5J/n9T/JP5nmtT/nFR/Tup/zrf/6c6MTOp/Ev8zEf8zEf8zXfzPZT8n9T8n
9T+J/5km1Z+T6s9J/c+Z6L5T/3OSfk7qf07qf07f/1xqQcqd+p+T+p+T9j8n1Z+T/Psk/z7Jv0/S
z0n+fZJ/n96/L/tO8u+T/Psk/z6p/iT+Z5rk3+eg+07+fZJ+TvLvk/z79P59JQtS7uTfif+ZJu3P
T6o/J/l34396Qlea5N+J/5km+fdJ/n15/76yBSH3Bfz5RPzPtICfnIz/Wav4T0KvcpF+LuAnpwX8
5LQ8P3kVC0JvbSn8bi7Sz0X151L43VxUfy6qPxfVn4vqz+Xrz1UtSPeI6s9F9ecCfnJawE9Oy/OT
V7MgXU/gJ6dF9eci/278z9rn9/d9kX9fpJ+L/Psi/768f1/dgnQ9yb8v8u+rw+/7ovpzkX9fr393
XI5F+rlIPxf590X+fXn/voYFKXfy74v8+4f/+edfX/QsLf8sTQvSs7TpWSL9XKSfxv+8nyXSz0X6
uUg/F+nnvvRzWRCu56b+5yb93HR+c9P5ze3Pb65tQbiem85vbqo/N9Wfxv+8ruem+nOTfm6qPzfV
n/uqP48F6XpS/bmp/iT+ZyL+ZyL+ZzL+55071Z/E/0zE/0zE/0wX/3O/Qcqd6k/if6ZN5zc36eem
+tP4n3fuVH9uqj831Z+b6s/t689tn6T6c1P9uan+3DQ/Iv5n2lR/Gv/zzp3qz03156b6c1P9uX39
ucWClDvVn8T/TMT/TMT/TBf/c6sFSUNo/k78z0T8z7Tf/c9Q308S/zMR/zMR/zMR/zNd/M9t30n+
/dD8nfififif6eV/9hrcJ6GmJf5nIv5nIv5nuvifO1kQ7tHN/7SMqP4k/mc6EeoQ4n8m4n8m4n8m
4n+mi/+5swXpHtH8iPif6dD8/dD8/fj5+y4WpOtJ+nlIPw/p53n3l+TrEYj/mYj/mQ7p5yH9PJd+
VgvS9ST9PKSfh/TzkH4e0k/jf965k34S/zMd0s9D+nku/WwWpNxJPw/p5yH/fqj+PFR/nrf+rN9d
o0P1J/E/06H680D9+YuJcLl3C/6be37Av+cH6s/8gH/Pxv/0lJX8gH/PxP/8hSH9k1F+wL/nx/v3
PSz47+9mfsC/Z+J/5gf8ezb+Z20/Ruv9JPj3/IB+5gf8e37Av+fH+/c9LUj3CPx7fsC/5wf8e37A
v+fH+/e9LEjXE85vZuJ/5gf8e36+/t09IeDf8wP6mR/w7/kB/54f79/3tiBdT/Dv+QH/nh/gh+QH
+CH58fyQfSxI1xP4IfkB/cwP6Gd+3v7nt+efH9DPTPzP/IB+5gf0Mz9eP88bpOu5SENAP/MD7+/I
xv+8M4L3d2Tif+YH3t+RH3h/R378+zvO+0m4RwHm7zlA/ZkDvD8uB9LPQPoZSD8D6Wcg/Qykn4H0
M3j9PGJByh3m7zmQfgZ4f3Em/mcm/md++Z9eaYn/mYn/mYn/mYn/mS/+51ELUu4wf8/E/8wB3r+Z
A9SfOQC/Lhv/01cCOQC/Lgfw7znA+aMc4PxRDv780bHvhPNHOcD8PQeoP/PN/7TcST+N/3nn3t/7
Ht0nKXeoP3OA/fkcYH8+B78/f5IFKXeYv+dA+nnzPy136H9m4n9m43/60zqZ+J+Z+J+Z+J+Z+J/5
4n8e+znBv2fif2bif+YA74/LxP/MAvy6/PI//X0n/mcm/mcm/mcm/me++J+nWBByJ/5nJv5nFnh/
XCb+Zyb+ZxaF+078z0z8z0z8z0z8z3zxP0+1IOUO/LpM/M8siXKn+lOAX5eN/3nfd+DXZeJ/ZgH/
ngX8exbv30+zIOUO/j0L1Z8C/OQssL+UBfh12fifd+7Ar8tC+ilUfwrVn+Lrz9MtSLmDf89C9afA
/CgLzI+y+PnRGRaEWlFgfpSF9FNIP+XVz+8mcxbSTyH9FNJPIf2USz+nBel6kn4K6aeQfhL/MxP/
MyvpJ/E/M/E/M/E/M/E/88X/PMuCkDvxPzPxP7OSfhL/MxP/M7/8zyt30k/if2bif2bif+aL/3m2
BSl30k/if2bif2bif2bif+aX/+k9AvE/M/E/M/E/M/E/88X/PMeClDvpJ/E/s5J+Ev8zE/8zv/xP
/3eT+J+Z+J+Z+J+Z+J/Z8z/L9z+n3Ek/if+ZddB9h/3P/OF//sl9gkdQeH9cVtJPhfl7Vpi/Z10+
9/eTlDvM3zPxP7PC+zuykn9XeH9HNv7nfd/h/R1ZST8jvL8jR3h/R46Pz10sCLkT/zMT/zMT/zO/
/E//W0z8z0z8z0z8z0z8z+z5n+VRC8LfYuJ/ZuJ/5gjnN3Ok/meE+VE2/uf1JEeYH2Xif+YI86Mc
YX6UY/a523fC/ChHmB/lSPoZYX8+R+p/Rup/xu/5o2/FEqn/SfzPHKn/Gan/GZvPPVmQcqf+ZyT9
jMCvyxH2l3KE/aVs/M/7vsP+Uib+Z45Uf0aqP+P0udvPSfVnpPozkn5G4M/nCPvzOcL5oxwX5Q7n
jzLxP3OE80c5wvmjHI/PvViQcofzRzmSfibg1+VE/c8E54+y8T8vrUtw/igT/zMnOH+UE5w/ykl8
7tWCkHuC80c5Uf2ZaH6UqP+ZaH5k/M/rvieaHxH/MyeaHyWaH6Xkc28WpNxpfpSo/kzAr8uJ+p8J
zh9l43/e9530k/ifOcH5o5zg/FFO1efeLUi5w/mjnKj+TMCvy4n6nwnOH2Xjf965w/mjTPzPnOD8
UU5w/iin4XMfFqTc4fxRTlR/JuDX5UT9zwTnj7LxP+9nHs4fZeJ/5gTnj3KC80c5bZ/7tCDlDueP
cqL6MwF/KSfy7wn2l3I6cN8z7C9l4n/mDPtLOcP+Us7B574sCLlnOH+UM82PMvDrcqb6M8P+Z85C
ucP+Zyb+Z86w/5kz7H/mHH3u24KUO+x/5kzzowz8pZyp/syw/5lzotxh/zMT/zNn2P/MGfY/cy4+
92NByh32P3Om+VGG80c5U/2ZYX8p50q5w/5SJv5nzrC/lDPsL+Xs9pdKeIOUO+wv5Uzzowz8+Zyp
/sw0f8+Dcqf5O/E/c6b5e6b5e14+d/skzd8z7C/lTP3PTP3PTP3P7PqfJYgFwRcT/zMT/zMT/zNn
0k/if2bif2bif2bif2bP/yxBLQjXk/ifmfifmfifmfifmfifuZB+Ev8zE/8zE/8zE/8ze/7nT8oW
pNxJP4n/mYn/mYn/mYn/mQvpJ/E/M/E/M/E/M/E/s+d/lpAsSLmTfhL/MxfSz0L6WUg/S4V6qZB+
Ev8zF9LPQvpZLv20n5P0s5B+FtLPQvpZSD8L6Wch/Sykn8T/zIX0s5B+lks/iwUpd9LPQvpZ4P0d
uZB/L7D/mQvsf+YC+5+Z+J+5wP5nLrT/WR+fe7Ug5F7h/FGuND+q8P6OXMm/V+p/Vup/Vup/Ev8z
V+p/Vup/Vt//DM2ClDv1Pyv1Pyv1Pyv590r9zxopd+p/Ev8zV+p/Vup/Vt//DN2ClDv1Pyv1Pyvt
f1by75X6n5X2Pyv1P4n/mSv1Pyv1P6vvf4ZhQcqd+p+V+p+V+p+V/Hul/mftlDv1PyvpZ6X+Z6X+
Z/X9zzAtSLlT/7NS/7PC+zsy8T9zpf5npf5npf5nJf2s1P+s1P+svv8ZlgUpd+p/Vup/Nup/Ev8z
N+p/Nup/Nup/NtLPRv3PRv3P5vufYVsQcm/U/yT+Z27U/2xUfzbqfzal3Kn/SfzP3Kj/2aj/2Xz/
MxwLUu7U/2zU/2zU/2xUfzbqfzbqfzbqfzbSz0b9z0b9z+b7n/IGKXfqfzbqfzbqfxL/Mzfqfzbq
fzbqfzbSz0b9z0b9z+b7n2KfpP5no/5no/5no/4n8T9zo/5nm5Q79T8b6Wej/mej/mfz/U8RC1Lu
1P9s1P9s1P8k/mdu5N8b+fdO/r2Tfnby7538e/f+XdSCkHsn/97Jv3fy78T/zJ38exf4G9fJv3fS
z07+vZN/796/i30n+fdO/r2Tf+/U/yT+Z+7k33ui3Mm/d9LPTv69k3/v3r9LsiDlTv69k3/v5N+J
/5k7+fdO/r2Tf++kn538eyf/3r1/F/s5yb938u+d/Hsn/078z9zJv/dBuZN/76Sfnfx7J//evX+X
YkHKnfx7J//eyb8T/zN38u+d/Hsn/95JPzv5907+fXj/LtWCkPsg/z7Ivw/y78T/zIP8+wiQ+yD/
Pkg/B/n3Qf59eP8uzYKUO/n3Qf59kH8n/mce5N8H7S8N8u+D9HOQfx/k34f379ItSLmTfx/k3wf5
d+J/5kH+fRTKnfz7IP0c5N8H+ffh/bsMC1Lu5N8H+fdB/p34n3mQfx+0vzTIvw/Sz0H+fZB/H96/
y7Qg5U7+fZB/H+Tfif+ZB/n3Qf59kH8fpJ+D/Psg/z68f5dlQcqd/Psg/z7JvxP/M0/y7/OB3Cf5
90n6Ocm/T/Lv0/t32RaE3Cf590n+fZJ/J/5nnuTfJ+0vTfLvk/Rzkn+f5N+n9+9yLEi5k3+f5N8n
+Xfif+ZJ/n2Sf5/k3yfp5yT/Psm/T+/f9Q1S7uTfJ/n3Sf6d+J95kn+f5N8n+fdJ+jnJv0/y79P7
d7VPkn+f5N8n+fdJ/p34n3mSf5/k3yf590n6Ocm/T/Lv0/t3FQtS7uTfJ/n3Sf6d+J95kn+f5N8X
+fdF+rnIvy/y78v7d1ULQu6L/DvxP/Mi/76o/lzk3xfN3xf5d+J/5kX+fZF/X96/q30n+fdF/n2R
f1/k3xfVn4v8+6L5+yL/vkg/F/n3Rf59ef+uyYKUO/n3Rf59kX8n/mde5N8X7S8t8u+L9HORf1/k
35f372o/J/n3Rf59kX9fxA8h/mde5N8X+fdF/n2Rfi7y74v8+/L+XYsFKXfy74v8+yL/TvzPTPzP
7Pif7r6Tfyf+Zyb+Zyb+Z/b8z6LVgpA78T8z8T/zJv++qf7c5N83+fdN/p34n3mTf9/k37f379os
SLmTf9/k3zf590315yb/bvzP6/Qo8T8z8T/zJv++yb9v79+1W5ByJ/++yb9v8u+b6s9N/n2Tf9/k
34n/mTf5903+fXv/rsOClDv5903+fZN/31R/bvLvxv+87zv5d+J/5k3+fZN/396/67Qg5U7+fZN/
3+TfN9Wfm/z7Jv++yb9v0s9N/n2Tf9/ev+uyIOVO/n2Tfz/k34n/mQ/5d+N/Xvf9kH8/pJ+H/Psh
/368f9dtQcj9kH8n/mc+5N8P1Z+H/Psh/37IvxP/Mx/y74f8+/H+XY8FKXfy74f8+yH/fqj+POTf
jf9533fy74f085B/P+Tfj/fv8Q1S7uTfD/n3Q/6d+J/5kH83/uedO/n3Q/p5yL8f8u/H+/donyT/
fsi/H/Lvh/w78T/zIf9u/M87d/Lvh/TzkH8/5N+P9+9RLEi5k38/5N8P+Xfif+ZD/t34nz73X4ze
P7n/BP/9zvKAfy8P+PfyeP8e1YL/5l4e8O+F+J/lAf9eHqg/ywP+vRj/884d/Hsh/md5wL+XB/x7
ebx/j/ad4N/LA/69PODfywP+vTxQf5YH/Hsx/uedO/j38oB+lgf8e3nAv5fH+/eYLEi5g38vD/j3
8oB/L8T/LA/492L8zzt38O/lAf0sD/j38oB/L4/379F+TvDv5QH/Xh7w7+WB+Xsh/mch/md5+Z9X
7uDfC/E/C/E/C/E/i+d/llgsSLmDfy/E/ywP+PfyQP1ZHvDvxfifd+7g38sD+lke8O/lAf9egvfv
sVoQcg/g3wvxP0sA/14C1J8lgH8vxv+8cg/g30sg/Qzg30sA/16C9++xWZByB/9eiP9ZAvj3EqD+
LAH8ewng30sA/14C6WcA/14C+PcSvH+P3YKUO/j3QvzPEsC/lwD1Zwng34vxP+/cwb+XQPoZwL+X
AP69BO/f47Ag5Q7+vRD/swTw7yVA/VkC+PcSwL+XAP69BNLPAP69BPDvJXj/HqcFKXfw74X4nyWA
fy8B6s8SwL8X43/euYN/L4H0M4B/LwH8ewnev8dlQcod/Hsh/mcR4C8VAf5SEc9fituC899/XYC/
VIT0U0g/hfRTSD+J/1mE9FNIP+XSz2NBuJ5C+kn8zyKkn0L6KaSfQvoppJ/E/yxC+imkn+L1M71B
yp30k/ifRUg/hfRTSD+F9FNIP4n/WYT0U0g/xetnsk+SfgrpJ/E/i5B+CumnkH4K6aeQfhL/sxD/
sxD/s3j+Z0n2u0n6SfzPQvzPIqSfQvoppJ9C+imkn0L6KaSfQvopXj+TWpByJ/0k/mdR6H8WJf+u
0P8sCv3PotD/LEr6qdD/LAr9z6K+/5nsO6H/WRT6n4X4n0Wh/1mU/LtC/7OoUu7Q/yxK+qnQ/ywK
/c+ivv+ZkgUpd+h/FuJ/FoX+Z1Hy7wr9z6LQ/ywK/c+ipJ8K/c+i0P8s6vufyX5O6H8Whf5nIf5n
Ueh/FiX/rtD/LAr9z6LQ/yxK+qnQ/ywK/c+ivv+ZigUpd+h/FuJ/FoX+Z1Hy7wr9z6LQ/ywK/c+i
pJ8K/c+i0P8s6vufqVqQcof+ZyH+Z1HofxYl/67Q/yxK/c9I/c9I+hmp/xmp/xl9/zM1C0Lukfqf
kfqfkfqfxP8skfqfkfqfkfqfkfQzUv8zUv8z+v5n6hak3Kn/Gan/Gan/SfzPEqn/Gan/Gan/GUk/
I/U/I/U/o+9/pmFByp36n5H6n5H6n8T/LJH6n5H6n5H6n5H0M1L/M1L/M/r+Z5oWpNyp/xmp/xmp
/0n8zxKp/xmp/xmp/xlJPyP1PyP1P6Pvf6ZlQcqd+p+R+p+R+p/E/yyR+p+R+p+R+p+R9DNS/zNS
/zP5/mfaFoTcE/U/E/U/E/U/if9ZEvn3RP49kX9PpJ+J/Hsi/568f0/HgpQ7+fdE/j2Rfyf+Z0nk
3xP590T+PZF+JvLvifx78v49v0HKnfx7Iv+eyL8T/7Mk8u+J/Hsi/55IPxP590T+PXn/nu2T5N8T
+fdE/j2Rfyf+Z0nk3xP590T+PZF+JvLvifx78v49iwUpd/Lvifx7Iv9O/M+SyL8n2F8qifx7Iv1M
5N8T+ffk/XtWC1Lu5N8T+fdM/p34nyWTf89w/qhk8u+Z9DOTf8/k37P379m+k/x7Jv+eyb/f/E+x
IP2c5N8z7C+VTP49k35m8u+Z/Hv2/j0nC1Lu5N8z+fdM/p34nyWTf8+Zcif/nkk/M/n3TP49e/+e
7eck/57Jv2fy75n8O/E/Syb/nhvlTv49k35m8u+Z/Hv2/j0XC1Lu5N8z+fdM/p34nyWTf8/ATy6Z
/Hsm/czk3zP59+z9e64WpNzJv2fy75n8O/E/C/E/Syb/TvzPQvzPQvzPQvzPcvE/c7Mg5E78z0L8
z0L8z0L8z0L8z0L8z0L8z0L8z0L8z0L8z3LxP3O3IOVO/p34n6WQfyf+ZyH+Zynk34n/WYj/WYj/
WYj/WS7+Zx4WpNzJvxP/sxD/sxD/sxD/sxQ4f1SI/1mI/1mI/1mI/1ku/meeFqTcyb8T/7MQ/7MQ
/7MQ/7MQ/7MQ/7MQ/7MQ/7MQ/7Nc/M+8LEi5k38n/mch/mch/mch/mcpcP6oEP+zEP+zEP+zEP/z
5/H0uW8LQu7E/yzE/yzE/yzE/yzE/yzE/yzE/yzE/yzE/yzE/ywX/zMfC1Lu5N+J/1mI/1mI/1mI
/1mI/1mI/1mI/1mI/1mI/1ku/md5g5Q7+Xfifxbifxbifxbifxbifxbifxbifxbifxbif5aL/1ns
k+Tfif9ZiP9ZiP9ZiP9ZiP9ZiP9ZiP9ZiP9ZiP9ZiP9ZLv5nEQtS7uTfif9ZiP9ZiP9ZiP9ZKs3f
if9ZiP9ZiP9ZiP9ZLv5nUQtS7uTfif9ZiP9ZiP9ZiP9ZGs3fif9ZiP9ZiP9ZiP9ZLv5nse8k/078
z0L8z0L8z0L8z0L8z9Jo/k78z0L8z0L8z0L8z3LxP0uyIOVO/p34n4X4n4X4n4X4n6XR/J34n4X4
n4X4n4X4n+Xifxb7Ocm/E/+zEP+zEP+zEP+zEP+zNJq/E/+zEP+zEP+zEP+zXPzPUixIuZN/J/5n
If5nIf5nIf5naTR/J/5nIf5nIf5nIf5nufifpVqQcif/TvzPQvzPQvzPQvzP0si/E/+zEP+zEP+z
EP+zXPzP0iwIuRP/sxD/sxD/sxD/sxD/s3SavxP/sxD/sxD/sxD/s1z8z9ItSLmTfyf+ZyH+ZyH+
ZyH+Z+nk34n/WYj/WYj/WYj/WS7+ZxkWpNzJvxP/sxD/sxD/sxD/s3SavxP/sxD/sxD/sxD/s1z8
zzItSLmTfyf+ZyH+ZyH+ZyH+Z+nk34n/WYj/WYj/WYj/WS7+Z1kWpNzJvxP/s9z8T7Eg/Zzk34n/
WYj/WYj/WYj/WYj/WS7+Z9kWhNxv/me2IOT+4X/eGRn/079nuYxLP6MF6Tv/q593Rhf/8/2HPvXn
fzM6FpyQ0aWfbxCu583/tNzJv3/4n39yj5R7pNxJPz/8zz+5J8o9udy/Qco9U+6knzf/UyxIP2eh
3AvlXih30s8P//NP7pVyrz7395OUe6PcST9v/qfdd/LvH/7nn9w75d4pd9LPD//zT+6Dch8+d7tH
g3KflDvp583/tNzJv3/4n39yX5T7otxJPwe8P64MeH9cGf79cVUtSLkfyp30c5B+DtLP6fWzRguC
fs4Hfo8m6eck/Zykn5P0c5J+TtLPSfo5vX7WZEG4npP0k/ifZZJ+TtLPSfo5ST8n6eck/Zykn5P0
c176aT8n6eck/ST+Z5mkn5P0c5J+TtLPSfo5ST8n6eck/ZyXfhYLUu6kn8T/LLNR7qSfk/TT+J9X
FTRJPyfp5yT9nKSf89LPakHKnfw78T8L8T8L8T8L8T8L8T8L8T8L8T/Lxf+szYKkS+Tfif9ZPvzP
P//6oet5/PXsFoTrefM/xYKQ+6L+56L+56L+56L+56L+56L+5/L9zzosCNdzUf9zUf9zUf+T+J9l
Uf/T+J8/wfL9JPU/F/U/F/U/F/U/l+9/1mlByj2Bzi/qf374n38y+ujn+MX9fz8Jv++L9PPD//yT
UYHn0/if/81oWZCezwpaR/zPsirlTv3PD//zT+4twt1slDvp54f/+Sf3Trl3n/u2IOU+KHfy72uA
zi/qf374n39yn5T7pNyp/vzwP//kvij35XM/FqTcN+VO/n1tuu+knx/+55/cD+V+KHeaH206/77p
/Pv259/bG4Tcb/7nG4Tcd4DcN9WfH/7nnbvxP6/ct0Dum/Tzw//8k7tS7upzfz9JuUfKnfRzR3jm
N9WfH/7nn9w/+vnzl2u4T1LupJ8f/uef3DPlnn3u9nNmyr1Q7jQ/2oVyp/rzw//8k3uFmnZXyp30
88P//JN7o9ybz10tSLl3yp3mR7tT7lR/fviff3If9MwPyp3088P//JP7pNynz92+c1Lui3Kn+nMv
+n0n//7hf/7JfVPum3In/dxUf26qP7evP1uyIOR+8z/fIOR+qP95yL8f8u+H/Psh/35IPw/590P+
/Xj/3uznJP9+yL8T/7Mc8u+H/Psh/37Ivx/y74f085B/P+Tfj/fvrViQcif/TvzPcjLlTvXnIf9+
yL8f8u+H9POQfz/k34/3761akHIn/078z3Ko/3mo/jzk3w/1Pw/590P6eci/H/Lvx/v31ixIuVP/
k/if5VD/81D9eaj/eaj/eaj/eUg/D/U/D/U/j+9/tm5Byp36n8T/LIf6nwf6n7//f/evDwv+6w3r
A/3P+oB+1gf0sz6gn/UB/azE/6wP6Gd9QD/rc+nntOC/17M+oJ+V+J/1Af2sD+hnfUA/6wP6WR/Q
z0r8z/qAftYH9LM+l34uC1LuoJ+V+J/1Af2sD+hnfUA/6wP6WR/Qz0r8z/qAftYH9LM+l35uC1Lu
oJ+V+J/1Af2sD+hnfUA/6wP6WR/Qz0r8z/qAftYH9LM+l34eC1LuoJ+V+J/1Af2sD+hnfUA/6wP6
WR/Qz0r8z/qAftYH9LM+Xj/7G6TcQT8r8T/rcyh38O/1w/+8czf+55X7zf+MFqTvDJD7xf98/6Hg
c38/Cbnf/M83CLkHgdwD+Pf64X/+yV0pd6XcST8//M8/uUfKPfrcxYKUe6LcYX+pBuh/1gD+vQbo
f1bjf965Q/+zEv+zBuh/1gD9zxp8/7OrBSl36H9W4n/WAP69BvDvNUD/s4a3/5mD+yR9J+lngP5n
DdD/rMH3P7t9J/Q/a4D+ZyX+Zw2D7jv49xqg/1nDpPsO/c9K/M8aoP9ZA/Q/a/D9z54sSLlD/7MS
/7MG6H/WAP69Buh/1nAod+h/VuJ/VoH+ZyX+Z734nz1bEHIX6H9W4n9Wgf5nFao/BfqfVQRyF+h/
ViH9FOh/VoH+ZxXf/+zFgpQ79D8r8T+rRMqd6k+B/mc1/uedO/Q/q5B+CvQ/q0D/s4rvf/ZqQcod
+p+V+J9VCuVO9adA/7MK9D+rkH4K6adA/7MK9D+r+P5nbxak3KH/WYn/WaVT7lR/CvQ/qwzKHfqf
VUg/BfqfVaD/WcX3P3u3IOUO/c9K/M8q0P+sQvWnQP+zyqbcof9ZhfRToP9ZBfqfVXz/sw8LQu4K
/c9K/M+q0P+sSvWnkn9X8u9K/l1JP5X8u5J/V+/f+7Qg5U7+nfifVcm/K9WfSv5dyb8r+Xcl/VTy
70r+Xb1/78uClDv5d+J/ViX/rlR/Kvl3Jf+u5N+V9FPJvyv5d/X+vW8LUu7k34n/WZX8u1L9qeTf
lfy7kn9X0k8l/67k39X7934sSLmTfyf+Z1Xy70r1p5J/V/LvSv5dST+V/LuSf1fv38cbpNzJvxP/
syr5d6X6M5J/j+TfI/n3SPoZyb9H8u/R+/fxfhJyj+Tfif9Z41V/igXp5yT/Hsm/R/LvkfQzkn+P
5N+j9+/Dfk7y75H8O/E/ayT/Hqn+jOTfI/n3SP49kn5G8u+R/Hv0/n2oBSl38u/E/6wR9pdqpPoz
kn+PjXIn/x5JPyP590j+PXr/Puw7yb9H8u/E/6yR/Huk+jOSf4/k3yP590j6Gcm/R/Lv0fv3kSxI
uZN/J/5njeTfI9Wfkfx7JP8eyb9H0s9E/j2Rf0/ev49sQcg9kX8n/mdN5N8T1Z+J/Hsi/57IvyfS
z0T+PZF/T96/j2JByp38O/E/ayL/nqj+TOTfE/n3RP49kX4m8u+J/Hvy/n1UC1Lu5N+J/1kT+fdE
9Wci/57Ivyfy74n0M5F/T+Tfk/fvo1mQcif/TvzPmsi/J6o/E/n3RP49kX9PpJ+J/Hsi/568fx/d
gpQ7+Xfif9ZE/j1R/ZnIvyfy74n8eyL9TOTfE/n35P37GBaE3DP5d+J/1kz+PVP9mcm/Z/Lvmfx7
Jv3M5N8z+ffs/fuYFqTcyb8T/7Nm8u+Z6s9M/j2Tf8/k3zPpZyb/nsm/Z+/fx7Ig5U7+nfifNZN/
z1R/ZvLvmfx7Jv+eST8z+fdM/j17/z62BSl38u/E/6yZ/Hum+jOTf8/k3zP590z6mcm/Z/Lv2fv3
cSxIuZN/J/5nzeTfM9Wfmfx7Jv+eyb9n0s9M/j2Tf8/ev883SLmTfyf+Z83k3zPVn4X8eyH/Xsi/
F9LPQv69kH8v3r/P95OQeyH/TvzPWmj+Xqj+LOTfC/n3Qv69kH4W8u+F/Hvx/n2KBSl38u/E/6yF
/Huh+rOQfy/k3wv590L6Wci/F/Lvxfv3qRak3Mm/E/+zFvLvherPQv69wPmjWsi/F9LPQv69kH8v
3r9P+07y74X8O/E/a4HzR7VQ/VnIvxc4f1QL+fdC+lnIvxfy78X795ksSLmTfyf+Zy3k3wvVn4X8
e4HzR7WQfy+kn5X8eyX/Xr1/n9mCkHsl/078z1rJv1eqPyv59wrnj2ol/15JPyv590r+vXr/PosF
KXfy78T/rJX8e6X6s5J/r4lyJ/9eST8r+fdK/r16/z6rBSl38u/E/6yV/Hul+rOSf6+Vcif/Xkk/
K/n3Sv69ev8+mwUpd/LvxP+sFfh1tQK/rlbPr5vdghH+ddLPSvpZST8r6Wcl/ST+Z62kn5X0s176
OSxI15P0k/iftZJ+VtLPSvpZST8r6SfxP2sj/Wykn+3Sz2lByL2RfhL/szbSz0b62Ug/G+lnI/0k
/mdtpJ+N9LNd+rksSLmTfhL/szbSz0b62Ug/G+lnI/0k/mdtpJ+N9LNd+rktSLmTfhL/szbSz0b6
2Ug/G+lnI/0k/mdtpJ+N9LNd+nksSLmTfhL/szbqfzby7436nw3Ob9ZG/U/if9ZG/c9G/c/m+5/r
DVLu1P8k/mdt1P9s5N8b9T8bnN+sjfqfxP+sjfqfjfqfzfc/1/tJyL1T/5P4n7VT/7OTf+/U/+wB
cu/U/yT+Z+3U/+zU/+y+/7nEgpQ79T+J/1k79T87+fdO/c8eKXfqfxL/s3bqf3bqf3bf/1xqQcqd
+p/E/6yd+p+d/Hun/mcvlDv1P4n/WTv1Pzv1P7vvfy77Tup/dup/Ev+zdup/dvLvnfqfvVPu1P8k
/mft1P/s1P/svv+5kgUpd+p/Ev+zdup/dqo/O/U/+6Lcqf9J/M/aqf/Zqf/Zff9z2c9J/c9O/U/i
f9ZO/c9O9eeg/ud4IPdB/U/if9ZB/c9B/c/h+5+rWBByH9T/HNT/HNT/HFR/Dup/DqXcqf9J/M86
qP85qP85fP9zVQtS7tT/HNT/HNT/HFR/Dup/jky5U/+T+J91UP9zUP9z+P7nahak3Kn/Oaj/Oaj/
Oaj+HNT/HNT/HNT/JP5nHdT/HNT/HL7/uboFKXfqfw7qfw7aXxpUfw7y74P8+yD/TvzPOsi/D/Lv
w/v3NSxIuZN/H+TfB/n3QfXnIP8+yL8P8u+D9HOSf5/k36f372taEHKf5N8n+fcJ/Lo6gV9Xp+fX
rWVB6AVN2v+cpJ+T9NP4n+33lUvfT8L1JP5nnaSfk/RzXvq5LUjXk/Rzkn5O0s9J+jlJP43/eedO
+kn8zzpJPyfp57z081iQcif9nKSfk/Rzkn5O0k/jf965k34S/7NO0s9J+jm9fu43SLmTfk7Sz0n6
OUk/J+mn8T/v3Ek/J+nnJP2cpJ/T6+d+P0m5k35O0s9J+kn8zzpJP43/eedO+jlJPxfp5yL9XF4/
t1gQcl+kn8T/rIv6n4v8+6L+p/E/r9wX9T+J/1kX9T8X9T+X739utSDlTv1P4n/WRf3PRf59Uf/T
+J937tT/JP5nXdT/XNT/XL7/ue07qf+5qP+5qP+5qP+5yL8v6n8a//POnfqfxP+si/qfi/qfy/c/
d7Ig5U79z0X9z0Xzo0Xzo+XnR9uuEs2PiP9Zif9Zif9Zjf8Zzznuk3Q9ST+J/1mJ/1kv/ucuFqTr
Ce/vqMT/rAve31GN/5meHr+fhPd31EX+fQF/qS7iL23PX9rVgnCPNvGXNvn3Tf1P43/+ZNTdJ+Ee
Ef+zbup/bup/bt//3M2CcI828JPrpv7nBn5yNf5nen4M4ftJ4CdX4n/WDfzkuoGfXLfnJ+9uQbpH
ie4R6eem+tP4n+mZ7h5R/bmp/txUf26qP7evP/ewIN2jCr9Hm+rPDe8/qsb/TM9yGcH7j+qm/ueG
9x/VDe8/qtu//2hPC9I9Av5nJf5nJf5nNf5nevZwn6R7RPpJ/M9K/M968T/3siDdI5ofEf+zbup/
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
Pkn9zwLnNxvxPxvxP1t5+5+ut0b8z0b8z0b8z0b8z+b5n1Xs56T+J/E/G/E/W6H6k/ifjfifrWT4
W0z8z0b8z0b8z0b8z+b5n1XUgpQ77H824n824n824n824n+20ui+0/yI+J+N+J+N+J/N8z+r2HfS
/Ojmf9oTQv3PQvOjMuh3k+ZHheZHheZHheZHxc+PJFmQfjcX6FKh/mch/ST+Zytw/qiVDZpcqP9Z
qP9Z4PxRK3D+qNXH554tCLlX2l+qtL9UYX++1Xd/3nVfK/U/if/ZKuzPtwr7862Kfz6LBeH5rLS/
VGl/qdL+Z333591cptL+J/E/W6X9z0r7nzX5e1QtSPeI9j+J/9nqNT+y+07zo0rzd+N/XmpTaf5O
/M9Waf5eaf5e/fxdmgUpd9r/JP5nq1R/Vqo/P/zPP7k3y939lak0PyL+ZyP+ZyP+Z/P8zyrdgpQ7
+Xfif7Y6QZMr6Wel/aVK+0uV9pcq1Z+V9pcq7S9Vv78kw4KU+4Z6ififjfifrb7+vThdIv9O/M9G
/M9G/M/m+Z8/cmRB0KWb/ykWhOvZaH+pBfjdbLS/1Gh/qdH+UqP9peb3l2RZEO5RU3g+G9WfN/8z
W5B+TvLvLcLfzUb+vVH92ci/N/Lvzft32Rak3Mm/N6o/G/n39vp3t8/QyL8T/7M18u+N/Hvz/l2O
Ben5bPR8kn420s/26qf7jWukn8T/bI30s5F+Nq+f+gbpHgE/pBH/szXqf7a3/+k2bxv1Pxv1Pxv1
Pxv1P5vvf+r7SbpH1P9sVH828u+N/Hvz/l3tvpN/b+TfG+lnp/35/u7P5+w+CdeT+J+t0/58p/35
Hvz1VAvC9ezAr2ud9LOTf+/k3zv59/76d+d6Ovl34n+2Tv69k3/v3r+rfSf5957g972TfnbaX+rv
/pLPiPaXiP/ZOu0vddpf6n5/SZMF4fnsND8i/mfrcP69dfLvHc6/t/6ef3fK0OH8eyP+Z+vU/+zU
/+y+/6nZgpQ78JMb8T9bp/5nf/uf7i9sp/5nJ/3s1P/s1P/svv+pxYL0fFL/s1P92an/2Rc9n+Tf
O+lnJ/3spJ/90s9qQbpHhzSE9JP4n228+pmq+yTcI+J/NuJ/NuJ/tnHpZ7Mg3KOb/5ktCNdz0Pmj
8T1/9L1Hg/z7IP8+6PzRoPNHI/p71C0I92jQ/tKg+fug+pP4n22Qfhr/M541v58k/Rykn4P0c5B+
jks/hwUpd9LPQfo5SD+J/9kG6afxP9NUlzvp5yD9HKSfg/RzXPo5LUi50/xokH4O0s/x6qc77ThI
P4n/2Qbp5yD9HJd+LgvS7ybp5yD9HKSfg+ZHg/ST+J9tkH4O0s9x6ee2IN0j0k/if7ZJ+jlf/XSd
vUn6OUk/J+nnJP2cl34eC8I9mlR/TtLPCfzkRvzPRvzPNt/60ykt8T8b8T8b8T8b8T+b53/W+AYp
d6o/if/ZJumn8T+vcyiT9HOSfk7Sz0n6Ob1+Rvsk6ecs8HxO0s9J+0vz3V9yJ9Qm7S8R/7NN2l+a
tL80/f5StJ+T9pdmp3tE/n3S/rzxPy+dn7Q/T/zPNml/ftL+/PT781EtSPdo0j0i/z5pf37S/vyk
/flJ86NJ+/OT9uen35+P9p20Pz8P1GCT5keT9ufnuz/v6uRF+/OL5u+L9ucX7c8vvz8fkwXhHi3a
XyL+ZyP+Z1sCf4uJ/9mI/9mI/9mI/9k8/7PGbEG4R8T/bMT/bIvmR4vmR8vPj2KxIF1Pmr8T/7Mt
mr8b//OqVBfN3xf1PxfN3xfN35efv8dqQbqeNH9fVH8uOv++6Pz7av56NgvS9bzm72+Qcqfz78b/
vK8nnX9fVH8uOv++6Pz7Gv56dgvS9YT3d7RF86NF/BDif7ZF+mn8zzt30s9F+rlIPxfp57r0c1iQ
cof3dzTif7ZF/c9F9eem+tP4n1fum+pP4n+2TfXnpvpz+/ozTgtC7pvqz03156b50ab50fbzo7gs
CL9Hm+ZHm+rPTeffjf9Zf38lvp+k60n+fdP5903n37c//x63Bel6Uv25qf7cNH83/mdKrqbdNH/f
NH/fNH/fNH/ffv4ejwXpHlH9uan+3LS/tBv8Ld60v7RJPzftL23aX9p+fym9QbpHVH9uqj837S9t
2l/atL+0ST837S9t2l/afn8p2Sdpf4n4n434n434n22//DpX0xL/sxH/sxH/sxH/s3n+Z01iQbhH
h+pP4n+2Q/ufxv+8fMeh/c9D8/dD+5+H9j+P3/9MakG4R4fqz0P15yH/fl7/7rzhIf9+SD8P+fdD
/v14/57sO8m/H+p/HvLvh/z7If9+SD8P6ech/37Ivx/v31OyIN0jmr8f8u+H/Pt5/bvrsRzST+J/
tkP+/ZB/P96/p2xBukc0fz/k3w/59/M9//6dOBzST+J/tkP+/ZB/P96/p2JBukc0fz9Ufx6qP8/r
310P8JB+Ev+zHao/D9Wfx9efqVqQ7hHtfx6qPw/59/P69+8s8je1f77zJ/jvd/YH/Ht/wL/3x/v3
1Cz47z3qD+x/9gf8e3/Av/fn9e/fTaf+gH524n/2B/x7f8C/98f799Qt+O896sT/7MT/7A/sL/Xn
3V/6bvv0B/SzP6Cf/YH9pf7A/lJ//P5SGhakewT+vT/g3/sD+0v9efeXvts+/QH97A/oZ39gf6k/
sL/UH7+/lKYF6R7B/Kg/MD/qD+wv9efdX/rStPoD+tmJ/9kf2F/qD+wv9cfvL6VlQbpHMD/qD8yP
+gP7S/1595fycJ+k7wT97A/sL/UH9pf64/eX0rYg3SOYH3Xif/YH9uf78+7PP/P7SdDP/oB+9gf2
5/sD+/M9+P35dCwI94j4n534nz3A/nwP8P6OHkg/A+lngP35HmB/vge/P5/fINwj4n924n/2APvz
Pbz7818CZw+kn4H0M0D/swfof/bg+5/ZPgn9z078z078zx6g/9mN//nzaFf3SfpO0s8A/c8eoP/Z
g+9/ZrEg3SPof3bif/YA+/M9QP3ZA/j3bvxP37PqxP/sxP/sAfx7D+Dfe/D+PasFKXd4f1wPUH/2
APVnD1B/9uDrz2wZQf3ZA/Q/eyD9DFB/9gD9zx6g/uwB6s8eoP7sAerPHnz9mZMF6XpC/7MH0s8A
/c9O/M8u0P/sAv3PLqSfQvop0P/sAv3PLr7/mbMFIXeB/mcn/mcXqj+F6k8B/97l9e9OFYn/2Yn/
2QX8exfw7128f8/FgpQ71Z9C9aeAf+8C+0ud+J+d+J9dwL93Af/exfv3XC0Iv5sC+0tdqP4U4Cd3
If0U2F/qxv+8/iII1Z9C9afA/lIX2F/q4veXcrMg5d4pd5gfdYH5UReYH3Xx86PcLUjPEsyPOvE/
u8D5o278z/tZgvNHXWB/qQucP+oC54+6+PNHeViQrifwQzrxP7tQ/SmknwL+vRv/88qd+J+d+J9d
yb8r+Xf1/j1PC0LuGiB3pfpT4fxRV9JPhf3PbvzPO3eqP5XqT4X9z66w/9nV73/mZUHKHfY/u8L8
qCvMj7rC/Kirnx/lbUH4PVJ4f0cn/mdXmB91zXQ9YX7UFeZHXWF+1BXmR139/CgfC9L1pPqT+J+d
+J+d+J/94n+WN0jXE/hLnfifnfifXTtdT+h/duJ/duJ/duJ/9ov/WeyTVH8q1Z/E/+xK/l3Jv6v3
70UsSNcTzh91Jf+u5N+N/3lfT9JP4n92Jf+u5N+j9+9FLQjXMz5wPSPVn5Hqz0j1Z/T1Z4kWhOsZ
qf6MpJ+R9DO++/Ouqoykn5H0M5J+RtLP6PWzJAvS9YT5eyf+Zyf+Z//yP10/hPifnfifnfifnfif
/eJ/lmxBukekn8T/7BHe39Hj+/4O17OKVH9Gqj8j7C/1CPtLPfr9pVIsSPeI/Hsk/x5hf6nH9/0d
rq8YYX+pR6o/I9WfkerP6OvPUi1I9wjm7z1S/Rmp/ozv+XfX+41Uf0aqPyPVn5Hqz+jrz9IsSPcI
5u+d+J+d+J89wvn3TvzPTvzPTvzPTvzPfvE/S7cg3KME8/dO/M+e4Px7T+/5dzdDSVR/JtLPBPtL
PcH+Uk9+f6kMC8I9SuTfE/n3BPtLPb3v73BzLuJ/duJ/9kT1Z6L6M/n6s0wL0j0i/56o/kxUfyaq
PxPpJ/E/e6L6M1H9mXz9WZYF6R5R/Un8z57Ivyfy74nmR8b/vHoCieZHxP/sxP/sxP/sF/+zbAtS
7sAP6cT/7In0M5F+JtLP9Oqnf5JJPxPpZyL9TKSf6dLPY0HKnfw78T97ovozUf2ZyL8b//O675n8
eyb/nsm/Z/Lv2fv3bxByz+Tfif/ZM+lnJv3MVH8a//POnerPTPVnpvozU/2Zff1Z7ZNUf2by75n0
k/ifnfifPVP/0/ifd+6kn5n0M1P/M1P/M/v+ZxULUu7U/yT+Zyf+Zyf+Z7/4n1UtCH87iP/Zif/Z
M+lnJv3MpJ+Z9DOTfmbSz+z1s9p3kn5m0k/if/ZM+plJPzPpp/E/79xJP4n/2TPpZyb9zF4/a7Ig
5U76mUk/M+lnJv3MpJ+Z9LOQfhL/sxfSz0L6WS79zBaE3AvpZyH9LKSfhfSzkH4W0s9C+llIPwvp
ZyH9LJd+FgtS7qSfhfSzkH4S/7MX0s9C+llIPwvpZyH9LKSf5dLPakHKnfSzkH4W8u/E/+yF5keF
5keF6s9C+lloflRoflT8/Kg2C1LuND8q5N8L9T+J/9mJ/9mN/3nnTvpJ/M9O/M9O/M9+8T9rtyDl
DvzPTvzPTvzPTvzPTvzPbvzPO3fST+J/duJ/duJ/9ur7n3VYEHKv1P8k/mev5N8r+fdK/t34n1fu
lfSzkn5W8u+V/Hv1/r1OC1LucP6oV/LvxP/sxP/slfY/jf955076WUk/K+1/Vtr/rH7/sy4LUu6Z
cqf9pUr7S5X2l6rfX6rbglArVtpfqqSflfSzkn5W0k/if/ZK+llJP+uln8eCdD1JPyvpZyX9rKSf
lfSzkn5W0k/if/ZK+llJP6vXz/YGKXfSz0r6WUk/K+lnJf2spJ+V9LOSflbSz0r62bx+tmBByL2R
fjbSz0b6SfzPTvzP3kg/if/Zif/Zif/Zif/ZL/5nEwtS7qSfxP/sjfST+J+d+J+9kX4S/7MT/7MT
/7MT/7Nf/M+mFqTcST+J/9kb9T8b9T8bzY+M/3nnTvVnI/1sND9qND9qfn7U7DtpftTg/HtvND8i
/mcn/mdvNH83/uedO+lnI/1sNH9vNH9vfv7ekgUpd5q/E/+zN/Lvjfx7A/5SN/7nnTvpJ/E/O/E/
O/E/+8X/bNmClDvtfxL/s3fy7538e4fzm934n1funfSzk352OL/ZO5zf7N2f32zFgpD7zf98g5Q7
+fdO/r3T/rzxP+/cST876Wen/flO+/Pd78+3akHKHfjzvdP8nfifnfifvdP8yPifd+6kn530s9P8
qNP8qPv5UWsWpNxpftRpfkT8z078z96p/9mp/9lJPzvpZ6f+Z6f+Z/f9z9YtSLlT/5P4n71T/dmp
/uzU/+w0P+qkn8T/7J36n536n933P9uwIOVO8/dO/c9O8/f+zt/dtLrT/J34n33Q/H3Q/H34+Xub
FgTPNUg/B+nnoPpzvPN3t1EwqP4k/mcfVH8Oqj/HVX8uC8I9GjR/H1R/Dpq/G//z+o0bNH8n/mcf
NH8fNH8ffv7etgXpHtH+J/E/+6DzR4Pqz0HnN43/eedO5zeJ/9kHzY8GzY+Gnx+1Y0HKneZHxP/s
g/aXBtWfg/aXjP955077S8T/7IP2lwbtLw2/v9TfIOVO+/OD9HPQ+c1B9eeg80fG/7xzp/NHg/z7
oPNHg84fDX/+qL+fpNzp/NEg/z5IP4n/2Yn/2Y3/eeVO/M9O/M9O/M9O/M9+8T+7WBByJ/5nJ/5n
n3T+iPifnfif3fifd+6kn8T/7MT/7MT/7Bf/s6sFKXd4f1wn/meftP85qf6cdH5z0vnNSfo5ST8n
9T8n9T+n7392+07qf07qf07y75P8+yT/Pr1/78mC8Hdzkn+fpJ+T9HOSfk7Sz0n6OUk/J+nnvPQz
W5CuJ+nnJP2cpJ/E/+zE/+yT9JP4n534n534n534n/3if/ZiQcqd9JP4n32Sfk7Sz0X6uUg/F+nn
Iv1cpJ+L9HNd+lktCLkv0s9F+kn8z078z75IPxfp5yL9XKSfi/RzkX6uSz+bBSl30s9F+kn8z078
z078z75IP4n/2Yn/2Yn/2Yn/2S/+Z+8WpNxJP4n/2Yn/2Yn/2S/+Zx8WBP0k/mcn/mcn/mdfpJ/E
/+zE/+zE/+zE/+wX/7NPC9L1JP0k/mdfpJ/E/+zE/+yL9JP4n534n534n534n/3if/ZlQcqd9JP4
n32RfhL/sxP/s2/ST+J/duJ/duJ/duJ/9ov/2bcFIXfif3bif/ZN+rlJPzfp5yb93KSfxP/sm/Rz
k37uSz+PBSl30s9N+rlJPzfp5yb93KSfm/Rzk35u0s9N+rm9fo43SLmTfm7Sz036uUk/t9fPYZ8k
/dykn8T/7Jv0c5N+btLPTfq5ST836ef2+jnEgnQ9ST+J/9k36ecm/dykn5v0k/ifnfiffZN+btLP
7fVzqAUpd9LPTfq5ST836ech/Tykn4f085B+HtLPQ/p5vH4O+07Sz0P6eUg/if/Zif/Zif/ZD+kn
8T878T878T878T/7xf8cyYKUO+kn8T/7If08pJ+H9POQfh7Sz0P6eUg/D+nnufQzW5ByJ/08pJ/E
/+zE/+yH+Evn5Se7rvuh/uch/TzEXzrEXzqevzSKBSl3mr8T/7Mf2l86Lz/ZTUYOzY8O6eeh/aVD
+0vH7y+NakH4e0T8z078z36An9zPy09206tD86ND86MD/OR+gJ/cj+cnj2bBf+/R77Hcf/71n+C/
13M8MH8fD8zfxwPzo/HA/Gg8MH8fD8zfx+Pn76Nb8N97NB6Yvw/if44H5u/jgfn7eGD+Ph6Yvw/i
fw7if44H5u/jgfn7ePz8fQwLUu4wfx8P6Od4YP4+HpgfjQfm7+OB+ft4YP4+Hpi/jwfm7+OB+ft4
/Px9TAtS7jB/Hw/o5yD+5yD+5yD+53hg/j6I/zmI/zmI/zmI/zku/udYFqTcYf4+iP85HtDP8YB+
jgfm7+OB80fjgfn7eGD+Ph6Yv48H5u/j8fP3sS1IucP5o/GAfg7ifw7if44Hzh+NB84fjUD6GUg/
A5w/GgHOH43gzx+NY0HIPcD5o0H8zxFg/j4C1J8jwPmjEV5+yPcv1yD+5yD+5whw/mgEOH80gj9/
NN8g5Q7z9xFg/j4C8ENGePkh3+piEP9zEP9zBOCHjAD8kBE8P2S+n4S/xYH0M5B+Btj/HOHlh3wr
wBFg/3MQ/3ME8O8jgH8fwfv3KRakewT15yD+5wjg30d4+SFf2sYI4N9HAP8+Avj3EcC/j+D9+1QL
0j0i/Qykn4H0MwC/bgTSz0D6GUg/A+ln8Po57TtJPwPpZyD9DFB/jgD15wi+/pzJgnA95dLPNwi5
C9WfQvWnUP0pVH8K1Z9C9af4+nNmC8L1FKo/if85hPRTSD+F6k+h+lOo/hSqP4XqT6H6U3z9OYsF
KXeqP4X0k/ifg/ifQ6j+FKo/hfRTSD+F6k+h+lN8/TmrBSl3qj+F6k/ifw7ifw6h+lOo/hSqP4Xq
T6H6U6j+FF9/zmZByp3qT6H6U0g/if85iP85hOpP4n8O4n8O4n8O4n+Oi/85uwUpd9JP4n8O4n8O
4n8O4n8OofqT+J+D+J+D+J+D+J/j4n/OYUHInfifg/ifg/ifg/ifg/ifQ+H8+yD+5yD+5yD+5yD+
57j4n3NakHKH8++D+J9D4fzRUOh/DoXz70Ph/PtQ0k/ifw6F8+9D4fz7UH/+fS4LUu5w/n0o7H8O
pfpTqf5UOL85FM5vDiX9VNJPhfObQ+H85lB/fnNuC1LucH5zKNWfxP8cxP8cCv3PoXB+cyjpp5J+
KvQ/h0L/c6jvf85jQcodzm8Ohf7nUDh/NIj/OYj/ORTObw7ifw7ifw7ifw7if46L/7neIORO/M9B
/M8Rqf6MVH9G2J8fEc5vjkj6SfzPEWF/fkTYnx/R788v+yTsz48I5zdHhPnRiDA/GhHmRyP6+dES
C4JHiDA/GpH0M5J+RtLPSPoZST8j6Wck/YxeP5dakK4n6Wck/YywPz8i7M+P6Pfnl2UE+/Mjwv78
iKSfkerPSPVnpPozUv0Zqf6MVH9GX3+uZEG6nlR/Rqo/P/zPP//6pOs5/fXMFqTrueh6Uv0Z4fzm
iHB+c0TSz0j6GeH85ohwfnNEf35zFQvS9YTzm4P4nyNR/Zmo/kzk3xP5d+J/DuJ/jkT+PZF/T96/
r2pByD2Rf0/k3xO8P24keH/cSP79catZEJ6lBO9/H4n8e4Lz7yO9749zHbNE9Wci/Uxw/n0kOP8+
kj//vroF6XrC/H0kmL+PBOePRoL3x40E549GIv1MpJ+J9DNd+jksSPeI6k/ifw7if470vj/OdZ6J
/zmI/zmI/zmI/zku/ueaFqR7BO+PG8T/HAneHzfS9/1xxX2SvhP2l0YC/vxIwJ8fyfPn17Ig3SPS
z0T6maj+TO/7477k6kH8z0H8z5Go/kxUf+ar/twWhHuUYX9pZKo/M7w/buT3/XFfuvjI8P64QfzP
keH9cSPD++NG9u+PW8eCcI+I/zmI/zky9T/z+/64LwF+ZOp/ZtLPTP3PTP3P7Puf+w3SPaL5Uab+
Z4b9pWH8T0/pH5n0M5N+ZthfGhn2l0b2+0v7/STdI/Lvmfx7Jv9u/M9r3pFJP4n/OTL590z+PXv/
vsWCdI/Iv2fy7xneHzcy+fdM/t34n3fu5N+J//n/s3Wu2a7jrBbtkvVAQs3Rs/9NuDvfPTioMv/V
YPikNpazsgBpehSq3wvV78XX7ztZkHKn+r1Q/V5g/+cosP9zFL//c1tGsP9zFNj/OYj/OYj/Ocr7
/mL37SD+5yD+5yD+5yD+57j4n1ssCPezkn4S/3NUeH/xqO/7i52CVdj/OSr5z0r+s5L/rN5/7mJB
WKNK+llJPyv5z/r6T/crQ/zPQfzPUcl/VvKf1fvPXS1Ia0T6WUk/K/nP+vpP5wQq+U/if45K/rOS
/6zef261IK0R6SfxP0cl/1lf/+ncWiX/Wcl/VvKflfxn9f5zNwvSGpH/rOQ/K/nP+vpP56gr+c9K
/rOS/6zkP6v3n7tbkNaI/CfxPwfxP0d9/aereoj/OYj/OYj/OYj/OdT7zz0sCGuk5D+J/zmU/Ke+
/tNVpkr6qaSfSv5TyX+q9597WhDWSMl/KvlPJf9p/M/r9534n4P4n0PJfyr5T73857IgrRHN35X8
pwI/ZCj1P5Xm7wrv7xhK83el+bvS/F1p/q5+/r63BSl3mr8rzd8V3h83FN4fN9S/P24fC9KzBO+P
G0r6qcCvGwr8ukH8z0H8z6HArxsK/Lqhnl933iDdT+DXDSX9VJq/K/U/lfqfSv1P4n8O4n8Opf6n
Uv9Tff/z2JXU/1Tqfyr1Pxv5z0b+s1H/s1H/k/ifg/ifo1H/s1H/s/n+54kWhNwb9T8b+c9G+tlI
PxvpZ6P9S8T/HMT/HI30s5F+Nq+fJ1mQcif9bKSfjeZHjfSzkX422r9E/M9B/M/RSD8b6Wfz+nns
M0k/G+lnI/1s5D8b+c9G/rPR/Ij4n4P4n6OR/2zkP5v3n0csSLnT/KiR/2xUvzeq3xvtX2q0f4n4
n4P4n6PR/qVG+5ea3790igUpd9q/1Gj/UiP/2ch/NqrfG+1fIv7nIP7n6FS/d6rfu6/fT7Ug5N5p
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
pJ+F9LNQ/V6ofi++fs9qQVoj8p+F/Geh+r289bv7PSqkn4X0s1L9Xql+r75+z82CsEaV/Gcl/1mp
fq9v/d6/36NK+llJPyvV75Xq9+rr99wtCGtUyX9W8p+V6vf61u8juivpM0k/K9Xvler36uv3PCxI
a0T+s5L/rFS/17d+H9/vUSX9rKSfler3SvV79fV7nhakNaL6vVL9Xql+N/7nX0bdXUmfSfpZqX6v
VL9XX7/nZUFaI6rfK9Xvlep343/+ZeS+R6SflfSzUv1eqX6vvn7P24K0RlS/V6rfK9Xvxv/sfbrv
EelnJf2sVL9Xqt+rr9/zsSCskVL9rlS/K9Xvxv/8y+j7PVLSTyX9VKrflep39fW7vEFYI6X6Xal+
V6rfjf/5l1F3V9Jnkn4q1e9K9bv6+l3eK2mNqH5Xqt+V6nfjf/5l9P0eKekn8T+nUv2uVL+rr98l
WpDWiPYvKdXvSvN343/2vqK7kj6T9JP4n5P4n9PzP5skC9Ia0fyd+J9Taf6u5D+V6nfjf157D5Tq
d6X6Xal+V6rf1dfvYp9J9bvC+aNJ/M+p5D+V/Kd6/yliQXqWgB8ylfRTyX8a//O+n+Q/if85G/nP
Rv6zef8pxYJwP2/+5xuE+9lo/3yj/fON9s8b//PKvZF+Ev9zNto/32j/fPP756VakHKH9x9N4n/O
Rv6zkf9sVL8b//POnep34n/ORvV7o/q9+fpd1IKUe6XcyX820s9G+tlIPxvtX2qkn8T/nI30s5F+
tks/mwUpd9JP4n/ORvV7I/1spJ+N9LORfhL/czbSz0b62S797Bak3Ek/if85G/nPRv6zkf80/ued
O/lP4n/ORv6zkf9s3n/KsCDk3uH975P4n5P4n5P4n9PzP/++vBaE3w7if07if85O+tlJPzvpZyf9
7KSfnfSzX/q5LEj3k/Szk3524IfMDvyQ2T0/RLYF6X4CP2R20s8O7z+axv+87yftn++0f77D+49m
h/cfzV79/TwWpPupdD+p/9mp/9mp/9l9/7O8QbqfcH5zdqrfO/U/jf9530/ST+J/zk79z079z+77
n+W9ku4n8Osm8T9np/3znfbPdzi/OY3/eedO+kn8z9nh/ObscH5zdn9+s0QLUu7w/qNJ/M/ZyX92
8p+D5kfG/7xyHzQ/Iv7nJP7nJP7n9PzPVpIFIXfif07if85B+jlIPwfV78b/vHOn+n1Q/T6ofh9U
vw9fvxf7TKrfB7y/eBL/cw7yn4P0c5B+DtLPQfo5SD8H6ecg/RxeP4tYkHIn/ST+5xzkPwf5z0H9
T+N/3rlT/3OQfg7qfw7qfw7f/yzFgpQ7vD9uDup/DvKfg/znoPNH4z1/5Pohg/RzkH4OOn806PzR
8OePSrUg5U7z90Hz90Hnj8Z7/sj1rIj/OYn/OQedPxp0/mj680dFLQi/xZP0c5J+TuDXTeN/Xn1F
4n9O4n/OCfy6OYFfN6fn15VmQVijSfP3SfP3Cfy6afzPq/dL/M9J/M85yX9O8p/T+8/SLUhrRPo5
ST8n6afxP6/+PPE/J/E/5yT9nKSf89LPYUFaI5q/T9LPSfuXjP95zVCI/zmJ/zkn7V+atH9p+v1L
ZVqQ1oj85yT/Oal+n+/5IzfnIv7nJP7nnFS/T6rfp6/fy7IgrRHN3yfV75P2L813/5KbRRL/cxL/
c07avzRp/9L0+5fKtiCtEfnPSf5zkf9c7/4lNy8m/uck/udc5D8X+c91+c9jQVijRfP3Rf5z0f6l
9e5fcjN94n9O4n/ORfuXFu1fWn7/Un2DsEaL+p+L+p+L+p/r3b/k9l0s0k/if85F/c9F/c/l+5/1
vZLWiObvxP+ci/YvrXf/ktsbs0g/F+nnovp9Uf2+fP1eowVpjch/LvKfi+r3RfuXFunnIv1cVL8v
qt+Xr99rsiCtEc3fF9Xvi/YvrXf/kttjtkg/F+nnovnRovnR8vOjap9J86NF/c9F/c9F86P17l9y
+wAX6eci/dw0P9o0P9p+flTFgrBGxP+cxP+cxP+c+92/5PZqEv9zEv9zEv9zEv9zXvzPWiwIa0T8
z0n8z0n8z7nf/UtuPy3xPyfxPyfxPyfxP+fF/6zVgrRGNH8n/uck/ufc7/4lt+eZ+J+T+J+T+J+T
+J/z4n9WtSCtEdXvxP+cm+r3/Z4/cr9Hm/Rzk35uqt831e/b1++1WZDWiPYvbarfN+1f2u/5I3d2
YJN+btLPTfuXNu1f2n7/Uu0WpDWC9x/NTf1P4n9O4n/OTfW78T/1Wfq9kur3TfX7pvp9U/1+fP1e
hwUh90P8EOJ/TuJ/TuJ/zov/WacF4Vk61P8k/uck/uc0/ufV3SL+5yT+5yT+5yT+57z4n3VZkO4n
vP9oEv9zHtq/dKj/eWj/0hH4Hh3Sz0P6eWj/0qH9S8fvX6rbgpQ7zd8Pzd8Pzd+N/3lp3SH9PKSf
h+bvh+bvx8/f67EgPZ/EXyL+5yT+5zT+5/V7RPzPSfzPSfzPSfzPefE/v0FaI+p/Ev9zEv9zGv/z
8gzE/5zE/5zE/5zE/5wX/1PfK2mNSD+J/zmJ/zmN/+l93V/5/vuZf8Hfz1zE//wL/q7RuvifGi34
u0aL+J+L+J/rgfn7Mv6n/5VZxP9cxP9cxP9cxP9cF/9TkwV/12g9MH9fxP9cD/jP9YB+rgfq9/V8
zx+51YT6fT1Qv68H6vf1QP2+Hl+/q30m1O+L+J+L+J+L+J/ry//8fuPWA/X7Iv7nIv7nIv7nuvif
Khak5xP85yL+5yL+5/ryP7+quIj/uYj/uYj/uYj/uS7+pxYL0hqB/1zE/1zE/1zG//S/XIv4n4v4
n4v4n4v4n+vif2q1IK0R1O+L+J+L+J/L+J/eXSzify7ify7ify7if66L/6lqQVgj4n8u4n8u4n+u
APX7Iv7nIv7nIv7nIv7nuvif2iwIaxSgfl/E/1wB6vdl/M9L5wPpZyD9DFC/rwD1+wq+ftduQVoj
4NetAP5zEf9zEf9zEf9zffmffjXBfy7ify7ify7if66L/6nDgpQ7zI8W8T8X8T9XgPd3LOJ/LuJ/
LuJ/LuJ/rov/qdOC9HzC+zsW8T9XIP0MpJ+B9DNM+m6SfgbSz0D6GUg/w6Wfy4KUO+lnIP0MpJ+B
9DOQfgbSz0j6GUk/46Wf24LwfBL/cxH/cxH/c8UAv3HE/1zE/1zE/1zE/1wX/1OPBWGNiP+5iP+5
iP+5YgYfQvzPRfzPRfzPRfzPdfE/2xukNYL6fRH/c0Xof65YwCtG8p+R/GeE/ueK0P9c0fc/m10J
/c9F/M9F/M8Vof+54nt+s7mnjvxnJP8Zof+5IvQ/V/T9zxYtSGsE+5dWhPp9Ef9zEf9zRdi/tIz/
ef2+R6jfV4T6fUXYv7Qi7F9a0e9fasmClDu8P24R/3NF0s9I+hlJPyOcP1rE/1zE/1yJ9DORfiav
ny1bEHJPcP5oJdLPRPV7ovo9Uf2eYP/8SlS/J6rfE9Xvier35Ov3Jhak3Kl+T1S/E/9zEf9zEf9z
JTh/tIj/uYj/uYj/uYj/uS7+ZysWpNzh/NEi/udK5D8T+c8E/c+V4PzRSqSfifQzQf9zJeh/ruT7
n61akHKH80crkf8k/uci/udKsH9pJTh/tBLpZyL9TLB/aSXYv7SS37/U1IKUO5w/WsT/XMT/XMT/
XBf/szULwu9mgvObi/ifi/ifK5F+Ev9zEf9zEf9zEf9zXfzP1i0I9zOTfhL/c2U4/74ynH9f2Z9/
b8OCcD9zhPuZST8z7J9fOYEPIf7nIv7nyrB/fmXYP7+y3z/fpgXpfsL8aGWYH60M86OVBbwi8T8X
8T9XhvnRyjA/WtnPj9qyIK0R6Wcm/cykn/k9/+78PPE/F/E/Vyb9zKSf+dLPbUFaI6rfM+lnhvnR
yu/741zNRfzPRfzPlWF+tDLMj1b286N2LEhrRP4zk//MMD9a+X1/nKuLif+5iP+5MsyPVob50cp+
ftTfIK0RzI9WhvnRyjA/WpnmR8T/XMT/XELzI6H5kfj5UbcraX4k5D+F/KeQ/xSaHxH/cxH/cwn5
TyH/Kd5/9mhBWCMh/ynkP4X8p5D/FPKfxv+8cyf/KeQ/hfynkP8U7z97siDlTv5TyH8K1e9C9bv4
+r1bRlS/C7y/eAnpp1D9Lt/63X07qH4Xqt+F6neh+l18/d7FgnQ/ST+F9FNg/9IS2L+0hPqfQv1P
gf1LS2D/0hK/f6kXC9IakX4K6afA+fclLz/Z/coI1e9C/lPg/PsSOP++xJ9/79WCsEaF9LOQfhbg
L63y8pecEyjU/yzkPwv5z0L+s3j/2dWCsEaF9LOQfhbyn+XrP6O7kj6T/Gch/1nIfxbvP3uzIK0R
+c9C/rOQ/yxf//l96gr5z0L+s5D/LOQ/i/efvVuQ1oj8ZyH/Wch/Gv/z+u0o5D8L6Wch/1nIfxbv
P/uwIK0R1e+F/CfxPxfxP1eh+t34n3fuVL8Xqt8L1e+F6vfi6/c+LUi5U/1O/M9F/M9F/M918T/7
siA9S1S/E/9zEf9zGf/zvp9UvxP/cxH/cxH/c138z74tCPezUv1O/M9VyX9W8p+V/KfxPy9lqKSf
lfSzkv+s5D/r5T+PBSl3OL+5KvnPCu/fXPV9/6ZT70r6WUk/K7x/c1V4/+aq/v2b4w3C81lp/l5p
/l5p/l7f+bv7ha2kn5X0s9L8vdL8vfr5+3ivpDWi+Xul+Xul+bvxPy8XVKl+r6Sflebvlebv1c/f
R7QgrRHpZyX9rDQ/Mv7n5VQr1e+V6vdK86NK86Pq50cjWZDWCPbPr0rzowr751d9z7+7aqJS/V6p
fq+wf35V2D//0VyXUbYgrJHC+c2lsH9+KZx/X8b/vPq0SvqppJ8K59+Xwvn3pf78+xALwhppAp1X
2D+/iP+5iP+5lObvCuePllL9rlS/K83flebv6ufvo1iQcif/SfzPpTR/1+/8/ashSvN3pfpdqX5X
qt/V1++jWpCeT/KfxP9cSvW7NtB5pfpdqX5Xqt+V6nf19ftQC9IaUf2uVL8r1e/68pOby4jqd6X6
Xal+V6rf1dfvo1mQ1ojqd6X6Xal+15ef3N33iOp34n8upfpdqX5XX7+PbkFYo0b1e6P6vVH93t76
/XtmeTWq34n/uRrV743q9+br9zEsCGtE/M9F/M/VqH43/uefnx/uSvpM0s9G9Xuj+r35+n1MC9Ia
AX9pNfKfxP9cxP9cDfghq738EPer3ch/NvKfDfghqwE/ZDXPDxnLgpQ77Z9vtH++AT9kNXj/0Wrk
Pxv5zwb8kNWAH7Ka54eMbUF6Pql+J/7nIv7navD+o0X8z0X8z0X8z0X8z3XxP8exIK0R7f8k/udq
wA9Z7eWH+IzIfzbynw34IasBP2Q1zw+Zb5DWiOr3RvV7B37I6vD+o9XJf3bynx3Ob64O5zdX9+c3
53slrFGn/Z+d9n92OL+5OvBDVofzm6uT/+xwfnN1OL+5uj+/OaMFYY06+c9O/rPT/Ki/54+GWyPS
T+J/rk7zo07zo+7nRzNZkNaI/Gcn/9np/JHxP68KpZN+Ev9zEf9zEf9zXfzPaZ9J54+I/7mI/7k6
1e+d6vdO83fjf15duE7+s5P/7DR/7zR/737+PsWClPuk3Kl+76SfnfSzk34a//Ned9LPTvrZST87
6We/9LNYkHI/lDvp5yD/Och/DvKfxv+8ch/kPwf5z0H+c5D/HN5/zmpByH3Q/iXif65B+jlIPwfw
65bxP+/cqf85qP85gF+3BvDr1vD8uqkWpNyBn7yI/7kG1e+D6vdB9bvxP+/cST8H6eeg+n1Q/T58
/T6bBSl3mr8T/3MN8p+D/Oeg/qfxP69frkH6OUg/B/U/B/U/h+9/zm5Byp3OHxH/cw3yn4P85/D+
cw4Lwu/moPnRIP0cpJ+D9JP4n4v4n2uQfg7Sz3Hp57Qg3U/Sz0H6OUk/J+nnJP2cDzxLk/Rzkn5O
0s9J+jkv/VwWhNwn1e+T9HNS/T7f+btzqpPq90n1+6T6fVL9Pn39PrcF4fmcND+aVL9Pmr9P2v85
ST8n6eek+fuk+fv08/d5LEhrRPOjSfOjSfP3+e7/dBXfpP7nJP2cNH+fNH+ffv6+3iCtEennJP2c
5D8n7f+c5D8n+c9J/nOS/5zefy67kvznpPnRJP85af/npP2fk/qfk/qfk/Z/Ttr/Of3+zxUtSGtE
86NJ86NJ+z8n7f9cpJ+L9HPR/s9F+z+X3/+5kgVhjRbNjxbNjxbN39c7f3fd10X6uUg/F83fF83f
l5+/L/tMmr8v8p+L/Oei+fvK8Hu0SD8X6eei+fui+fvy8/clFqQ1ov7nov7novn7eufvrue/SD8X
6eei+fui+fvy8/dVLEhrRP5zkf9c5D/X6z/dXGaRfi7Sz0X+c5H/XN5/rmpBWiPqfy7yn4vm7+vl
z7vZ2SL9XKSfi+bvi+bvy8/fl1qQ1oj85yL/uWj+voBftxbp5yL9XDR/XzR/337+vpoFYY028OvW
pv4n8T8X8T8X8T+X439+v3HE/1zE/1zE/1zE/1wX/3N1C1Lu5D+J/7mI/7m+/E/nLoj/uYj/uYj/
uYj/uS7+5xoWhOeT+J+L+J+L+J/ry/90Lp34n4v4n4v4n4v4n+vif65pQVoj8p/E/1zE/1ybzr8T
/3MR/3MR/3MR/3Nd/M+1LEhrRP6T+J+L+J9rf99f/HUXxP9cxP9cxP9cxP9cF/9zbQvSGpH/JP7n
2jR/3+/8fbg1ovn7pvn7pvn7pvn79vP3dSwIa3TIfx7yn4fqd+N/6uN6F4f085B+HqrfD9Xvx9fv
+w3CGh3qfx7yn4f85yH/ebz/3O+VdD/p/NEh/3nIfxr/8+oFEf9zEf9zHfKfh/zn8f5zRwvS/Sx0
P8l/HtLPQ/p5aH50Xn6d+3Ycmh8dmh8dmh8dmh8dPz/ayYKUO+nnIf08xK87L7/OKdih+fuh+fsh
ft0hft3x/Lptn0n8ukP6eUg/D/GXzpe/5NaI5keH+p+H9s8f2j9//P75LRakNSL9PKSfh/bPn5c/
75zAofn7gf7n55/8ZPQX/F2j/fj987tY8HeN9gP6uR/Qz/2A/9zP6z+/bm0/4D/3A/5zP+A/9wP+
cz/ef+5qwd812g/4z/2A/9wP+M/9wP7PTfzPTfzP/YD/3A/4z/14/7nVgrRG4D/3A/5zP+A/9wPz
o038z038z/2A/9wP+M+/osevUbMgrRHMj/YD/nM/UL/vB+r3/UD9vp/2q/P7gfp9P1C/7wfq9/1A
/b4fX7/vbkHKHer3/UD9vh+o3/cD9ft+oH7fD9Tv+4H6fT9Qv+/H1+97WJCeT6jf9wP1+36gft/P
d/+8ywjq9/1A/b4fqN/3A/X7Dr5+39OCsEYB9i/tAPX7DrB/fofw+1u8A/Q/d4D+5w6wf34H2D+/
g98/v5cFYY0CzN93gPn7DjB/3+F9f9y3s7cD9D93AP+5A8zfd4D5+w5+/r63BWmNYP/SDjB/3wH2
f+7w7v8cLiPof27if+4A+z93gP2fO/j9n/tYkNYI/OcO4D93gP2f2/iffjfvJv7nJv7nDrD/cwfY
/7mD3/953iCtUQedD+A/d4D6fQeo33eA+n2Ht37/OqtN/M9N/M8doH7fAer3HXz9fuxKqN93gPp9
B6jfd4D6fYfv/vnurqTPBP+5A9TvO0D9voOv30+0IDyfEer3HaF+3xHq9x3f+fvXz2/if27if+4I
9fuOUL/v6Ov3kywIaxRhfrQj1O87wvx9x+/8vbgr6TPJf0aYv+8I8/cd/fz92GfC/H1HqN93hPp9
R5i/7/idv7uMyH8S/3NHmL/vCPP3Hf38/YgFaY1gfrQjzI92hPn7ju/7O76z3U38z038zx1h/r4j
zN939PP3UyxIa0T+M5L/jDB/3/G7//Pr5yPpJ/E/d4T5+44wf9/Rz99PtSCtEez/3MT/3MT/3MT/
3Bf/86gF6X4C/3MT/3NH8p/G/7yfEPKfkfxnJP8ZyX8m7z9PsyDcz0T+M5H/TOQ/0+s/3beY+J+b
+J87kf9M5D+T95+nWxDWKJH/TOQ/E/nP9PWfLiPyn8T/3In8ZyL/mbz/PMOCtEbkP4n/uRP5z/Q9
f9TdlfSZ5D8T+c9E/jN5/3mmBWmNyH8m8p+J/Gd631/sHEsi/5nIfybyn4n8Z7r857IgrRH0Pzfx
PzfxP3d631/sXCXxPzfxPzfxPzfxP/fF/zzbgrRG0P/cxP/cCfZ/buN/XjVCovo9kX4m2P+5E+z/
3Mnv/zzHgrRGsP9zE/9zZ/KfmfxnJv9p/M9L5zP5T+J/buJ/buJ/bs//7O8/J/+ZyX8S/3MT/3N/
+Z+uhiX+5yb+5yb+5yb+5/b8z/69Ep5P4n9u4n9u4n/uTP6T+J+b+J+b+J+b+J/b8z/7Ey1Ia0T+
k/ifm/if+8v/dJ0T4n9u4n9u4n9u4n9uz//sT7IgrRH5T+J/buJ/7vy+P851t4j/uYn/uYn/uYn/
uT3/s7+fSf6T+J+b+J+b+J87f98ft92V9JlUvxP/cxP/c3v+Z3/EgrRG5D+J/7mJ/7mN/3n1/In/
uYn/uYn/uYn/uT3/sz/FgrBGN//zDcL9FJofCc2PBM5vbongQ4T8p5D/FDi/uQXOb27JPvdqQcqd
5kfE/9zE/9wi4BWJ/7mJ/7mJ/7mJ/7k9/7M/akF4PoXmR8T/3ALz9y3w/vct5D+F/KfA/H0LzN+3
NL9GzYK0RjB/38T/3ALz9y0dvKKQ/xTynwLz9y0wf98y/Bp1C9IaUf+T+J9bYP6+5Z2/u0mTkP8U
8p8C8/ctMH/fsv0aDQvSGlH/k/ifW2D+vuWdv7tpoMD8fQv5z0Lz90Lz9/L4NZoWhDUi/ucm/ucu
NH83/qff+7oL6Wch/Sw0fy80fy/Jr9GyIKzRzf98g3Q/qX4vVL8X2L+0C+xf2sT/3MT/3AX2L+0C
+5d2KT73bUHKHfYv7UL1eyH9LKSfhfSzwPn3XUg/C+lnIf0spJ/l0s9jQcodzr/vQvpZYP/nLrD/
cxe3/7OHN0jfI3j/0S7kPwvNj8p3/+dXGQrpZyH9LDQ/KjQ/Km5+1INdSfOjQv6zkP8sND8q7/zI
qXch/ST+5y40Pyo0PyrHr1G0IKxRJf9ZyX9Wqt/rl7/0zaiSfhL/c1eq3yvV79XX7yFZENaI+J+b
+J+7Uv1eaX5UqX6vpJ+V6vdK9Xv19Xuwz6T6nfifm/ifu1L9XoGfvCvV75Xq90r1e6X6vfr6PYgF
aY2ofif+565Uv1fgJ+9K9Xul+r1S/V6pfq++fg/FgrRGwE/exP/cxP/cxP/cnv/ZQ7Ug3U84/76J
/7mJ/7mN/3n9chH/cxP/cxP/cxP/c3v+Zw9qQbqfND8i/ueu1P+s1P+sx9/PZkG6n9T/rOQ/FfhL
2/if1/NJ/M9N/M+twF/aCvylrcHfz25BuJ8a4X4q+U8l/VTSTyX9VHj/0Sb+5yb+51bSTyX91Es/
hwUpd9JPJf1U0k999dP9IhD/cxP/cyvpp5J+6qWf04LwfCrpp5J+Kumnfvuf211Jn0n6qaSfSvqp
l34uC9IakX4q6adS/a5UvyvNj3TA77vS/EhJP5XmR0rzI50+921Byp3qd6X6XWl+pAs8mNL8SEk/
lfRTST/10s9jQXo+qX5X0s9G+tke0JBG+tlIPxvpZyP9bF4/4xuENWqkn430k/ifm/ifm/ifu5F+
Ev9zE/9zE/9zE/9ze/5nj++VlDvpJ/E/dyP9bALPZyP9bKSfjfSzkX42r58xWhCez0b62Ug/G+ln
U9CQRvrZSD8b6Wcj/WxeP2OyIK0RzY8a6Wej+VF750euMm00P2pUvzeaHzWaHzU/P4r2mTQ/auQ/
G/nPRvOj9s6PXPegUf3eqH5vND9qND9qfn4UxYK0RjQ/ajQ/ajQ/ai8/xM1QOtXvner3TvOjTvOj
7udHsVgQ1qjT/qVO86MO/JDd4f1xu5N+dtLPDuc3d4fzm7snv0bVgrBGHc5v7k79T+J/buJ/buJ/
bsf/dKtJ8yPif27if27if27P//y7txak3Kn/SfzPTfzP3Ss9n9T/JP7nJv7nJv7n9vzPHpsF6fmk
+RHxP3en+VF/50dOFTv5z07+s9P8qNP8qPv5UewWpDWi/men/men+VF/50ful4v4n5v4n7vT/KjT
/Kj7+VEcFqQ1ov5np/5np/lRh/Obu5P/JP7nHjQ/GjQ/Gn5+FKcFYY2I/7mJ/7kHzY/Glx/y/R4N
mh8N8p+D5keD5kfDz4/isiCs0SD/Och/Djq/Ob7nN7e7kj6T9HPQ+c1B5zeH+DXaFqQ1Iv9J/M9N
/M9t/M/rl4v4n5v4n5v4n5v4n9vzP3s8FqQ1ovObxP/cxP/cxP/cxP/cxv+8uoXE/9zE/9zE/9zE
/9ye//n3W29Byp36n8T/3IP0c5B+DtJP43/euZN+Ev9zD9LPQfo5vH4mu5L0c8D74/Yg/RzkPwf5
z0H+0/if1zNP/M9N/M89yX9O8p/T+88ULQi5T9q/NMl/TtLPSfo5af+S8T/v3Gn/0qT9S5P2L03a
vzT9/qWULEi5Z8qd9HOSfk7Sz+n1M1lGpJ83//MNUu6kn5P0c5J+TtLPSfo5ST+n188kFqT7SfpJ
/M89ST8n6eck/TT+55076SfxP/ck/Zykn/PSz2JByp30c5J+TtLPSfo5ST+N/3nnTvo5ST8n6eck
/ZyXflYLUu6kn5P0k/ifm/ifm/ife5J+Ev9zE/9zE/9zE/9zr0s/1YKQ+yL9JP7nXqSfi/RzkX4u
0s9F+rlIPxfp5yL9XJd+NgtS7qSfi/ST+J+b+J97Uf/T+J937uQ/F+nnov7nov7n8v3P1C1IuVfK
nfqfi+r3RfX7ovNHSyl30k/if+5F548WnT9a3ec+LEi50/n3RfX7ov7nov7nov1Lxv+8cyf9XKSf
i/YvLdq/tPz+pTQtSLkvyp36n8T/3MT/3MT/3Iv4IcT/3MT/3MT/3MT/3J7/2dOyIOS+aX5E/M+9
6fzm/p7f7O5K+kzSz03nNzed39zRe7BtQfBgm/Rzk35uOr+5v+c3v2u0af/npv7npvObm85vbvFr
dCxIa0T9z039z03nN/d7ftN1tzad39y0/3PT+c1N5ze3O7/Z8xukNSL93KSfm/Rzv+c3XQdyk35u
0s9N+rlJP7fXz2xXkn5u6n9u0s9N8/f9nb+77xHN3zf5z03z903z9+3n7zlakNaI/Ocm/7lp/r7h
/R17k35u0s9N8/dN8/ft5+85WZDWiPYvbep/Ev9zE/9zE/9znwd0nvifm/ifm/ifm/if2/M/e7bP
pP2fh+ZHxP/ch+bv53t+s7sr6TOp/3lo/n5o/n78/D2LBeH5JP7nJv7nPuQ/zzt/d2cDD/nPQ/7z
kP885D+P95+5WJDWiObvh/znofn7ofObh+bvh+r3Q/P3Q/P34+fvuVqQ1ojq90P1+6H5+3nn7+6M
7SH/ech/Hpq/H5q/Hz9/z2pBWiOavx+avx+av58FfunQ/P2Q/zw0fz80fz9+/p6bBWmNyH8e8p+H
6vfzrd/fc/p/8vn7mX/B3888D9Tv54H6/Ty+fs/dgr9rdB6o388D/vM8UL8f4n+eB+r388D5zfOA
/zwP+M/zQP1+Hqjfz+Pr9zwsSLnD/OgQ//M8MH8/zzt//zqr84D/PA/4z/PA/P08MH8/j5+/52nB
3+fzEP/zEP/zPDB/Pw+c3/z70abPBP95Hpi/nwfm7+fx8/e8LEhrBPP388D8/Twwfz/PO39vbo3A
f54H/Od5YP5+Hpi/n8fP3/O2IK0R1O/ngfr9PND/PM93/u4yAv95HvCf54H+53mg/3ke3//Mx4K0
RjB/Pw/0P88D8/fzfM9vRnclfSb4zxNg/n4CzN9P8PN3eYOwRgH85wngP0+A+fsx/qf38yeQfgbS
zwDz9xNg/n6Cn7+LXQnz9xPg/OYJ4D9PAP95AvjPE7z/lGhBup/w/vcTwH+eAP7zGP/zvp/gP08A
/3kC+M8TwH+e4P2nJAvS/YT+5wngP0+A9x+dAO8/OkH9/bSM4P1H5+Z/vkHKHeZHJ8D8/QTwnyeA
/zwB5kcnwPzoBD8/ErEg3U+YH50A9fsh/uch/ucJpJ8B5u8nkH4G0s9A+hlIP4PXTykWpNxhfnSI
/3kC+M8TwH+eAP7zBOCH/JXF8JnE/zyR/Gck/xm9/5RqQcg9kv+M5D8j6Wck/YzkP43/eedO/jOS
/4zkPyP5z+j9p6gFKXeYH51I/pP4n4f4n4f4nyeSfhL/8xD/8xD/8xD/88RLP5sFKXfST+J/nkj+
M5L/jND/PMb/vHOH/ueJpJ8R+p8nQv/zRN//lG5Byh3mRyeS/yT+5yH+54kwPzrG/7xzJ/2MpJ8R
5kcnwvzoRD8/kmFByh3mRydC/X4i9D8P8T8P8T+P8T/v3Ek/if95iP95iP95PP+zy7Qg5J7g/XGH
+J8nwfmjk+D80Un+/JEsC4JnSHD+6CTSz0T6md763bl04n8e4n+eRPqZSD/TpZ/bgnQ/qX5PpJ+J
6vf01u+ukiL+5yH+50lUvyeq35Ov3+VYkNaI6vdE9Xui+j299burdon/eYj/eRLV74nq9+Tr9/IG
aY2ofk9Uvyeq39OXv1TclfSZpJ+J6vdE9Xvy9Xt5r6Q1Iv1MpJ+J/GcC/tIh/uch/udJ5D8T+c/k
/WeJFqQ1ovo9kf9MVL+n7/757q6kz6T6PVP9nql+z75+L8mCsEbE/zzE/zyZ6vcM++dPJv+ZST8z
1e+Z6vfs6/din0n1O/E/D/E/T4b98yd/988XdyV9Julnhv2fJ8P+z5P9/s8iFqQ1Iv9J/M+TYf/n
yfD+o5NJPzPpZ4b9nyfD/s+T/f7PUixIawT7Pw/xP08m/5nJf2aq3zPV78T/PMT/PJnq90z1e/b1
e6kWpNypfs9Uv2eYv58M8/eT/fy9qAXpWVrgbTLpZ4b5+8lffrJ+ryT/mcl/Zpi/nwzz95P9/L00
C9L9hPn7yaSfxP88xP88AvP3I9/5+1cZhPRTSD8F5u9HYP5+xM/fS7cg5C4wfz8C8/cjMH8/Auff
j5B+CumnUP9TqP8pvv9ZhgXh+RSq34Xqd6H6Xb7n311GpJ9C+ilUvwvV7+Lr9zItSGtE9btQ/U78
z0P8zyNUv4vS80n6KaSfQvW7UP0uvn4vy4KUO/lP4n8egf1LR979S84BCuxfOkL6KaSfQvopl35u
C9LzSf6T+J9HSD9lgV8S0k8h/RTSTyH9lEs/jwVpjUg/if95CulnIf0spJ8F3n90iP95iP95Culn
If0sXj/rG4TcC+lnIf0spJ8lwfNZSD+J/3kK6Wch/SxeP+t7JTyfxP88xP88hfSzAH/+FNLPQvpZ
SD8L6Wfx+lmjBWmNSD8L6SfxPw/xP08h/Syw//MU0s9C+llIPwvpZ/H6WZMFKXfSz0L6WUg/y4Df
90L6WUg/C+lnIf0sXj+rfSbpZyH9LKSfhfSzLHo+ST8L6Wch/Sykn8XrZxUL0hpR/V5IPyvwl04F
ft2psH/+VOp/Vup/Vup/Vt//rMWCsEaV+p+V6nfifx7ifx7if54v/9OtJvE/D/E/D/E/D/E/z8X/
rNWClDvpJ/E/D/E/D/E/D/E/D/E/D/E/D/E/z8X/rGpBeD6J/3mI/3mI/3mqwm8c8T8P8T8P8T8P
8T/Pxf+szYK0RlS/E//zVNj/eeq7/9PVCJXmR5XmRxX2f54K+z9P9fs/a7cgrRHs/zzE/zwV9n+e
+u7/dL3fCvs/T6X5UYX9n6fC/s9T/f7POixIa0Tzo0rzo0rz9/ryl1x/Xsl/KvlPpfm70vxd/fy9
TgvCGimcPzpK83cF/tIx/uc1QyH+5yH+51HgLx0F/tJRz1+qy4KwRgr8paNw/ugo9T+V+p9K8yPj
f15dOKX5kdL8SGl+pDQ/Uj8/qtuClHul3Kn/SfzPQ/zPQ/zPY/zPO3fST+J/HuJ/HuJ/nov/WY8F
KXfgfx7ifx7ifx7ifx7ifx6F98cd4n8e4n8e4n8e4n+ei//5DVLu5D+J/3mI/3mU+p/E/zzE/zzE
/zzE/zwX/1PtSvKfSvU78T9PI/1spJ+N6vcG/PnTqH5vVL83qt8b1e/N1+8aLQi5E//zEP/zEP/z
OP6ny4j8J/E/D/E/D/E/z8X/1GRBeD6J/3mI/3mI/3ka8JMP8T8P8T8P8T8P8T/Pxf9U+0zyn8T/
PMT/PMT/PI7/2d2V9Jmkn8T/PMT/PBf/U8WCtEbkP4n/eYj/eYj/eYj/eYj/eYj/eYj/eS7+pxYL
0hqR/yT+5yH+52lw/ugQ//MQ//MQ//MQ//Nc/E+tFqQ1Iv9J/M9D/M/z5X+6ypT4n4f4n4f4n4f4
n+fif6paENaI+J+H+J+H+J+nv/7T7Uoi/uch/uch/uch/ue5+J/aLAhr1OH8+yH+5+nw/qNj/M/r
96iTfnbSzw7vPzod3n90un//kXYL0hrB+ffT4fz7+cf//E9G9dU6t0akn530s9P++U7757vfP6/D
grRG1P/s1P/sNH83/qc/D3s66Wcn/ew0f+80f+9+/q7TgrRG5D87+c8O7+84xv/0Z5ZPJ/3spJ8d
3t9xOry/43T//g5dFqQ1Iv/ZyX922v9p/M/L03bSz0762Wn/Z6f9n8Pv/9RtQVijQfs/B/U/if95
iP95iP95iP95iP95iP95iP95iP95Lv6nHgtS7uQ/if95iP95vvxP5y6I/3mI/3mI/3mI/3ku/md7
g/B8Ev/zEP/zEP/zGP/z+i0m/uch/uch/uch/ue5+J/NrqT9S4P8J/E/zz/+538yauBpB+3/HLT/
c8D7486A98ed4d8f16IFaY3Ifw7yn4P2z4/3/XGu7iD+5yH+5xm0f37Q/vnh98+3ZEFaI/Kfg/zn
gPfHnfG+P87VhoP2fxL/8wx4f9wZ8P64M/z745p9Jrw/7hD/8xD/80yq3ye8//1M0s9J+jmpfp9U
v09fvzexIKzRJP85yX9Oqt/nt36P7kr6TNLPSfX7pPp9+vq9FQvSGtH5zUn+c1L/c1L/cwJ/6Rj/
815N8p+T/OcE/tKZwF860/OXWrUg5a6UO83fif95iP95Jumn8T+vnuok/Zykn5P0c5J+zks/1YKU
O7x/80zSz0n1+6T6ffr6vTUL0vdo0v0k/zmpfjf+530/ST8n6eek+n1S/T59/d66Bel+Hrqf5D8n
+c9J/nN5/9mGBeF+LvKfi/znAn7dMf7ndT8X1e/E/zwL+HVnAb/uLM+va9OCcD9v/ucbhPu56Pz7
Iv1c5D+N/3nnTv6T+J9nkf9c5D/X5T+XBSl34Ccf4n+eRfq5SD8X1e/G/7xzp/qd+J9nUf2+qH5f
vn5v24KUO51/J/7nWaSfi/Rz0fkj439ev0eL5kfE/zyLzh8tOn+0/PmjdixIuZP/JP7nWXT+aL3n
j5wDXDQ/WjQ/WnT+aNH5o+XPH/U3SLpE/nOR/1x0/mh9zx8VdyV9Js2PNp0/2nT+aPvzR/29EtZo
k//c5D831e/7rd9dJbWpft9Uv2+q3zfV79vX7z1aENZok//cpJ+b9HPT+aNN+rlJPzfp5yb93F4/
e7IgrRHV75v0c1P9vt/63XUkNtXvm+r3TfX7pvp9+/q922dS/b6pft/kPzf5z/3W765rtEk/N+nn
Jv+5yX9u7z+7WJDWiOr3Tf5zU/2+4f3vZ5N+btLPTfX7pvp9+/q9FwvSGpH/3OQ/N9Xv+63fXed5
k35u0s9N9fum+n37+r1XC8IaEf/zEP/zEP/zfPmfbjpA/M9D/M9D/M9D/M9z8T+7WhDWiPifh/if
h/if58v/dBMc4n8e4n8e4n8e4n+ei//ZmwVpjWh+RPzPQ/zP4/ifbo1IP4n/eYj/eYj/eS7+Z+8W
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
Jf2spJ/V6+e2K0k/K+lnJf28+Z+WO/lP4H9+gpZ7/tZcSv4T+J+fIOQO/M+/oPefO1oQclfyn8D/
/AtGyF2pfleq343/eX3flep3Jf1Uqt+V6nf19ftOFqTcqX4H/udfUCh36n/q7/75T9B88vhWUvq7
f/4TpM/83T//CVLufv/8ts/83T//CVLutP9TlXIn/6m0f0lp/5LS/iUl/VTav6S0f0n9/qUtFqTc
f9+/+QlS7oNyp/pdf88ffYJvj+XrfvX3/NEnSJ9J8yOl+ZH6+dG2v5PmR0r7l5Tq95v/aRpC+z/1
l7/0CdL3/Xf//CdIn/l7/v0ThNybP/++qwUh90b7lxr1P2/+Z7Qg/J3t9/zmJ/ju5fjm3n7Pb36C
9Jm/5zc/Qcrdn9/cakHK/ff8+ydIudP8qJH/bDQ/Mv7n9RsH/M9PkD6T5keN5kfNz492syDlTvOj
RvV7o/l7I//ZaH7UvvP37+ys0fyokX42qt8b1e/N1++7W5Byp/lRo/q9Uf+zUf+z+f7nHhaE2vDm
f9r9JP1spJ/G//zziu5K0s9G+tlIPxvpZ7v0c1qQ7ifpJ/A//4Kkn430s5F+Gv/z1hDST+B/foKU
O+lnv/RzWRBy76SfnfSzB/jd7KSfnfTT+J/X96iTfnbSz0762Uk/+6Wf24KUO+lnJ/3spJ/A//wE
KfdMuZN+Av/zE6TcST8v/uc+FqTcST+B//kXJP3spJ+d9LOTfnbSz0762Uk/O+ln9/p53iDlTvrZ
ST9v/qc981S/d5q/99/zm39Bmr930s9O86NO86Pu50fHrqT5Uf/lL32ClPuidaf6vf/y5z9Byv2X
//kJ0mf+8uc/Qcrd8+eP/Z2//PlPkHKn+fug/ueg+n1Q/3M8kDvwPz9B+kzqfw7qfw7f/zzJgpD7
oP7noP7nSPDMD6rfB/U/jf955079z0H6Oaj/Oaj/OXz/89hnUv9zUP9zUP9z/L6/4xMEvzT8+zuO
WBD80iD9BP7nJ0j3k/RzkH4O0s9B+jlIP8eln7bupJ+D9BP4n39B2r80SD8H6efo4JeA//kJ0meS
fg7Sz3HpZ7Ug5U7z90H6OWj+Pt75e/BXwuwM+J9/QZq/D5q/Dz9/P2pBej5p/9Ig/znIfw7yn9P7
z9MsCPdzXv6zWBByn3T+yPif1/2cdP5oUv9z0vx90vx9+vn76RaE+znp/NEk/bz5n5Y7+c9J54+M
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
fwaB9x8FgfcfBXl87seCkLvA+4+CUP0uAXIX6n8K9T+N/3nlLtT/FNJPof6nUP9TfP8zvUHKPVPu
1P+8+Z+WO9Xvxv+8cxfKHd5/FIT0U+D8URA4fxSk+NzfKyn3SrnD/qVA/M9A/M/g+Z8jRQuCXyL+
ZyD+ZyD+ZxDST+J/BuJ/BuJ/BuJ/Bs//HClZkO4n6SfxP4OQfgrpp5B+CumnkH4S/zMI6aeQforX
z2SfSfoppJ9C+imkn0L6KaSfQvoppJ9C+llIPwvpZ/H6mcSCkHsh/Sykn4X0k/ifoZB+FtLPQvpZ
SD8L6Wch/SyXftrfSfpZSD+J/xkK6Wch/Sykn4X0s5B+Ev8zFNLPQvpZLv2sFqTcST8L6WeB/Uuh
UP+zUP+zUP+zUP+zkH4W6n8W6n8W3/9MakHKnfqfhfqfhfqfhfqfxfc/U7Mg/HYU6n8W0s9C+llI
PwvpZyH9LKSfhfSzXPrZLUj3k/SzkH4W0k/if4ZC+llIPwvpZyH9rKSflfSzXvo5LAi5V9JP4n+G
SvpZST8r6Wcl/aykn8T/DJX0s5J+1ks/pwUpd9JP4n+GSvpZST8r6Wcl/aykn8T/DJX0s5J+1ks/
lwUpd9JP4n8G4n8G4n+GevnPbUHQkEr+k/ifoZL/rC9//vvmlFDJf1byn5X8ZyX/WS//eSxI95P8
ZyX/Wcl/Ev8zVNJP43/euZN+VtLPSvpZST+r18/8Bil30s9K+llJP4n/GSrpp/E/79xJPyvpp5J+
Kumnev3M75WQu5J+Kumnkn4S/zMo6adGyF1JP5X0U0k/lfRTvX7maEHKnfRTST9v/qd9Jumnkn4q
6aeSfirpp5J+Kumnev3MyYKUO+mnkn4q+U/ifwYl/6nkP5X8p5J+KvlPJf+p3n9m+0zyn0r+U8l/
3vxPW3fav6Tw/uKg7/uLh7+Scif9VHh/cVB4f3HQ6XMXC1Lu8P7ioLB/Ptz8T1t3mh8pvD8uGP/z
zh3eHxeU9FOBPx8U+PNBj8/d/k7gz4cG7y8OjfZ/NuCHBOJ/hgb8kGD8zyv3BvyQ0Eg/G/BDQgN+
SGjR514tSLkDPyQ02j/faP8S8T9Do/1L7d2/9H23Tmi0f6mRfjbav9Ro/1Lz+5eyWpByp/1LjfYv
3fxPW3eaHzXghwTjf965Az8kNNLPBvyQ0IAfEpr63JsFKXfgh4RG+z8b8EMC8T9DA35IaJ1yB35I
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
/M948T+HWJByJ/0k/mcc5D8H+c9B/tP4n1cNO8h/DtLPQf5zkP8c3n+OYkHKnfznIP85yH8S/zMO
8p9jgF8a5D8H6ecg/znIfw7vP0e1IOVO/pP4n3HQ/GhQ/T6ofh+btI7qd+J/RuJ/RuJ/xov/OdSC
kPuk+p34n3EGyH1S/T6pfjf+5/UbN6l+n6Sfk+r3SfX79PX7aBak3Kl+J/5nnLR/ftL++X/8z//k
nkHrJunnJP2cwJ+PE/jzcXr+/OgWpNwL5Q78zzgrrTv1P//xP/+Te4XfuKmUO+nnP/7nf3JXyr35
3IcFKfdGuVP/c5L/nOQ/J/CTo/E/73UHfnKcpJ8T+MlxAj85Ts9PHtOClPuk3Gn+PhetO/nPf/zP
/+S+4DduUv9zkn7+43/+J/dNuR+f+7Ig5X4od+DPxwXvj4sL3h8Xl39/3NgWhPpokX4S/zMu0k/j
f16/m4v0c5F+LtLPRfq5Lv08FoT7uWh+RPzPuGh+ZPzP6zTZovnRIv+5aH60aH60/PxovkFaI5of
Ef8zLpofGf/z2h+yaH60SD8XzY8WzY+Wnx9Nu5LmR4vOHy2aHy2aH63v+aPmrqQ1Iv1cND9aND9a
fn407e+k+dGC92/GRfq54P2bkfifcdH+JeN/Xo5l0f6lRfq5aP/Sov1Ly+9fmsmClDud31ykn4v8
53rnR65ft8h/Ev8zLvKfi/zn9v5zZgvC87lp/9Im/7lp/r7f/UvBXwlrRPzPuGn+vmn+vv38fYoF
YY02nX8n/mfcdH7T+J/XDHqT/9zkPzed39x0fnP785uzWJDWiM5vbtq/RPzPSPzPuEk/dwG/tEk/
N+nnJv3cpJ/70s9qQcqd9n9u0s9N/U/if8ZN/c/d4Lu5yX9u8p+b+p+b+p/b9z+nWpByp/7nJv3c
wE+OxP+Mm/qfe1Lu1P/c5D839T839T+373/OZkHKfZMuUf9zw/uLo/E/L2+z4f3FcZP/POQ/D/nP
4/3n7BYEXToBfjsO+c9D/tP4n5fSHvKfh/znIf95yH8e7z/nsCCs0SH/ech/HvKf53t+s7grYY0O
+c9D/vOQ/zyX/5wWpDWi85vE/4yH+p+H+p/H9z/nsiDdTzq/eaj/eWj/51G6n7T/k/if8dD+z0P7
P4/f/zm3Bel+wvuP4iH9PFS/G//z+i0+VL8T/zMeqt8P1e/H1+/zWJDWCN5/FA/5zwPvP4rn+/44
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
pJ9K+qnRr1GyIKyRkn4q6aeSfhL/Mynpp/E/r9VU0k8l/VTSTyX9VPG522eSfirpp5J+Kumn8T/v
1ST9VNJPJf1U0k+t/vkUC9LzeennG6T7SfuXiP+ZiP+ZjP9ZHtnuSsqd/CfxPxPxP5Pnf05za8T/
TErzd+J/JqX+p1L/U6n/afzPO3fqfyr5T6X+p1L/U5fPvVqQcqf5O/E/k27KnfRTaf5u/M/yFPfM
0/xdyX82mr83mr+3x+euFoTcG83fif+ZWoDcG82PGs2PjP/5l3t0V0LujfSz0fyo0fyoJZ97syDl
TvP3RvrZaP9So/l7o/l7o/2fjebvjfSz0fy90fy9FZ97tyDlTvuXGtXvN//Tcqf5UYPzR8n4n9cz
3+D8UWqknw3OH6UG549Saz73YUHKHfjzqVH93uD9cYn4n6kBfz4Z//PSugb8+dRIPxvw51MD/nxq
0+c+LUi5A38+NarfG/lP4n+mRv6zbXrmyX820s9G/rOR/2yX/1wWhNw77f8k/mfqcP49dep/djj/
nnqA3Ducf0/E/0wdzr+nDuffU48+921Byh3484n4n4n4n4n4n8nzP+dzLAhesdP+JeJ/pk76afzP
S0M66Wcn/eykn530s3v9DG+Q7ifpZyf97HB+MxH/M3XSz66gIZ30s5N+dtLPTvrZvX6G90rKnfST
+J+pw/s7Uif97KSffdD3iPST+J+pk3520s/u9TPY30n62Uk/if+ZOulnJ/3spJ/G/7yfedJP4n+m
TvrZST+718+QLAi5D9JP4n+mQfo5SD8H6afxP69nfpB+Ev8zDdLPQfo5vH4G+0zSz0H6SfzPNOD8
exo0Pxpw/j0NeH9cGnD+PRH/Mw04/54GnH9PQ3zuYkHKHc6/J+J/plEod6rfB+1fGrR/adD+JeJ/
pkH7lwbtXxrqcy8WpNwb5U79z9HAKw6q3wft/xzv/s/vey3ToP2fxP9Mg/Z/Dtr/OYbPvVqQcqf9
n8T/TAPOv6dB9fug/Z9jUe60/5P4n2nQ/s9B+z/H9rmrBSl3OP+eiP+ZBpx/T4Pq90nn343/eeU+
6fw78T/TpPObk85vzuBzbxaE3Cedfyf+Z5oRnvlJ9fuk8+8zUe50/p34n2nS+fdJ599n9rl3C1Lu
QrnT/H1S/3OS/5zU/zT+599vXHFXUu6kn5P6n5P6n9P3P8OwIOVO/U/if6ZJ/c9J/nNS/3M28DaT
+p/E/0yT+p+T+p/T9z/DtCDlTv1P4n+mSeePJvnPSf3P+b5/c/grKXfSz0n9z0n9z+n7n2FZkHKn
/ifxP9Ok/uck/zmp/2n8zzt36n8S/zMR/zMR/zN5/ucM24KQ+6L+J/E/06L984v856L+p/E/r9wX
9T8X6eei/uei/ufy/c9wLEi5U/9zUf9zUf+T+J9pUf1u/M87d6rfF+nnovp9Uf2+fP0e3yDlTvU7
8T/Tovp9kf9cVL8v6n8uqt+J/5kW1e+L6vfl6/f4Xkm5A38pLarfF+1fMv7n9cu1aP8S8T/Tov1L
i/YvLbd/aUb7O2n/0qL9S8T/TIv2Ly2q3xftXzL+5+VYFu1fIv5nWrR/adH+pXV87smClDv5z0X6
ucl/7td/upprk/8k/mfa5D83+c/t/We0zyT/ucl/bvKfm/znJv3c5D+N/3k9yZv85yb/ucl/bvKf
2/vPKBak3Im/tMl/buIvGf/zUhvifybif6ZN/KVN/KVd/fNpd574S5vmR5v0c5N+7q9+RnclrRHp
5yb93KSf+9LPakFaI9JP4n+mTfq5v/r57W5t0s9N+rlJPzfp5770Uy1Ia0T6uUk/N/DnE/E/0yb9
3K9+erUh/dykn5v0c5N+7ks/mwUpd9JP4n+mQ/pp/M9LQw7p5yH9PKSfh/TzXPrZLQjP583/LBaE
+3mIv3Te98e5PbqH+EuH+p+H5keH5kfHz4/isCCs0aH5EfE/0yH/eWh+dMh/HvKfh/znIf95Lv85
LUhrRP7zkP88xK8j/mci/mc67/vfpbkrKXfST+J/JuJ/pnPp57Ig5U7zI+J/pkPz90P9z0PzozNo
3Wl+dKh+PzQ/OjQ/On5+FLcFKXfSz0P6eUg/D+2fP6Sfh/TzkH4e0s9z6eexIH03D60R6OfnYNdP
Rn/BX/3MxP/MxP/MxP/MxP/Mnv850xv8XaP8AL8uE/8zP6Cf+YH3x+UH9DM/oJ/5Af3MD+hnfrx+
JrsS9DM/8P64/IB+ZuJ/ZuJ/ZuJ/5ud9f9xwV4L/zMT/zMT/zMT/zJ7/OZP9neA/8wP1eyb+Z35A
P/MD8/f8gH7mB/QzP6Cf+QH9zI/Xz5QsSM8n6Gcm/md+QD/zA/qZH9DP/MD+pfyAfmbif+YH9DM/
oJ/58fqZ7DNBP/MD9Xt+QD/zA/qZH/Cf+QH9zMT/zA/oZ35AP/Pj9TOJBen5BP+ZH9LPQPoZSD8D
6SfxPzPxPzPxP3O49LNYENaI+J+Z+J+Z+J85gP/MxP/MxP/MxP/MxP/M4dLPakFYo0D6SfzPHOD8
Zg6kn4H0M7z6+XVrOZB+BtLPQPoZSD/DpZ9qQcod/GcOpJ9B4bsZYH6UA5w/ykHhtyPA+aMcYP6e
A5w/ygHOH+Xgzx+lZkHKnfQzkH4G0s8w6LtJ+hlIPwPpZyD9DJd+dgvSdxP8Zw6kn4H0M5B+BtLP
QPoZSD8D6We49HNYkNaI9DOQfkbST+N/Xk9dJP2MpJ+R9DOSfsZLP6cFYY0i9D9zJP2M0P/MxP/M
Efqf2fifd+7Q/8wR+p85Qv8zR+h/5uj7n2lZkHIX0JBI+hlJP+OXP9+/V5J+RtLPSPoZST/jpZ/b
gvB8RvKfkfQzkv+MChoSyX8S/zNH8p+R/Ge8/OexIK0R9D9zJP8Zof+ZI/Q/c4T+Zyb+Z47Q/8wR
+p85+v5nfoO0RtD/zMT/zJH8ZyT9jKSfxv+8cyf9JP5njqSfkfQzev3MdiXpZ4Tz75n4nznB+c2c
YP9nTnB+M6cHfjsSnN/MxP/MCc5v5gTnN3Py5zez/Z1wfjMneH9HJv5nTqSfCfYv5UT6mUg/E+ln
Iv1MXj9zsiB8NxPV74n0M5F+JtLPRPqZSD8T6Wci/UxeP7N9JulnIv1MpJ+J9DMp/MYl0s9E+plI
PxPpZ/L6mcWCtEZUvyfSz0T+k/ifOZH/NP7nnTv5z0T+M5H/TOQ/k/ef2f5O8p+J9DORfibSz7To
+ST9TKSfifQzkX6mSz+rBen5JP+ZSD8z+c8M+z9zJv+ZyX9m8p+Z/Gf2/jOrBWGNMtXvmfxnpvo9
U/8zU/2eqX7PVL9nqt+zr99zsyCsUab6PVP9TvzPTPzPnEk/M9XvmfQzk35m0s9M+pkv/ewWpNyp
fif+Z87AD8mZ6vdM9bvxPy9vk6l+J/5nzlS/Z6rfs6/f87Ag5Q7nj3Im/cykn/nVT9eJyqSfxP/M
mfQzk37mSz+nBem7SfV7Jv3MpJ+Z9DOTfhL/M2fSz0z6mS/9XBakNSL9zKSfQvopVL8L6SfxP7OQ
fgrpp1z6uS0IayRUvxP/MwvV70L+U8h/CtXvQv6T+J9ZyH8K+U+5/OexIOVO/pP4n1lIP4X8p5B+
CumnkH4K6ad4/ZQ3CM+nkP8U0k8h/ykKGiLkP4X8p5D/FPKf4v2nvFfSGlH9LuQ/hep3eev34taI
6nfif2ah+l2ofhdfv4v9nVS/C9XvQvW7wPuLs5B+CumnLPh9F9JP4n9mIf0U0k/x+inJgpQ71e9C
+lmofi9Uvxeq343/eT3Jhep34n/mQvV7ofq9+Ppd7DOpfi+kn4X0s5B+lu/7N7u7Er6bxP/MhfSz
kH4Wr58iFoTvZiH9JP5nLqSf5bv/81tNFNLPQvpZSD8L6We59NPuPOlnIf0spJ+F9NP4n57Snwvp
ZyH9LKSfhfSzXPpZLUhrRPU78T9zofq9kP8s5D+N/3nnTv6zkP8s5D8L+c/i/aeoBSl3OP+eif+Z
y6Lc4fxmLnD+PZfv+Xf3JMP591zg/FEucP49Fzj/nos//y7NgpB7hfPvmfifuT6QeyX/WeH8ezb+
57XuFc6/5wrnj3KF8++5wvn3XP35d+kWpNzh/Hsm/meucP49V9LPCuffs/E/L09b4fx7rlS/Vzj/
niucf8/Vn3+XYUHKHc6/50r6WeH8eyb+Z65w/j0b//POHc6/50r6WeH8e65w/j1Xf/5dpgUpdzj/
non/mSu8/yhXOL+ZK5x/z/U9//59x1+ucP49E/8zVzj/niucf8/Vn3+XZUHKHc6/Z+J/ZuJ/ZuJ/
5ov/KduC8LtJ/M9M/M9M/M9cv/rp7ifpJ/E/M/E/M/E/88X/lGNBuJ9K+kn8z6ykn0r6qaSfGiB3
Jf1U0k8l/VTST/X6Wd4g5U76SfzPrIlyJ/1U0k/jf965k34q6aeSfirpp3r9LO+VlDvpp5J+Ev8z
E/8zK+mnvvr5V+Z9r6TPJP1U0k8l/VSvnyVakHIn/VTSTwV+SCb+Z1bST+N/3utO+qmkn0r6qaSf
6vWzJAtS7qSfSvpJ/M9M/M+swA/Jxv+81x34IVlJPxX4IVmBH5LV80OKfSbwQ7ICPyQr8EOyUv+T
+J+5Uf+z0f7PRv3PRvrZqP/ZqP/ZfP+ziAUh90bzo0b9z0bzI+N/ytnjeyXNjxrpZ6P5UaP5UfPz
o1IsCL/FDc4fZeJ/ZuJ/5vaeP3KTEeJ/ZuJ/ZuJ/ZuJ/5ov/WaoFaY3g/ZuZ+J+5wfs7svE/L7fW
4P0dudH8qMH7O3KD93fk1vwaqQVpjeD9HbmRfjbgh+QG/JDcPD+kNAvS/aT+Z6P+ZwP+fG4vf94p
WAP+fG6kn438ZyP/2bz/LN2CdD/h/UeZ+J+5wfvjcqP+Z4P3H2Xjf97PErz/KDfSzwbvP8oN3n+U
++NzHxaE3Du8/ygT/zN30s9O+tkv/ZwWhGep0/yok3520s8e4VnqpJ/E/8zE/8zE/8wX/7MsC9L9
pPk78T9zp/5np/5np/5nF3iWOvU/O/nPTv3PTv3P7vufZVuQcqf5O/E/c6f5eyf97DR/7+/83TnA
TvP3Tv6z0/y90/y9+/l7ORak3Gn+TvzPTPzP/OV/up0kxP/MxP/MxP/MxP/MF/+zvkH6blL/k/if
uVP/k/ifmfifuVP9TvzPTPzPTPzPTPzPfPE/63sl5D5ofkT8zzxofmT8z8sFDZofDZofDZofDZof
DT8/qvZ30vxowPs78qD50SD9JP5nHvD+jjwSaPKA93fkAfylPOD9HXnA+zvy8O/vqMmClLtQ7uQ/
b/5nsSD9nYVyL7AfbFTKnfznP/7nf3KvlLv63O0zlXIHfl0eND8awK/Lxv+8+rQD+HWZ+J95kP8c
5D+H959VLEjfTeDX5UH+c8D7O/Ig/RzAr8sD3t+RB9XvxP/MA/h1eQC/Lg/Pr6v2dwK/Lg/yn4P8
5yD/afzPS2kH+U/if+ZB/nOQ/5zef9ZqQXg+J/lP4n/mCe8vzpP0c8L7N7PxP6/cJ7x/MxP/M094
/2ae8P7NPJPPXS1IudP8iPifeVL/c2Z4Pif1Pyf5z0n9z0n9z+n7n7VZEJ7PSf3PSfo54f3vmfif
eVL/c9L8aFL/c5L/nNT/nNT/nL7/WbsFKfdGzyf5zwnvf8/G/7x+Oya8/z1Pmr9PeP97nvD+9zyH
fz6HBen5HPTdJP2ck3Kn+v0f//M/uc93L5x7kmn/0iT/+Y//+Z/cF+W+fe7TgpT7pu8m+U/if+aX
/9mluivp+aT+J/E/M/E/88X/rMuC8HwS/zMT/zMv8p+L/Oe6/Oe2INxP4n9m4n/mRfuX1rv/Myd3
JX0m6eei/UuL9i8tv3+pHgvS/QR+cl5Uvy94f3Fe8P7ivNz7i+c3SPeT9HORfi7ST+N/9hH8lXQ/
ST8X6eci/VxeP/W9ku4n6eci/Vykn8b/9G8pzYv0k/ifeZF+LtLP5fVT7e8k/VzAT86L9HOR/zT+
56Uhi/wn8T/zIv+5yH8u7z81WZDWCPjJmfifeZF+LtLPRfq5Xn6yX03ST+J/5k36uUk/t9dPzRaE
3Df5z036ucl/Gv+z9/79fd/kP4n/mTf5z03+c3v/qWJBeD43vP89E/8zb3j/e95Uv294/3s2/uel
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
CvE/xfif15NM/E8h/qcQ/1OI/ykX/3PZZ9L++UH754n/KQPOv8sg/zng/LsY//N+kuH8uwzSzwHn
32XA+XcZ/vz7EgtS7sD/FOJ/CvE/xfiflyYT/1OI/ynE/xTif8rF/1z2dwJ/SQbwl4T4nzJo/+eg
/Z/D7/9c1YJ0P+H8uwzyn5P2z88H7uek/fPE/5RJ++cn7Z+ffv/8UgvC/Zx0/p34nzJp/+ck/zlp
/6fxP69vx6T+J/E/ZdL+z0n7P6ff/7maBSl32v85af/SBH6ITOCHyPT8kNUtCM/SpPqd+J9C/E/5
8j93cFfS/ST/SfxPIf6nXPzPNSxI95Pqd+J/yqTzm5Pq90n1u/E//3Jf7kr6TPKfk+r3SfX79PX7
mhak3Gl+RPxPmXT+aJJ+Tpofzff9Rye6Kyl38p+T5keT5kfTz4/WsiDlTvOjSfOjSeePiP8pi/Rz
ve9//1JSZZF+LtLPRfq5SD/XpZ/bgpD7Iv1cpJ+L+CHE/xTif8qX/+nWnfifQvxPIf6nEP9TLv7n
Ohak3Ek/if8pSyh38p+L9s+vQutO8yPif8qi/fOL9s8vv39+v0HKnc6/L9r/uej8+yL/uej8+2q0
7qSfi/Rz0fn3Refflz//vt8rKXfgz8ui/Z+L/CfxP4X4n/LyP691J/9J/E8h/qcQ/1Mu/ueOFqTc
yX8S/1MW9T+J/ynE/5Qv/9OvO/U/if8pxP8U4n/Kxf/cyYKQ+6b+J/E/ZVP/c1P9vqn/afxPCU93
V0Lum/RzU/9zU/9z+/7nts+k/uem/ifxP2XD++NkU/9zU//T+J8f/IK7knIn/dzU/9zU/9y+/7nF
gpQ7vD9ONtXvG94fJ8b/vFcT3h8nm/Rzw/vjZMP742T798ftYkHw3hveHyfE/5RN59831e+bzr8b
//ODmvleSeffN+nnpvPvm86/b3/+fVcLUu7kPzfp5yb/afxPCW73/ib/ucl/bvKfm/zn9v5zqwXp
+aTzR5v856bzR8b/lFC/1cSh80eH+p+Hzh8dOn90/Pmj3SwIa3To/BHxP+VQ//NQ//P4/ufuFoT7
eaj/eaj/eaj/afxP+R9FwILU/yT+pxzqfx7qfx7f/9zDgnQ/6fzmIf085D+N//lhR7gr4Zkn/qcc
8p+H/Oe5/Oe0IK0R+c9D+nng/UdyyH8e8p/G/5TQ3WqS/zykn4f85yH/eS7/uSxIuZP/PKSfh/wn
8T/lkP80/ue97uQ/D+nnIf95yH+ey39uC1Lu5D+J/ymH/Och/3nIfxr/84NGcVdS7uA/P8ecf3L/
C/7mXp7Lfx4L/uZeHvCf5QH/WZ7wm3t5QD/LA/6zGP/T1x3lAf9ZiP9ZHvCf5QH/WR7vP88bpNzB
f5YH9LM8MH8vD/jP8oD/LMb/9M98ecB/lgf0szzgP8sD/rM83n+e90rKHebv5QH/WW7+p+UO/c/y
wPy9PC8/5NtTLQ/M38sD+lkemL+XB+bv5fHz9xMtSLnD/L084D8L8T8L8T8L8T/LM+iZh/l7If5n
If5nIf5nufifJ1mQcof5eyH+Z3ng/ZuF+J+F+J/l5X9ezzzM3wvxPwvxPwvxP8vF/zz2mTB/LwHm
74X4nyXA/L0E6H+WAPP3YvzPK/cA8/cSSD8D+M8SwH+W4P3nEQtS7rD/sxD/swTY/1kC9D9LgP2f
JWT4vgfY/1kC6WeA/Z8lwP7PEvz+z1MsSLnD/s8SYP5eAsyPCvE/S4D5UTH+51/V09yVlDvpZ4D5
UQkwPyrBz49OtSDlDvOjEmB+VG7+p+UO/rMEmB8V4396T1sCzI9KIP0MMD8qAeZHJfj50VELUu4w
PyrE/ywB6vcSwH+WAPV7Mf6n93UlQP1eiP9ZAtTvJUD9XoKv30+zIOUO86NC/M9C/M9C/M8S/fmj
0y34WxsW4n8W4n8W4n+WGOB+Ev+zEP+zEP+zEP+zXPzPMywI95P4n4X4nyWSfhL/sxD/s8QMnoH4
n4X4n4X4n4X4n+Xif55pQcqd9JP4nyVC/V4i6Wck/Yyvfo7grqTPJP2MpJ+R9DNe+rksSLmTfkbS
zwj750sk/Yykn8b/vJ950s9I+hlJPyPpZ7z0c1uQcif9jKSfEc5vFuJ/FuJ/lkj6SfzPQvzPQvzP
QvzPcvE/z7Eg5U76SfzPEmH/UiH+ZyH+ZzH+5/W7SfzPQvzPQvzPQvzP4vmf6/vPIfcE8/dC/M+S
YP5eEtXvCebvJSXQugTz95JIPxPM30uC+XtJ2ef+Xkm5w/y9EP+zJJi/l0T1e4L+Z0kwfy+J9DOR
fibof5YE/c+Sqs89WpByh/5nSdD/LAnm74X4nyVB/7OkRrlD/7Mk0s8E/c+SoP9ZUve5JwtS7tD/
LAn6nyVB/7MQ/7Mk6H+WBPP3kqD/WRLpZ4L+Z0nQ/yxp+dztM6H/WRL0PwvxP0uC/mdJVL8n6H+W
dCh36H8W4n+WTP3PTP3P/PjcxYKQe6b+J/E/Syb/mcl/Zup/5gjeJlP/k/ifJVP/M1P/Myefe7Eg
5U79z0z9z0z9z0z+M1P/0/if17pn6n8S/7Nk6n9m6n/m4nOvFqTcqf+Zqf+Zqf+ZyX9m6n9mpdyp
/5lJPzP1PzP1P3PzuasFKXfqf2bqf2bqfxL/s2Tqf2bqf2bqf2bSz0z9z0z9zzx97s2ClDv1PzP1
PzP1P4n/WTL1P/Om3Kn/mUk/M/U/M/U/8/G5dwtC7kL9T+J/FgH+UhHyn0L1uwTIXUg/if9ZhOp3
ofpdos99WJByp/qd+J9FgL9UhPynUP0uVL8L1e/E/yxC9btQ/S7ic58WpNypfif+ZxHgLxUh/ylU
v0ul3Kl+J/5nEarfhep3UZ/7siDlTvU78T+LUP9TyH8K1e/SKXeq34n/WYTqd6H6XYbPfVuQcqf6
nfifRaj/KeQ/hep3WZQ71e/E/yxC9btQ/S7b534sSLlT/S5Uvwvsny9C/rNQ/V5g/3wpVL8T/7MU
qt8L1e/F1+/hDULuher3QvV7gfe/lwLvfy/Fvf99BbsS3v9eiP9ZiP9ZiP9ZCukn8T8L8T8L8T8L
8T+L53+uYH8n6SfxPwvxP0uh+r2QfhbSz0L9z0L6SfzPUkg/C+ln8foZkgUpd9LPQvpZqP9ZSD8L
6Wch/ST+ZyH+Zymkn4X0s3j9DPaZpJ+F9LOQfhbqfxbSz0L6WUg/C+kn8T9LIf0spJ/F62cQC1Lu
pJ+F9LOQfhbSz0r6WUk/K+kn8T9LJf2spJ/10s9iQci9kn5W0s9K/c9K9Xul/mel/mel/ifxP0ul
/mel/mf1/c9QLUi5U/+zUv+zUv+zUv1eqf9Zqf9ZST+J/1kq9T8r9T+r738GtSDlTv3PSv3PSv3P
SvV7pf5npf5npf4n8T9Lpf5npf5n9f3P0CxIuVP/s1L/sw74fa9Uv1fqf1bqf1bqfxL/s1Tqf1bq
f1bf/wzdgpQ79T8r9T/rptypfq/U/6zU/6zU/6ykn0r9T6X+p/r+ZxgWhNyV+p9K/U+l/Z/E/yxK
/U+l/Z9K/U8l/VTqfyr1P9X3P8O0IOVO/U+l/qdS/5P4n0Wp/6nU/1Tqfyrpp1L/U6n/qb7/GZYF
KXfqfyr1P5X6n8T/LEr9T6X+p1L/U0k/lfqfSv1P9f3PsC1IuVP/U6n/qcAPKQr8kKKOH7LCsSDU
R0r6SfzPoqSf+t0/P92VdD9JP5X0U0k/1etnfIN0P0k/lfRTaX5E/M+ipJ/61c/grqTcST8b6Wcj
/WxeP+N7JeTeSD8b6WeD85uF+J+lkX420s9G+tlIPxvpZyP9bF4/o/2dpJ+N9LORfjY4v1mI/1ka
6Wej/fON9LORfjbSz0b62bx+xmRByp30s5F+NtJP4n+WRvpp/M9rT2kj/Wykn430s5F+Nq+f0T6T
9LORfjbSz0bzI+J/lkbzI+N/3utO86NG+tloftRoftT8/CiKBSl3mh8R/7M0mh81qt8bzY+M/3mv
O82PiP9ZGs2PGs2Pmp8fRfs7aX7UaX7UaX7Uaf9np/q90/zI+J9X7p3mR8T/LJ3mR53mR93Pj2K1
IOVO86NO86NO/c9O9Xun/qfxP+/cqf9J/M/Sqf/Zqf/Zff8zqgUpd+DXlU79zw78umL8T4nBXQn8
ukL8z9KBX1c68OtKd/y6FZsFwYN1OL9ZiP9ZOtXvxv+UGLO7ktaI6vdO9Xun+r37+j12C9Iawfvj
Sqf6vcP744rxPyWm9b0S3h9XOvU/O7w/rnR4f1zpy6/RsCCtEekn8T8L8T9Lp/NHxP8sxP8sxP8s
xP8s/dLPaUFYowHvLy7E/ywD3l9cjP95OcAB7y8ug/zngPcXlwHvLy4j+jVaFoQ1Gpf/fINwP4n/
WYj/WYj/WYz/eT2fxP8sxP8sxP8sxP8snv+54rYg5Q78z0L8z0L8z0L8z0L8z/LyP/2TTPzPQvzP
QvzPQvzPMi79PBak3Ek/if9ZBunn+Oqne5JJPwfp5yD9HKSfw+tneoP03bz0s1iQ7ifp53j1M8j3
StLPQfo5SD8H6efw+pnsStLPAfzkMkg/B+nn2PAbN0g/B+nnIP0cpJ/D62eyv5P0c5L/nKSfk/Yv
Ef+zTPKf833/UUvuSsh9kv+c5D8n+c/p/WdKFqTcST8n6eck/Zxf/XQZkX5O0s9J+jlJP6fXz2Sf
Sfo5gR9SJunnpPnRfPkh7hdh0vyI+J9l0vxo0vxo+vlREgvSGtH8aNL8aFL9Pkk/J+nnfPkh219J
n0n6OUk/J+nnvPTTvkekn5PmR5P0c1L9Pql+n9T/NP7nnTv1P4n/WSb1Pyf1P6fvf6ZqQcqd+p+T
+p+T9HOSfk7qfxr/886d+p/E/yyL+p+L+p/L9z+TWhByX9T/XOQ/F/nPRf5zef+ZmgVBQ4j/WYj/
WYj/WV7+p9cQ4n8W4n8W4n8W4n8Wz/9cqVuQ7ie8/70Q/7MseP97Mf6nhPidDix4/3tZ5D8XvL+4
LHh/cVnVr9GwIK0RvL+jLOp/Lup/Gv/zclaL9JP4n2VR/3NR/3P5/meaFqQ1ov7nov7nov7nov7n
ov7nGpQ76SfxP8ui/uei/ufy/c+0LEi5U/9zUf9zUf2+yH8u8p9rU+6kn8T/LIv85yL/uS7/uS0I
uW/yn5v85yb/ucl/bvKfO0Dum/wn8T/LJv+5yX/uy38eC1Lu1P/c5D837Z/fpJ+b+p/G/7xzp/4n
8T/Lpv7npv7n9v3P/AYpd9r/uUk/N/FDNvnPTfs/jf955077Pzfp56b9n5v2f26//zO/V1LutP9z
0/7PTfvnif9ZNu3/3O/5d1ehbNr/uUk/N+3/3LT/c/v9n9n+Ttr/ueH9cWVT/b7h/XHF+J996Ndd
bHh/XNmknxveH1c2vD+ubPf+uJWTBeG3eF/6+QbpfgL/sxD/sxD/s7z8zxhePm0h/mch/mch/mch
/mfx/M8/62VByP3Q/J34n+XQ/P285zedszo0fz/kPw/N3w/N34+fv2exIDyfh+bvxP8sh+bvh/Tz
0Pz9vPN31ws6NH8n/mc5NH8/NH8/fv6eiwUpd+Anl0P9zwP85GL8z8v5H+AnF+J/lgP85HKAn1xO
889ntSA9n8BPLsT/LAf4yeWQ/zzATy7G/7x+ZQ7wkwvxP8sBfnI5wE8uZ/rc1YKUO+2fJ/5nObR/
/rz8ZMfQOLR//pD/PLR//tD++eP3z+dmQXo+af/8If08tH+e+J8fNPRP7n/BX89QH9g/Xx/wn/WB
/fP1gf3z9fH753O34G/u9Ym/z2d9YP98/cf//E9G8fd3sz7p9/msD/jP+o//+Z+M0u/zWY3/+f8Z
DQv+Pp/1Af2sxP+sxP+sD+hnJf5nJf5nJf5nJf5nfS79nBakNQL9rMT/rA/oZ32++qnfK0E/6wP6
WR/Qz/qAftbn0s9lQVoj0M/6gH7WB94fV4n/WR/Qz/q8/PntrgT9rA/oZ31AP+sD+lmfSz+3BSn3
SbmDftab/2nrDv6z/uN//if39fu7WZ9NuUP/sz7w/rj6wPvj6nN87seClDvwl+pD+hlIPwPpZyD9
JP5nDaSfgfQzeP2UNwjfzUD6GUg/A+mn8T/9vLgG0k/if9ZA+hlIP4PXT7ErST8D6SfxP2sg/Qyv
fobjrqQ1Iv0MpJ+B9DN4/RT7O0k/A+z/rIH0M0D/sxL/swbof9bw7v/8vu2iBuh/1gD9zxqg/1kD
9D9r8P1PSRak3MF/1kD6GUg/w6ufnxPVFiT9DKSfgfQzkH4Gr59in0n6GUg/if9ZA9TvNZB+BtJP
43/+OdX+vZL0M5B+BtLPQPoZvH6KWJByP5Q76WeE/Us1Qv1eI+xfqsb/vL7FEfYv1QjzoxphflQj
zI9q9PMjKRaE3CPsX6oR6vcaYf5eif9ZI8zfa3zfX/zdUVAjzN9rhPq9Rpi/1wjz9xr9/F2qBSl3
2L9UI+nnzf+0+wn9zxph/1I1/qd/d0mNsH+pRtLPCPuXaoT9SzX6/UuiFqTc4f3FNZJ+3vxPyx36
nzXC+4ur8T/vZ578ZyT9jHD+qEY4f1SjP38kzYKU+6DcYX5UI/Q/K/E/a4T+Z42TnnnSz0j6GaH/
WSP0P2v0/U/pFqTcof9ZI/Q/a4T+ZyX+Z43Q/6zG//RvmqsJ+p81kX4m6H/WBP3Pmnz/U4YFIfcE
7z+qCfqf9eZ/FgvS30n+M0VY90T+M5F+JvKfifxnuvzntCDlnil38p8J5u+V+J81wfy9Gv/z+r4n
mL/XRPqZYP5eE8zfa/Lzd1kWpNwr5U7+8+Z/2rpT/f6P//mf3JXWvVHupJ//+J//yb1R7t3nvi1I
uXfKHeZHNZH/JP5nTbD/sxr/8/J1CfZ/1kT6mWD/Z02w/7Mmv/9TjgUp90W5Q/+zJuh/1gT9z5p8
/7O8QagREvQ/ayL9TKSf6cD9zKSfmfQzk35m0s/s9bPYlaSfmfST+J81U/2eST8z6WeOoCGZ9DOT
fmbSz0z6mb1+Fvs7ST8z1e/E/6zE/6xf/qf7NST+ZyX+ZyX+ZyX+Z734nyVZEJ5P4n9W4n9W4n9W
4n9W4n/Wl//pq13if1bif1bif1bif9aL/1nsM6l+z1S/E/+zZqrf8/f9m+5K0s9M+pmpfs9Uv2df
vxexID2fwK+rmer3DPOjmt/50fdcec0wP6rE/6yZ9DOTfuZLP+1ZIv3M5D8z6Wcm/czv/P1LCahC
+kn8zyqkn0L6KZd+VgvCGgnpJ/E/q5B+CumnkH7Kq5+xfa8k/ST+ZxXSTyH9lEs/1YKUO+kn8T+r
kH7K+/7iEd2V8HwK6aeQfgrpp1z62SwIz6fQ/EhIP4XmR/LOj777Q6rQ/EjIfwrNj4TmR+LnR6Vb
kNYI9i9V4n9W4n/Wl//p3shcif9Zif9Zif9Zif9ZL/5nGRakNQJ+XSX+ZyX+ZyX+ZyX+ZzX+5+X8
if9Zif9Zif9Zif9ZL/5nmRak3Ek/if9ZhfRTXv/pfhEK6Wch/Sykn4X0s1z6uSwIz2ch/Syknzf/
0/5O0s9C+mn8T/nfxMyCpJ+F9LOQfhbSz3Lp57Yg5U71O/E/a7nq92JB+jupfjf+5/UkF6rfif9Z
C9Xvher34uv3cixIudP8iPiftZD/LO/++e9Zy1rIfxbyn4X8ZyH/Wbz/rG8QvpuF/Gch/1nIf5bX
fzqlLeQ/C/nPQv6zkP8s3n9Wu5L8ZyH9JP5nJf5nffmf/ved+J+V+J+V+J+V+J/14n9W+ztJPwvp
J/E/ayH9LNT/rKSflfSzkn5W0s/q9bMmC8IaVeDX1Ur6WWH/Z63v/k83xaiw/7MS/7NW2P9ZK+z/
rNXv/6z2mbD/s1bY/1krzY8q+c9K+lnJf9Yvf2m6Kyl38p+V/Gcl/1m9/6xiQcq9gs5X8p+V/Kfx
P6+qvJL/JP5nreQ/K/nP6v1ntb+T/Gel/UvE/6zE/6zE/6wX/7NWC9L9hPPvlfiftVL/s77n3/0T
Qv3PSv6zUv+zUv+z+v5nVQvS/YTz77WSflY4f1Try1+azV1JzzzNjyqcP6oVzh/V6s8f1WZBWCOF
80dVST8V+EtVaf+Swvmjqi9/aYq7EnIn/mdVOH9UFc4fVfXnj2q3IOWe4PlU8p9K83fjf149K6X5
O/E/q9L8XWn+rn7+XocF4flUmr8T/7Mqzd+V/KfS/F0LfDeV5u/E/6xK83el+bv6+XudFqTcaf5O
/M+qDXyI0vxIaf6u3/n71ysqzd+J/1mJ/1mJ/1kv/mddFqTc4f1xlfiflfif9eV/eh9C/M9K/M9K
/M9K/M968T/rtiB9N+H8eyX+Z1XgJ1fif1bif9aX/3l9i+H8eyX+ZyX+ZyX+Z734n/VYEHK/+Z/F
gpD7P/7nnZHxPy8f0qh+b1S/N3h/R23w/o7a/Ps7vkF4PluC72aD85v15n9GC9LfmSn3DN/NJpQ7
1e//+J//yV0o9+JztysL5V4odzi/WRv1P4n/WRv5z1bh96iR/2zkPxv5z0b+s3n/qfZ3kv9s1P9s
5D8b9T/b2/90HbNG/U/if9ZG/c9G/c/m+5+aLEjfTep/NvKfjer3RvrZqH5vC7xio/qd+J+1Uf3e
qH5vvn5X+0yq3xvN3xvV7w3e/14bvP+99sc/S2JBeJaI/1mJ/1mJ/1n79/x7d1fC/ST+ZyX+ZyX+
Z734n1osCPeT+J+V+J+V+J+V+J+V+J/1y/903yPif1bif1bif1bif9aL/6nVgpQ7nH+vxP+snfSz
k352OP9e+/v+I7fro8P599qp/9nh/HvtcP69dn/+XdWClDucf6+d/Gcn/ST+Z+2kn72Dt+mkn530
s5N+dtLPfulnsyDlPsHbEP+zdtr/afzPq+7otP+z0/7PTvs/O+3/7H7/p3YLki7R/k/if9ZO/c9O
+tmp/9lpfjSo/0n8zzqo/zmo/zl8/1OHBSH3QfOjQfo5aP4+yH8Omh+NCN5m0PyI+J910Pxo0Pxo
+PmRTgtS7tT/HKSfg/qf452/u37IoP4n8T/roP7noP7n8P1PXRaE7+ag/ifxP+sg/zm+8/fvHrNB
/nOQ/xzkPwf5z3H5z21BWiPqfxL/sw6aHw2q3wfNj8Y7P3IV9KD5EfE/66D50aD50fDzIz0WpNzp
/NEg/zno/OYg/Rx0/mi854/8k0znjwbV74POHw06fzT8+aP2Bil3On80qH6fVL9Pqt+nr9/beyV8
j2aA+zmpfp9Uv88AOj+pfp+kn5Pq90n1+/T1e7O/k+r3SfX7JP9J/M9K/M86qX43/ufl1ibV75Pq
90n1+6T6ffr6vSULUu7kP4n/WSfV75P0c5J+zkrrTvpJ/M86ST8n6ef0+tnsM0k/J+kn8T8r8T8r
8T/rxf9sYkH6HgH/sxL/s06aH03aPz9pfjTJf06aH02aH00/P2rFgnQ/af/8pPr95n/as0T6+Y//
+Z/cNz1Lh3In/zmpfp9Uvy9fv7dqQch9PZD7ovp90flN4n/WRfq5Aqz7Iv1cpJ+L9HORfq5LP9WC
lDvpJ/E/66L+5yL9XKSfK8Nv8SL9JP5nXaSfi/RzXfrZLEi5w/vf6yL9XFS/r7d+d93sRfU78T/r
ovp9Uf2+fP3eugVBlxbV74vq90X1+yL9XFS/r7d+dz3ARfU78T/rovp9Uf2+fP3ehgUpd6rfF+nn
ovrd+J/380n1O/E/66L6fVH9vnz93qYF6fmk+p34n3Udyp30c1H9vmj//Kb6nfifdVP9vql+375+
b8uCkPum+p34n3VT/b5JPzfV75vq9031O/E/66b6fVP9vn393rYFKXfa/0n8z7rp/OYm/dy0/3ML
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
KvE/tbz+cx93JT3zpJ/E/1Tif+rF/1z2d5J+Ev9Tif+pxP9U43/2x807iP+pxP9U4n8q8T/14n+u
ZEFYowrvf1fifyrxP9X4n/3/P9WCsEbE/1TifyrxP/Xify77TNq/RPxPJf6nVpofVZofVT8/WmJB
up80PyL+p1bY/6nG/2xn+ivpfpL/rNT/rNT/rL7/uYoF6X7C/k8l/qdW4CdrJf2sND8y/uedO82P
iP+pxP9U4n/qxf9c1YKUO82PiP+plebvleZHleZHxv+8v0fkPyvpZ6X5UaX5UfXzo6UWpNxpflSp
/0n8TyX+p1aaHxn/886d/Gcl/6k0P1KaH6mfH61mQchdA+Su1P8k/qcS/1OV9FNJP5X0U0k/lfRT
ST/10s9uQcqd9JP4n6q0f0nJfyrt/zT+5/V9V9r/SfxPVdr/qbT/U/3+zzUsSLnD+4+U+J+qtH9J
qX5X4M+r8T/v3Ek/if+pSv5TyX/q5T+nBSn3TrmT/1Sq35Xqd6X9S8b/vHMn/ST+pyrtX1Lav6R+
/9JaFqTc4fyRKu1fUvKfSv5T4fyRGv/zzp30k/ifqnD+SBXOH6n680drWxByb8BP1kb+s1H93qh+
b9T/bAFyb6SfjfSzUf+zUf+z+f7nOhak3Kn/2aj/efM/7e+k+r1R/d4y5U71eyP9bFS/N6rfm6/f
9xuk3Kn/2ah+b+Q/if+pjfqfxv+UlIO7kj6T9LNR/7NR/7P5/ud+r6Tcqf/ZqP/ZyH8S/1OJ/6kv
//PKnfST+J9K/E8l/qde/M8dLUi5U/+T+J/ayH8S/1OJ/6lt0TNP+kn8TyX+pxL/Uy/+504WpNyp
/0n8T23kPxv5z079T+N/XuveST+J/6md+p+d+p/d9z+3fSb1Pzv1Pzv1Pzv5z07+8x//8z+5J1j3
TvpJ/E81/uede6bcs89dLEi5C+VO8/dO/rOT/+xUvxv/81530k/if2qn+r1T/d59/b6LBSl3qt87
1e+d/Gcn/9mpfu9Uv3fST+J/aqf6vVP93n39vqsFKXeq3zvV7538Zyf/2al+N/7nnTvpZyf97FS/
d6rfu6/ft1qQcqf6vVP93sl/Ev9TO9Xvxv+8n3nSz076Oah+H1S/D1+/72ZByH1Q/T6ofh/kP4n/
qYPqd+N/XrkP0s9B+jmofh9Uvw9fv+9uQcqd6vdB9fsg/0n8TyX+p778zyt30k/ifyrxP5X4n3rx
P/ewIOVO9TvxP3VQ/T7Ifw6q343/eedO+jlIPwfV74Pq9+Hr9z0tSLlT/U78Tx20/3OQ/xxUvxv/
886d9HOQfg6q3wfV78PX73tZkHKn+p34nzpo/+cg/zmofjf+55076ecg/RxUvw+q34ev3/e2IOQ+
qX6fVL9P2v85yX9Oqt+N/3nlPkk/J+nnpPp9Uv0+ff2+jwUpd6rfJ9XvxP9U4n/qpPrd+J937qSf
k/RzUv0+qX6fvn4/b5Byp/p9Uv1O/E8l/qdOqt8n1e+T6vdJ+jmpfp9Uv09fv5/3Ssqd6vdJ9Tvx
P5X4nzqpfp9Uv0+q3yfp56T6fVL9Pn39fqIFKXeq34n/qZP85yT/Oal+N/7nnTvV78T/1En1+6T6
ffr6/SQLUu5UvxP/Uyed35zkPxfV74vq90X1O/E/dVH9vqh+X75+P/aZVL8vqt+J/6mL/Oci/7mo
fjf+55071e/E/9RF9fui+n35+v2IBSl3qt+J/6nE/1Tif+rF/zzFgjDTX6SfxP9U4n/qIv0k/qcS
/1OJ/6nE/9SL/3mqBel+kn4S/1MXnT9adP5o+fNHRy1I95P8J/E/dZH/XOQ/F/nPRf5zkf9c5D+X
95+nWZDuJ/lP4n/qIv+5SD8X+c9F/nOR/yT+py7yn4v85/L+83QLQu6b/CfxP3WT/9ykn5v85yb/
ucl/Ev9TN/nPTf5ze/95hgUpd/KfxP/UTf5zk35u8p+b/Ocm/0n8T93kPzf5z335z2lByp38J/E/
dZN+btLPTfq5ST836SfxP3WTfm7Sz33p57Ig5U76SfxPJf6nEv9TL/7n2RYE/dykn8T/VOJ/6ib9
JP6nEv9Tif+pxP/Ui/95jgXpfpJ+Ev9TN/lP4n8q8T91k34S/1OJ/6nE/1Tif6rnf+7vP4fcD+kn
8T/1kP88pJ+H9POQfh7Sz0P6eUg/D+nniT7390rKnfST+J96iL90iL90HH9p247WQ/ylA+8/0kP6
eaj/ed73v39JjHqo/0n8Tz3U/zzU/zzF389kQbqfdH7zUP/z0PlN439e+5MPnd8k/qcS/1OJ/6me
/7nfz6Tzm4fqd+J/6qH50aH50en+fooF6X7S+fdD86ND59+N/9mfuL9X0vl34n/qofPvh86/n+Xv
Z7Eg3U94/7se0s9D+mn8z/uZJ/0k/qce0s9D+nku/awW/F2jD6DjJ6O/4O/9bA/wl9rz8pdG/F4J
/KX2wPzoL/i7Ru0B/lJ7ol8jteDvGrWb/2kZQf3eHqjfm/E//77F4q78XaP2gP9sD9Tv7YH6vT3Z
r1GzIK0R1O/tgfq9PVC/twfq9/YUfz+7Bel+Frqf4D/bA/6zPe/5zVHclXQ/wX+2B/xne8B/tkf9
/RwWpPsJ/rM94D/bA/6zPeA/29P9/ZwWpPsJ/Lr2gP9sD/jP9gy6n+A/2wP+sz3gP9sD/rM909/P
ZUG6n+A/2wP+sxH/sxH/sz2gn+357v/s7kr6TNDP9oB+tgf0sz2Xfm4LQu4B/GcLpJ83/7NYEP7O
AP6zhQDrHsB/tgD+swXwny2A/2zh8p/HgpQ7+M9G/M8W4PxmC6SfAer3ZvzP/ieP7krKHfxnC1C/
twD1ewuuft/hDVLucH6zEf+zBTi/2Yz/6c8btgDnN1sA/9kCnN9sAc5vtuDOb+5gV8L5zb/gr1ds
Aebv7eZ/2pNM+mn8zzv39vrk/b2yU+4wf2//+J//yb1T7sPnbms0KPdBuZN+BuDPtwD+swXgzzfj
f965A3++Ef+zBeDPtwD8+Ra2zz1ZkHIHfl0LpJ8B9i+18OXXHXclfTdhftQi7F9qEfYvtfj472a2
IHw3I/CXGvE/WwT+Uosvf6l81SYCf6lFmB+1COffW4Tz7y0mv0ZiQVijSPoZST8j6Wd89dM9dZH0
M5J+RtLPSPoZL/0sFqQ1Iv0k/mcj/meLpJ/E/2zE/2zE/2zE/2zx0s9qQVoj4H824n824n+22OB7
RPzPRvzPRvzPRvzP5vmfO6gFaY1g/2cj/meLpJ/E/2zE/2zxPb+Z3WrC/L0R/7MR/7MR/7N5/ucO
zYKUO+z/bMT/bMT/bMT/bMT/bPGAtyH+ZyP+ZyP+ZyP+Z0uXfnYLQu7E/2zE/2zE/2xf/uf+VtDE
/2zE/2zE/2zE/2zp0s9hQfhuEv+zEf+zJarfE9XvydfvYVqQ7ifw5xvxP1sC/nwz/uff/QzfK4E/
3xLpZwL+fEvAn2+p+vu5LEj3s8Izn6h+T7D/sxn/03dKW4L9ny2RfibY/9kS7P9sqfk12hakNYL9
ny2R/0zkPxP5z3T5z2NBup/AT26J9DORfqZXP5/qrqT7SfqZSD8T6Wfy+hnfIN1P4H824n824n82
43/eTwjwPxvxPxvxPxvxP5vnf+4YLAhrRPzPRvzPlmH/Usuwf6nl4O9ntCDczwzv72jE/2wZ3t/R
jP/ZH2nfK+H9HS1T/Z5hftQyzI9a9vOjmCxI9xPmRy2T/8wwP2rG/7wzgvlRyzA/ahnmRy3D/Khl
Pz+K9pkwP2oZ9s834n+2TP4zk//M3n9GsSDdT/KfmfQzk//Mr/90v9qZ/CfxP1sm/5nJf2bvP2Ox
IN1PmB814n+2DPOjlgc98zA/apnq9wzzo5ZhftSynx/FakFaI9i/1Ij/2Yj/2Yj/2Tz/c0e1IN1P
4C814n+2DPylloG/1AT4S02o/ynAX2oC/KUmwd/PZkG4nwL8pUb8zyZw/qhJBA0R2P/ZhOZHAueP
msD5oybJr1G3IKyRwPmjJnD+qAnwl5oAf6mJ+Ps5LEj3U+h+kn4KnN9s8vKXjror6X7S/Ejg/GYT
OL/ZpPr7OS1I9xP4801g/t4E+PPN+J/3EwL8+Ub8zyY0PxKaH4mfH8VlQVoj2L/UiP/ZiP/ZiP/Z
PP9zx21Bup/U/yT+ZxPqfxr/86plhPqfQv1Pof6nUP9TfP8zHgvS/aT6Xah+F6rf5ZCGUP1O/M9W
qH4vVL8XX7+nNwhrVOD8ZitUvxeavxeavxc/f092Jc3fy6WfxYKUO83fS4L7WWj+TvzPVqh+L1S/
F1+/p2hBup80fy9UvxfSz0L6WUg/jf/ZQ0juSsqd9LOQfhbSz+L1MyULUu6kn4X0s5B+Gv/zzoj0
s5B+FtLPQvpZvH4m+0zSz0L6WUg/C/lP4n+2Qv6zfPcvre+V5D8L6Wch/1nIfxbvP5NYkHKH/UuN
+J+t0Pzd+J93RjR/L6Sfhebvhebvxc/fk2kIzd8rzd+J/9mI/9mI/9k8/3OnakG4n8T/bMT/bMT/
bMb/vH4Nif/ZiP/ZiP/ZiP/ZPP9zJ7Ug3U94f0cj/mer8P6OZvzPOyN4f0erpJ+V9i9V2r9U/f6l
1CxIawT75xvxPxvxPxvxP1u99LNbkO4n6SfxP1sl/TT+Zzvrq5+V9LOSflbSz0r6WS/9HBak+0n7
lyrpZ6X9S/Xdv+Qzov1LxP9slfYvVdq/VP3+pTQtSGtE+5cq+c9K/rOS/6zef6ZlQbqf5D+J/9mI
/9m+/M/kvnHkP4n/2ZT8J/E/m17+c1sQ7qfS/Ij4n01pfqTv/N1lpDQ/Uup/Ks2PlOZH6udH6VgQ
1khpfqTkP5X8p5L/VO8/8xuk+0nzIyX9VJof6Ts/clW50vxIaX6kND9Smh+pnx9lu5LmRzf/s1iQ
7ifNj/SdH7npP/E/G/E/G/E/G/E/m+d/7mx3nuZHCvz5RvzPpsCfb/ry590ODQX+fFPynwr8+abA
n286/RolC9IaAX++Kc2PFM6/N+N/Xs6f+J+N+J9Nqf+p1P9U3//M9pnU/1Tqfyr1P5X6n8b/7MFN
2Rr1P4n/2Rr5z0b+s3n/mcWCsEaN/CfxP1sj/2n8zx7OdFfCGjXyn438ZyP/2bz/zMWCsEaN+p+N
/Gej+RHxP1uj+ZHxP3tsxV1JuVP93mh+1Gh+1Pz8KFcLUu5w/qg1mh81OH/UjP95P59w/qg18p8N
zh+1BuePWvPnj7JakJ5POH/UiP/ZGulnI/1spJ/G/7ymV430s5F+NtLPRvrZLv1sFqTcST+J/9mI
/9m+/M+T3ZX0fJJ+Ev+zEf+ztUs/uwXp+QR+SCP+Z2s0f280f+9+/p7/r7j32Z2kWc7z9r6K7xKq
MqsqK8+OIkWIMEES5xwLkA0vIjIiAAGCLEjw/XuGmuiO5DyAvfOCCwb66zNZ0f3+3viTT2sG4XkK
/H7cJP7nFNqflxOep9D+vJB+Cu3PC+3PS92fv1YG4XkK7c8Lzd93/ueTQfp30v6nXHR22v8U0k+h
/U+h/U+p+5+XZZDODvffp5D/FPj9uEn8zyl0/0gGnZ3uHwn5T6H7R0L3j6TeP7o8g3R2un8kVL8L
/H7cJP7nFOAvzeR/7mcH/tIUqt+F5kdC8yOp86MrMkhnB/7SFOp/Cvz+5iT+5xTSTyH9FNJPIf0U
0k8h/ZSqn/cnSGcn/RTSz53/mVpH9bsCf2km/1Oa3uWVcHYl/VTaX1LaX9K6v3R/Xgln161+fzII
Z1faX0r+pzRp31fS/pKSfirtLyntL2ndX7pbBuHv0c7/zBORfhL/c+rHf65VXkk5Iv9J/M9J/M9Z
+Z9+9wxSjsh/Ev9zKvlP/dx/n+VE5D+V/KeS/1Tyn1r9553vSf5TJ3yPlPRTST+T//mjPiqfOtJP
4n9OJf1U0k+t+nnfGaQckX4q6afS/qeSfirpZ/I/f9RHUl5J70n6qaSfSvqpm37m94j0U0k/lfRT
ST+V9HORfib/c4ZpeSWcnfifc5F+LtLPtennyCCcfZF+LtLPRfqZ/M+t0l+kn8T/nIv0c5F+rk0/
3wzCd3NR/U78z7lIP5P/uVW7i/RzkX4u0s9F+rk2/ZwZpByRfi7Sz0X6mfxPafe3771IPxfp5yL9
XKSfa9NPySDliPST+J+T+J8z+Z/SWvkekX4S/3MS/3MS/3OuTT81g5Qj0k/if85F/pP4n5P4n3OR
/yT+5yT+5yT+5yT+51ybfq4M0tmp/0n8z7mo/7kC/r4b9T+N+p9G/U+j/qfV/udtGYTPp1H/06h+
N+p/Jv9TWulRE/9zEv9zGvU/jfqfVvuft2cQcmQ0fzfqfxrN3+07f/86f6P5O/E/J/E/J/E/Z+V/
+h0ZpBwRP4T4n5P4nzP5n1uflvifk/ifk/ifk/ifs/I//fkEKUdUvxP/cxrV70b6aaSfJuBDjPST
+J/TSD+N9NOqfj6fV9LZST+N9NNof8lof8nK/lJrnyB9lkg/if85if85k/85Hy/fd9pfIv7nJP7n
JP7nrPzP1j6vhOfppJ/E/5xO/KXkf/74A/p16U78Jaf5u9P+p9P+p7eao5ZByJGTfjrpp9P+Z/I/
f66UlFfSe1L/02n+7jR/96vmqGeQckT66aSfTvP35H++o5Uc0fyd+J/Taf7uNH/3UXOU70nzd+J/
TuJ/Tqf5e/I/31E2NJzm707zd6f5u9P83WfN0Z1ByhHxQ5zmR07zo+R//gh+b987zY+c5kdO8yOn
+ZGvmqMng5SjzX9+gvQ8aX+J+J/zF//z35zdPhry7XK409np/uYv/ue/ObvT2aOefWSQzg78+elU
vwfpJ/E/Z5B+xgFnD9LPIP0M0s8g/YxNP98MwtmjwdmD9DPIfwb5z+j1ezQzCN+joPl7kP8M8p/J
/9yfJ+lnkH4G+c8g/xlPfZ6SQXqetP8Z5D+D+CHE/5zE/5zJ/9zPTvU78T8n8T8n8T9n5X+2vM9F
/M9J/M9J/M8ZpJ9B+hmkn8n/3M9O+kn8zxmkn0H6GZt+rgzS2Uk/g/QzNv1sGaR/J+ln8j+3v4ZB
+hmkn0H6GaSfsemnZZDOTvoZoJ8/DclvZ/8R/P3fKcT/lOR/VrcmxP8U4n8K8T+F+J9ybPrpGfz9
7EL8TyH+pxD/U5L/WR21EP9TiP8pxP8U4n/KsfnPyODvmiwH7H8K8T/lAP8pyf+cb5vfV4L/lAP8
pxzgP+UA/ylH9Z/9E6Qcwf6nEP9TDvCfkvzPOdpZXkk5Av8pB/hPOcB/ylH9Z/+8knIE+0tygH7K
Afopyf/8UZmO7ytBP+UA/ZQD9FMO0E85qn72/HeCfsoB+0tygH7KAf1PSf7ne7uWV1KOoH6XA/qf
ckD/Uw6vOeoZpBzB/EgO6H/KAfMjOUg/T5gfSfI/t7OfMD8S4n/KCfMjOWF+JOdZz57vCfMjOeH3
j+SE+ZGcsD8vJ+zPy9nrZ+nOIHyWiP8pxP8U4n9K8j/rX1gh/qcQ/1OI/ynE/5TK/2y/7p0J8T/l
hP0lIf6nnHB/U07wn3JC/1OS/7kpwwn1u5yknyf0P+WE/qecbz37yCCdHe4fCfE/hfifkvzPTb2J
/ynE/xTifwrxP6XyP9uvW29C/E854f6REP9TTuAvSfI/t7+wJ8zf5ST9PIG/JCfwl+S0mqOZQcoR
+E85wX/KCfwlSf5n7VnJCfwlOUk/T9j/lBP2P39WC+VEkkHIUSP9bKSfDfY/JfmftfcrDfY/pcH8
SBrsf0qD/U9preZIMwg5ajB/lwbzd/nF//w3J+q/936lXfSeUL9LA36INOCHSLtrjlYGKUcwf5cG
83dpcP9dkv+5VRON9LORfja4vykN7m9KGzVHlkHKEdTv0qB+lwb3NyX5n3PNr3o30s9G+tng/qY0
uL8pTWqOPIOUI5gfSYP5kTS4vynJ//yhDOV7RPpJ/E9pcH9TGtzflLZqjiKDlCPgh0iD+l0a1O+S
/M85RjkR6SfxP6VB/S4N6ndptX6/PkHKEdzfFOJ/Sif/mfzPOS4rr4T37KSfnfxnJ//Zq/+8Pq+E
HBH/U4j/KR32lyT5nz9O9P0L20k/O+lnh/0l6bC/JP2qOWoZhBx18p+d/GeH/SVJ/ucc71NeSe9J
+tlhf0k67C9Jf2qOegYpR9D/lA79T+nQ/5Tkf84x7+8rST876WeH/qd06H9Kr/3PK98T+p/SgV8n
Hfqf0mH+Lsn/nOMs3yPSz0762WH+Lh3m79K15ujOIOUI+CHSYf4uHfhLkvzPH3+PvlrXST876WeH
++/S4f67dK85ejJIOYL5u3SYv0uH+++S/M/5fHckpJN+dtLPC+6/ywX33+U6ao5GBiFHF/U/L+p/
XnD/XZL/OZ8vCVwu0k/if8pF9ftF9ftV6/df9/jkovr9ov7nRfX7RfV78j9/KMMsr6T3JP28qH6/
qH6/av3+63aeXFS/X9T/vKh+v4A/L8n/nEO/n7qL9JP4n0L8TyH+p1T+Z/t1O0+I/ykX9T+J/ynE
/5QP/3N8JzhC/E8h/qcQ/1OI/ymV/9l+3fgT4n/KBfx5If6nXMCfl4v850X1e/I/6/RKLqrfL6rf
L6rfL6rfr1q//7obKBfV7xfw5+Ui/3mRfl6knxfpZ/I/97OTfl6knzfp5036eW/6aRmEs9/Ar5Ob
9HPnf36C9O+E/U9J/ud2duJ/CvE/hfifQvxPqfzP9utuoBD/U4j/KcT/lBv25+Um/bzJf94f/1kU
7Cb/SfxPucl/3uQ/781/Rgbp7LA/Lzfp503+M/mf29/Nm/wn8T/lJv95k/+8q/+8P0HQ5Bv25+Um
/bzJfyb/c3NrN/lP4n8K8T+F+J9S+Z/t/ryScgT8TyH+pxD/Uz78z+1TR/6T+J9C/E8h/qdU/me7
899J/pP4n0L8TyH+pyT/cz8R6SfxP4X4n0L8T6n8z/brHp8Q/1OI/ynE/xTifwrxP6XyP9uvO3dC
/E95aP5O/E8h/qc8HZ4n8T+F+J9C/E8h/qdU/mf7dedOiP8pD83fif8pD83fk/+5n4j850P+86H5
+0Pz96fO33/dpJOH5u/PgL+bD82Pdv5nvifpJ/E/Jfmfm/Mn/qcQ/1OI/ynE/5TK/2y/btIJ8T+F
+J9C/E8h/qcQ/1OI/ynJ/9zPTvU78T+F+J9C/E+p/M/2686dEP9THuDPC/E/5aH5+0Pz96fO33/d
j5OH5u8P3D+Sh+ZHD9w/kuR/bs9zwP6nEP9TiP8pxP+Uyv9sv+7HCfE/ZZD/JP6nDKrfB9Xvg/qf
o4GGDOp/Dup/Dup/Dup/jtr//HWTTgb1PwfV74P85yD/mfzPn1doyyvpPcl/DvKfg/znqP7z1/04
GeQ/B9Xvg/znIP85Pvufxa0N8p/E/5RB/nOQ/xyb/7QMUo6ofh/kPwf5z+R/br21Qf6T+J8yyH8O
8p9j85+eQcoR6ecg/RzkP5P/uW3mDPKfxP8U4n8K8T9lbP4zMkg5ovqd+J9C/E8Zn/5nqXqI/ynE
/5SX/CfxP6XyP9vzCUKOXup/Ev9TiP8pyf/cuu7E/xTifwrxP4X4n1L5n+3JV1L/8yX/SfxPean/
+X77n3d5Jb0n6edL/c+X+p9v7X8+LYOUI/KfxP+Ul/qf76f/WaZXL+nnS/r5Uv/zpf7nW/ufT88g
5Yj6n8T/lJf6n++n/1kmjC/p50v6+VL/86X+51v7n0++J/U/if8pxP+Ul/zn+/GfZQr8kn6+pJ8v
+c+X/Odb/edzZ5ByRPufxP+UF+5vSvI/t0n9S/r5kn6+cH9TXri/KW+9v/k8GYQcTeDPC/E/ZcLv
x8mk+fuk/aXkf269ykn7S8T/lEn7S5P2l2bdX3pGBunswK+TSf5zAj9ZJunnJP1M/uePs9/llXR2
0s9J+jlJP+emn28G6ey0/zlJPyftL03aX5q0/5n8z/3stP85qX6ftP85af9z1v3PZ2aQzg7332VS
/U78TyH+p0zyn1Po7OQ/J/nPSf5zkv+c1X8+kkE6O9x/l0n6SfxPIf6nEP9TPvzP+veI+J9C/E8h
/qcQ/1Mq/7M9mkE6O9XvxP+USfX7/Nbv32wK1e9C+ilUvwvV71Lr92dlEP4eCfBDhPifIjQ/Sv7n
5r2F5kdC/U+h+ZHQ/Ejq/OixDEKOBPghIjQ/Eri/KfK5v1lqWIH7myLU/xS4vykC9zdF6v3NxzNI
OQJ+iBD/U4j/KR/+Z+0zEP9TiP8pxP8U4n+KbPoZGaQcTcoR6afQ/rx89ueLMgjtzwvtzwvtzwvt
z0vdnx+fIOVom78/GaTnSfP35H9u3S2h+TvxP0Vo/i40f5c6fx+fV1KOtvl7nojm70L788n/3L9H
tD9P/E8R2p8X2p/Xuj8/WgYhRzv/88kgPE8l/5n8z817K/lPJf1U8p9K/lOr/xw9g5Cjnf+ZZyf/
qbQ/r5/9+aIMSvvzSvqptD+vtD+vdX9+5HvS/vzO//wE6XlS/5P4n1L5n23cGaTnSfU78T+F+J+i
3/vv37/vxP8U4n8K8T+F+J9S+Z9t5CeZ+p9K/pP4n6Kkn0r6qXR/U4XOTvW7Uv2udH9T6f6m1vub
Y2SQzg7334X4n6LU/1Tqfyrtzyf/c+sSK+3PK+mn0v680v681v358WaQzk79T+J/CvE/ZdH9TeJ/
CvE/hfifQvxPqfzPNmYG4bu5qP9J/E8h/qck/3PTOuJ/CvE/hfifQvxPqfzPNiSDkKNF9TvxP4X4
n7Ju+HtE/E8h/qcQ/1OI/ylr00/NIOWI9JP4n0L8T1k0PyL+pxD/U4j/KcT/lLXp58og5Yj6n8T/
FOJ/yhLwdcT/FOJ/CvE/hfifUvmfbVgGKUfU/yT+pyyaH63P/lLx3ov0c5F+LpofLZofrTo/Gp5B
yhH1Pxf1PxfNj9Znf6l0iRfp5yL9NJofGc2PrM6PRmQQcmQ0PzKaHxnNj+wzPyqzCSP9NNJPo/mR
0fzI6vzoG4QcGc2PjPqfRv3P5H9ufQYj/TTST6P+p1H/02r/8/28knJE8yOj/qfR/Mg+86My4zPS
TyP9NJofGc2PrM6P3pZByhHNj4zmR0bzI/vMj0p3y0g/if8pRvMjo/mR1fnR2zNIOaL9eSP/aXR/
06h+N6rf7bs/X85O9buR/zSq343qd6v1+5vvSfW70f68kf/c+Z+fIP07ST8t6Oykn0b66aSfTvrp
VT/fO4Nwdqf9T+J/CvE/hfifsvE/3yeD8D1y4NcJ8T+F+J/iHZ4n8T+F+J9C/E8h/qds/M93ZJCe
J/z+uxD/U5z8p5P/dLr/nvzP/ew0P3Lqfzrdf3e6/+71/vv7ZpDO/tLZyX/u/M+WQfp3kn4m/3P7
G+ekn0766aSfTvrpm37ODNLZaf+T+J/iNH93mr87+U8n/+k0f3eav3udv7+SQfpuwu+/i9P8yGn+
7p/5e/HzTv7TST+d5u9O83ev8/dXMwg5CuLXEf9TiP8pH/5nrSKJ/ynE/xTifwrxP2Xjf74rg5Cj
oP154n9KkH4m/3P7HgXpZ5B+BulnkH7Gpp+WQcoR7c8T/1OC9ufjphyR/wzyn0H780H781H351/P
IOWI+HVB86Mgfl288D0K8p9B+hnErwvi10Xl172RQcqRgM4T/1NC6OxUvwfxQ5L/uZ+d/GeQ/wzi
hwTxQ6LyQ+YnSGff6vc8EdXvxP+UIH4I8T+F+J9C/E8h/qds/M+Zr6T+ZxC/jvifP1Pw24l+BH/X
ED2g/6kH9D/1gP6nHtD/1KP2P2fL4O850gP4dXpA/a4HzN+V+J9K/E89wH8q8T+V+J9K/E8l/qdu
/M/ZM0hnB/+pxP/UA+bvesD8XY86f595Ipi/6wHzdz3Af+oB83c9YP6uB8zflfifesD8XQ+Yv+tR
5+/zziA9T9hf0gPm73rA73foAf5TD+h/6iF0duh/6gH6qQf0P/WA/qcetf85898J/U89YH9JD/Cf
SvxPJf6nEv9Tk/+5nx32l5T4n0r8TyX+p278zzkySGcH/qcS/1N3/mc+T9JP4n9q8j+3sxP/U4n/
qcT/VOJ/6sb/nG8G4ezE/1Tif+rZ4Own6edJ+nl2OjvpJ/E/9ST9PEk/z00/Zwbp7KSfJ+nnSfp5
kn6em35KBkE/T9JP4n8q8T/1JP0k/qcS/1OJ/6nE/9SN/zk1g/Q8ST+J/6kn6edJ+nmSfp6knyfp
50n6eZJ+nqSf56afK4N0dtLPk/TzhN+PU+J/6kn6eZJ+nqSfJ+nnSfp5kn6em35aBunspJ/E/9ST
9PMk/Wykn430k/ifSvxPbaSfjfSzbfrpGYSzN9LPRvrZSD8b6Wcj/Wykn430s5F+NtLPRvrZNv2M
DNLZST8b6Wcj/Wykn63qp3yCoJ+N9JP4n9pIPxvpZyP9bKSfjfSzkX62qp/yeSU9T9JP4n8q8T+V
+J+68T8lnxLcf9ed//l5JZ0d6ndN/uf+PKF+V+J/KvE/lfifuvE/pWeQnifU70r8TyX+p374n7Xa
Jf6nEv9Tif+pxP/Ujf8p+Z5Qv2uD3+9Q4n9qP+DsHfqf2qH/qcn/3M7eof+pHfqf2qH/qR36n9pr
/1PuDMLZO8yPtJN+dtj/VOJ/aof9T03+53522P/UDvuf2mH/Uzvsf2qv+5+SOYL9T+2w/6nE/9T+
UN6h/6kd5u+a/M/97DB/V+J/aof5u3aYv2uv83cZGaSzv3R26H9qn3R20s8O+/Oa/M+6Z6Ud9j+1
Q/9TO+zPa4f9ee11f17eDNLZYX9eO+lnh/m79s/+/Cgngvm7dvKfHebv2mH+rr3O32VmEDS5O303
ST877M9r8j9rl1g77M9rJ//ZYX9eO+zP61X350UyCDm64P6mXuQ/d/5nyyD8O4n/qR/+Z80m8T+V
+J9K/E8l/qdu/E/RDNLZO3w+if+pxP/UD/+zfuOI/6nE/1TifyrxP3Xjf8rKIHw+d/5n5oj0k/if
epF+Ev9Tif+pxP9U4n/qxv8UyyDliPST+J96wfxIL5gf6VXnR+IZpOcJ8yO9SD8v2J/XC/bn9YL9
eSX+p16wP68X7M/rVffnJTJIzxP255X4n3rB/qde5D8v8p+X0dnJfxL/Uy/ynxf5z6v6T/0E6ezk
P4n/qcT/VOJ/6sb/1M8r4bN0k34S/1Nv0s/kf24Vyk36eZN+3qSfN+nnXfVT899J+nnD7x/pTfp5
k37epJ836SfxP/Um/bxJP++qn9ozSDki/bxJP2/Szxv4yXqTfhL/U2/Sz5v08676qfmepJ837C/p
Tfp5w/6S3sAP0Rv2l5T4n3rD/pLesL+kd91f0juDlKNNP58M0vOE/SW9v/y6ry7dsL+kxP/UG/aX
9Ib9Jb3r/pLmvxP2l/SG/SW9qf95w/6SJv9zVwbYX1Lif+oN+0t6w/6S3nV/SUcGIUcP1e8P1e8P
1e/PZ3/pu0etD9XvxP9U4n8q8T9143/qm0HI0UP1O/E/9YH77/rA/Xd96v13nRmk5wn33/Wh+v2B
+++a/M/9ecL9dyX+pz7U/3yo//nU/qdKBul5wu8X60P9zwf2P/WB/U996v6nagbpecL+pxL/U4n/
qR/+Z/U2xP9U4n8q8T+V+J+68T91ZZCeJ/A/lfif+pD/JP6nEv9Tv/zP+lki/ST+pxL/U4n/qRv/
Uy2DdHaaHxH/Ux/Sz+R/blXPQ/r5kH4+pJ8P6eez6adnED6fxP9U4n/qIP1M/me96amD9HOQfg7S
z0H6OTb9jAxCjgbtLw3Sz0Hzo0Hzo0Hzo0H+c9D8aND8aNT50foEKUekn4P0c8D+p44bfMiA/U8d
5D8H7H/qgP1PHXX/c+UrYf9TB82PBs2PBux/6njBKw7Y/9RB/nNQ/T6ofh+1fl8tg5Qj6n8Oqt8H
1e/J/6x37nSQfg7Sz0H1+6D6fdT6ffUMUo6o/zmofh80fx8f/lKpUAbp5yD9HDR/HzR/H3X+vvI9
af4+qP85qP85gL+k48NfKn3Fl/TzJf18gb+kL/CX9K38pXVnEHL0Aj9EX+CH6Av8JX0/v99R6uKX
9PMl/XzJf77kP9/qP9eTQcjRS/Ojl/znS/7z/fjP750RfUk/X9LPl/znS/7zrf5zjQxSjuD+kb7k
P1+av7+f3y/+0iH0Jf18ST9fmr+/NH9/6/x9vRmkHJH/fMl/vjQ/Sv7nj+N+te4l/XxJP1+aH700
P3rr/GjNDFKOaP7+0vzopflR8j9/nEjKK+k9ST9fmh+9ND966/xoSQYpR9T/fKn/+dL86P38fvHh
31eSfr6kny/Nj16aH806P1qaQcjRpP0l4n8q8T81+Z/vOFt5Jb0n6SfxP5X4n7rxP9fKIORoAj9E
if+pk+bvyf/8caLv92iSfk7Sz0nz90nz91nn78sySDmC+5s6af4+4f6mJv/zx4mkvJLek/RzUv0+
qX6ftX5fnkHKEfBDdFL9Pql+T/7njxN9v0eT9JP4nzqpfp9Uv89av6/IIOWI9j+J/6mT9pfm9/eL
y/eI9HOSfk7aX5q0vzTr/pJ9gpQjmh9Nmh9Nmh8l//N9ouSI9HOSfk6aH02aH806P7J8Jc2PJs2P
Js2PBPjJSvxPFarfk/+59ZeE6neh+l2ofheq36XW79YyCGcX6n8S/1OJ/6nE/9SN/2k9g/BZEvj9
OCX+pxL/U7/8z/o8yX8S/1OJ/6nE/9SN/2n5nuQ/hfqfxP9UIf0U0k+p+ml3Bul5Uv9TSD+F9FM+
+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
Az5kkH4O0s9B+jlIP8emn28GKUfU/yT+5xpw/2iNCV5xkP8c5D8H3D9aA+4frSE1RzODlCPqfxL/
cw2aHw0FrRukn4P0c9D8aND8aNT5UZMMUo6o/0n8zzVofpT8z61CGaSfg/Rz0Pxo0Pxo1PlR0wxC
jl7qfxL/c700P3o/86NSRb6kny/p50vzo5fmR2+dH7WVQcgR8T8X8T/XS/Ojl/aXXtLPl/TzpfnR
S/Ojt86PmmWQckT9T+J/rpfmR8n/3P7CvqSfL+nnS/Ojl+ZHb50fNc8g5Yj6n8T/XC/Nj5L/uTnA
l/TzJf18aX700vzorfOjFhmkHMHvHy3ify7ify7if67K/+z9E6TnSf6T+J+L+J/rw//cnifNj4j/
uYj/uYj/uSr/s/fPK+l5Oj1P6n++1P98qf/51v5nbxmk5wn8uvWS/5zU/0z+5/Y8if+5iP+5JvU/
J/U/Z+1/9p5BeJ4Tfr94TfKfk/Rzkn5O0s8J/Pk1ST8n6eck/Zykn7PqZ8/3JP2cpJ+T9HOSfs7v
/L1kk/Rzkn5O0s9J+jmrfvY7g/D5nKSfk/Rzkn4m/3P7qz1JPyfp5yT9nKSfs+pnfzJIOaL6fZJ+
Tpq/T5q/T/Kfk/znpPn7pPn7rPP3PjJIOSL9nKSfk+bvk/Y/J/nPSf5z0vx90vx91vl7fzNIOaL5
+6T5+6T5+/zM34ufF/KfxP9cQvN3ofm71Pl7nxmEHAnN34Xm70Lzd/nM30vNJaSfxP9cxP9cxP9c
lf/Zu2QQciQ0fyf+5yL+50r+51YXE/9zEf9zEf9zEf9zVf5n75pByhHN34n/uYTm78n/3NRbSD+F
9FNo/i40f5c6f+8rg5Qj6n8S/3MJ9T8F+PNLSD+F9FPIfwr5T9n8p2WQckTzd+J/LiH/KcCfX0L6
KaSfQv5TyH/K5j89g5Qjmr8T/3MJ8OeXfPjzZQIupJ9C+inAn18C/PmlR81RZBBypPD7xYv4n4v4
n4v4n6vyP/v1CcLzVPKfxP9cxP9cH/5nddTE/1zE/1zE/1zE/1yV/9mvfCXN33f+5ydIz5P0U0k/
lfyn3vBZUvKfSv5TyX8q+U+t/vNqGaSzk34q6aeS/9QXvu9K/lPJfyr5TyX/qdV/Xj2D9Pkk/VTS
TyX/qXT/SMl/KvlPJf+p5D+1+s8r35P8p5J+Kumnkv9U2v9U8p9K/lPJfyr5T63+87ozSDki/VTS
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
tI3/OSyDlCPyn8T/NOJ/2vX5/aPyF5b4n0b8TyP+pxH/0zb+5/AMUo7IfxL/04j/aV/+Z+mDEf/T
iP9pxP804n/axv8ckUHKEdXvxP804n/ah/9ZXTrxP434n0b8TyP+p238z28QcnTT/Ij4n3YDf8lu
4C/ZXflLb74S+Et2b/tLnyCdHfhLlvzPbdpC/E8j/qfdND+6aX501/nR2zJIz5PmRzfNj27Sz5v0
8yb/eX/n71JeSe9J/vMm/3mT/7yr/3x7BunspJ836edN/vP+zo9KNsl/3uQ/b/KfN/nPu/rPN9+T
/OdN+nmTft7kP++P/yx/ZW7ynzf5z5v8503+867+870zSDki/bxJP2/ynzfsz9tN/vMm/3mT/7zJ
fz7Vf75PBiFHD+nnQ/r5kP9M/uf2PXrIfz7kPx/ynw/5z6f6z3dkEHL0kP98yH8+5D8f8p8P+c+H
/OdD/vMh//lU//m+GaQckf98yH8+5D+T/7nVCA/p50P6+ZD/fMh/PtV/vjODlCPynw/5z4f85/OC
1hH/04j/aQ/5z4f851P95ysZpByR/3zIfz7kP5/v72+WE5F+Ev/THvKfD/nPp/rPVzNIOSL/SfxP
e8h/Pl//+dW6h/TzIf18yH8+5D+f6j/flUHKEflP4n/aIP854PffbZB+DtLPQf5zkP8cm/+0DEKO
iP9pxP+0QfOj5H9uPatB+jlIPwfNjwbNj0adH72eQcgR8T+N+J82aH40PvOj0lccpJ+D9HPQ/GjQ
/GjU+dEbGaQc0fyI+J82aH6U/M+t6hmkn4P0c9D8aND8aNT50fwEKUfb/OgTpOdJ/nOQ/xywP28D
9ueN+J9G/E8bsD9vA/bnbdT9+ZmvhP15G+Q/B/nPAfvzNoC/ZMT/NOJ/2oD9eRuwP2+j7s/PlkH6
fJL/HOQ/B82Pxuf+e1HFl+ZHxP+0l+ZHL82P3jo/mj2DkKOX/OdL/vOl+dEL99+N+J9G/E97aX70
0vzorfOjme9J86OX/OdL/vOl+dF7wfeI+J9G/E97aX700vzorfOjeWeQckT+8yX/+VL9/sL9dyP+
pxH/016q31+q399av88ng5Qj8p8v+c+X6veX6veX9JP4n0b8TyP+p238zzkySDki/0n8TyP+p71w
/92I/2nE/zTifxrxP23jf843g5Qj8p/E/7SX6vfkf26V1Ev6+ZJ+vlS/v1S/z1q/z5lByBHxP434
nzapfk/+59YDnKSfk/RzUv0+qX6ftX6fkkHI0dz85ycIz5P4n0b8T5vU/5wXeMVJ/nOS/5zU/5zU
/5y1/zk1g3R2uL9pxP+0SfvzE/jzNsl/TvKfk/bnJ+3Pz7o/P1cG6fMJ9zeN+J82gT9vE/jzNml/
aZL/nMCftwn8eZuVPz8tg5Qj8p/E/7QJ999tAn/eJu0vTdpfmnD/3Sbcf7dZ779PzyDliPwn8T9t
wv13m8Cftwn3323S/tKE++824f67zXr/fUYGIUfE/zTif5rA/XeTD39e7u8r4f67Cdx/N4H77yZw
/92k3n+XTxBytPM/P0F4nsT/NOJ/2sb/lM8r6XleoMnE/zTif5pc9DzJfxL/04j/acT/tI3/KS2D
9Dzh99+N+J8mpJ9C+ilUvwvtfwrV70L1u1D9LlS/S63fpWeQzk76KaSfQvuf8vn9uKJgQv1Pof6n
0P6n0P6n1P1Pyfek/U8h/RTST6H9T/n8/lH5KyPU/xTqfwrtfwrtf0rd/5Q7g5Qj0k8h/RT4/SOT
z+/HFScg1P8U6n8q/P6RKfz+kWn9/SN5Mgg5UtJPJf1U+P0jS/7n9j1S6n8S/9OU5u9K83et83cZ
GYQcKflPJf+p5D+V/KeS/yT+pyn5TyX/qdV/yptByhH5T+J/mpL/TP7nVh8p6aeSfir5TyX/qdV/
yswg5Yj8J/E/Tcl/Jv9zq2GV9FNJP5X8p5L/1Oo/RTJIOSL/SfxPU/KfSv5TST+V9FPJfyr5T63+
UzSDlCPyn8T/NCX/mfzPrXOipJ9K+qnkP5X8p1b/KSuDkCPifxrxP22R/1zkPxfp5yL9XOQ/F/nP
tflPyyDkaJH/JP6nLZofLarfF83f1+f+ZlFF4n8a8T9t0fx90fx91fm7eAbp7DQ/WjQ/WjR/T/7n
9peL+J9G/E9bNH9fNH9fdf4ukUH6fJL/XOQ/F83fk/+56TzxP434n7Zo/r5o/r7q/F0/QcoR+c9F
/nPR/H0p+CXifxrxP23R/H3R/H3V+bt+Xkk5Iv+5yH8umr+vz/y9eFrifxrxP23R/H3R/H3V+bu2
DFKOyH8u8p9G8/fkf25/i4n/acT/NKP5u9H83er8XXsGIUdG/tPIfxrN3434IcT/NOJ/mtH83Wj+
bnX+rvmeNH834ocY+U+j+t2ofjfg15kBv86M/KeR/zTg15kBv86s8uv0ziCdneZHRvMjA36d2Ydf
V75xRv7TyH8a8OvMgF9nVvl1+mSQPp80PzKaHxnN3+0zfy+qSPxPI/6nGc3fjebvVufvOjJIOaL5
kdH8yGj+bp/5e/nLRfxPI/6nGc3fjebvVufv+maQckTzI6P5kdH83ej+JvE/jfif5jR/d5q/e52/
68wg5MhpfuQ0P3Kavzvd3yT+pxH/05z6n079T6/9T5UMQo6c/KeT/3TqfzrN34n/acT/NKf+p1P/
02v/UzWDlCPyn07+02n+7vD7R0b8TyP+pznN353m717n77oySDki/+nkP53m7z7BLxH/04j/aU7z
d6f5u9f5u1oGKUfkP538p9P8Pfmf2+YY8T+N+J/mNH93mr97nb+rZ5ByBL+/aU7+06l+d6rfnfqf
Dr//bk7+08l/BvU/g/qfUfufGhmEswfV70H1e1D/M6j/GeQ/g/xnUP8zqP8Ztf+5PkH4fAb1P4P6
n0H9z+R/bn+Lg/qfQf4zqP8Z1P+M2v9cn1dSjsh/BvnPoP5nPKDzQf3PoP5nUP8zqP8Ztf+5WgYp
R+Q/g/xnUP8zPvP34gCD+p9B/c+g/mdQ/zNq/3P1DFKOyH8G+c+g/mdQ/zOo/xnU/wzqfwb1P6P2
P1e+J/U/g/xnkP8M6n/Gt/9ZPnWkn0H6GdT/DOp/Ru1/rjuDv+fo54P97X/9R/D35+kH9D/9+PQ/
j/l9JeinH6CffkD/0w/of/pR+5/ryeDvOfID+p9+gP/0A/ynH+A//aj+c40M0vOE+bsf4D/9AP/p
yf+sfQY/wH/6Af7TD/CffoD/9KP6z/VmkJ4nzN/9AP/pxP904n/6AfN3T/5n/Xb8KHroPaH/6QfM
3/2A+bsfdf6+Zgbp7KCffoB++gHzdz9g/u4H9D/9gP6nHzB/9wPm737U+fuSDNLnE/TTD9BPP2D+
7sdn/v79K+MH9D/9gP6nHzB/9wPm737U+fvSDFKOQD/9AP30A/ynH5/5+1E+deA//QD/6Sf4Tz/B
f/pZ/edaGYQcnaSfJ+nnCf7Tk/9Z3Zqf4D/9BP/pJ/hPP8F/+rn5T8sg5OgE/+kn+E8/wX/6ef3+
d9NP8J9+gv/0E/ynn+A//dz8p2eQcgT+00/wn36C//Tkf9YawU/Sz5P08wT/6Sf4Tz83/xkZpByB
//QT/Kef4D/9nKB1J+nnSfp5gv/0E/ynn9V/2idIOQL/6Sf4Tz/Bf3ryP2tl6ifp50n6eYL/9BP8
p5/Vf1q+Evynn+A//QT/6Sf4Tz8//vPbOfGT9PMk/TzBf/oJ/tPP6j+tZRBy1Mh/NvKfjfxn8j+3
v0eN9LORfjbyn438Z6v+03oGIUcN+p/eyH82+P0jb5/fP/r267yRfjbSzwa/f+QNfv/IW/39I8v3
hN8/8kb+s5H/bDA/8vb5/eLyF7aRfjbSzwbzI28wP/JW50d2Z5ByBP1Pb9D/9AbzI2/f3y8unzrS
z0b62WB+5A3mR97q/MieDFKOoP/pDfqf3mB+5Mn/3DxDI/1spJ8N5kfeYH7krc6PbGSQcgT9T2/Q
//QG8yNv398vbuWV9J6knw3mR95gfuStzo/szSDlCOZHTvxPJ/6nN/j9Yif+pxP/04n/6cT/9I3/
aTODkCPifzrxP534n/7hf9buAfE/nfifTvxPJ/6nb/xPkwxCjjrV78T/9E7+s5P/7HD/3ZP/uVX6
HfaXvMP+kne4/+4d7r97r/ffTTNIZx90dvKfxP904n96J/3s39+PK59k0s9O+tlJPzvpZ9/0c2WQ
zk76SfxP76Sf/Tt//6pNJ/3spJ+d9LOTfvZNPy2D9N0k/ST+p3fSzw7zd++kn530s5N+dtLPvumn
Z5ByRPpJ/E/vpJ/9o5/lr/ZF+nmRfl6knxfp57XpZ2QQckT8Tyf+p1+kn9fn/ntxVhfp50X6eZF+
XqSfV9VP/wQhR8T/dOJ/+kX9zwv4yX6R/7zIf17U/7yo/3nV/qfnK6n/SfxPJ/6nXzB/9wv4dX6R
fl6knxfM3/2C+btfdf7uLYOUI5i/O/E//YL5u1/f++/le0T6eZF+XjB/9wvm737V+bv3DFKOYP7u
xP/0C+bvfgG/zi/Sz4v084L5u18wf/erzt893xPm7078Tyf+p19w/90vh79HF+nnRfp5wf13v+D+
u9/1/rvfGYQcEf/Tif/pN9x/9/vDTy7dmJv08yb9vOH+u99w/93vev/dnwxCjm7Y//Qb9j/9hv15
v+H33/0m/bxJP2/Yn/cb9uf9rvvzPjJIOSL/eZP/vGF/3u8vP9nLK+k9ST9v2J/3G/bn/a778/5m
kHJE86Ob5kc37M978j+3Pi3xP534n37D/rzfsD/vd92f95lByhHNj26aH92wP+/35/ePSs1F/E8n
/qffsD/vN+zP+133510ySDna5kefID1Pmh/dND+66/zINYP0POH3O/ym/udN86Pkf2513E3zo5vm
Rw/Njx6aHz11fuQrg/A8nxOe50P9z4f6nw/1P5/a/3TLIDzPh+bvD/nPh/qfyf/cnudD/c+H+p8P
9T8f6n8+tf/pnkF6njc9T/KfD/nPh/zns/nPyCA9T5q/E//TH/Kfyf/cnyf5z4f850P+8yH/+VT/
GZ8gPc9Jz5P086H50UPzo4fm78n/3M9O+kn8T39o/v7Q/P2p8/f4vJLOvujsND96aH700PzoqfOj
aBmkz5LRZ4nq94fmR8n/3J8nzY8e0s+H5kcPzY+eOj+KnkF4nuOA5zmofh9Uvw+q30et3+PKIDzP
ccLzHOQ/B9Xvyf/cnueg+n2Qfg6q3wfV76PW73FnkJ4n9T8H+c9B/nOQ/xzVf8aTQXqeNz1P8p+D
/GfyP/fnSf5zkH4O8p+D/Oeo/jNGBul5vvQ8yX8S/9OJ/+kb/zPeDNLzBP6nE//TB+nnIP0cpJ+D
9HOQfg7Sz7Hp58wgPU/Sz0H6OUg/B+nn2PRTMkjPk/ST+J8+SD8H6ecg/Rykn4P0c5B+jk0/NYPw
PF/ST+J/OvE/nfifvvE/Y2UQnudL+kn8Tyf+p7+kn8T/dOJ/OvE/nfifvvE/wzJIz5P0k/if/pJ+
vqSf76afnkF6nqSfL+nnS/r5kn4S/9OJ/+kv6edL+vlu+hkZpOdJ+vmSfr6kny/p51v08/r856Sf
L+nnS/r5kn6+pJ8v6edL+vmSfr6kn2/Rz+v7SnqepJ8v6edL+vmSfr5Wn2fLID1P0s+X9PMl/XxJ
P1/Sz5f08yX9fEk/36jPs2cQnuck/Zyknzv/s2UQ/p3E//QJv//uxP904n868T+d+J9e+Z/X5z2p
/0n8Tyf+p+/8zzw71e/E//TC//TySjo7zd+J/+nE//TK/7yOO4N09m1/KU9E+0vE//T54S+Vbjbx
P534n078Tyf+p1f+53U8GYTv5s7/zBPR/J34n078Tyf+pxP/04n/6cT/9Mr/vI6RQcrRNn/Ps9P8
nfif/uV/ljkX8T+d+J9O/E8n/qfPTT/fDFKOjHJE+kn8T59w/8iJ/+nE/3TifzrxP31u+jkzCDna
+Z8tg/A8if/p8t3//CoD8T+d+J9O/E8n/qdX/ud1SAYhR8T/dOJ/OvE/nfifXvmf16EZpOd50fMk
/0n8TxeavxP/04n/6cT/dOJ/euV/XsfKID1P6n8S/9OF/KeQ/5RRn6dlkJ4n+U/if7rQ/Cj5n5tj
EZofCfU/heZHQvMjkfo8PYP0PIWeJ/lPof0lIf0U0k9R+iyRfhL/04X0U0g/ZdPPyCCdnfaXhPRT
SD+T//nqGeWV9J6kn0L6KaSfUvXz/ATh86m0v6Skn0r6qV/9/P5FIP6nE//TlfRTST+16ueZryT9
VKrflfRTaX6k3/35p7yS3pP8p9L8SGl+pFfNUcsg5Yj0U0k/lfbn9bM/X5wV8T+d+J+utD+vtD+v
o+aoZ5ByRPMjpfmR0v5n8j+3Wob4n078T1fa/1Ta/9RZc5TvSfufSvtLSvtLSvufSvufxP904n+6
0v6n0v6nrpqjO4OUI9pfUtpfUtr/VPj9Iyf+pxP/05X2P5X2P9Vrjp4MUo5of0lpf0lp/1M//KWy
b0P8Tyf+py/qfy7qf66z5mhkEHK0qH5fVL8v6n+u7/6nl1fSe5J+LvKfi/znqv7zfDMIOSL+pxP/
0xf5zwX8JV+kn4v0c5H/XOQ/V/Wf58wg5Yj6n8T/9EXz9/X9/aOnvJLek/Rz0fx90fx9vTVHkkHK
EflP4n/6ov3P5H++Os/vK0k/F+nnov3PRfufS2uONIOUI9pfIv6nL9r/TP7njxPd5ZX0nqSfi/Y/
F+1/Lqs5WhmkHNH+J/E/fdH+Z/I/f5zou+W1SD8X6eei/c9F+5921BxZBiFHxP904n+6Uf8z+Z8/
TmTllfSepJ9G/U+j/qfV/ufpGYQcEf/Tif/pRvufyf98Vb7fIyP9NNJPo/mR0fzI7pqjyCDliPY/
jeZHRvOj5H/+ONFdXknvSfppVL8b1e9W6/f2CVKOaP/TqH43qt+T//njRN/vkZF+GumnUf1uVL9b
rd9bvpLqd6P5kVH9brT/mfzPHycq3yPSTyP9NNr/NNr/tFVz1DJIOSJ+iNH+pwE/2ZP/+R72dUFG
+mmknwb8ZDfgJ7tFzVHPIOVo2//8BOF5Os2PiP/pTvV78j+3/pJT/e5UvzvV7071u9f6veV7Uv3u
1P8k/qcT/9OJ/+mV/3m1O4PwWXKavxP/04n/6U78JeJ/OvE/nfifTvxPr/zPqz0ZpOdJ/U/if7rT
/MhpfuTEX0r+53520k8n/XSavzvN373O39vIIJ2d5u9O86Od//kJ0r+T6vfkf24a4lS/O9XvTvW7
U/3utX5vbwbp7IvOTv6T+J9O/E+v/M+rzQzS9wj4n078T3fyn8n/3D9L5D+d/KeT/3Tyn1H9Z5MM
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
k/8k/mcM2l8a1P8ctL+U/M/97DQ/Iv5nDNpfGrS/NOr+0vMJ0tmVzk77S0Phb9yg+n3A/c1I/ud+
dri/GYP0c8D+fAzYn49R9+efzyvp7LA/H4Pq953/mXkn/zlofjSCtI7mR4P086X50Uvzo7fOj56W
QTj7C/z5eKl+3/mfTwbp3wn33+OF++9B/M8g/mcQ/zOI/xmV/3k9PYN0dtifD+J/xnvR2cl/vjR/
T/7nfnaavxP/M16av780f3/r/P3J96T5+wu/HxcvzY/eQWcn//nS/tL70tlpf+kl/Xxpf+ml/aW3
7i89dwbp7LS/9NL86KX50Uvzo7fOj558SjQ/ehU05CX9fEk/30XPk/TzJf18ST9f0s9308+RQXqe
pJ8v6efO/8ynRPr5kn6+pJ8v6edL+jlJPyfp59z0880gnH2Sfk7Sz53/2TJI/07Sz0n6OUk/J+nn
JP2cpJ9z08+ZQTo76eck/ZzU/5zU/5y1//lIBuF7NKn/OUk/J/nPSf5zkv+c5D8n+c9J/nNW//lo
Bul50vxokv+cND9K/ud+IpofTarfJ82PJs2PZp0fPSuDlCOaH02q3yfNj6ZSjmh+NEk/J82PJs2P
Zp0fPZZByhH8/lFMmh9Nmr9Pmr/POn9/PIP0PMl/Ev8zJuln8j/350n6OUk/hfRTSD9l08/IIDxP
If0k/mcI6aeQfgrpZ/I/twmOkH4S/zOI/xnE/4yN/zk+QTo76SfxP0PIfwr5TyH/KTednfynkH4K
+U8h/ynVf47PK+ns5D+F/KfQ/pLQ/pLU/aWRnxDaXxKq34X8p1D9LlS/C9XvQvW7UP0uVL9Lrd9H
zyA9T7p/RPzPIP5nfPmfxV0Q/zOI/xnE/wzif8bG/xz5njQ/EpofEf8ziP8ZxP8M4n8G8T+D+J9B
/M/Y+J/jziDkSGl+RPzPUJofKfU/leZHesLZleZHSvqpND9Smh9pnR+NJ4N0dpofKc2PFPjzQfzP
UJofKc2PlOZHSvqpND9Smh9pnR+NkUE6O82PiP8ZSvMjJf+pND9Smh8R/zOI/xlK8yOl+ZHW+dF4
M0hnp/mRkv9Umh8p6afS/EhpfqQ0P1Lyn0rzI6X5kdb50ZgZpLPT/EhJP5X0U0k/ddNPySDop5J+
Ev8zlPRTaf6upJ9K+qmkn0r6qZt+agbheS7ST+J/xiL9XKSfi/Rz0fyd+J9B/M9YpJ+L9HNt+rky
SGcn/Vykn4v0c5F+LtLPRfq5SD8X6eci/Vykn2vTT8sgnZ30c5F+LtJP4n8G8T9jkX4S/zOI/xnE
/wzif8bG/xyeQTo76SfxP2PR/tIi/Vykn4v0c5F+LtLPRfq5SD/Xpp+RQTo76eci/dz5n3l26n8u
mr8vmr8vmr8v0s9F8/dF8/dV5+/fIJ2d5u/E/4wVdHaq343m70bzd+J/BvE/w2j+bjR/tzp/fz+v
hLMbzd+N5u9G94+M7h9ZvX/0tgzC300j/TTSTyP9NNJPI/000k8j/TTST6v6+fYM0vMk/TTSTyP9
JP5nGOmnkX4a6aeRfhrpp5F+WtXPN9+T9NNIP4n/GUb6aaSfRvpppJ/E/wzif4aRfhrpp1X9fO8M
0tlJP43000g/jfTTSD+N9NNIP43000g/jfTTNv3Mfyfpp5F+GumnkX4S/zOc9NNJP53000k/nfTT
ST9908+RQTi7k3466efO/3wySP9O2l/yTmen/SUn/XTaX3LaX/K6v/S+GaSz0/4S8T/DaX7k1P90
mh857c87zY+I/xlO8yOn+ZHX+dE7M0hnp/0l4n+GU//Tqf/p1P/0SWen/ifxP8Op/+nU//Ta/3wl
g3R26n8S/zOc+p9O/U+n/qeTfjrV7071u9f6/dUMgg9x4i856efO/8xPMs3fif8Z/uUvfacDxP8M
4n8G8T+D+J+x8T/flUE4O/E/g/ifEaSfQfoZm35aBuGzFMSvI/5nBPFDosHzDOKHBNXvQfyQIH5I
VH7I6xmk50n8uiD/GeQ/g/xnbP4zMkjPk/h1Qf4z6P57PPQ86f570PwoaH4UND+KOj+anyA9T7r/
HqSfO//zySD9O+n+e0w6O91/D9pfCtpfCtpfirq/NPOVtL8UdP+d+J8Ri85O+hl0/z0WnZ3uvxP/
M4Lm70Hz96jz95mfT5q/B91/D+p/BvU/g/qfUfufs2dw/x79y3/+b/7H/3H8n3/6X/7442//+Z/+
/k9/rPyf++OPv/z5b//0x3H9+J/8+fvcf/zxH/76z3/9m3/8EXrm+Bn+Gfp3//g3//S/7qG//Kd/
+vnf3TOOu/2M/Mf87642f73Vf8z/roR+/XfX0Y+fv8j9L/9F/uv33/ZPf/3zn/6wn4e+/ue/7a9/
/oe/+/d/+tfjnb9C//C//wr8+vf/yz//Zfv//+bv/u7PW+Av/9uff5z4aF3W/wz89R/+8d//89//
fXnR3/7f//1//F//ff9n/Pwn/NCb8f2f+PlrUUf/8f//u7/5y7/+G/Q6v4/3/H99vOf2eO/3+beP
t4Ty8V6/Pd7e8q0+j7eEfv13vb0//q/l4z3r453/vz3e+s84/7883n+99/3/AAURom+E4AsA

--MP_/7P+D6MDvabUSe5j7xKYK4Ba
Content-Type: application/x-gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=dri_hung_1.gz

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
sWT1cy2gl0Ys0fp7If0snVjqxNIglqx+titILA3qI9LPMomlSSxNYGm3+tnSCgJLO62/76Sfu4Cl
XcDSLmBpt/rZznxpJ//8TuvvO+nn7ixLq7gHL8dO8/ed3n/utH600/r7/tRPP+oVBC/H/sw/n16O
nebvO73/3J/6+fRu7U/9fDoG90s/jWNwT9YXtJqUTh+g9QXtCXxBe7Y+wCsIvqA9W29hW0Fb5wqe
6+8vDqKd8s995Z/WMbjT+8+d5u87zd93q5/rxctO8/ed8s+d5u87zd/32gAG6/+8YCD93Ek/96MB
DM/5+9PItz/182ns2Wn+vtP8fbf6ed0lmr/vlH/uNH/faf6+j8WnHbC0/r6Tfu6knzvln/tz/u7H
dZcm9FHdoI8qrb9X0s+6mT5ad74+88+nka9e83dj5KuX/9MY+eqpny8Dtj7083XA1lM/XwZsfejn
64Ctp3/pZRhWmr/XpZ/WyFdJPyu9/6z0/rPa/LOvq9P7z0rz90r6WSOwVGn9vZJ/qVL+WSn/rMmw
dHVcIpYysUTr75X8SzUTS8XUebFUYLxXyj8r5Z/V5p99NZ7yz0r5Z6X8s1L+WSn/rJR/Vpt/9gUt
5Z+V9LOSflbKPyvln5Xyz2rzz36sIDw7KuWflfLPSvlnpfyzUv5Zbf7ZxwrSOCL9rKSflfLPSvln
pfzzsPnn0AoCSwfp50H550H550H550H552Hzz7HOpPzzoPzzoPzzcMDS4YGlwwNLh9XPkVcQWDoo
/zxo/n4EYOkIwNIRgaXD5p+jriCwdJB+HqSfRwKWjgQsHYlYsvP30VeQWCL9PGj+fhRiqRBLhViy
+jlXnTuxRP7Pg/Tz2ImlSixVYsnq57yCxBL5Pw/Sz+Mglg5iqRFLVj9nWkFiifyfB+nn0YmlTix1
Ysnq59xXkFii/PMg/TwmsUT++YP884fVz3nOjxr55xvln430s5F/vpF/vpF/vln9nHMFgaVG/s9G
+tnIP9/IP9/IP9+Mfmplqo38843m7430s5F/vpF/vpF/vhn91Er2GvnnG+WfjfSzkX++kX++kX++
Gf3USvIb+ecb5Z+N9LORf76Rf76Rf74Z/dR2rCCxRP7PRvrZyD/fyD/fyD/fqmVprCCxRP7PRvrZ
yD/fyD/fyD/fjH5K6+rkn2/k/2ykn43884388438883op9a3lo388438n430s5F/vpF/vpF/vhn9
lPIKAkud/J+d9LOTf76Tf76Tf74b/ZTqCgJLnfyfnfSzk3++k3++k3++e8tSX0FgqdP8vZN+dvLP
d/LPd/LPd6OfWlPgTv75Tu8/O+lnJ/98J/98J/98N/opdwWJJfJ/dtLPTv75Tv75Tv75bvRTLq0g
sUTvPzvpZyf/fCf/fCf/fDf6KbevILFE/s9O+tnJP9/JP9/JP98Py9KZL3Xyz3fyf3bSz07++U7+
+U7++d4tS3MFiSXyf3bSz07++U7++U7++W70U96tILFE/s9B+jnIPz/IPz/IPz+MfsrHFQSWBvk/
B+nnIP/8IP/8IP/8MPopf+ZLg/zzg9aPBunnIP/8IP/8IP/8MPopf6wgsDTo/ecg/Rzknx/knx/k
nx/JsjRWEFga5P8cpJ+D/POD/POD/PPD6KfCujr55wf5Pwfp5yD//CD//CD//DD6qbDOJP/8oPWj
Qfo5yD8/yD8/yD8/jH4q5BUklsj/OUg/B/nnB/nnB/nnh9FPhbqCxBKtHw3Sz0H++UH++UH++TEt
S30FiSXyfw7Sz0n++Un++Un++Wn0U3HVSf75Sf7PSfo5yT8/yT8/yT8/jX4qXkFgadL60ST9nOSf
n7R+NGn9aBr9VEwrCCxNWj+apJ+T/POT/POT/PPT6KfivoLA0iT/5yT9nOSfn+Sfn+Sfn9mydOZL
k/zzk9bfJ+nnJP/8pPX3Sevvc7cszRUklmj9fZJ+Tlp/n+Sfn+Sfn0Y/ldwKEkvk/5ykn5P885PW
3yetv0+jn0pxBYklWn+fpJ+T1t8n+ecn+een0U+lM1+a5J+ftP4+ST8n+Ofve7J+3KRb8FOWtBn9
VDpW8FOWtIH/Uxvopzbwz2sD/7w28M/L7v+pNFbwU5ZE+3+K9v/UBv55beCfvwU/ZUmb0U/ldXXw
z4v2/xTt/6kN/PPawD+vDfzz2ox+Kq8zwT+vDdbftYF+agP/vDbwz2sD/7w2o5/KeQWJJfB/agP9
1Ab+eW3gn9cG/nltRj+V6woSS7D+Ltr/Uxv450X7f4r2/5Td/1O5ryCxBOvvov0/9br/5yrePvVy
aIP5uzZ4/6kN1o9E+3/K7P/ph7uCn3o5tD3zz8vLoQ3m79rg/ac2u/9SWsGnfl5GPj33/3wa+XTu
//li5NO5/+eLkU/n/p8vviCd+3++GPl07v/54gvSuf/ni5FP5/6fL0Y+nft/vjiIJMg/tfb/tEY+
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
gj2Vzu+Vzu/Vn9/f3xKd3xv5z0bn90bn9yf/8/eGbTR/b6SfjfSzkf90+Z9h1bcIn1ETfEaN5u+N
9NPlf37hK5f/+QX5vvmfDuRrL//pQL6b//lzwz75n7837M3//Llhn/zP3xv2yf/8vQ0bnd/f/M//
QL7+uMpG+tno+Wej55/N+U+F5yDW6Plno/N7I/188j//6SWav1P+pzXyn5T/aa25Xno/uEa91KiX
aP5O+Z/WOvVSd6/59lKH+72R/2zkP33+p8K6RbrfyX828p+N/Gcj/9nIf/r8z+//O/lPyv+0RvrZ
yH828p+N/KfP/1R8i/Dd0ch/NvKfnfxnJ//ZyX927z/jcwjt5D876Wcn/ezkPzv5z07+s3v/Gdst
Qi9R/qd18p+d/Cflfxrlf5rP/1Sctwi9RPmfRvmf1mF/0zrsb1qH/U3z+Z+K5xahlzr5z07n9w77
m9Zhf9M67G+ay//8KD3fCB32N62TfnbSzw77m9Zhf9M67G+az/9USrdIvUT62en83mF/0zrsb1qH
/U3z+Z9K9Rapl4j/7KSfHfY3rcP+pnXY3zSf/6k0bpF6ifjPTvrZYX/TOuxvWof9TfP5n0rPIbTD
/qZ14j876Wen/c1B+5uD9jd9/qey3SL00iD/OUg/B+1vDuLnB/HzPv9T+b0SemmQ/xykn4P4+UH8
/CB+3ud/KpdbhF4axH8O0s9B/Pwgfn4QP+/zP5UfrziInx90fh+kn4P4+UH8/CB+3ud/Kq9bpF4i
/zlIPwfx84P4+UH8vM//VLmvSfz8IP85SD8H8fOD+PlB/LzP/1R5i9RLxH8O0s9B/Pwgfn4QP+/z
P1UevzSInx/Efw7Sz0H8/CB+fhA/7/M/VdotUi8R/zlIPwfx84P4+Un8/Pz4Xpq3CL00if+cpJ+T
+PlJ/Pwkft7nf6qcW4RemsR/TtLPSfz8JH5+Ej/v8z9VH780iZ+fxH9O0s9J/Pwkfn4SP+/zP1XT
LUIvTTq/T9LPSfz8JH5+Ej/v8z9V6y1SL9Hzz0n6OYmfn8TPT+Lnff6n6rhF6iXiPyfp5yR+fhI/
P4mf9/mfqo9fmsTPT3r+OUk/J/Hzk/j5Sfy8z/9Uu+9O/Pwk/nOSfk7i5yfx85P4eZ//qfZeSb1E
/Ock/ZzEz0/i5yfx8z7/U63cIvTSIv5zkX4u4ucX8fOL+Hmf/6n2+KVF/Pwi/nORfi7i5xfx84v4
eZ//qbZuEXppEf+5SD8X8fOL+PlF/LzP/9Sd4Czi5xfNjxbp5yJ+fhE/v4if9/mf6m+Reomefy7S
z0X8/CJ+fhE/7/M/1R+/tIifX8R/LtLPRfz8In5+ET/v8z91H0cv4ucX8Z+L9HMRP7+In1/Ez/v8
T/V5i9RLND9apJ+L+PlF/Pwift7nf6qfW6ReIv5zkX4u4ucX8fOL+Hmf/6nx+KVN/Pym+dEm/dzE
z2/i5zfx8z7/UyPdIvTSJv5zk35u4uc38fOb+Hmf/6lRbxF6aRP/uUk/N/Hzm/j5Tfy8z//UTXLY
xM9vmh9t0s9N/Pym+dGm+ZHP/9R4/NKm+dGm+dEm/dzEz2/i5zfx8z7/U/O+O/Hzm/jPTfq5iZ/f
xM9v4ud9/qfmeyX1Es3fN+nnJn5+0/x90/zd539qllukXqL5+yb93DR/38TPb+Lnff6n5uOXNvHz
m/jPTfq5iZ/fNH/fNH/3+Z+a6xahlw7N3w/p56H5+yF+/hA/7/M/te5rEj9/aP5+SD8P8fOH+PlD
/LzP/9R6i9BLh/jPQ/p5iJ8/xM8f4ud9/qfW45cO8fOH+M9D+nmInz/Ezx/i533+p1a7Reol4j8P
6echfv4QP3+In/f5n1rzFqmXaP5+SD8P8fOH+PlD/LzP/9Q6t0i9RPznIf08xM8f4ucP8fM+/1P7
8UuH+PlD8/dD+nmInz/Ezx/i533+p3a6Reolmr8f0s/zw8+//xxYjkPnd8r/NMr/tAPz9//e9BbD
0lv8f5ZDLv/zZTn0gfO7KP9TH5+/lN/ilwuq3ysdF1RvUZ4Luj/SX/38Afn0+fn7m/EW/zJ7ngvS
k//5wwXpyf/8Afn05H/+gHx68j9/CCJ9wH/q5n96kE+U/6kPnN/1gfO7Pn7//UkJ0AfO7/qA/9QH
zu/6wPldT/7nP83w1U/XDKCf+oB+yuV/umb4nt9fkE8u//MFe/SB87s+cH7Xx++/v78lOL/rA/5T
Hzi/6wPndz35nz83rD4wf9cH9FMf0E99wH/K5X+G9S3SZzToM4L5uz6gn3L5ny98JZf/+YJ8+uZ/
fkE+fV7+8wvy6eZ//t6wf/Xznxv20c/fG/avfv5zwz780u9tCOd3vfmf9kcPdO9i0E994PmnPvD8
U+aff+59i///vSmD87uM9PPJ//ztJYP5uyj/Uwb+U5T/Kfue38OcbxF6yeV/fnvJYP4uyv+Uy//8
9pIF95q3lyzC/W7gP2XgP+XzP3Xubx78pwz8pwz8pwz8pwz8pwz8p3z+p8575f97BlH+p4z008B/
ysB/ysB/yud/6pRbhO8OA/8pA/8pA/8pA/8pA/8p8/7z9Fuk+4j000g/DfynDPynDPynzPvPs54i
+E9R/qcM/KcM/Kco/1OU/ymf/xne1wT/Kcr/FOV/ymB/Uwb7mzLY35TP/wzfIvUS+U/B+V2C/U0J
9jcl2N+Uy//88yPlW4ReEumnSD8F+5sS7G9KsL8pn/8ZPu0pwv6mRPopOL9LsL8pwf6mBPub8vmf
4Xpawf6mBPynRPop2N+UYH9Tgv1N+fzP8Dm3CL0k4D8l0k/B/qYE+5sS7G/K538G0y1SLwH/KZF+
CvY3JdjflGB/Uz7/M9jzBS3Y35TIf4r0U7C/KQE/LwE/L5//GazeIvUS+U+Rfgr4eQn4eQn4efn8
z2DjFqmXgP+USD8F/LwE/LwE/Lx8/mewfYvUS3B+l0g/A/DzCsDPKwA/L5//GfS8ewB+XoH8ZyD9
DMDPKwA/rwD8vHz+558LbhF6KZD/DKSfAfh5BeDnFYCfl8//DCq3CL0UgP9UIP0MwM8rAD+vAPy8
fP5nUL9F6KUA/KcC6WcAfl4B+HkF4Ofl8z+DHr8UgJ9XAP5TgfQzAD+vAPy8AvDz8vmff7rlFqmX
gP9UIP0MwM8rAD+vAPy8fP5nCG+Regn4zz/f+fRzAj+vAPy8AvDz8vmfIeRbpF4C/lOB9DMAP68A
/LwC8PPy+Z8hPH4pAD+vQOf3QPoZgJ9XBH5eEfh5+fzPP9Jxi9BLkZ5/RtLPCPy8IvDzisDPy+d/
hnBuEXopAv+pSPoZgZ9XBH5eEfh5+fzPEHWL0EuRnn9G0s8I/Lwi8POKwM/L53+G+PilCPy8IvCf
iqSfEfh5ReDnFYGfl8///PM9covUS8B/KpJ+RuDnFYGfVwR+Xj7/M8Rxi9RLwH8qkn5G4OcVgZ9X
BH5ePv8zxH2L1EvAfyqSfkbg5xWBn1cEfl4+/zOk++7AzysC/6lI+hmBn1cEfl4R+Hn5/M8/puIW
qZdgfqRI+hmBn1cEfl4J+Hn5/M+Qyi1CLyV6/plIPxPw80rAzysBPy+f/xlSv0XopQT8pxLpZwJ+
Xgn4eSXg5+XzP0N6/FICfl4J+E8l0s8E/LwS8PNKwM/L53+GO5dJwM8r0fwokX4m4OeVgJ9XAn5e
Pv8z5LdIvQT8pxLpZwJ+Xgn4eSXg5+XzP0POt0i9RPOjRPqZgJ9XAn5eCfh5+fzPkB+/lICfVwL+
U4n0MwE/rwT8vBLw8/L5n3+OG7dIvQT8pxLpZwJ+Xgn4eSXg5+XzP0M+t0i9RPOjRPqZgJ9XovlR
ovmRz/8MRbcIvZRpfpRJPzPw88rAzysDPy+f/xnK45cy8PPKwH8qk35m4OeVgZ9XBn5ePv/zz9nz
FqGXMs3fM+lnBn5emebvmebvPv8zlHGL0EuZ5u+Z9DPT/D0DP68M/Lx8/mco+xapl4D/VCb9zMDP
K9P8PdP83ed/hnrfnebvmebvmfQz0/w9Az+vDPy8fP5nqO+V1Es0f8+knxn4eWXg55WBn5fP/wy1
3CL1EvCfyqSfGfh5ZeDnlYGfl8//DLXfIvUS8J/KpJ8Z+Hll4OeVgZ+Xz/8M9fFLBfh5FeA/VUg/
C/DzKsDPqwA/L5//Gdp9TeDnVWj+Xkg/C/DzKsDPqwA/L5//GdpbhF4qwH+qkH4W4OdVgJ9XAX5e
Pv8ztHyL0EuF5u+F9LMAP68C/LwK8PPy+Z+hPX6pAD+vQvP3QvpZgJ9XAX5eBfh5+fzP0OYtUi/R
/L2Qfhbg51WAn1cBfl4+/zO0c4vUSzR/L6SfBfh5FeDnVYCfl8//DF23SL1E8/dC+lmAn1cBfl4F
+Hn5/M/QH79UgJ9Xofl7If0swM+rAD+vAvy8fP5n6PUWoZcqzd8r6WcFfl4V+HlV4Ofl8z9DH7cI
vVRp/l5JPyvw86rAz6sCPy+f/xn6vkXopUrz90r6WYGfVyV+qRK/5PM/w7jvTvxSpfl7Jf2sxC9V
4pcq8Us+/zOM90rqJZq/V9LPSvxSJX6pEr/k8j///EjlFqmXaP5eST8r8UuV+KVK/FJ1+hlGv0Xq
JZq/U/6nKvFLlfilSvySz/8M4/FLlfilSvN3yv9UJX6pEr9UiV+qnl+6wGElfonyP1VJPyvxS5X4
pUr8ks//DPMtUi/R/J3yP9WIX2rELzXil3z+Z5j5FqGXKP9TlP+pRvxSI36pEb/k8z/DfPxSI36p
0fy9kX62H37p/vM3/9Oxr43O742efzaaHzWavzf3999nf4v1eff//ku3+L7ml32l/E81ev7p8j+/
rLvL//wuPnzzP93iw5P/+bv48OR//i4+PPmfvxz1k//5u/jw5H/+ctRP/ufv4sOT//m7+PDkf/4S
1438583//Fl8oPxPNTq/Nzq/N7//fmdnjc7vjfxno/N7o/P7k//5TzN89dM1A+lnI/1sc0IzfM/v
38UHl//5BaEbnd8bnd99/uf3t0Tn90b+s9H5vdH5/cn//OeGpfk75X+qk3528p8u/zPM+hbhM+oG
nxHlf4ryP9XNfUb3N99dfvK7+PDN/3SLD/3l593iw83//Llh+8/+UbzFv6/5c8P2n/2jeovz/2/D
Tuf3N//zvwTj569AqpN+dnr+2en5Z/fPP9dbhO/NTuf3Tvr55H/+9hLlf4ryP9XJf3byny7/M8z3
gyvUS5V6iebvlP+pXqmXmnvNt5ca3O+d/Gcn/+nzP8OzeKtO/rOT/+zkPzv5z07+s5P/9Pmf4Vm8
VSf/2Uk/O+lnJ//ZyX928p8+/zM8i7fq5D87+c9O/rOT/+zkPzv5T5//GZ7FW3Xyn530c5B+DvKf
g/znIP/p8z/Ds3irQf5zkH4O8p+D/Ocg/znIf/r8z/As3mqQ/xzkPwf5z0H8/CB+fhA/7/M/w663
CL00yH8OOr8P4ucH8fOD+Hmf/xn2uEXopUH6OUg/B/Hzg/j5Qfy8z/8Mdz9uED8/SD8Hnd8H8fOD
+PlB/LzP/wx3R2wQPz+I/xykn4P4+UH8/CB+3ud/hvNeSb1E/Ocg/RzEzw/i5wfx8z7/M9wdsUH8
/CD+c5B+DuLnB/Hzg/h5n/8Z7o7YIH5+kP8cpJ+T+PlJ/Pwkft7nf4a7IzaJn5/kPyfp5yR+fhI/
P4mf9/mf8X1N4ucn8Z+T9HMSPz+Jn5/Ez/v8z/gtQi9NOr9P0s9J/Pwkfn4SP+/zP+PdEZvEz0/y
n5P0cxI/P4mfn8TP+/zPeHfEJvHzk/znJP2cxM9P4ucn8fM+/zPe4/8kfn4S/zlJPyfx85P4+Un8
vM//jHdHbBI/P4n/nKSfk/j5Sfz8JH7e53/GuyM2iZ+fxH9O0s9J/Pwkfn4SP+/zP+PdEZvEz0/i
Pyfp5yR+fhE/v4if9/mf8e6ILeLnF/Gfi/RzET+/iJ9fxM/7/M94d8QW8fOL+M9F+rmIn1/Ezy/i
533+Z7w7Yov4+UXn90X6uYifX8TPL+Lnff5nvDtii/j5Rc8/F+nnIn5+ET+/iJ/3+Z9R75XUS8R/
LtLPRfz8In5+ET/v8z/j3RFbxM8vev65SD8X8fOL+PlF/LzP/4x3R2wRP7+I/1ykn4v4+UX8/CJ+
3ud/xrsjtoifX8R/LtLPRfz8In5+ET/v8z/j3RFbxM8v4j8X6ecifn4RP7+Jn/f5nzG8ReilTfzn
Jv3cxM9v4uc38fM+/zPeHbFN/Pwm/nOTfm7i5zfx85v4eZ//Ge+O2CZ+ftP8aJN+buLnN/Hzm/h5
n/8Z747YJn5+0/PPTfq5iZ/fxM9v4ud9/me8O2Kb+PlN/Ocm/dzEz2/i5zfx8z7/M94dsU38/Cb+
c5N+buLnN/Hzm/h5n/8Z747YJn5+0/xok35u4uc38fOb+Hmf/xnvBGcTP7+J/9ykn5v4+U38/CZ+
3ud/xrsjtomf3zQ/2qSfm/j5Tfz8Jn7e53/GuyN2iJ8/xH8e0s9D/Pwhfv4QP+/zP+PdETvEzx/i
Pw/p5yF+/hA/f4if9/mfMb1XQi8dmh8d0s9D/Pyh+dGh+ZHP/4x3R+zQ/OjQ/OiQfh7i5w/x84f4
eZ//Ge+O2CF+/hD/eUg/D/Hzh/j5Q/y8z/+Md0fsED9/aP5+SD8P8fOH5u+H5u8+/zPeEfah+fuh
+fsh/Tw0fz/Ezx/i533+Z8xvkXqJ+M9D+nmInz80fz80f/f5n/HuiB2avx+avx/Sz0Pz90P8/CF+
3ud/xv+x9Tc5suy61i3YldeBDzCJIiUVsjGS/SSy8goPSCCbn3G2i+aUr7Gjci/hx1bI5D5jTpE2
fD0j9r928j+/0l/x3z2SA/RTDpiflwPm5+WA+XkJ/M+/X+n04r/vJTlg/lMO0E85YH5eDpiflwPm
5+WQ+F56vPjve+mv+O8eCfE/5YD5eTlgfl4OmJ+XyP8s6xkxOWB+Xg6Y/xTif8oB8/NywPy8HDA/
L4H/+fcr6SrC/LwQ/1MO0E85YH5eDpiflwPm5yXyP8t6RkwOmJ+XA+Y/hfifcsD8vBwwPy8HzM9L
5H+W9YyYHDA/L8T/FOJ/ygHz83LA/LwcMD8vkf9Z1jNicsD8vBzQf5cD9FOObX7e/+cv//M7yyEH
5Hc54PxTDugfyQH9dznC97+f+S3+O8shx9d/vrMcQvxPOeD8UwL/853dksD/fAf55Mv//A7yyeJ/
boN8svif2yCfLP7nNhcki/+5DfLJ4n9uc0Gy+J/bIJ8s/uc2yCeL/7lNEEkC/ynO/4yDfEL8T0mQ
3yVBfpcUvz9u+ishv0sC/ykJ8rskyO+y+J/7myHwP79vBuJ/SiL9THbAm+Gb399BPgn8z3ewRxLk
d0mQ3yXyP793CfK7JPCfkiC/S4L8Lov/uX9gif8pxP+URPqZwH9K4H/+rd2Lg/Zo0B5B/12I/ylp
hj1673zgJ9u7R29+/w7ySXrnP7+DfOL8z/0D+9HPnw/s0s/9A/vRz58P7Jpf2j+GkN/l5X/+b5Bv
PfggifQzwfmnJDj/lBTPP5tfE84/JUF+l0T6ufifP+8l6L9LhvklyeQ/M/nPwP+UeXoxwXspJ3gv
Ef9TiP8pOcN7KedwzfYW4fOeyX9m8p+R/1nWg7eSyX9m8p+Z/Gcm/5nJf2byn5H/WdaDt5LJf2bS
z0z6mcl/ZvKfmfxn5H+W7tck/5nJf2byn5n8Zyb/mcl/Rv5n6W8RPkeZ9DOTfmbyn5n8Zyb/Gfmf
ZT14K5n8Zyb9zOQ/M/nPTP4zk/+M/M+yHryVTP4zk//M5D8zPL8pGZ7flAzPb0rkf5b14K1keH5T
MvnPDPldMjy/KRme35QMz29K5H+W9eCtZHh+U4T0U0g/BZ7fFIHnN0Xg+U2J/M+yHrwVgec3RUg/
hfK7wPObIvD8pgg8vymR/1nWg7ci8PymCMx/ipB+Cjy/KQLPb4rA85sS+Z9lPXgrAs9visD8pwjp
p8DzmyLw/KYIPL8pkf9Z1oO3IvD8pgjMf4qQfgo8vykCz2+KwPObEvmfZT14KwLPb4qQ/xTST4Hn
N0Vgfl4E5ucl8j/L9H8d5udFyH8K6afA/LwIzM+LwPy8RP5ncecvMD8vAvOfIqSfAvPzIjA/LwLz
8xL5n8X9p8D8vAjldyH9FJifF4H5eRGYn5fI/yzrwVsRmJ8XIf9ZSD8LzM9Lgfl5KTA/L5H/WdaD
t1Jgfl4K+c9C+llgfl4KzM9Lgfl5ifzP4j65wPy8FJj/lEL6WWB+XgrMz0uB+XmJ/M9yvkV4LxWY
/5RC+llgfl4KzM9Lgfl5ifzPsh68lQLz81Jg/lMK6WeB+XkpMD8vBebnJfI/y3rwVgrMz0uB+U8p
pJ8F5uelwPy8FJifl8j/LOfySwXm56XA/KcU0s8C8/NSYH5eCszPS+R/lvPxIr2XYP5TCulngfl5
KTA/LwXm5yXyP8uVvUjvJcrvhfSzwPy8FJiflwLz8xL5n+VSL9J7ic4/C+mnwvy8KMzPi8L8vET+
59/NWUWYnxeF+U9R0k+F+XlRmJ8Xhfl5ifzPck0vwntJ6fxTST8V5udFYX5eFObnJfI/y3V7Ed5L
CvOfoqSfCvPzojA/Lwrz8xL5n+X2fx3m50Vh/lOU9FNhfl4U5udFYX5eIv/z75OyijA/Lwrzn6Kk
nwrz86IwPy8K8/MS+Z/lrl6k9xLMf4qSfirMz4vC/LwozM9L5H+We3iR3ksw/ylK+qkwPy8K8/Oi
MD8vkf9Z7suL9F6i/pGSfirMz4vC/LwozM9L5H/+yeYqwvy8KJ1/Kumnwvy8GMzPi8H8vET+Z3ne
IryXDOY/xUg/DebnxWB+Xgzm5yXyP8tjXoT3ksH8pxjpp8H8vBjMz4vB/LxE/md5uhfhvWTUPzLS
T4P5eTGYnxeD+XmJ/M+/v6GrCPPzYjD/KUb6aTA/Lwbz82IwPy+R/1mex4v0XqL+kZF+GszPi8H8
vBjMz0vkf6o3QQzm58Vg/lOM9NNgfl4M5ufFYH5eIv9TvY9gMD8vBvOfYqSfBvPzYjA/Lwbz8xL5
n+r9I4P5eTHqHxnpp8H8vBj1j4z6R5H/qcf0Ir2XqH9kpJ8G8/NiMD8vFebnJfI/9bi9CO+lCvOf
Ukk/K8zPS4X5eakwPy+R/6nJ/3WYn5dK/fdK+llhfl4q9d8r9d8j//PPXa8i9d8r9d8r6Wel/nuF
+XmpMD8vkf+pqXoR3ksV5j+lkn5WmJ+XSv33Sv33yP/UNLxI7yXqv1fSz0r99wrz81Jhfl4i/1PT
5UV6L1H/vZJ+Vpiflwrz81Jhfl4i/1O9u1phfl4qzH9KJf2sMD8vFebnpcL8vET+p+a3SO8lmP+U
SvpZYX5eKszPS4X5eYn8T83mRXovwfynVNLPCvPzUmF+XirMz0vkf2ruXoT3UqP+eyP9bDA/Lw3m
56XB/LxE/qeur2mWBvPz0mj+s5F+Npiflwbz89Jgfl4i/1Pz40V4LzXqvzfSzwbz89Jgfl4azM9L
5H+qZC/Ce6lR/72RfrZtft7/5+/3v4dZjkb5nfifQvxPadR/b+H73+fwYoNZjsD//M5yNMrvxP+U
FvlL9ha/c0Ht+8owF9TeYpwL8l/po5/7IN/if+5zQYv/uQ/yLf7nPhe0+J/7IN/if+6DfIv/uU8Q
NfKfzv/cBvmI/ymN8nuj/N7i98e920H5vZH/bJTfG+X3xf/8eTN89TO8GUg/G+ln4H+GN8M3v38H
+QL/8zvY0ym/d8rvPX5/XH7/56Ahnfxnp/zeKb8v/qeW/43sv8Wln/L8zxL7/9z18zm/R53O/0wp
/71Dqhc/v2ftt37/9Y9+Ps91XsPPk53/qdvvSf2jTv2jTv2jTv2jyP/U4r8n9Y+I/ymd+ked+ked
+ked+keR/6lleBE0uZN+dtLPTv2jTv2jTv2jHvynlsuL8NnspJ+d9LNT/6hT/6hT/yjyP1X9mtQ/
6nT+2al/1Kl/1Kl/1Kl/1IP/VH2L9F6i80/if0qn/lGn/lGn/lHgf/79SuZFei+RfnbqH3XqH3Xq
H3XqH/Wgn6rdi/ReovNP4n/KoP7RoP7RoP7ROOJ7af01HNQ/Iv6nEP9TBvWPBvWPBvWPRo7vpceL
8F4adP45qH80qH80qH80qH80gn6qZS/Ce2nQ+ecg/RzUPxrUPxrUP4r8TzX1IryXiP8pxP+UQf2j
Qf2jQf2jEfRTbVmjQf0j4n8K8T9lUP9oUP9oUP9oBP1Um16k9xKdfw7Sz0H9o0H9o0H9ozHje+n2
Ir2XyH8O0s9B/aNB/nOQ/xxBP7X6v07+c5D/HKSfg/znoP7RoP7RCPqp1V9J/aNB55+D9HNQ/2iS
/5zkP2fQT63Vi/BemuQ/J+nnJP85qX80qX80g35qHV6E99Kk889J+jmpfzSpfzSpfzRLfC9dXoT3
0qTzz0n6Oal/NKl/NKl/NIN+qoeRSf2jSeefk/RzUv9oUv9oUv9oBv3U9hbpvUTnn5P0c1L/aFL/
aFL/aMb+UTMv0nuJzj8D/1Mee4vfM4GnvMVvNpz3W6Rr0vz8pPPPSeefk/Qz8D/Dv36G33O8Rbom
zc9POv+cdP45ST+J/ymL/5n/MmgOxc81W5I7FNc1+2HX+RbDWdCz/vBNyu+T9JP4n0L8TzkPuJ/n
Vz/l/hbhmiedf56kn8T/FOJ/yknzn2eG92fgf37fn4H/Kef3lXRN0k/if8pJ+f2k+fnA/wz/eoH3
50n6SfxPIf6nnJTfT5qfP+n8c/E/9/en8z+39+fL/+xHzedbhPfnSfn9pPPPk84/T+ofBf5nuJ+N
3p/kP0/K7yfNz5/0/NFJ/aOT9PMk/TxJP8+gn+f7y5N+nqSfJ+nnSfpJ/E8J/M/wr5N+nqSfJ+nn
Sfp5kn4S/1OI/ykn6efp+vm3ilB8359tfovvNfX7/iT9JP6nEP9TTtLP64D7eZF+XqSfF+kn8T+F
+J9ykX5epJ8X6edF+hn4n3J9X0nXJP28SD8v0s+L9DPwP8O/TvpJ/E8h/qdcpJ8X6edF+nmRfl6k
nxfp5/XVTxvvTSb9vEg/L9LPi/TzIv0M/M9wP0k/L9LPi/TzIv28SD8v0k/if8pF+nmRfl5BP6/3
lyf9vEg/L9JP4n8K8T/lCvr5/ddJPy/Sz4v08yL9JP6nEP9TLtLPi/TzIv95Bf95n2+R3p+kn8T/
lIv08yL9DPzP7/28ST9v0k/ifwrxP+Um/bxJP2/Sz5v08yb9DPxPub+vpGuSft6knzfp5036Gfif
4V8n/ST+p9yknzfp5036eZN+3qSfN+nnTfp5B/08z7cI78+b9PMm/bxJP4n/KYH/Ge4n6edN+nmT
ft6knzfpJ/E/hfifcpN+3qSfgf/5v2aoF+mapJ/E/xTif8pN+nkH/fz+66SfN+nnTfpJ/E8h/qfc
pJ836edN+vnyP5+rhSJdM/aPFuxdiP8pN+nnTfp5k34u/uf+ezr/c/scvfzP+Dl6DvgcPaSfD+nn
Q/r5kH4+GfY98D+/nyPif8pD+vmQfj6knw/p50P6ufifP/ezfPddfIL9If18Cuz7Q/r5kH4+pJ/E
/5SH9NP5n9uUwuJ/Jr37/94NXnyv2Z/1VTLykH4+pJ/E/xTif8rTQJeeBroU+J9/9/gt0jVJP4n/
KcT/lIf0c/E/f+7n0s/0v/bSt/i5n8/Tnu/v+dXP+ryfI9JP4n/KQ/q5+J/lLOloPli++J8/v+dJ
n/fz+3m/vkX6vJN+PqSfD+nnQ/oZ+J9hN2/QeeJ/CvE/5SH9fEg/H9LPB/SzHB/9vOrnx4v/XfMu
nx8v/nvNcoD/LMc7//nfjxf/u+Z1fn68+N81n/L58eLnmvfnZxWBH1IW/7OXz48XP9dc/3nxMxNV
Pz+rCPpZDtDPcoB+/hVp7TD/WQ6Y/ywH6Gc5wH+WA/SzHKCfZfE/9fj8ePG/az7p87OKdsBd+ujn
eXx+vPjfNXP9/HiRfk/Qz0L8z0L8z3KAfpYD+kflgP5ROcB/lgP0syz+Z5qfHy/+d81nfH68+N81
7+fz40V6f0L/vRzQfy8HzC8V4n8W4n+WA/SzHKCf5QD/WQ7ov5cD5pcK8T8L8T/LAfpZDtDPsvif
o31+vHjCWxHmlwrxP8sB+lkO0M9ygH4W4n8W4n+Wg/QzAT+kJOAvlUT6ufiff3fwv59VTPDZXPzP
5/j8eJGuCf6zJNLPBPPzhfifJYH/LMT/LIn0c/E/l/b7MgX2ffE/f4uFiqDzi//5U1S6ptI1la65
9HN+flbxo59n+vx4kdYO/feSSD8T6efif+6Svvifu6Qv/ufPL//Rz13SF/9zl/RE+kn8z0L8z0L8
z0L8z5LAf5ZE+plIP4n/WYj/WRLpZyL9TKSfifQzkX4m0s9E+plIPxf/s12fHy/S+/Ojn/P+/HiR
rkn6mUg/F//zls+PF+m99NHP9aZ7i3RN0k/if5bF/5zt8+NF+FtM/M+SyX9myO9l8T/t/vx4ET7v
i/9p5+dnFRc/OX9+vPj5PTf7uvifazN9Re/zR8ESZ9LPTPqZyX8S/7MQ/7Nk8p+Z/Gcm/5nJfy7+
p9jnx4sNNm7p53JRq7j4deXz48WVNz8/XqTfk/Qzk34S/7MQ/7Nk8p+Z/Gcm/5lJPzPp5+J/tvr5
8SJ83hf/s8nnx4t0TdLPTPqZST+J/1mI/1ky6Wcm/cykn5n0M5N+Ev+zEP+zZPKfmfxnJv+ZyX9m
0k/ifxbif5ZM/jOT/8ykn5n0M5N+Ev+zEP+zCOnn4n+m8vlZRfKfQv5TyH8S/7MQ/7MI+U8h/ynk
P4X0U0g/F//T5ufHi/9dc+TPzyp+9HOs/7z43zXH+fnxYqPiCcWPfv4W4fMu5D8X/3N/0zr/Uz4/
XqS1k34K6efif+6Svvifu6Qv/ucu6c7/3CTd+Z+bpAvpp5B+Ev+zEP+zCPlPIf8ppJ9C+imkn8T/
LMT/LEL6KaSfQvoppJ9C+kn8z0L8zyKkn4v/mfTz40V6f37085HPjxfpmqSfxP8si/85x+fHi6DJ
i/9Zzs+PF+mapJ/E/yyL/3nJ58eLn/PP9PnxIlyzkP8s5D+d/7mdGi3+534/F//z0s/PKn70sx2f
Hy/CHi3+p56fHy/S70n6SfzPQvzPUsh/FvKfhfxnIf9ZyH8S/7Ms/ufMnx8vgn4u/mc7Pz+rCM+/
l0L6WUg/if9ZiP9ZCvnPQv6zkP8s5D8L6SfxP4vzP8fnZxU/+nlfnx8vft5L1+fHi59ez/X58SL9
nqSfxP8sxP8shfSzkH4W0s9C+llIP4n/WYj/WQrpZyH9LOQ/C/nPQv6zkP8k/mcppJ+F/Gch/+n8
z/758eJ/19wPw4n/WYj/WZT8p5L/VNLPxf+s679VJP+5+J+zf368SNck/6nkP5X8p5L/VNJP4n8W
4n8WJf1U0k8l/VTSTyX9JP5nIf5nUfKfSvqp0H8vSvqppJ/E/yzE/yyL/7lL+uJ//vxKH/3cJV1J
P5X0k/ifhfifRcl/KvlPJf+p5D+V9JP4n4X4n0VJP5X0U0k/lfRz8T9VPj9e/JyDtc/PKpJ+Kumn
kn4q6efif66jdN9N8p+L/3n3z48X6Zqkn0r6ufif1T4/XgRNXvzPPTAS/7MQ/7Mo6efif+7/0OJ/
9vT58SJc08h/Ev+zEP+zLP7n3kBf/M+fX+mjn0///Hjx09Mfnx8vfn5P+fx4kX5P0k8j/TTSTyP9
NNJPI/0k/mch/mcx0s/F/9xNlJF+Lv7nfmxupJ/E/yzE/yxG+mnkP438p5H/NNJP4n8W4n8WI/1c
/M9dQxb/8+cuffRz1s+PF+mapJ/E/yxG+mmkn0b6aaSfRvpJ/M9C/M9ipJ9G+mmkn0b6aeQ/if9Z
jPynkf800k8j/TTyn0b+c/E/l4T4P/TRzx9h+einzs+PFz/X3I6SKvlP53/Oz48XP55hS9CL//mc
n59VXP5zi0KL/7mS+uNFWHsl/+n8z/r58SK85xf/s6XPjxfpmqSflfSzkn5W0s9K+kn8z0L8z1JJ
PyvpZyX/WUk/K/lP4n8W4n+WSvpZST8X/3OX9Er+c/E/d0kn/mch/meppJ+V9LOS/6zkPyv5T+J/
FuJ/Fud/7u/PQe/PQe9P0s9K+kn8z7L4n3P950XQJed/ps+PF6FvWEk/F/9z/a99RR/93E8gK/nP
xf/s9vnxIq2d9LOSfi7+57qdzYuftW+d5cX//NGlj35q//x4kdZO+rn4n+uSjxc/ZwLy+fEiXJP4
n6WR/2zkPxf/M7fPjxehX7z4n/t2LP6n3p8fL9LvSfrZSD8b6Wcj/Wykn8T/LMT/LI30s5F+NtLP
xf/cp5Ia6efif47787OKa36pfn68+PHz5fPjxUbFzxn1dmy++J+ryWZe/MxdHJ8fL9LaST8b6Wcj
/ST+Z1n8z/P+/Kwi+c/F/1wjz+8r6Zqkn438ZyP/2ch/NtLPRvrZSD8b+U/if5ZG/pP4n6WRfjby
n4v/uWvy4n+uaHh58ZPft8HyRv5z8T+Xg/N/6KOfu4Vr5D+J/1kW/3P1uv33fKC/ufifP7/SRz/X
7NX6xC3+57IMtxfhLH3xP/drLv7n/q8v/qflz48XYY86+c9O/rP7979//vMi/I1b/M99trCTfnbS
z076SfzP0kk/O+lnJ/3spJ+d9JP4n2XxP/e/Mp30s5P/7OQ/O/nPTv6T+J9l8T93Se/kPxf/c5f0
xf/cJX3xP3f1XvzP32L7V9IX/3OX9MX/3CW9k//spJ+d9HPxP3/en4PWPuj9SfrZST876efif+6T
D4v/uXuwxf/8+ZU++vno58eLDZThpM/7Rdf86OfqvPkyP/r5c5fIfxL/s3Tyn530c/E/1/3wN8Py
n/tH5qE9ekDnF/9zvWfX2hf/c28/DeofDfKfg/znIP9J/M9C/M+y+J+r0eS/0kc/9+eknP+5HXUO
8p+D9JP4n4X4n2WQfg7Sz0H6OUg/B+kn8T8L8T/L4n/u2XCQfi7+50+Rnj9a/M/fIl3T6JqVrvnR
z3N+frxIayf/Och/Ev+zEP+zLP7nmvzy9/xHP+f1+fEiZNhB+jlIP4n/WYj/WQb5z0H6OUg/B+nn
IP9J/M9C/M8yyH8O8p+D/Ofif172+fEivZcuei+R/1z8z9/i5720PcYySD8H+c9B85+L/ynrPy9+
zkM297v4nyvKrLPKxf/c/6As/uc+0r/4n3v3avE/8/35WUXST+J/lkn6Ocl/Tuq/L/7n/ulY/M/V
2m1epGuSfk7Sz0n6OUk/J+nnJP0k/mch/meZpJ+L/7lkyXfzo5/n+s+LdE3yn8T/LMT/LJP85+J/
7pI+yX8u/udvET5Hi//5W6RrNrpmo2t+9HOX9En+c5J+Ev+zTNLPxf/8eX8Oen+SfhL/sxD/sxD/
syz+5344tvifQz4/Xvx83tfDLV5soAwf/dxN6eJ/rh6d/88v6KEQ/7MQ/7NM8p+T/Ock/Zykn5Pm
Pxf/c9WKF2GucvE/9+BwUv/oJP9J/M9C/M9C/M9C/M9C/M9C/M9ykn6eNL90kv8k/mch/mch/mch
/mch/mc5ST9P0k/ifxbifxbifxbifxbifxbif5aT9PMk/TxJP0/ST+J/FuJ/FuJ/FuJ/lpP850n+
k/ifhfifhfifhfifhfifhfif5ST9PMl/nuQ/if9ZiP9ZiP9ZiP9ZiP9ZTvKfJ/lP4n8W4n8W4n8W
4n8W4n8W4n+Wk/TzJP08ST9P0k/ifxbifxbifxbif5aL9PMi/ST+ZyH+ZyH+ZyH+ZyH+ZyH+Z7lI
Py/Sz4v0k/ifhfifhfifhfifhfif5SL9vEg/if9ZiP9ZiP9ZiP9ZiP9ZiP9ZLtLPi/TzIv28SD+J
/1mI/1mI/1mI/1ku0s+L9JP4n4X4n4X4n4X4n4X4n4X4n+Ui/bxIPy/ST+J/FuJ/FuJ/FuJ/FuJ/
lov08yL9JP5nIf5nIf5nIf5nIf5nIf5nuUg/L9LPi/TzIv0k/mch/mch/mch/me5ST9v0k/ifxbi
fxbifxbifxbifxbif5ab9PMm/bxJP4n/WYj/WYj/WYj/WYj/WW7Sz5v0k/ifhfifhfifhfifhfif
hfif5Sb9vEk/b9LPm/ST+J+F+J+F+J+F+J/lJv28ST+J/1mI/1mI/1mI/1mI/1mI/1lu0s+b9PMm
/ST+ZyH+ZyH+ZyH+ZyH+Z7lJP2/ST+J/FuJ/FuJ/FuJ/FuJ/FuJ/lpv08yb9JP5nuUk/if9ZiP9Z
iP9ZiP9ZHtLPh/TzIf18SD+J/1mI/1mI/1mI/1ke0s+H9JP4n4X4n4X4n4X4n4X4n4X4n+Uh/XxI
P4n/WR7ST+J/FuJ/FuJ/FuJ/lof08yH9fEg/H9JP4n8W4n+Wxf/ciT2L/7mG0VYXePE/957+4n/u
neXF/zzl8+PF/65ZxudnFUk/if9ZiP9ZiP9ZHtLPh/TzIf18SD+J/1mI/1mI/1ke0s+H9PMh/XxI
Px/ST+J/FuJ/FuJ/FuJ/lof08yH9JP5nIf5nIf5nIf5nIf5nIf7n/zC5VPzvmtvJsx4wv6SL/7m1
3vQA/dQD9FMP0E89QD+V+J96gH7qAfqpB+inEv9Tif+pi/+5Qdh08T+382Q9gF+ni/+5Qdh08T83
CJsS/1OJ/6nE/9QD9FMP0E89QD918T+3vqEe0H/Xxf/cBuCV+J9K/E8l/qcS/1MX//PnrQj9I138
z5+3IvhPPUA/9QD91AP0Uxf/c3uIRhf/8+dXAv1U4n8q8T+V+J9K/E8l/qcu/ufP7wnzS0r8TyX+
pxL/U4n/qcT/1AP0Uw/QTyX+pxL/U4n/qYv/+fOJg/l5PWB+SQ+Y/9TF/9yLCZ7f1MX//C1+/r6v
Z428CGtPpJ+L/7l/NhPw63TxP/fPJvE/lfifSvxPJf6nLv7n/tlc/M+fX0ngs5nAf2oC/6mL//mz
duB/6uJ//qyd9DORfibSz0T6ufifP2uH+SVd/M+ftYP/VOJ/6uJ//qwd+u+6+J8/a4f8rgnyuxL/
U4n/qYv/+bN24Nfp4n/+rB38pxL/Uxf/82ftg9Y+aO2kn8T/VOJ/KvE/dfE/f9Z+0tpPWjvpZyL9
TKSfifST+J9K/E8l/qcm0s8E/lMT+E8l/qcS/1OJ/6mZ/Ofif24D8JrJfy7+54ZWU+J/aib/mcl/
ZvKfmfQzk35m0s9M+kn8T138z20UWRf/c5vl0MX/3MZxdfE/NwibOv8zzhYq8T+V+J9K/E/NpJ+Z
9DOTfmbyn4v/uT2Ip5n85+J/bqMgSvxPJf6nEv9Tif+pi//581Yk/7n4nz9vRdLPTP4zk//M5D8z
+c9M/pP4n0r8TyX+pxL/U4n/qcT/1Ez+M5P/JP6nEv9Tif+pxP9U4n9qJv3MpJ/E/1TifyrxP5X4
n0r8TyX+p2byn4v/ud9P4n8q8T+V+J8q5D+F9HPxP/fPppD/XPzP/bNJ/E8l/qcS/1OJ/6mL/7l/
NoX85+J/7p9NIf8p5D8X//Nn7eQ/F//zZ+2kn0L6KaSfQvq5+J8/ayf/ufifP2sn/ymkn4v/+bN2
8p+L//mzdvKfxP9U4n8q8T918T9/1k7+c/E/f9ZO/pP4n7r4nz9rJ/+5+J8/ayf9JP6nEv9Tif+p
i//5s3byn4v/+bN20s/F/2zP58eL/11zmxTVxf/cIBi6+J+LHaWr+NHP7fElXfzPPYAL6aeQfi7+
58Yp1cX/3EC4SvxPJf6nFtLPxf/cWHNayH8u/qet/1aR9LOQ/yzkPwv5z0L6WUg/C+kn8T+V+J+6
+J8bhE0X//Nn7R/93CBsSvxPJf6nEv9Tif+pxP/UQvpZSD8L6SfxP3XxPzcUmBbyn4v/uT1MocT/
VOJ/KvE/lfifuvifP29F8p+L//nzViT9LOQ/C/nPQv6zkP8s5D+J/6nE/1TifyrxP5X4n0r8Ty3k
Pwv5T+J/KvE/lfifSvxPJf6nFvKfhfwn8T+V+J9K/E8l/qcW8p+F/Gch/1nIfxL/U4n/qcT/VCX/
qaSfi/+5fzaV/Ofif+6fTeJ/KvE/lfifSvxPXfzP/bOp5D8X/3P/bBL/U4n/qYv/+bN28p+L//mz
dtJPJf1U0k/if+rif/6snfzn4n/+rJ38p5J+Lv7nz9rJfy7+58/ayX8S/1OJ/6nE/9TF//xZO/nP
xf/8WTv5T+J/6uJ//qyd/Ofif/6snfST+J+qpJ9K/nPxP3/WTv5z8T9/1k76qaSfSvqppJ/E/1Ti
fyrxP1VJP5X0U0k/if+pxP9U4n/q4n+uJnD2ItzPxf/c6GTq/M9IlVfifyrxP9XIfxr5TyP9NNJP
I/0k/qcS/1MX//NnmeQ/F/9zP/Mn/qcS/1OJ/6nE/1Tif6qRfhrpp5F+Ev9TF/9zQ4Hp4n9uw0K6
+J97klr8zw0FpsT/VOd/bgfCi//581aE5zd18T9/9mjp5/5WJP008p9G/pP4n2rkP438J/E/lfif
SvxPJf6nEv9Tif+pRv7TyH8S/1OJ/6nE/1TifyrxP9VIP430k/ifSvxPJf6nEv9TjfTTSD8X//PK
nx8vft6fC3DzKRL/Uyv5z0r+s5L/rKSfi/+5fzYrfH+xLv7n/tlc/M/9s1lJPxf/c/9sLv7n/tlc
/M/9vVRJP53/uX02if+pxP/Uxf/8WXuhtRdau9LaST8X//Nn7UprB36ILv7nz9qN1k7+s5L/XPzP
n7VXWnultTdaO/lP53/ua2+0duDX6eJ//qy909rJf1byn4v/+bP2QWsftPZJayf9XPzPn7VPWjvp
5+J//qz9pLWTflbSz0r6WUk/if+pxP9U4n9qJf2spJ+V9LOSfhL/Uyv5z0bzS4v/uXeWF/9T139e
pGuSfhL/Uxv5z0b+s5H/bKSfxP9U4n8q8T918T+3gW1t5D8X/3ODsOnif24QNl38z423pov/+Vv8
75obhE0X/3ODsOnif24QNm3kPxv5z0b+s8H8vC7+54YC08X//HmHAH9JF/9zQ4Hp4n9uKDBtwA/R
xf/8+Yc++vnzVqT83sh/NvKfi/+5QSx18T83iKUu/ufPish/Lv7nhvHRxf/cIJZK/E8l/qcu/ufP
7znp95z0e5J+Lv7nz+950u9J+tlIPxvpZyP9bKSfjfSzkX4S/1OJ/6mN9LORfjbSz0b62cl/dvKf
nfxnJ/3spJ/E/9TF/9w/mx34ydqBn6yL/7m/Qxb/c/9sLv7nz/9c4LO5+J/7Z5P4n0r8TyX+pxL/
Uxf/82fthdYO3/+ui//5s3altQO/Thf/8+cfMlo7PH+kxP/UTv6zU35f/M+ftVdaO+X3xf/8WXuj
tQN/SRf/8+cf6rR2yu/E/9RO/rNTfl/8z5+1D1r7pLVPWvuktQN/Xp3/uf9DJ62d8nsn/eykn530
s5N+Ev9Tif+pxP9U4n9qJ/3spJ+d9LOTfnbSz8X/3DBouvifG6hZif+pxP9U4n8q8T+V+J86yH8O
8p+D/CfxP5X4n0r8T138zw3CpoP85+J//hTp+aPF//wt0jULXZP0c/E/NwibDvKfg/znIP85yH8O
0s9B85+L/7mhwHTxPzcUmC7+5/7o1uJ//rwVP/r581ak/E78Tx3kPwf5z8X/3MfFF//z58532iPy
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
Iv9ZyH8uTujPiob/7TjjK+mapJ+LE/qzokl7NOMeqRdpj066n9BnOhYn9GdF55u5vidmhfSTOKHH
4oT+rOiiPbrjHpkXaY9uup/QZzoWJ/RnRc/79z2860g/iRN6LE7ovqKNE9reV8Y9ql6EPVLqHxEn
9Fic0H1FzgndTp6V9JM4ocfihP6sKMMeBU7o34qaF2GPlPwncUIPJf/pnNCtO6Ckn8QJPZT8p5L/
1Og/F2HwUPKfSv0j4oQeixP6syJ7/x6FV5J+Eif00Ep7VGmPWtyj4UXaI+ofESf0UMrvzgndumxK
+kmc0EMpvyvld435XaYXaY+of0Sc0GNxQn9WNN9+x7cTqqSfxAk9Fif0Z0Un7dEV9+j0Iu0R5Xfi
hB6LE/qzovv1dRZeSdck/Vyc0J8VPbRHT9yjy4uwR0b9I+KEHkb9d+eE1lq/ymCkn8QJPYz670b9
d4v9d7m9CHtk1D8iTuhh1H9fnNCjPVbDK+mapJ9G/Xej/rvF/vv6os3DqP9u1D8iTuhh1H9fnND/
uSD9vpL0kzihh1H/3aj/brH/Xt4i7dGW398i3U/yn8QJPRYn9Gft/j1JuX3/Fhv1j4gTehjld6P8
bjG/F38l5Xcj/2nkP43yu33z+wyvpGtSfjfK70b53WJ+X4j/wyi/G/lPI/9plN+dE9pk9u8rKb8T
J/Qwyu9G+d1ifi/iRdoj8p/ECT0q5XfnhLZ8lfBKuCZxQo9K+b1Sfq8xvxe/JuX3Sv6TOKFHpfzu
nNDa+/dzVCm/Eyf0qJTfK+X3GvP7gvAelfJ7Jf9JnNCjUn53Tmg77xleSdek/F4pv1fK7zXm92Je
pD0i/0mc0KNSfndO6N+Kvn+LK+kncUKPSvm9Un6vMb+X6kXaI/KfxAk9KuV354S285HwSrom6Wel
/F4pv9eY30vzIu0R+U/ihB6V8rtzQv9W9HUXlfSTOKFHpfxeKb/XmN8X4eWolN8r+U/ihB6V8rtz
Qv9WFD5HpJ/ECT0a5fdG+b3F/L6+CftolN8b+U/ihB6N8rtzQv9W9P0cNdJP4oQejfJ7o/zeYn4v
04uwR438J3FCj0b53Tmhf2FXwivpmqSfjfJ7o/zeYn4vpxdpj8h/NvKfjfK7c0L/VvT9HDXSz0b6
2Si/N8rvLeb3cnmR9ojyO3FCj0b5vfV3j2Z4JV2T9LNRfm+U31vM7+X2Iu0R5fdG+b1RfndO6N+K
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
/lQ6/1Tyn0rnn/rOf35nDxLxPxPxP5PS+afS+afG88/xvpL2iM4/lfRT6fxTyX8qnX/qpLXT+aeS
fiqdfyqdf2o8/xz+e9L5p9L5p9L5p8L8fFKYn08a5+eHeJHeSzD/mYj/mRTmP5M+dD9h/jMp6afB
/GcymP9MFuc/R/Ei3E+D598T8T+TJVi70fmnwfPvyTJoHfE/E/E/k8Hz78ng+fdk8fn3oV6ktVP/
3aj/btR/N+q/E/8zEf8zGfXfjfrvFvvvw7wI70+j/rvR+adR/92o/26x/z6qF+l+bvndf0/K78T/
TEb9d+J/JuJ/JuJ/JuJ/po3/OZoX6X5Sfif+ZzLK70b53Si/O/9z+7tplN+N8rtRfjfK7xbz++he
pLVf4OuM8rtR/8j5n5vWGfWPjPTTqH9k1D+y2D8aw4vw/qwHvD8r9Y8q8JeS8z83Bavw/FGqpJ8V
+EupAn8p1chfGtOLsEc1w/uzkn5W0s9K+lk3/Ty9SPeT9LOSflbST+d/7veT9LOSflbSz0r6WTf9
vLxI95P0s5J+Vpj/TMT/TMT/TC//c1s7zH8m4n8m4n8m4n+mjf85bi/S2mH+MxH/M1WYn0+V/GeF
+c9U3/nPoAwV5j9TJf2sMP+ZKsx/phrnP8fjRVr7Cd6mUn6vMD+fKszPpwrz86mSflaaX6o0v1Tj
/NJ8i/TZhPn5VOn8s1J+J/7n33Jh7Q2ef0+N8nuj/N4ovzfK7y3m9/m+EtbeKL8T/zM1yu+N9LNR
fm9vfg9/tYn/mYj/mRrl90b5vcX8Pv33pPzeqH/USD8b5femoEvE/0zE/0yN8nuj/N5ifp/iRfhs
tgrvz0b5vVF+b5Tfif+ZiP+ZGuX3Rvm9xfw+/ZqU3xvl90b62ej8s9H5Z4vnn1O9SPeTzj8b5fdG
55/tpPtJ55+N9LPR+Wej888Wzz+n7zudfzY6/2x0/tno/LPR+WeL55+zepHuJzx/lBrpZyf9dP7n
dj876Wcn/eykn530s2/62bwI97OTfnbSz076SfzPRPzP1Ek/if+ZiP+ZiP+ZiP+ZNv7n7F6ktdP5
J/E/E/E/08v/DE+PJuJ/JuJ/JuJ/JuJ/po3/OYcX4f3ZST+J/5mI/5le/mdgpyTifybifybifybi
f6aN/zmnF2mPSD+J/5l2/qevnfI78T9Tn7R2Ov8k/mci/mci/mfa+J/z9CKtnc4/if+ZOs1/dvKf
nfK78z83J9ApvxP/M3XK753ye4/5fV5ehLUPyu+D8vug/O78z+2zOSi/E/8zDcrvg/L7iPl93l6E
z+Yg/ST+Zxqkn87/3P52DNLPQfo5SD8H6efY9PPxIu0R+U/if6ZB+jlofn6Qfg7Sz0H6OUg/R9TP
8y3SHtH8EvE/E/E/E/E/08b/PN9X0v2k/jvxPxPxP9Og+U/ifybifybifybif6aN/3n670n+cwA/
JBH/Mw3Sz0H6OaJ+nuJFup8X3U/SzwH8ujTg+48S8T8T8T/TIP85yH+O6D9Pvyb5z/HQ/ST/OQ9Y
+yT9nKSf89XPkPQn6eck/Zykn5P0c0b9PNWLsPZJ+jlJPyfpp/M/t7/vk/Rzkn5O0s9J+jmjfp7m
RXh/TtLPSfo5ST8n9d8n6eck/Zykn5P0c276Wb1Ie0T6OUk/J/WPiP+ZiP+ZJnx/XCL+ZyL+ZyL+
ZyL+Z9r4n2fzIq2d+kfE/0yT+keTzj8n9Y/m2z8Kbm1S/2hS/2hS/2hS/2jG/tHZvUhrp/7RJP85
yX/O9/mj4NYm+c9J/nOS/5zkP2f0n+fwInw2T/KfJ+nnSfrp/M/NrZ2knyfp50n6eZJ+npt+Ti/C
Hp3UPzpJP3f+Z/Yi/Z7AT07O/9w+myfwk9NJ/aMT+MnpBH5yOiM/+Ty9SGtX+NtB/M90Aj85Of9z
cwIn8JPTSf2jk/rvJ/Xfz9h/Py8v0vtz08+3SPez0dopv5/w/UfJ+Z/7bgL/MxH/M53w/UfphO8/
Smf8/qPz9iKtfdLaST/PCbp0kv886fzzPGntdP550vnnSeefJ51/nvH883y8SGun88+T/OfO//S1
k34S/zN9+Z9x7TS/RPzPRPzPRPzPtPE/r7cIa79ofon4n+lKsPaL5pcuml+6Mqz9ovmli/Tzov77
Rf33K/bfr/eVtPZCayf9vIC/lIj/mS7gLyXnf8bvWU4X8JfSRfp5AX8pXcBfSlfkL13+ewJ/KV2V
1k7994vm5y+an7/i/PwlXoS/HRfpJ/E/00X6eb36GdzaRfp5kX5epJ8X6ecV9fPya5J+XqSfF+nn
Rf33i/rvV+y/X+pFup/Ufyf+Z7qo/+78z/1+Uv/9Iv95Uf/9ov77Ffvvl2sI9d8v6r9f1H+/qH9E
/M90U//opvn5m/pHN/WPbuof3dQ/umP/6KpehLXf1D8i/mci/mci/mfa+J9X8yK8l4j/mYj/mYj/
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
/hHxP7NR/8iof2Q97tHlRdojyu9G+d2of+T8z+1M1Ug/if+ZjfpHRv0jm3GPbi/SHtH5J/E/s1H/
yN7+UcgyRvpppJ9G/SOj/pHdcY8eL9Ie0fkn8T+zUf/I3v5ROFM10k8j/azUP6rUP6qhfzTTW4Q9
Iv5nJv5nrtQ/qt/+0fdzVEk/K+lnJf9ZyX/W6D+Tv5L8Z6X8Xsl/VvKf9fv9cU94JV2T9LOS/6zk
P2v0nyl7kfaI8nsl/1mpf1S/39/x/RxV0k/if+ZK/aNK/aPa4h6JF2mPyH9W8p+Vzj+d/7nNM1TS
T+J/5krnn5XOP+uIe+TXpPNP4n9m4n/mSv2j+j7/HmZOKulnJf2s1D+q1D+qV9wj9SLtEZ1/Ev8z
V+ofOf9zmwuqpJ+V9LNS/6hS/6g+cY/Mi7BHjfpHjfpHjfpHDfghuZF+NtLPRv2jRv2jluMeVS/C
HjXqHxH/MxP/Mzfgh2Tif2bif2bif2bif+bI/5ypeZH2CObnM/E/M/E/cwN+XSb+Zyb+Zyb+Zyb+
Z478z5m6F2mPYH4+E/8zE/8zE/8zE/8zE/8zE/8zE/8zR/7nTMOLtEfw/FEm/mduwE/Ozv/cZokb
6Wcj/WzUP2rUP2pn3KPpRdojeP49E/8zN+ofNeofNdLPRvrZqH/UqH/U7rhHpxdpj6h/1Kh/1Kh/
RPzPTPzP3Kl/RPzPTPzPTPzPTPzPHPmfM11ehLUT/zMT/zN30k/if2bif2bif2bif2bif2bif2bi
f+a+6eftRVo76SfxPzPxP/OX/zm/akP8z0z8z0z8z0z8z9w3/Xy8CJ/NTuefxP/MnfJ7p/zeqX/U
3+/fPMLaqX/UqX/UqX/UqX/UY/8ov0VaO/CXMvE/cwf+Uu6kn538p/M/t7+bnfxnJ//ZyX928p89
+s/sryT/2eH7NzPxP3O/ae10/tnh+zez8z/3tcP3b+ZO+tnh+zdzh+/fzOOIa89ehLWPTT/Ni7D2
Qc8fjff738OKBj1/NOj5o0HPHw16/miE549mFi+CLg34/vc86PxzUP+I+J95UH53/uemyYPy+6D8
Pii/D8rvI+b37Nek/D7g+fdM/M88KL87/3NfEeX3Qfl9UH4flN9HzO9ZvUjvT+CH5EH+c1B+H+/8
UvC0g/L7oPw+KL8Pyu8j5vfsnyPK74P0c5B+DtLPAd9/lAfp5yD9HKSfg/RzbPpZvUh7RPo5SD8H
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
L21DBPrvQvxPEei/i0D/XST233V6kdYO/XcR6L+LUH4X8p9C+V0arZ3yO/E/RSi/C+V3ifldTy/S
2im/C+V3GbTv5D+F8rtQfhfK70L6KZTfhfK7xPyulxdp7cCvE6H8LsBfEud/xs6ICPCXREg/BfhL
IsBfEon8Jb29COdLAvw6If6nEP9TygF7RPxPIf6nEP9TiP8pZfOfjxdhj4j/KcT/FOJ/CvE/hfif
EvifEl5Jayf/SfxPIf6nRP7ntLdIayf/SfxPKQr7Xkg/C/nPAv0jKeQ/C/nPQv6zkP8s0X/a+0pa
O8x/CvE/hfif8vI/42eT+J9C/E8h/qcQ/1M2/qf57wnzn0L8TyH+pxD/U778z2/XUoj/KcT/FOJ/
CvE/ZeN/mniR9ojOP4n/KYXOPwvl90Lnn+WmtdP5ZyH/Wej8s9D5Z4nnn+bXpPNPpfNPpfNPhfkl
UZhfEo3zS6ZehPeSJngvKflPJf/p/M/tfir5TyX9VPKfSv5To/808yLdT/KfSv5TYf5TiP8pSv7T
+Z+bMij5TyX9VPKfSv5To/+06kVaewWtU/KfCs8fiX75dV/1Vnj+SJT0U6H/Lgr9d9HYf7fmRXp/
0vmnUn7f+Z/+DiH/qTD/KTpo7TD/KUr5XWH+UxTmP0Xj/Kd1L9La6fxTKb/v/E9fO+kn8T/ly/+M
n2Lyn8T/FOJ/CvE/ZeN/2vAirR2+/12I/ynE/5SX/xm+QViI/ynE/xTifwrxP2Xjf9r0Inw2Debn
hfifQvxP+fI/g6sk/qcQ/1OI/ynE/5SN/2mnF2GPjPST+J9C/E/58j9zWBHpJ/E/hfifQvxP2fif
dnmR9ojyO/E/xSi/G+V3o/xujdZO+d0ovxvld6P8bjG/2+1FWjvldyP9NMrvxP8UI/9pk9ZO/tPI
fxr5TyP/aZv/fLxIayf/SfxPMfKfRv7TyH86/zNyiYX4n0L8TzHyn0b+06L/rG8R1l4P0KVK/rMC
v07qAbpE/E8h/qdU4NdJBX6d1Mivq/5K4NdJpf5RJf9ZyX9W8p81+s/qd4n8Zy3wt7iS/6wwPy/O
/9zvJ8zPS6X8XmF+XirMz0uN8/NVvEj3E55/l0r5fed/+tpJPyv5z/r6z6AMlfxnJf9ZyX9W8p81
+s/q1yT/ufM/fd/Jf1bqvzv/c8sIlfrvlfSzUv+9Uv+9xv57VS/S+/Okzzv13ys8vynO/9ycVYXn
N6WSflZ4flMqPL8pNT6/Wf29BM9vys7/fF9J95P6R/XLT67hlbRH5D8b9Y8a9Y9a7B/V6kXYo0b9
I+J/CvE/hfifsvE/a/Mi3M9G55/E/xTif0oTuJ/E/xTifwrxP4X4n7LxP2v3It1POv8k/qc0mJ+X
Rv6z0flng+ffpdH5ZyP9bHT+2ej8s8Xzzzq8SGun/nsj/dz5n+ZF+j2p/96+378p4ZW0dtLPRv33
Rv33FvvvdXqR1j7h7xHxP6UBf0mc/7lpXQP+kjTSzwb8JWnAX5IW+Uv19CJ9NoG/JMT/FOJ/CvE/
ZeN/1suLdD8fup80v9Tg+U1x/ud2Pzs8vymd/Gen889O5589nn/W24twPzv13zudf+78T/Mi/Z6U
353/ua+d8nun/N4pv3fK7z3m9/p4kdZeaO2U3zt8f5wQ/1OI/ykv/zOmHuJ/CvE/hfifQvxP2fif
3yKtnfI78T+lU37v1H/vlN876Wen/N4pv/eY39v7Svhsdnj+XTrl907nn87/bMn0+0o6/yT+p3Q6
/+x0/tnj+Wfz35POPzs8fySdzj87zX86/3Pz3p3mP4n/KZ30s5N+9qifTbxIe0Tzn8T/lE7nn538
56Dzz0Hnn4POP4n/KYPOPwedf454/tn8mnT+Oaj/Pkg/R4Z9H+Q/B/lP53/uayf/SfxPGeQ/B/nP
Ef1nUy/S2sl/DtLPQf5zkP8c5D8H+c9B/nOQ/xzkPwf5zxH9Z/M9Iv85qP8+yH8O6r8P6r8P6r8P
6r8P6r8P6r+P2H9v1YugSwP4SzIovw/K74Py+4j5vTUv0v08wYcQ/1MG5Xfnf+73k/L7oPw+KL8P
yu8j5vfWvUj3k+Y/B+X3AfwQIf6nDPKfzv/8cy5fZZjkPyf5z0n+c5L/nNF/tuFFWPsEfohM8p+T
+u/O/9yc1aT++yT9nHT+Oen8c8bzzza9CO/PCfwQIf6nEP9T5vf8M6yIzj+J/ynE/xTif8rG/2yn
F2mPjPaI9HPS80fO/9yc1aTnjyb5z0nPH016/mjG54/a5UXaI3r+aJJ+Tjr/JP6nTDr/dP7n/v6k
889J+jlJPyfp59z08/YirZ2eP5qkn5P8J/E/hfif8vI/t7WT/yT+pxD/U4j/KRv/sz1epLWT/yT+
p0ya/5zkP0/yn87/3N7zJ/lP4n/KSf7zJP95Rv/Z3yKs/aT++0n+86T8fmbQpZPyO/E/5aT8flJ+
P2N+7/5Kyu8n5feT8vtJz2+e9PzmGZ/f7H6X6PnN08CHnJTfT+DPi/M/9/sJ/Hk5qX90An9eTuDP
yxn58128SPeTnj86Kb+fwF8S4n/KCfwlcf7npgwn8JfkpPx+An9JTuAvyRn5S92vCfwlOSd83k/q
v5/0/JHzP7fMddLzRyfp50nPH530/NEZnz/q6kV6fwJ/SU6aXzqBvyTO/9wVDPhLQvxPOYEfIifx
Q67ID+nmRdijC/jzcpF+XgnWflH/6AL+vDj/c1v7Bfx5If6nXMCflwv483JF/nyvXqS1A39eLsrv
F/nPi/znRf7T+Z/72sl/XuQ/L/KfF/nPK/rP3rxIa6f++0X+86L5T+J/ykX9d+d/bp/ii/rvF+X3
i/rvF/Xfr9h/792LtPYOunSR/7zIf17w/cVykf+8yH9e5D8v8p9X9J99eBF06SL/eZH/vMh/Ev9T
iP8pX/5nXDv5T+J/CvE/hfifsvE/+/QirZ38J/E/5aLzz4v8503+0/mfW9K/yX/epJ83+c+b/Oe9
+c/Ti7D2m/pHN+nnTf7zpv7RTf7zJv95k/+8yX/em/+8vAifzZvmP2/ynzfNfzr/c1Pam+Y/bzr/
vGn+86b5zzvOf/bbi7RHNP95k37e1D8i/qfc1D9y/ue+duof3eQ/b+of3dQ/umP/qD9epLXT/Cfx
P+Wm+c+b9POm+U/nf+5rp/lP4n/KTfOfN81/3nH+c7xFWjvNf950/nlftO+knzfNfzr/c9clmv+8
6fzzpvnPm+Y/7zj/Od5Xwtofmv986PzzofnP5zv/+f0r89D850P+86H5pYfml544vzT896T5pYfm
Px86/3zg+zuE+J9C/E9x/ue2m8T/FOJ/CvE/hfifsvE/h3iR1k7PbxL/U4j/KS//M3YHiP8pxP8U
4n8K8T9l438Ovyb1jx7qHxH/Ux7qHz3v93eETv1D/aOH8vtD/aOH+kdP7B8N9SLtEfWPiP8pD3x/
nDzUf39oful5vz8u7ibNLxH/Ux6aX3pofumJ80vD33U0v/TQ/BLxP+W56bNJ+f2h/O78z33tlN+J
/ynE/xTif/7v4mHt1Yv/rr0ckN8L8T/LAfm9HKCf5YD8Xpz/Gd/z5YD8Xg7wn+WA/F4OyO/liPl9
NC/S2oFfV4j/WYj/WZz/GZW2EP+zEP+zEP+zEP+zbPzP0b34ry4V4n8W4n+WA/pH5QD9LAf0j8rx
5deF3YT+USH+Zzmgf1QO6B+VI/aPxvAirR3OP8sB+lkOOP8szv+Mn81ywPlnIf5nOeD8sxxw/lmO
eP45phfp/Qnnn4X4n+WA88/i/M/ogsoB55/lgPxeDjj/LAecf5Yjnn+O04u0R8BfKgfoZ9n5n76b
4D/LAfPzxfmf+27C/Hw5IL+XBPPzJcH8fElxfn5cXoS1J5ifL4n0M0H/vRD/syTovxfnf25rT9B/
Lwn8Z0nQfy8J+u8lxf77uL1Ia4fn30sC/1kS8JcK8T9LgvxeksJ7PkF+Lwn8Z0mQ30uC/F5SzO/j
8SKtHc4/S4L8XhKcf5ZU4e9mgvPPksB/lgTnnyXB+WdJ8fxzvkXQJeJ/FuJ/lgTz8yXB/HxJcX5+
vq+k+wnz8yWB/ywJ/Gdx/ud+P8F/FuJ/lgT+syTwnyVF/zl938F/lgT+sxD/syTwnyWRfibwnyXd
tHbwn4X4nyWB/yyJ/GeO/nOKF2Htmfwn8T9LJv+ZST8z+c/89Z9fZcjkP4n/WTL5z0z+M0f/Of2a
5D8z+U/if5ZM/jOT/8zkPzPpZyb/mcl/5ug/p3oRPpuZ/Gcm/5lhfr5kmJ8vOc7PT79LMD9fMpx/
lkz+M8P5Z8kwP18ynH8W4n+WDOefJcP5Z8nx/HNWL9L9hPn5ksl/ZpifLxm+v7hkmJ8vxP8sGebn
S4b5+ZLj/PxsXqQ9gv5RIf5nydA/Khnm50uG/lHJpJ8Z+kclQ/+o5Ng/mt2LtEfQPyqZ9DND/6gQ
/7MI9I+K8z+3tQv0j4qQfgr0j4pA/6hI7B/N4UVYu8D8fBHST4H5+UL8zyIwP1+c/7mvHebni5B+
CszPF4H5+SJxfn5OL9LaYX6+CPTfi8D8fCH+ZxE4/ywC8/NF4PyzCOV3gfPPInD+WSSef87Ti7R2
OP8sQv5T4PyzCJx/FoHzzyKU3wXOP4vA+WeReP45Ly+CLgmcfxbifxYh/ymkn0L+U8h/CvlPIf8p
5D+F/Kds/vP2Iq2d/KeQfgr5T+J/FiH/KeQ/hfynkH4K+U8h/1k2//l4EdZeyH8S/7OUBGsv5D8L
+c9C55+F/CfxP0sh/1nIf5boP8+3SGuH+aVC/M9SYH6pFMrvBeaXivM/N/UuML9UiP9ZCswvlQLz
S6XE+aXTXwnzS6XA93cU4n+WQuefpYImFzr/LOQ/C51/Fjr/LPH88/Tfk84/d/6nvz9JPwudfzr/
M85ylELnn4X8Z6Hzz0LnnyWef57iRdoj4M8X4n+WAs8flUL6WeD5o1Lg+aNS4PmjQvzPUuD5o1Lg
+aNS4vNHp18Tnj8qBZ4/KsT/LAWePyqF9LPA80fF+Z/b2hWePyrE/yzE/yzE/ywb//NUL8LaFZ5/
L8T/LArz80VJPxXml4rC/HxRmF8qCv33ojC/VBTml4rG+aXTvEhrh/mlQvzPQvzPosCfL8T/LMT/
LMT/LMT/LBv/86xeBF1SmF8qxP8sSvldST+V8rtSflfK70r5XSm/K+V3jfn9bF6ktVN+J/5nIf5n
efmfUZOJ/1mI/1mI/1mI/1k2/ufZvUjvT+B/FuJ/FgX+fCH+ZyH+ZyH+ZyH+ZyH+ZyH+ZyH+Z9n4
n+fwIq0dvv+oEP+z2AF/j4z002B+qRjMLxWD+aVi5D8N5peKwfxSsTi/dE4vwtoN+EvFKL8b5XeD
59+LUX438p9G+d0ov1vM7+fpRfhsGuV3I/9p5D+N/Kdt/vPyIt1P6r8b+U8j/+n8z/1+kv8k/mcx
8p9G/tM2/3l7ke4nPL9ZjPynwfx8MeofGczPF+d/7muH+flC/M9iMD9fDObni8X5+fPxIq0d5ueL
kf800k8j/TQ6/zT4/rhidP5J/M9idP5pdP5p8fzzeou0djr/NPKfRuefRvpZ6fyzAj+kVDr/rJTf
K51/Vjr/rPH883pfCWuv5D8r+c9K/rOS/6zkPyv5z0r+s5L/rNF/Xv57kv+s5D8r+c9K/rPC/Hyp
5D8r+c9K/rOS/6zRf17iRdoj8p/E/yy1gi5V0s9K/rN+/WfYTfKflfxnJf9ZyX/W6D8vvyb5z0r+
s5L/rOQ/67d/9HXUlfxnJf9ZyX9W8p81+s9LvUjvz5Pen6SflfTT+Z+7hpB+VtLPSvpZST/rpp/+
XiL9rKSflfSzkn4S/7M00s9G+tlIPxvpZyP9bKSfbdPP6kVYe6P+USP9JP5nIf5nIf5nafD9R4X4
n4X4n4X4n4X4n2Xjf17Ni7R24NcV4n+WBvy64vzPTWkb8OtKo/57o/57o/57i/33q3sRPpuN8nsj
/Wykn430s5F+Ev+zNNLPRvrZNv0cXqQ9guePSiP9bPD8UWnkPxs8f1Sc/7mdwjV4/qg0Ov9s8PxR
afD8UWnx+aNrepHWDs8flUb5vcHzR4X4n6XB80fF+Z/72uH5o9Lo/LPB80elwfNHpcXnj67Ti7D2
Dt9/VIj/WfoB+95JPzt8/3vpCd7zHb7/vRD/s3T4/vfS4fvfS4/f/35dXqS1C+gS8T9Lh+ePivM/
N6Xt8PxR6dQ/6vD8Uenw/FHp8fmj6/Yi6FKn/nsn/9mp/+78z0jGKJ36753ye6f+e6f+e4/99+vx
Iu0R8JNLp/57p/nPTvOfPc5/3m+R7ifl9075vVN+78BfKp3yeyf97JTfO+X3HvP7/b6S7ifl9075
vZP/JP5nIf5nefmf8a828T8L8T8L8T8L8T/Lxv+8/fck/9mpf0T8z9Kpf+T8z03BBvWPBunnoP7R
oP7RiP2jW7wI788B3x9XBunnoPn5QfPzg+bnif9ZBs3PD5qfH3F+/vZr0vz8oPn5Qfo5aH5+UH4f
lN+d/7llhEH5nfifZVB+H5TfR8zvt3qR1g7f31EG5fdB8/MDvr+jDJqfJ/5nGaSfg/RzbPrpvyfp
56D5+UH6OSi/D/Kfg/K78z/3dzLl90H5fVB+H5TfR8zvd/UirZ3OPwfp54DvjyvE/yyD+kcDvr+4
DOofDeofDeofDeofjdg/upsXae3UPxqU3yf1j4j/WSb1j5z/uU2GT+ofTeofTeofTeofzdg/ursX
Ye2T8jvxP8uk/D6pfzQpv0/K75Py+6T8PmN+v4cXQZd2/qfvEeX3Sfl9An++TMrvk/L7pPw+Kb/P
mN/v6UXaowrvT+J/FuJ/FuJ/lo3/eZ9epPtJ80vE/yyT5pcm8OvKpPmlSfo5aX5p0vzSjPNL9+VF
up80vzQpv0/4/qNC/M8yaX5p0vzSpPmlSfo5aX5p0vzSjPNL9+1FWjs9vzkpv096ftP5n/vnnZ7f
JP5nOen5zZOe3zzj85v340V4f540/3mSfp40/+n8z02TT5r/JP5nOWn+86T5zzPOfz5vEfboFNij
k/TzpOePnP+5Of+Tnj8i/mch/mch/mfZ+J/P+0raI3r+iPif5ST9PEk/z6ifj98l0s+T+kcn6edJ
558nnX+edP5J/M9y0vnnSeefZzz/fMSLdD/p/JP4n+Wk88+T8vtJ558nfP97Oen8k/if5aTzz5PO
P894/vn4Nen886Tzz5P086Tzz5Py+0nnnyd8/3s56fzzJP086fzzpPPPM55/PupFWPtF/vMi/3mR
/3T+5/a3+CL/SfzPcpH/vMh/XtF/Pv57kv+8yH9e5D8v8p8X+c+L/CfxP8tF/vMi/3lF//lUL9Ie
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
VIX5T3X+Z605hVfSNUk/FeY/VWH+U3WEPervK2mPyH8S/1MV+PPq/M+/Fen3laSfSvqpwJ9XBf68
6hX3KHuR9oj6R0r9I4X5eXX+59+KwueI9FNJPxXm51Vhfl71iXskXoQ9MuofEf9Tif+pzv/8W9H1
fSXpJ/E/lfifSvxPDfzP/33VrBdhj4z6R8T/VOJ/qvM/a5UUXknXJP0k/qcS/1MD//NvRepF2iPq
HxH/Uw2e31Tnf/6t6Ps5MtJPI/006r8b9d8t9t+7eZH2iPpHxP9Uo/678z//VtTDK+mapJ9G/Xej
/rvF/nuvXqQ9ovxulN+N8ru9+V3C54j000g/jfK7UX63mN978yLtEfWPiP+pxP/Ul//5P5z695V0
TdJP4n8q8T/VYv+9dy/SHgG/Ton/qUb+k/ifSvxPdf7ndhJF/E8l/qcS/1OJ/6k15vc+vAhrr+Q/
if+pxP9U539up4XE/1TifyrxP5X4n1pjfu/Ti/D+rOQ/if+pxP/U+ub3cKJL/E8l/qcS/1OJ/6k1
5vd+epH2iPwn8T+1Un6vb34Pp+6V8nul/F4pv1fK7zXm9355kfaI/Gcl/1kpv9c3v4fOSKX8Xim/
V8rvlfJ7jfm9316kPSL/Wcl/Vsrvzv/culeV8nul/F4pv1fK7zXm9/54kfaI/Gcl/1kpvzv/c+sw
VtJP4n/+xSPYo0b5vcX8Pt4i7FEj/9nIfzbK787/3LrAjfST+J/aKL83yu8t5vfhr6T8TvxPJf6n
Nsrvzv/cOvWN9LORfjbK743ye4v5fWQv0h6R/yT+pzbK7+3N72GaopF+NtLPRvm9UX5vMb8P8SLt
EflP4n9qo/zu/M9t4qWRfjbSz0b5vVF+bzG/D78m5fdG/rOR/2yU353/uU0lNdLPRvrZKL83yu8t
5vehXqQ9Iv9J/E8l/qc6/3ObHCP+pxL/U4n/qcT/1Bbz+zAvwh51yu/E/9RO+b2/+T2cvnbSz076
2Sm/d8rvPeb3Ub0Ie9Qpv3fK753ye3/ze9HwSrom6Wen/N4pv/eY30fzIu0R5fdO+b1Tfu9vfv/y
WLSTfnbSz075vVN+7zG/j+5F2iPK753ye6f83t/8Xq7wSrom6Wen/N4pv/eY38fwIu0R5fdO+b1T
fu/f/nv4HJF+dtLPTvm9U37vMb+P6UXaI8rvxP9U4n+q8z//VhQ+R6SfxP9U4n8q8T+1x/w+Ti/S
HtH8J/E/lfif2t/5+fpVb+J/KvE/lfifSvxPHXF+flxehD0a8P1xSvxPHeQ/B/nPQfnd+Z/byfOg
/D4ovw/K74Py+4j5fdxepLWT/yT+pxL/U53/uXUHiP+pxP9U4n8q8T91xPw+Hi/C+3OQ/yT+pxL/
U53/uXVwiP+pxP9U4n8q8T91xPw+3yLtEflP4n/qoPw+3vweumyD8vug/D4ovw/K7yPm9/m+kvaI
/Ocg/zkovzv/c+uEDsrvxP/UQfl9UH4fMb/P7EXaI/Kfg/znoPzu/M+tWz0ovxP/Uyfl90n5fcb8
PsWLsEfE/1Tif+qk/O78z22iYJJ+TtLPSfl9Un6fMb9Pvybld+J/KvE/dVJ+n+/zm6HLNkk/J+nn
pPw+Kb/PmN+nepH2iPwn8T91Un53/uc2xzJJPyfp56T8Pim/z5jfp3mR9oj85yT/OSm/zze/h1mj
Sfo5ST8n5fdJ+X3G/D6rF2mPyH9O8p+T8vt883uYB5ukn8T/1En5fVJ+nzG/z+ZF2iPyn5P856T8
Pt/8Hmb2Jukn8T91Un6flN9nzO+zexH26CT/eZL/PCm/O/9zm6s8ST+J/6kn5feT8vsZ8/scXoQ9
Oim/n5TfT8rvzv/cZl9P0k/if+pJ+f2k/H7G/D6nF2mPKL+flN9Pyu/O/9zmk0/ST+J/KvE/lfif
esb8Pk8v0h5Rfif+pxL/U8/3+feq4ZV0TdJP4n8q8T/1jPl9Xl6kPaL8TvxPPSm/n9/++9cznKSf
J+nnSfn9pPx+xvw+by/SHlF+Pym/n5Tfz/f599rDK+mapJ8n5feT8vsZ8/t8vEh7RPn9pPx+Un4/
v/n964Iu0k/if+pF+f2i/H7F/H6+Rdiji57fvCi/X/T8u/M/t6c2LtJP4n/qRc+/X/T8+xWffz/f
V8IeXfD9HXrR85sX+c+L/OdF+f16+++hJ3VRfif+p16U3y/K71fM72f2Iq2d/OdF/vOi/H69/ffQ
N7wovxP/Uy/K7xfl9yvm91O8SO9P8p/E/9SL8vv17b/P8Eq6JuX3i/L7Rfn9ivn99GtSfr/If17k
Py/K7xf13y/K7xfl94vy+0X5/Yr5/VQv0h6R/7zIf16U36+3/x46oRfl94vy+035/ab8fsf8fpoX
YY9u8p83+c+b8vv97b9/leGm/H5Tfr8pv9+U3++Y38/qRdijm/znTf7zpvx+v/33MJlzk37epJ83
5feb8vsd8/vZvEh7RP7zJv95U36/3/57mJ66ST9v0s+b8vtN+f2O+f3sXqQ9Iv95k/+8Kb87/3Ob
cLtJP2/Sz5vy+035/Y75/RxepD0i/3mT/7wpvzv/c5tCvEk/b9LPm/L7Tfn9jvn9nF6kPSL/eZP/
vCm/3+/8fJiSvUk/b9LPm/L7Tfn9jvn9PL0Ie/SQ/3zIfz6U35+3/x4mmR/Sz4f086H8/lB+f2J+
Py8vwh495D8f8p8P5ffnOz+v4ZV0TdLPh/L7Q/n9ifn9vL1Ie0T5/aH8/lB+f9783r7Z8CH9fEg/
H8rvD+X3J+b38/Ei7RHl94fy+0P5/Xnzezh9fUg/H9LPh/L7Q/n9ifn9eou0R5TfH8rvD+X35+XX
tfCuI/18SD8fyu8P5fcn5vfLX0n5/aH8/lB+fyi/P29+b0EZSD8f0s+H8vtD+f2J+f3KXqQ9ovz+
UH5/KL8/b35vr3rbAfr5V/z3mnZAfrcD8rsdMb9f4sV/98gOyO92QH63A/K7Of8zPuNgB+inHaCf
dkB+twPyux0xv19+TcjvdkB+twPyuxH/04j/aQfkdzve/vt3PsQOyO92QH63A/K7HZDf7Yj5/VIv
0trBf9oB/tMOyO92vP33uJuQ3+2A/G4H5Hc7IL/bEfP7ZV6k9yf4TzvAf9oB+d2c/xnnrOyA/G4H
5Hc7IL/bAfndjpjfr+pF2iPwn3aA/7QD8rs5/zPOwtkB+d0OyO92QH63A/K7HTG/X82LtEfgP+0A
/2kH5Hdz/mecV7QD8rsdkN8tQX63BPndUszvV/ci7FEC/2kJ/KclyO/m/M84U2oJ8rslyO+WIL9b
gvxuKeb3a3gR9iiB/7QE/tMS5HdLb37/zv1aIv1MpJ8J8rslyO+WYn6/phdpj8B/WgL/aQnyu6Xv
/PzzfSXpZyL9TJDfLUF+txTz+3V6kfYI/Kcl8J+WIL9bevvvPbzrSD8T6WeC/G4J8rulmN+vy4u0
R+A/LYH/tAT53dLbf+9fZUikn4n0M0F+twT53VLM79ftRdoj8J+WwH9agvxu6e2/9x5eSdck/UyQ
3y1BfrcU8/v1eBH2KJP/zOQ/M+R3y2//vX//wmbSz0z6mSG/W4b8bjnm9/stwh5l8p+Z/GeG/G75
7b+PFF5J1yT9zJDfLUN+txzz+/2+kvYI8rtlyO+WIb9bfvP7+H6OMulnJv3MkN8tQ363HPP7nb1I
ewT53TLkd8uQ3y2/+X308Eq6JulnhvxuGfK75Zjfb/Ei7RHkd8uQ3y1Dfrf89t9zWBHpZyb9zJDf
LUN+txzz++3XhPxuGfK7ZcjvliG/W37z+wjKQPqZST8z5HfLkN8tx/x+qxdpjyC/W4b8bhnyu+U3
v8+vMgjpp5B+CuV3ofwuMb/f5kXYI4H5eRPK78T/NOJ/GvE/7cv//M4eGPE/jfifRvxPI/6nbfzP
u3qR1k7+k/ifRvxPe/mfYT7EiP9pxP804n8a8T9t43/ezYvw/iT+pxH/04j/aS//M8zwGPE/jfif
RvxPI/6nbfzPu3uR9oj8J/E/TSi/y9t//85ZmVB+F8rvQvldKL9LzO/38CLtEflPIf8plN/l7b9/
Z+GM+J9G/E8Tyu9C+V1ifr+nF2mPyH8K+U+h/C5v//07r2jE/zTif1qh/F4ov5eY3+/Ti7BHhfxn
If9ZKL+Xt//+nSk14n8a8T+tUH4vlN9LzO/35UXYo0L+s5D/LJTfy5vfv3O/RvxPI/6nFcrvhfJ7
ifn9vr1Ie0T+s5D/LJTfy5vfv7PZRvxPI/6nFcrvhfJ7ifn9frxIe0T+s5D/LJTfC8zPG/E/jfif
Vii/F8rvJeb35y3SHpH/LOQ/C+V353/GZxyM+J9G/E8rlN8L5fcS8/vjr6T8Xsh/FvKfhfJ7+fLr
rvBKuibpZ6H8Xii/l5jfn+xF2CMl/6nkP5Xyu/M/47NCRvxPI/6nKeV3pfyuMb8/4kXYI6X8rpTf
lfK78z/j81xG/E8j/qcp5Xel/K4xvz9+TcrvSvldKb8r5Xfnf8Zn7oz4n0b8T1PK70r5XWN+f9SL
tEeU35Xyu1J+1ze/f5+LNOJ/GvE/TSm/K+V3jfn9MS/SHlF+V8rvSvldv/k9fI5IP4n/aUr5XSm/
a8zvT/Ui7RHld6X8rpTf9Ts/L+GVdE3ST6X8rpTfNeb3p3mR9gj4daaU35X8p5L/NODXmfM/41SS
GfDrzIBfZwb8OjPg15lFft3TvQhrN/KfRv7TKL/b+/z7d3LMjPK7UX43yu9G+d1ifn+GF+H9aeQ/
jfynUX63t//+nbMyo/xulN+N8rtRfreY35/pRdoj8p9G/tMovxt8f4cZ5Xej/G6U343yu8X8/pxe
pD0i/2nkP43yu/M/40ypGeV3o/xulN+N8rvF/P5cXqQ9Iv9p5D+N8ru9+f0792tG+d0ovxvld6P8
bjG/P7cXaY/Ifxr5T6P8bm9+/85mG/E/jfifVim/V8rvNeb35/Ei7FEl/1nJf1bK7xXm5434n0b8
T6uU3yvl9/rN7+X7P6f8Xsl/VvKflfJ7/fLranglXZP0s1J+r5Tf6ze/l/BK2iPyn5X8Z6X8Xt/8
LmFFpJ/E/7RK+b1Sfq8t7lH2Iu0R+c9K/rNSfq9vfv8+K2TE/zTif1ql/F4pv9cR90i8SHtE/rOS
/6yU3+vbf/8+z2XE/zTif1ql/F4pv9cr7pFfk/J7Jf9ZyX9Wyu/17b9/J5mN+J9G/E+rlN8r5ff6
xD1SL8IeNcrvjfJ7o/ze3v779ylCI/6nEf/TGuX3Rvm95bhH5kXYo0b5vVF+b5Tf2zs//+UaGfE/
jfif1ii/N8rvrcQ9ql6kPaL83ii/N8rv7e2/z7Ai0k/if1qj/N4ov7ca96h5kfaI8nuj/N4ov7c3
v88eXknXJP1slN8b5ffW4x51L9Iebfn9LdL9JP/ZyH82+P5Nc/7nNlPa4Ps3rcH3b1qD79+0Bt+/
ae2Max9epLWT/2zkPxt8f5w5/3Ob+23w/XHW4PvjrMH3x1mD74+z9sT35/QivT/Jfzbyn53ye3/z
e5jN7pTfO+X3Tvm9U37vKe7R6UXYo07+s5P/7JTf+9t/D88OdMrvnfJ7p/zeKb/3Evfo8iLsUSf/
2cl/dsrv/e2/f5/vsE75vVN+75TfO+X3bnGPbi/SHpH/7OQ/O+X3/j7/3sK7jvJ7p/zeKb93yu+9
xz16vEh7RP6zk//slN/7238PHZxO+tlJPzvl9075vc+wR+kt0h6R/+zkPzvl9/7m93l+X0n62Uk/
O+X3Tvm932GPkr+S8nsn/9nJf3bK7/07Px8+R6SfnfRzUH4flN/HEfcoexH2aJD/HOQ/B+X38eb3
M7yS9JP4nzYovw/K7yPm9yRehD0a5D8H+c9B+X28+f0s4ZV0TdLPQfl9UH4fMb8nvybl90H+c5D/
HJTfx5vfz+9ZJfE/jfifNii/D8rvI+b3pF6kPSL/Och/Dsrv483v5xleSdck/RyU3wfl9xHzezIv
0h5Rfh+U3wfl9/F+f1x4sob4n0b8TxuU3wfl9xHze6pepD2i/D4ovw/K7+PN71d8JV2T9HNQfh+U
30fM76l5EfZoUn6flN8n5ff55vfrqwzE/zTif9qk/D4pv8+Y31P3IuzRpPw+Kb9Pyu/zze9fppMR
/9OI/2mT8vuk/D5jfk/Di7RHW35/i3Q/yX9O8p+L//mzdiuwm0bXNLpmpbVXWnuNa59epLWT/5zk
Pxf/82dF7X1/hld2umana3Z6f3Z6f474/jy9SO9P8p+T/Oek/D6/+V3DK+malN8n5fdJ+X3G/J4u
L9Iekf+c5D8n5ff5fv97+Ms1Kb9Pyu+T8vuk/D5jfk+3F2mPyH9O8p8n5ffz/f734C5Oyu8n5feT
8vtJ+f2M+T09XoQ9Osl/nuQ/T8rv55vfgwM8Kb+flN9Pyu8n5fcz5vf8FmGPTvKfJ/nPk/L7+eb3
M76Srkn6eVJ+Pym/nzG/5/eVtEfkP0/ynyfl9/Odnw9J6iT9PEk/T8rvJ+X3M+b3nL1Ie0T+8yT/
eVJ+P9/8HtLuSfp5kn6elN9Pyu9nzO9ZvEh7RP7zJP95Un4/3/weTiRO0s+T9POk/H5Sfj9jfs9+
TcrvJ/nPk/znSfn9fPvv4dToJP08ST8vyu8X5fcr5vesXoQ9ush/XuQ/L8rv15vfw8neRfp5kX5e
lN8vyu9XzO/ZvAh7dJH/vMh/XpTfrze/h9NX4n8a8T/tovx+UX6/Yn7P1Yu0R5TfL8rvF+V3539u
J+TE/zTif9pF+f2i/H7F/J6bF2mPKL9flN8vyu/X+/3voYtB/E8j/qddlN8vyu9XzO+5e5H2iPL7
Rfn9ovx+vf330GUj/qcR/9Muyu8X5fcr5vc8vEh7tOX3t0j3k/znRf5z8T9/1n6/f4vDJ46e37xo
/nPxP3/W/sDaF/9zrX16EdZ+k/+8yX8u/ue+Iud/bl3gm/hLNz2/ufif+4o2/uf7D+X4/jy9CO/P
m/znTf5z8T9/ViS+R6FTfxe6JvGXFv/zZ0WF9kjjHl1epD0i/3mT/7wpv99vfg/TFDfl95vy+035
/ab8fsf8nm8v0h6R/7zJf96U3+83v4eJl5vy+035/ab8flN+v2N+z48XaY/If97kP2/K787/3KaS
bsrvN+X3m/L7Tfn9jvld3iLtEfnPm/znTfn9fvN7mBy7ST9v0s+b8vtN+f2O+V38lZTfb/KfN/nP
h/L78+b3MN33kH4+pJ8P5feH8vsT87tkL8IePeQ/H/KfD+X3583vYQLzIf18SD8fyu8P5fcn5ncR
L8IePeQ/H/KfD+X3583vYUr2If18SD8fyu8P5fcn5nfxa1J+f8h/PuQ/H8rvD3z/uz2knw/p50P5
/aH8/sT8LupF2iPynw/5z4fy+/Pm9zBt/pB+PqSfD+X3h/L7E/O7mBdpj8h/PuQ/H8rvzv/cngh4
SD8f0s+H8vtD+f2J+V2qF2mPKL8/lN8fyu/O/9wYmA/p5wP6+b+78M+K/or/7lE9Yn6X5sV/96ge
W35/i//ez0r8z0r8z3oA/7Me3+/vSOGVdE3oH1Xif1bif9bA//xbe/cirR38ZyX+Z138z58VlX9z
cT1g/rMe0D+qi//5syL99/1ZF/9zrWh48d/3Zz3Af9YD/Gdd/M+fFdV/zy7qAfOf9YD5z3o02qNG
e9TiHk0v0h6B/6wH+M+6+J8/K+r/ni/VA57frAfMf9bF//xZ0aA9mnGPTi/SHoH/rAf4z7r4nz8r
Ov89A6wHPL9ZD3h+sy7+58+KLtqjK+7R5UXaI/Cf9QD/WQ/I79X5n/Gcth6Q3+sB+b0ekN/rAfm9
ppjf5fYi7FEC/1kT+M+aIL/X9M3vZ3glXZP0M0F+rwnye00xv8vjRdijBP6zJvCfNUF+r+nN799+
R02kn4n0M0F+rwnye00xv5e3SHsE/rMm8J81QX6v6c3vZ3wlXZP0M0F+rwnye00xv5f3lbRH4D9r
Av9ZE+T3mt78/u0b1kT6mUg/E+T3miC/1xTze8lepD0C/1kT+M+aIL/X9Ob3b2+3JtLPRPqZIL/X
BPm9ppjfi3iR9gj8Z03gP2uC/F4T9N9rIv1MpJ8J8ntNkN9rivm9+DUhv9cE/rMm8p8Z8nvN7/z8
d0aiZtLPTPqZIb/XDPm95pjfi3oR9ihDfq8Z8nvNkN9rfvP79yy9ZtLPTPqZIb/XDPm95pjfi3kR
9ihv+f0t0v0k/0n8z0r8z/ryP0PmqsT/rMT/rMT/rMT/rDk+f1SqF2nt5D+J/1mJ/1m//M9vLq7E
/6zE/6zE/6zE/6w5Pn9Umhfp/Un+k/iflfif9eV/hrOLSvzPSvzPSvzPSvzPGviffyvqXqQ9Iv9J
/M9K/M/65X9+z5cq8T8r8T8r8T8r8T9r4H/+rWh4kfaI/CfxPyvxP+uX//k9A6zE/6zE/6zE/6zE
/6yB//m3oulF2CMh/0n8zyqU353/Gc9pq1B+F8rvQvldKL9LzO/l9CLskZD/FPKfQvnd+Z/xLL0K
6aeQfgrld6H8LjG/l8uLtEfkP4X8p1B+lze/f/sdVUg/hfRTKL8L5XeJ+b3cXqQ9Iv8p5D+F8rt8
8/v31EhIP4X0Uyi/C+V3ifm9PF6kPSL/KeQ/hfK7vPn92zesQvoppJ9C+V0ov0vM7/oWaY/Ifwr5
T6H8Lm///dvbrUL6KaSfQvldKL+XmN81eRH2qJD/LOQ/C+X3Av33Wkg/C+lnofxeKL+XmN81exH2
qJD/LOQ/C+X38s3v35O9QvpZSD8L5fdC+b3E/K7iRdojyu+F8nuh/O78z/jsQC2kn4X0s1B+L5Tf
S8zv6tek/F62/P4W6X6S/yT+ZyX+Z335nzFzEf+zEv+zEv+zEv+zlji/pOpFWjv5T+J/VuJ/1vLO
L4VcTPzPSvzPSvzPSvzPWuL8kpoX6f1J/pP4n5X4n/Xlf8azC+J/VuJ/VuJ/VuJ/1hKfP9LqRdgj
4n9W4n9W4n/Wl/8Zz5eI/1mJ/1mJ/1mJ/1k1Pn+kzYuwR8T/rMT/rMT/rC//M54BEv+zEv+zEv+z
Ev+zanz+SLsXaY/IfxL/sxL/s778z3hOS/zPSvzPSvzPSvzPqjG/6/Ai7RH5T+J/VuJ/1i//M5yl
E/+zEv+zEv+zEv+zaszvOr1Ie0T+k/iflfif9eV/xn4H8T8r8T8r8T8r8T+rxvyupxdpj8h/Ev+z
Ev+zfvmfoSdF/M9K/M9K/M9K/M+qMb/r5UXaI/KfxP+sSvldv9+/+f0cGemnkX4a5Xej/G4xv+vt
RdgjI/9p5D+N8ru9+T30do3000g/jfK7UX63mN/18SLskZH/NPKfRvndqP9upJ9G+mmU343yu8X8
bm+R9oj8p5H/NMrv9ub3cPJspJ9G+mmU343yu8X8bu8raY+2/P4W6X6S/yT+ZyX+Z335n9HPE/+z
Ev+zEv+zEv+zWpxfsuxFWvtJayf/aaSfRvpppJ/O/9zfyaSfRvpppJ9G+mlRP028SGsn/TTSTyP9
NPj+4lpJPyvpZyX9rKSfNeqn+TVJPyvpZyX9rKSf9aufPbySrkn6WUk/K+lnjfpp6kXYo0r6WUk/
K+lnfc8/w1/tSvpZST8r6Wcl/aybfpoXaY9IPyvpZyX9rK9+BmdVST8r6Wcl/aykn3XTz+pF2iM6
/6ykn5XOP+t7/hncbyX/Wcl/Vjr/rHT+WeP5pzUv0h7R+Wel889K55/O/9wSSiX9rKSflc4/K51/
1nj+ad2LtEd0/lnp/LPS+Wd955dCiqykn5X0s9L5Z6XzzxbPP214Efao0flno/PPRuef7T3/DEm/
kX420s9G55+Nzj9bPP+06UXYo0bnn43OPxudfzr/czuNaaSfjfSz0flno/PPFs8/7fQi7RGdfzY6
/2x0/tm+80tneCVdk/Sz0flno/PPFs8/7fIi7RHNLzU6/2w0v+T8z+1Us5F+NtLPRvNLjeaXWpxf
stuLtEfkP4n/WYn/WV/+Z/TzxP+sxP+sxP+sxP+sG//THi/SHm3zS2+R7if5z0b+s9H5Z3u//yju
Jp1/Njr/bHT+2ej8s8Xzz/oWYe2d/Gcn/9np/LN/zz+/n7hO55+dzj87nX92Ov/s8fyz+ivp/LOT
/+zkPzudf/bv+WcLr6Rr0vlnp/PPTuefPZ5/1uxF2iPyn538Z6fzz/7yk8Nfrk7nn53OPzudf3Y6
/+zx/LOKF2mPyH928p+dzj/7e/55xlfSNen8s9P5Z6fzzx7PP6tfk84/O/nPTv6z0/lnf7//KDjA
Tuefnc4/O51/djr/7PH8s6oXaY/If3byn53ye3/PP4NL76SfnfSzU37vlN97zO/VvEh7RP6zk//s
lN/7d37pm6QG6ecg/RyU3wfl9xHze61ehD0a5D8H+c9B+X1887uGV9I1ST8H5fdB+X3E/F6bF2GP
BvnPQf5zUH4f3/z+/RwN0s9B+jkovw/K7yPm99q9SHtE/nOQ/xyU3wc9fzRIPwfp56D8Pii/j5jf
6/Ai7RH5z0H+c1B+d/7ndrI3SD8H6eeg/D4ov4+Y3+v0Iu3R5j/fIt1P6r8T/7MOeH6zOv9zXzvN
zw/ynwOe36wDnt+sIz6/WU8v0trJfxL/sw54frOOh96fND8/aH5+0vObk57fnPH5zXp5Ed6fxP+s
xP+sE/hLdQJ/qU6an580Pz+Bv1Qn8JfqjPylensR9oj4n5X4n3UCf6nOAjo/4fn3Oml+fgJ/qU7g
L9UZ+Uv18SLtEfnPSf5zAn+pToO/xROef68Tnn+vE/hLdQJ/qc7IX/oWaY/If07yn5Pml2YHvzSp
fzSpfzRpfmnS/NKM80vtfSXtEfnPSf5z0vzS/PKTw+eI9HOSfk6aX5o0vzTj/FLLXqQ9Iv85yX9O
yu/zO78UX0nXJP2clN8n5fcZ83sTL8IeneQ/T/KfJ+X3k+aXTtLPk/TzpPx+Un4/Y35vfk3K7yf5
z5P850n5/aT8fpJ+nqSfJ+X3k/L7GfN7Uy/SHpH/PMl/npTfz29+/yrDSfp5kn6elN9Pyu9nzO/N
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
NIcXaY/o/JP4n61A/6iVd34puN9C+llIP5X6R0r9I439ozm9CHuk1D8i/mdTyu9K+V0pvyv1j4j/
2Yj/2ZTyu1J+15jf5+lFWjv1j5Tyu0L/vSn035vG/vu8vAjvJSX/qaSfSv5Tof/elPynkv9U8p9K
/lM3/3l7ke4n9N+bkn4q6aeSfuqmn48X6X5SflfSTyX9VODXNSX9VNJPJf1U0k+N+nm+RbqfwK9r
SvpJ/M9G/M9G/M/25X8GXSL+ZyP+ZyP+ZyP+Z9v4n+f7Slr7Q2un808l/VTSTyP/aQfsu5H/NPKf
Rv7TyH9a9J9n9iKs3TKs3ch/Ev+zEf+zGeV3o/xulN+N8rtRfjfK7xbz+ylepLVTfif+ZzPyn0b6
aaSfRvpJ/M9G/M9mpJ9G+mlRP0+/JumnkX4a6adR/8iof2TUfzeYX2rE/2zE/2xG/Xej/rvF/vup
XqS1w/xSMzr/NDr/NDr/tHj+eZoX4W+H0fkn8T8b8T+bAT+5Ef+zEf+zEf+zEf+zbfzPs3qR7if1
j4j/2Yj/2Qz4IY34n434n434n434n23jf57Ni7BHxP9sxP9sxP9sX/5nSHzE/2zE/2zE/2zE/2wb
//PsXoQ9Iv5nI/5nI/5ne/mfMZUT/7MR/7MR/7MR/7Nt/M9zeJH2iPST+J+N+J/t5X9GXSL+ZyP+
ZyP+ZyP+Z9v4n+f0Iu0R8JMb8T9bpfPPSuefNZ5/nqcX6X4O0KVK/rPS+Wed4OuI/9mI/9kqnX9W
Ov+s8fzzvLxI9xPm51ul/F5JPyvpZ6X5pXrT2im/V8rvleaXKs0v1Ti/dN5ehLU3mJ9vjfSzkX42
0s+26efjRXgvNZifb8T/bI30s2W4n430s5F+NtLPRvrZon5eb5HuJ+V34n+2Ruefjc4/G51/NqW1
k/8k/mdrdP7Z6PyzxfPP630lrZ3mPxudfzbSz0b62Wh+yfmf21+ZRv6zkf9sNL/UaH6pxfmlK3uR
1k7zS4367436743674367438ZyP/2ch/tug/L/EifTbJfzbyn8T/bMT/bI36R87/3NdO/aNG/aNG
/aNG/aMW+0eXX5P6R436743ye6fzz07nnz2ef17qRXgvdTr/JP5n68Bfav3lLwVl6NQ/6pTfO/CX
Wgf+UuuRv3SZF+F+7vzPt0j3k/xnJ/3s5D97gfcS8T8b8T9bJ//ZyX/26D+v6kVaO80vdfKfnfJ7
p/zeY36/mhfpvUT5vVN+79R/743uJ/XfO/nPTv6zk//s0X9e3Yt0P8l/dvKfxP9sxP9snebn+6S1
U/+o0/lnp/n5TvPzPc7PX8OLtPaL1k7+s5N+dtLPDvz51m9aO+V34n+2Dvz51oE/30bkz1/Ti7D2
ccDaB51/DppfGqSfg/TT+Z/b2gfp5yD9HKSfg/RzbPp5epHWTvo5SD+J/9mI/9mI/9kG6SfxPxvx
PxvxPxvxP9vG/7wuL9LaST+J/9kG9d8H+c9B/fdB85+D+u+D9HNQ/2hQ/2jE/tF1e5HWTv2jQeef
xP9sxP9sg/znIP85SD8H6ecg/znIf47Nfz5epLWT/xzkP4n/2Yj/2Qb5z0H+c5B+DtLPQf5zkP8c
0X/eb5HWTv6T+J9t0vnnpPw+af5zHrB24n824n+2SfOfk+Y/Z5z/vP2VNP85M6x9Un6fNL80aX5p
wvd3tCm0dtLPSfo5qf8+qf8+Y//9zl6ktVP/fVJ+J/5nI/5nI/5ne/mf29pJP4n/2Yj/2Yj/2Tb+
5y1epLXT85vE/2yT8vuk/D5jfr99RZTfJ83PT9LPSfo5ST+J/9mI/9km6eck/ZxRP2/1It1P0s9J
+jlJPyfp5yT9nKSfk/Rzkn5O0s9J+jk3/TQv0tpJPyfpJ/E/G/E/G/E/20n6SfzPRvzPRvzPRvzP
tvE/7+pFWPtJ+kn8z3aSfp6knyfp50n6eZJ+nqSfJ+nnSfp5bvrZvEhrJ/08ST+J/9mI/9lO0s+T
9PMk/TxJP0/Sz5P089z0s3uR1k76SfzPdlJ+Pym/n8Cfb2entZP/JP5nO4E/307gz7cz8ufv4UVa
O/DnG/E/20n5/aT8ftL853nS2kk/if/ZTpr/PGn+84zzn/f0Iq39prVT/+ik/H5Sfj+p/+78z23t
F+nnRfp5Uf/oov7RFftH9+lFWPtF/aOL+kfE/2zE/2zE/2wv/3NbO+kn8T8b8T8b8T/bxv+8Ly/S
2gutnfpHF+X3i/L7Rc+/X0prJ/28SD8vev79ouffr/j8+317kdZeae3UPyL+ZyP+Z7vo/POi88+L
9PMi/bzo/POi888rnn/ejxdp7XT+SfzPdpH/vMh/XnT+edH5J/E/G/E/20Xnnxedf17x/PN5i7R2
Ov+86PzzIv95kf+86PzzovPPi/TzIv286PzzovPPO55/PsmLsPabzj9vOv+8yX8S/7PddP550/nn
Tfp5k37edP550/nnHc8/n+xFWjudf950/nmT/yT+Z7vp/POm88+b9PMm/bzp/POm8887nn8+4kVa
O51/3nT+eZP/JP5nu+n886bzz5v08yb9vOn886bzzzuefz5+TTr/vOn886bzz5v8J/E/2035/ab8
fpN+3qSfN+X3m/L7HfP7o16ktVN+vym/38Cvazfw69od+XWPeRHOQ27g17Wb9PMm/bxf/QwTGjfp
5036eZN+3qSfz6af1YtwPx+an39IPx/4/uL2vN9fHGY1H5r/JP5ne+D7i9sD31/cnvj9xU/zIuzR
Q/7zIf/5UH5/3u8vDvO0D+kn8T8b8T8b8T/bxv98uhdpj2h+ififjfif7eV/xpln4n824n824n82
4n+2jf/5DC/SHpF+Ev+zPeQ/n/f59zDL8ZD/fMh/PuQ/H/KfT/Sfz/Qi7RH5z4f850P6SfzP9pD/
fIhf95D/fMh/PuQ/H/Kfz+Y/Ty/S2mn+8yH/+dD850P8OuJ/NuJ/tofmPx+a/3zi/OdzefHf9+f/
xPmf3fwr/ns//4r/7ns/QD/7AfrZj1c/v+/kTvzPTvzPfoB+9gP0sx+bft5epLULrR30sx+Q3/sB
+b0fMb8/jxf/fS/1A/J7J/5nJ/5nJ/5nJ/5nJ/5nJ/5nJ/5nj/zP9P2f0/2E+c9O/M9O/M9O/M9+
hPPP9L4Szj878T878T878T/7l/8Z35/w/FEn/mcn/mcn/meP/M+0WMed+J/9gOePOvE/+wHz8/2A
889+AD+5O/9zfy/B85v9AP/ZD/Cf/QD/2Y8rrl28SGsH/9kP8J/9gP5RP6B/1I8nvpd8RdA/6gf0
j/oB/aOe4PnNng54LyXwnz2RfiZ4frMneH6zpxTvp3oR7meC5zd7gvzeif/Zif/Zif/ZX/7ntnZ4
frMT/7MT/7MT/7NH/mc6zIu0dnh+sxP/syfSz0T6mcB/9gTPb/YE/rMn8J89gf/sCfxnTzWuvXqR
1g7znz2B/+wJ8ntPkN976vFz1LwIn6ME+b0n0s8Ez7/3NOi9BM+/9wT+syd4/r0neP69pxnvZ/ci
3U94/r0n8J+d+J+d+J+d+J/95X9u7yXwn534n534n534nz3yP9MxvEhrh+ffO/E/e4Ln33si/cyk
n5n0M5N+ZtLPTPqZST/zpp/Ti7D2TPqZST+J/9mJ/9kz6Wcm/cykn5n0M5N+ZtLPvOnn6UVaO+kn
8T97Jv3MpJ+Z9DMbrZ30k/ifPZN+ZtLPvOnn5UVaO+kn8T97huePeib/mcl/ZvKfmfwn8T97Jv+Z
yX/mzX/eXqS1k/8k/mfP5D8z+c9M/jOftHbST+J/9kz+M5P/zJv/fLxIayf/SfzPniG/9wz5vWfg
L/UM/KWeST+J/9kFnj/qAs8fdQnPH/05TC/C2gWeP+rE/+xC+V0ovws8v9kF+Eud+J+d+J9d4PnN
LvD8ZheJa39fSWuH5ze7wPlnF3h+swvld6H8Lu/zm9+zoC6kn8T/7EL5XSi/S8zvKXuR1g79oy6U
3wX6R11eft33vK4T/7MT/7ML+U8h/ynRfybxIvhPIf0U0k8h/ynkP4n/2Yn/2YX8p5D/lOg/k1+T
/KeQ/xTynwLnn13g/LPLFe+nepHuJ/Tfu5D/FDj/7PKef8Z3COmnkH4KnH92gfPPLk+8n+ZFuJ8F
5pd6ofPPAvOfvbzf3xE+xQX6772QfhaY/+wF5j97yXGPqhdhjwrpZyH9LOQ/y+s/v32uXsh/FvKf
hfxnIf9Zov9MzYu0R9B/74X8Z4H5pV7e+aVvL7IXmF/qBeaXeoH5pV5gfqmXGveoe5H2CJ5/7wXm
l3qB5997aaBLhfxnIf9ZYH6+F5if76XHPRpepD2C+fleoP/eC8x/9gLzn73MeD+nF+l+wvxnL+Q/
C/nPQv6zkP8s5D8L+c9C/rNE/5lOL9L9JP9ZyH8S/7MT/7MT/7O//M/t00H+k/ifnfifnfifXTf/
eXkR1q6kn8T/7ArzS11hfqkrzC91pfyuML/UFeaXukp8f95ehPenwvxSV9JPJf1U0k/d9PPxIt1P
yu9K+qmknwrzn11JP5X0U0k/lfRTo37mt0j3E+Y/u5J+KvlP4n92hf571wZ/OxT6712h/94V+u9d
of/edcS1+yuh/96J/9mJ/9kV+Evd+Z/7blJ+V9JPBf5SV+AvdQ38pZSzF+n9CfyQrjA/3xXm57vC
/HzXO95P8SLdT5if70r6qaSfSvmd+J+d+J/dSD+N9NOifubiRbifRvndSD+N8rtRfjfK7wb8pU78
z078z26U343yu8X8ntWLtHbK70b53Si/G+V3o/xuwJ/vxP/sxP/sRvndKL9bzO/ZvEhrp/xulN+N
8rsBf74b6SfxP7tRfjfK7xbze65ehM8m8T878T+7UX434M93I/000k+j/G6U3y3m99y8SHsE80vd
KL8bPH/UDfjz3eD5o26kn0b6aaSftuln9yLtEflPI/000k8j/TTSTyP9rKSflfSzbvo5vAh7VEk/
K+lnheePOvE/O/E/e6XzT+J/duJ/duJ/duJ/9rrp5/QirZ30k/ifvZJ+VtLPSvpZgV/XK+lnJf2s
pJ+V9LNu+nl6kdZO80uV9JP4n534n71Sfq9vfg+f4kr5vVJ+r5TfK+X3GvN7vrxIa4f5+V4pv1eY
n+/1/f7NoLQV5j97pf5Rhfn5XmF+vtcz6tLtRdClSvm9Un6v1H+vLz85/DUk/mcn/mev1H+v1H+v
sf+eHy/SHsH8fK/Uf6/w/Gav7/ObwbE0Ov8k/mcn/mcn/meP/M8kbxH2qJH/JP5nJ/5nJ/5nJ/5n
J/5nJ/5nJ/5nj/zPJO8rYY+I/9mJ/9mJ/9mJ/9mJ/9kbzX8S/7MT/7MT/7MT/7NH/meS7EVaO+kn
8T97o/nPRvOfLc5/iniR3ks0/0n8z96o/96o/97Ifzbyn43674367y3238WvSf33Rv134n/2Rvm9
UX5vdP7Z3vPPGd5LpJ/E/+yNzj8bnX+2eP4p6kVaO51/Ev+zN/KfjfxnI//ZHlo7+U/if3bif3bi
f/bI/0xiXoS1E/+zE/+zd9LPTvrZST97hrV30s9O+tlJPzvpZ9/0s3qR1k76SfzP3kk/O+lnJ/3s
Smsn/eykn530s5N+9k0/mxdp7aSfnfSzk//s5D87+c8O/OTeyX920s9O/rOT/+zRf0r3Iq2d/Gcn
/9nJf/bXfwa3RvzPTvzP3sl/dvKfPfpPGV6Ev0ed9LOTfnbyn/31n8FRd/KfxP/snfxnJ//Zo/+U
6UXaI/KfxP/snfxn/37/+zf1DPKfg/znIP85yH+OzX+eXoQ9GqSfg/RzkH4O0s9B+jlIPwfp5yD9
HJt+Xl6EPRqkn8T/7AOe3+wDnt/sQ+P9vL1I9xP4S32Qfg6a/xxG95PmP4n/2QfNfw6a/xxx/lMe
L9L9pPlP4n/2Qfo5SD8H+c/x+s/46SD/SfzPPsh/DvKfI/rP8hZp7aSfxP/sA57f7ON9fjMo2KDz
z0Hnn4PmlwbNL404v1T8lTS/NEg/B+nnoPml8c4vhb8yg/znIP85aH5p0PzSiPNLJXsR9oj4n534
n534n/3L/wxOgPifnfifnfifnfifPfI/UxEvwh5N0k/if/ZJ80tTQEMmzS9N6r9P6r9P6r/P2H8v
fk3qv0/qv0/qv0/gh/QJ/JA+Ld5P9SLdT+CH9En6OeH7j/qE7z/qk/znJP854fuP+oTvP+qzxftp
XqT7Cd9/1Cf13yf13yf132fsv5fqRbqf8Px7n9Q/mtR/n9R/n5TfJ+X3Sf33Sf33GfvvpXmR7if1
34n/2Sfp5yT9nKSfzv/c1Yb0c5J+TtLPSfo5N/3sXoS1E/+zE/+zE/+zv/zPqDbE/+zE/+zE/+zE
/+znpp/Di/D+JP5nJ/5nJ/5nJ/5nJ/5nf/mf29qBH9KJ/9mJ/9mJ/9kj/zOV6UVaO/lP4n/2nf/5
Fun3BP5nJ/5nJ/5nJ/5nJ/5nJ/5nj/zPVE4v0trp/JP4n/2k/H5Sfj9jfi+XF+lzRPOfxP/sJ+X3
E/hL/ST/eZL/PCm/n5Tfz5jfy+1Fup/AX+on5Xfif3bif/YT+Mn9BH5yP4Ff1086/zzp+feTnn8/
4/Pv5fEirZ2efz/p/JP4n534n/0i/bzIf16knxfp50X6eZF+XlE/9S3C2i/ynxfp50X+86L5+Yv8
50X+8yL/eZH/vKL/1PeV8Nkk/mcn/mcn/md/+Z8xxxH/sxP/sxP/sxP/s0f+Z9LsRdoj8p/E/+wX
nX9e1H+/KL9fpJ8X6edF+nlF/VTxIu0RnX9epJ8X6ef1nn+e4ZWkn8T/7Bfp50X6eUX9VL8m6edF
558X6edF55/Xe/75Zym+r6Rrkv+86PzzovPPK55/qnqR9ojOP4n/2S86/7ze88+zva+8ST9v0s+b
zj9vOv+84/mnmhdhj246/7zp/POm88/7Pf88z/BKuibp503nnzedf97x/FOrF2GPiP/Zif/Zif/Z
X/5n/h/Z2oukn8T/7MT/7MT/7JH/mbR5kfaIzj+J/9lvyu/3N79reCVdk/Tzpvx+U36/Y37X7kXa
I5qfvym/38Cf787//Nujr2cg/mcn/me/6fmjm54/uuPzRzq8SHtE+f2m/H5T/935n21cM7ySrkn6
SfzPTvzPHvmfSacXaY/IfxL/sxP/s7/8z5gNif/Zif/Zif/Zif/ZI/8z6elF2KOH+HXE/+wP+c+H
/OdDzx899PzRQ88fPfT80UPPHz30/NETnz/Sy4u0dnr+6CH/+ZD/fMh/Ppv/vL0I76WHzj8f0s+H
/OdDzx895D8f8p8P+c+H/Oez+c/Hi3Q/6fmjh/TzIf18SD+fqJ/2Ful+0vkn8T/7Q/r5wPd39If0
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
3ri/WW7c3yz3fn/zWZ+J+5vlxv33Iv5nuZW/38rfb/WP7ktrl3+K/1lu9Y9u9Y/uvX/0xCVq7bj/
XsT/LLfy91v5+4377+XG/fdyyz/F/yzifxbxP8uL//mkJWrtuP9exP8st+aXbs0v3fv80pOXiJjh
Vv3zln/e8s9b/nnLP8X/LLf885Z/3i//vJeo/ZR/iv9ZbvnnLf+85Z+3/POWf4r/WW755y3/vF/+
+SxRa5d/iv9ZHvnnI/985J+P/PORf4r/WR755yP/fF7+WZaItT/yT/E/yyP/fOSfj/zzkX8+8k/x
P8sj/3zkn8/LP+sStXb5p/if5ZF/PvLPR/75yD8f+af4n+WRfz7yz+fln22JWrv8U/zP8qj++aj+
+Wh+6cH9oyL+ZxH/szyaX3o0v/Ts80tPX6LWjvtH5VH//VH981H989H8/IP7R+WRfz7yz0fz84/m
5599fv4ZS9TaNT//aH5e/M8i/mcR/7M8E2sX/7OI/1nE/yzif5YX//OZS8Tai+bnxf8sRfNLRfNL
ZZ9fKl8RMUO5EDMU+WeRfxb5Z5F/iv9ZxP8s4n+WF/+zrCfln+J/FvE/S5F/FvlnkX8W+WeRfxb5
Z5F/Fvln2f2znEvU2uWf4n+WIv8s8s8i/yzyzyL/LPLPIv8s8s+y+2e5lqi1yz+L/FP8zyL+Zyny
zyL/LPLPIv8s8s8i/yy7f5b1mfLPIv8U/7MU+WeRfxb5Z5F/iv9ZxP8sVf5Z5Z91988Sl4i1V/ln
lX9W1T+r6p9V/feq/ntV/Fnln1X996r+e9377yUtUWtX/72q/15V/xT/s1T136v671X+WeWfVf33
qv573fvvJS9Ra1f/XfzPUlX/rKp/VvXfq/rvVf4p/mcR/7OI/1le/M9yL1FrV/9d/M9Slb9X5e9V
/feq/nuVf1b5Z1X/var/Xvf+e3mWqLWr/y7+Z6nK36vy96r+e1X/vco/q/yzqv9e1X9ve/+9lCVi
7U3996b+u/ifRfzP0tQ/auofNflnk3829Y+a+kdt7x+VukStXf2jpv6R+J9F/M/S1D9q6h81+WeT
fzb1j5r6R23vH5W2RK1d/aOm/pH4n0X8z9LUP2rqHzX5Z5N/NvWPmvpHbe8flb5ErV39o6b+UVP8
Kf5nEf+ziP9ZxP8s4n8W8T+L+J/lxf8sY4lau+qf4n8W8T+L+J9F/M8i/mcR/7OI/1nE/yzif5YX
/7PMJWrtqn+K/1nE/yzifxbxP0tX/VP8zyL+ZxH/s4j/WV78z/oVsfau+qf4n6Ur/uyKP7vy9678
vcs/u/yzK3/vyt/7nr/X9aTy9678vSt/F/+ziP9ZuvL3rvy9yz+7/LMrf+/K3/uev9dziVq78nfx
P0tX/NkVf3bl7135u/ifRfzP0pW/d+Xvfc/f67VErV35e1f+3hV/dsWfXfl7V/7e5Z9d/tmVv3fl
733P3+v6TOXvXfl7V/4u/mcR/7OI/1m68nfxP4v4n0X8zyL+Z3nxP2tcItY+lL+L/1mG4s+h+HMo
fx/K34f8c8g/h/L3ofx97Pl7TUvU2pW/D+Xv//E//+e/vsef3/963Gq/NS8Rtd8B/nwZ8s8h/xzy
zyH/HPLPIf8c8s/x8s97idpP+eeQf4r/WcT/LOJ/liH/FP+ziP9ZxP8s4n+WF/+zPkvU2uWf4n+W
If8c8s8h/xzyzyH/HPLPIf8c8s/x8s+yRK1d/jnkn+J/FvE/y5B/DvnnlH9O+eeUf07553z5Z10i
1j7ln1P+Kf5nEf+zTPnnlH9O+eeUf07555R/zpd/tiVq7fLPKf+cyt/F/yzifxbxP4v4n0X8zyL+
ZxH/s7z4n7UvUWtX/VP8zyL+ZxH/s7z4n3UsEf92iP9ZxP8s4n8W8T+L+J9F/M8i/mcR/7O8+J91
LlH7Kf8U/7NM3X+fuv8+9/vv7StqP/H+oyL+Z5nK36fy96n8fSp/n8rfp/L3uefvbT2p/H0qf5/I
33/gJH/+zn/i37+zfpC/1w/y9/pB/l4/yN/rB/l7/SB/r589f2/nEv+uvX6Qv9cP8vcq/mcV/7N+
kL/XD/L3+kH+Xj/I3+sH+Xv9IH+vnz1/b9cStXbk71X8z/qBf9YP/LN+EH/WD+LP+kH8WcX/rB/E
n/WD+LN+9vizrc9E/Fk/iD/rB/Fn/SD+rB/4Z/3AP+sH/lk/8M/6gX/WD/yzfuCf9bP7Z4tL1Nrh
n/UD/6wfxJ9V/M8q/mf9IP6s4n9W8T+r+J9V/M/64n+2tEStHfFnFf+zfhB/VvE/q/if9YP4s4r/
WcX/rOJ/VvE/64v/2fISsXbxP6v4n/VA/FnF/6zif1bxP6v4n1X8zyr+ZxX/s774n+1eotaO+LOK
/1nF/6zif1bxP+uB+LOK/1nF/6zif1bxP+uL/9meJWrtiD+r+J/1QP+oHugf1QP993qg/14P+ech
/zzQf68H+u/12PvvrSxRa0f/vR7ov1fxP6v4n/VA/70e6L/XQ/55yD8P9N/rgf57Pfb+e6tL1NrR
f6/if9YD8Wc9EH/WA/33eqD/XsX/rOJ/1gP993qg/17Pvf/e2hKx9hP993qi/15PxZ+n4s8T/fd6
ov9eT/nnKf880X+vJ/rv9dz7760vUWtH/72e6L9X8T+r+J9V/M96ov9exf+s4n9W8T+r+J/1xf9s
Y4laO/rvVfzPeir+PBV/nui/1xP993rKP0/554n+ez3Rf6/n3n9vc4laO/rv9UT/vZ54/3s98f73
eu7vf+9f8W9eXM+Xf35FrV3+eco/T/nnKf885Z+n/PPc/bOvJ+Wfp/zzlH+K/1nF/6zif9ZT/in+
ZxX/s4r/WcX/rC/+Zz+XiLVf8k/xP+sl/7zkn5f885J/XvLPS/55yT8v+ee1+2e/lqi1yz8v+eeb
//kV9XfKPxf/c2e41Uv+eck/L/nnJf+8dv/s6zPln5f8U/zPKv5nFf+zvvifPS4RHvLmf35FrV3x
56X4U/zPKv5nFf+ziv9ZX/zPnpao/VT8Kf5nvRR/XvLPS/55yT8v+ecl/7zkn5f883r5Z16i1i7/
vOSf4n9W8T/rJf+85J+X/POSf17yz0v+GV7+eS8Raw/yT/E/q/ifVfzP+uJ/9meJ+B0F8Ouq+J9V
/M8alL+L/1nF/6zif1bxP+uL/9nLErWfyt/F/6xB/hnkn0H5e1D+HpS/B+XvQfl7UP4e9vy91yVq
7crfg/J38T+r+J81yD+D/DPIP4P8M8g/g/wzvPyzLVFrl38G+af4n1X8zxrkn0H+GeSfQf4Z5J9B
/hle/tmXqLXLP4P8M8g/xf+s4n9W8T+r+J9V/M8q/mcV/7O++J99LBFrF/+ziv9Zxf+s4n/WF/+z
zyXCP8X/rOJ/VvE/q/ifVfzPKv5nFf+ziv9ZX/zP8RW1n/JP8T/rm/95LlF/p/zzy//caNhV/M8q
/mcV/7OK/1lf/M+xnpR/iv9Zxf+sb/7nWrv8U/zP+uV/bmzzKv5nFf+ziv9Zxf+sL/7nWH+n/FP8
zyr+Z33zP9dnyj/F/6xf/ufGDK/if1bxP6v4n1X8z/rif45riVr7yz/XiuSf//E//2dF//nn+5v8
6h+tFal/9B//839WNOVLc/OlsT5zwpfSB2eU1D9K6r8v/uf+NoEq/mcV/7Mm9d+T+u9p77+PuESc
UTpxRkn99//4n/+zov/8c3/jQ33zP9eKlL8nvL+4Jry/uKb9/cUjLVFn9PLP9aT8M8k/F/9zfytH
TfLPJP9M8s8k/0wv/8xL1BnJP5P8M2F+qSbML9W0zy+Ne4naz0ffeflnUv998T/f+6n+u/ifNan/
ntR/T3v/fTxL1H6q/57Uf0+YX6oJ80s17fNLoyxR+4n5pSr+ZxX/s4r/WcX/rOJ/VvE/q/if9cX/
HHWJ2k/ML1XxP2tW/z3LP7P8c/E/X9+lLP8U/7Nm+WeWf+aXf7YlYu0Z74+rWf6Z5Z+L//mKWLL8
U/zPmuWfWf6ZX/7Zl4jvp/ifVfzPmuWf+euf9/ak/DPLP7P8M8s/88s/xxJ1Rnh/XM3yz4z3b9bF
/3z9G5fx/s2aNb+Uwa+rGfy6mnd+3ZhL1BnJP8X/rOJ/1i//c49DxP+s4n9W8T+r+J/1xf+cX1Fn
hPfHVfE/a8b7N+vif75ixYz3b9as+DPj/Zs14/2bNe/v35zfJ3VGyt+z8ves+aXF/9zfmFNv+af4
n/XW/NKt+aV7n1+a5xJxRjfeH1dvzS/deP9mXfzPV4Zyyz/F/6w33r9Zb7x/s977+zfntUSckfif
VfzPeqt/dH/777/vpKu3/POWf97qH93qH917/2iuz1T/6Mb74+qt/tGN92/Wxf/c3xtYb/nnLf+8
FX/eij/vPf6ccYk6I+Xvt+LPW/Hn/X3/5u+7Hest/xT/s96KP2/Fn/cef860RJ0R3h9Xb8WfN96/
WW+8f7Pe8k/xP+uN9x/VG+8/qvf+/qOZl6gzUvwp/me9Vf+8v+/fvLffkfzzln/eqn/eqn8+e/1z
3kvEGT14f1x9VP988P7Nuvif+3ts6yP/fOSfD/h19QG/rj47v24+S8QZif9Zxf+s4n/WL/9ze9dw
Ff+ziv9Zxf+s4n/WF/9zliXqjPD+uCr+Z33w/s26+J/7+6DrI/985J+P+u+P+u/P3n+fdYk6I/WP
HtU/H9U/F/9zf2d3Ff+ziv9ZH9U/H9U/n73+OdsSdUZ4/2Z9VP988P7Nuvif+3vV6yP/FP+zPsrf
H+Xvz56/z75EnZHm58X/rI/y98X/vH8u/H+flH8+8s9H+fuj/P3Z8/c5lqgzwvs366P8veD9m3Xx
P/+d0f4kPrPIP4v6R0X9o7L3j+ZcIs6oaH6pqH9U1D9a/M/XXFCRf4r/WYv6R0X9o7L1j87v/139
o6L+UVH/qLziz6+ov1P5e1H/XfzPKv5nLcrfi/L3kve1ryeVvxfVP4viz6L4syj+LFv8ea6qZlH8
WXB/s4r/WcX/rOJ/VvE/q/ifVfzPKv5n3fmf5+daovZT9U/xP6v4n1X8zyr+ZxX/s4r/WcX/rOJ/
VvE/687/PL+fqftH4n9W8T+r+J9V/M8q/mf98j93VxT/s4r/WcX/rOJ/1p3/eX7iErH2qvhT/M9a
lb8v/ufrX66q/L0qf6/K36vy93rtv820RPw2q+LPqvizKn9f/M9XdCH+ZxX/s1bl71X5e037GeUl
6owUf1bFn1X5e/3m71sEWJW/i/9Zq/yzyj/ryz/vJeqMFH+K/1mr/LN+8/ctSq/yzyr/rPLPKv+s
L/98lqgzUvxZ5Z9V+Xv9zd/79qQ+U/l7Vf5elb/Xvp9RWaLOSPGn+J9V/M+68T9/s13xP6v4n1X8
zyr+Z935n+enLhFn1BR/iv9Zm/L3xf98VSSa/LPJP5vy96b8vZ37GbUl4oya4s+m+LMpf2+/+fvv
GYn/WcX/rE35e1P+3uJ+Rn2JOiPl7035e1P+3r75+1bZa/JP8T9rU/7elL+3vJ/RWKLOSPm7+J+1
KX9v3/x9q742+WeTfzbl7035eyv7Gc0l6oyUvzfl7035++J/virkTf7Z5J9N+XtT/t62/P08vqLO
SPGn+J9V/M/65X/uXQzxP6v4n1X8zyr+Z935n+exnlT+3pS/i/9Zu/L3xf98dZq6/LPLP7vy9678
vR/7GZ1LxBl15e9d+XtX/r74n69uoPifVfzP2pW/d+Xvfc/fj2uJOKMetJ/K3//jf/7PiuK3d7ad
kfxT/M/6H//zf1aUdEZpP6P1mUlnpPub4n/Wrvubi//56qp3+WeXf3bd3+y6v9mf/YziEnVGj/ZT
9zf/43/+z4rKmhO49yf1mfLP//if/7OiqjOq+xmlJeqMlL+L/1nF/6xf/uc+nSL+ZxX/s4r/WcX/
rDv/8zzyEnVGmv8U/7P+x//8nxXN7yzH5gzyzy7/HHh/cR14f3Edn/2M7iXijIbml4bml4buby7+
579v3e+/sOJ/VvE/69D9zaH7m+Paz+hZIs5oaH5paH7pP/7n/6wofHtn24rkn+J/VvE/q/ifded/
nkdZos4I/M8q/mcdur85FH8O5e+L//nvNPv2pNau/H0ofx/K38eevx91iVq76p/if9ah+HMo/hx7
/Hm0Jeq7pPn5If8cij8X//P961D8Kf5nHYo/h+LP8Yo/+xK1n/JP8T/rUPy5+J8vBxuKP4fiz6H4
cyj+HK/4cyxRZyT/HPLPqfhzfuPP7V+ZqfhzKv6cij+n4s/5ij/nEnFG4n9W8T+r+J91qn8k/mcV
/7OK/1nF/6w7//M8vyLOSPzPKv5nnfLPKf+cu3+e3ye1n/JP8T/rFL9u8T/f3xDFn1Px5xS/bopf
N+99P88laj81/zk1//kf//N/VvQgDpmKP6fizyl+yBQ/ZJb9jK4l6ow0/zk1/zl1/2jxP19OOxV/
TsWfU/ePpu4fzb6f0fpM3T+amv+cmv+cun+0+J+veH4q/pyKP6fuH03dP5pzP6O4xL9n9FMU+vNf
/yf+3c8m/mf7/M7Pj98nEX828T+b+J9N/M/2OfczSkv8e0btg/5RE/+zfTA/3z6/8/Pn9qQ+E/Fn
+2B+vn0wP98+YT+jvESdEfpH7YP+Ufug/94+8e+/HU38zyb+Z/ug/94+6L+3z95/P+8l6ozQf28f
xJ/tg/izfRB/ts8ef57PErWfiD+b+J9N/M/25X9uEXUT/7OJ/9nE/2zif7ad/3meZYnaT/Tfm/if
TfzPJv5nE/+zffmfr7Uj/mzifzbxP5v4n23nf55nXaLWjv57E/+zif/ZxP9s4n+2L/9zX7v4n038
zyb+ZxP/s+38z/NsS8Taxf9s4n828T+b+J9N/M92nFo74s8m/mcT/7OJ/9mOV/zZl6i1I/5s4n82
8T+b+J9N/M92RK1d/in+ZxP/s4n/2Y6Xf44lau3yT/E/2yH/POSfx8s/5xLhn4f8U/zPdsg/jwf/
Hh3yz0P+ecg/D/nnsfvn9RW1n/LPQ/55IH9vB/L3duz5+/V9UvuJ+5vtkH8eyN/b0fX9RP7exP9s
B/L3diB/b8eev1/nErWfuL/ZDuTv7UT9s52of7Zzr39e1xKxn2/+51fE2sX/bOeB/RT/s4n/2cT/
bOJ/tp3/eV7rM1H/bOJ/NvE/m/ifTfzPJv5nO4PWLv8U/7OJ/9nE/2w7//O84hK1dtQ/m/if7UT/
vZ3ov7dz779faYn6LoFf18T/bCf6723xP9/7if57O+WfJ+qf7UT9s517/fPKS9R+ov7ZTtQ/24n8
vYn/2cT/bOcvP+Q3kxL/s4n/2cT/bOJ/tp3/+e+XskStHfl7E/+zncjf2/mbv2+nify9nYo/T+Tv
7UT+3s49f7+eJeL7eX3w/bwUf16KPy/Fn9cef15lidjPS/HnpfjzwvxnW/zP135eyt8v5e8X5j/b
hfnPdu3zn1ddovYT/M8m/me7ML/ULswvtWufX7raErWfeH9Hu9B/bxfml9rif75+cRfml5r4n038
zyb+Z7te/tmXqP1E/72J/9nE/2yX/FP8zyb+ZxP/s4n/2a6Xf44l6ozkn+J/NvE/m/ifTfzPdlWt
Xf4p/mcT/7OJ/9mul3/OJWrt4Nc18T+b+J9N/M8m/mf78j9f32Tl7+J/NvE/m/ifbed//oudloi1
B/SPmvifLWD+sy3+5+s0A+Y/W5B/Bsx/toD5zxb2+c/wfRK/zTf/8ytiP4Pqn0HxZ0D/vS3+53vt
6L838T9bQP+oBfSPWtj7R+FcotaO/lET/7MF+WeQfwb039vif76+yQH99yb+ZwvK34Py97Dn7+Fa
otYu/xT/swXl70H1z6D8PSh/D8rfg/L3sOfvYX2m8veg/D0ofxf/s4n/2YLqn0H1z6D6Z1D+HlT/
DKp/hr3+GeIStXbVP4Piz6D4Myj+DHv8GdIS8V2Kij+j4s+o/lEEv65F9Y+i8veo/lFU/yju/aOQ
l4j9jIo/o+LPqP5RvOB1Uf4Z5Z9R/aOo/lHc+0fhXqLOCPc3m/ifLWL+s0XFn1Hx5+J/vtcu/4zy
z6j4Myr+jHv8GZ4lau3K38X/bBHzny1i/rPFff4zlCXqu4T3d7SI/nuLmP9ssWg/Mf/ZxP9sEfOf
LWL+s8V9/jPUJWo/m/ZT/hlx/6hF3D9qEfyltvif77Urfxf/s0Xwl1oEf6nFsa+9LVFrn1q74s+I
+aUWVf9MmF9q6YOYISn+TIo/E+aXWsL8Ukv7/FLoS8Tak+qfSfXPpP5R+vaPtjmBpP5RUvyZ1D9K
6h+lvX8UxhLx20yKP5Piz4T5+bb4n/ssR0vyzyT/TJifbwnz8y3t8/NhLlFnhPmlljC/1BLm51v6
zs//ztu0pPw9yT+T/DPJP9Pun/Er6owwv9SS/DPJP9PXP39nolqSfyb5Z5J/Jvln2v0zfp/UGSn+
TPLPpPgzYX6+JcWf4n+2pPgzKf5Me/wZzyXqjFT/TIo/E+bn2+J/5rvE7Ul9pvwzq3+U1T/Ke/8o
XkvEGYn/2cT/bFn9o8X//Lei399Rln9m+WdW/yirf5T3/lFcn6n+kfifTfzPlpW/L/7nvxX17Ul9
pvwzK3/Pyt/znr/HuESdkfrv4n+2jPnPtvif+f55g+sS5Z9Z/pkx/9ky5j9b3uc/Y1qizgjzn038
z5Yx/9kW//PfiuL2pD5T/pkx/9ky5j9b3uc/Y16izkj1T/E/W1b9c/E//61o+x3JP7P8M6v+mVX/
zHv9M95L1Bkp/hT/s2X1jxb/89+Ktt+R/DPLP7Py96z8Pe/5e3yWiDO6Nb8k/me7lb8v/ue/7+nv
7+iWf97yz1v5+638/d7z91iWiDMS/7OJ/9lu5e+L//lvRXF7Up8p/7yVv9/K3+89f491iToj9d/F
/2y35pcW//Pfin5/R7f885Z/3ppfujW/dO/zS7EtUWek+qf4n+0GP7kt/ue/FfXtSX2m/PMGP7nd
4Ce3+9nPqC9RZ6T6p/if7QY/uS3+Z7779juSf97yzxv85HaDn9zutp/RWKLOSPm7+J/tVv6++J//
VrT9juSft/zzVv5+K3+/9/w9ziXqjNQ/Ev+z3Zr/XPzPfyv6/R098s9H/vmo//6o//7s/ff0FXFG
4n828T/bo/7789t/T9uT+kz556P++6P++7P339P3SZzRo/67+J/t0fzno/jzUf7+/ObvfXtSa1f+
/ih/f5S/P3v+ns4lau1Za1f8+cg/H/nnI/98bp27/PORfz7yz0f++ez+ma4lau1Fa5d/iv/ZxP9s
4n+2p+rccX+zif/ZxP9s4n+2nf95pvWZmv98NP8p/md78P6j9sg/H8Wfzzf+3B1M8eej+PNR/Pko
/nz2+DPFJWLtRf2jIv988z/PJeLvLOq/L/7n61/YIv8s8s+i/ntR/73s/feUlqi1v+qfa0Wqfxbw
l9rif76ioKL5zyL/LJpfKppfKvv8UspLxL9HJeqM5J9F/aPF/3xFqkX9o6L+UVH/qKh/VPb+UbqX
qDPC++NaUf2zaH5p8T9f2URR/138z1Y0v1Q0v1T2+aX0LFFnVHRG8s8i/1z8z1fGV+Sf4n+2Iv8s
8s/y8s+yRJ2R/FP8zyb+ZxP/s734n6kuUfs5tJ/yz6L6Z5naT9U/i+qfVfXPqvpn3eufqS0R+1k1
P1+Vv1fl71X5e93z99SXiP188z+/otau/L2q/16Vv1fl71X5e1X+Xvf8PY0laj/Vfxf/s1XFn1X+
WeWfNeG7JP5nE/+zVflnlX/Wl3/OJWrt6h9V+WeVf9avf25ZpPifTfzPVuWfVf5Zd//MX1HfT8Wf
Vf5Z5Z/1N/7cn9Rnyj+r/LPKP+vun/n7pM5I/aMq/6y6f7T4n69/48T/bOJ/tqr7R1X3j+p+/yif
S9QZyT+r/LOp/774n684RPzPJv5na+q/N/Xf295/z9cScUZN/aOm/lFT/33xP1/Rr/ifTfzP1tR/
b+q/t73/ntdnqv/e1D9qyt+b8vfF/3xFv+J/NvE/W1P+3pS/tz1/z3GJOiP1j5ry96b+++J/vrIz
8T+b+J+tqf/e1H9ve/89pyXqjNQ/auofNfXfF//z1e8Q/7OJ/9ma+u9N/fe2999zXqLOSP2jpv5R
U/998T9fPSnxP5v4n60p/myKP9sef+Z7iToj5e9N8WdT/Nm+8efWNxT/s4n/2briz674s+/xZ36W
iDPq6h91xZ9d/ff+7b9vvV3xP5v4n62r/97Vf+97/z2XJeKMuuLPrvizq//e1X8X/7OJ/9m6+u9d
/fe+999zXaLOSP2jrv5RV/+9f/vv24yE+J9N/M/W1X/v6r/3vf+e2xJ1Rqp/dtU/u/rv/dt/3+ZY
xP9s4n+2rv57V/+97/333JeoM1L/qKt/1NV/77/3N3+rxOJ/NvE/W1f/vav/3vf+ex5L1Bmpf9RV
/+yqf/bv/c1tHkz8zyb+Z+uqf3bVP/te/8xziTijof7RUP1zqP8+vvylbWZP/M8m/mcbyt+H8vex
5++/Is5oqH80lL8P5e8D739v4n828T/bUP4+lL+PPX+/v0/qjNR/H8rfh/rvi//5muYd8k/xP9tQ
/32o/z72/vt9LlFnpP6R+J9tqH801D8a8s8h/xzqHw31j8beP7qvJeqM1D8a6h+J/9nE/2zif7ah
/pH4n038zyb+ZxP/s734n/f6TOXvQ/VP8T/bkH8O+eeQfw7dfx/yzyH/HPLPIf8cu3/ecYlY+1T/
aMo/p/rvU/33ufff77RE/I6m7r9P9Y+m+u9T99+n/HPKP6f671P997n33++8RO2n+u9T/aOp/tFU
/2ju/aP7XqL2U/ffp/L3qfrn1P2jqfrnVP1zqv45Vf+ce/3zfpao/dT9o6n8fSp/n8rf556/32WJ
2k/dPxL/s03l71P3j6by9yn/nMrfp/L3uefvd12i9lP3j8T/bOJ/NvE/24v/ebclaj91/138zyb+
Z5vyT/E/m/ifTfzPJv5ne/E/777Ev/v582f8WdE/8e9+9g/885/4dz/75+WfY4l/97N/4J/9A//s
H/hn/8A/u/ifXfzP/oF/9g/8s39e/jmXqP2Ef/YP/LN/kL/3D/L3/kH9s38wv9Q/qH/2D/yzf1D/
7B/UP/tnr38+X1Frx/xS/yB/7x/En138z/5B/Nk/t9aO+LN/EH/2D+LP/kH82T97/Pl8n9TaEX92
8T+7+J9d/M/+4n8+5xL1O8L99y7+Z//g/XF98T/f+4n5z/7B/Gf/4P1x/YP3x/XP/v6451qi9nNo
P9E/6h/4Zxf/s39Q/+yfqbWj/tk/qH/2A/XPfqD+2Y+9/vmEJWLtB/rv/UD+3g/ML3XxP/sh/zzk
n4f885B/HvLPQ/557P75xCVq7fLPQ/55yD/F/+yH/POQfx7yz0P+ecg/D/nn8fLPtEStXf55yD8P
+af4n/2Qfx7yz0P+ecg/D/nnIf88Xv6Zl6i1yz/F/+wH4s9+IP7sB/L3fiB/7wfy9y7+Zxf/s4v/
2V/8z+deotaO/L2L/9kP5O/9QPzZD8Sf/UD82Q/55yH/PBB/9gPxZz/2+PN5loi1n4o/T8WfJ/rv
/UT/vZ+Y/+wn+Ev9lH+e8s8T85/9xPxnP/f5z6csUWsHf6mf6L/3E/XPLv5nP9E/6if4S/2Uf57y
zxP9o36if9TPvX/01CVq7eAv9RP1z36i/tlP1D/7udc/n7ZExEsn+Mn9lH+e8s9T/nnKP0/55yn/
POWf58s/+xK1n/LPU/55yj/F/+yn/POUf57yz1P+eco/T/nn+fLPsUStXf55yj/F/+zif3bxP7v4
n138zy7+Zxf/s4v/2V/8z2cuEWsX/7OL/9kv+ecl/7zkn5f885J/iv/ZL/nnJf+8dv8sX1Frl39e
8s9L/nnJPy/55yX/vOSfl/zzkn9e8s9r98/yfVJrl39e8k/xP7v4n/0Cv65feH9cvxR/XvLPC/y6
foFf16+dX1fOJWrt4M938T+7+J9d/M/+4n+Wa4n4t0P8zy7+Z7/kn5f885J/XvLPS/55yT+v3T/L
+kz55yX/vOSfl/xT/M9+yT8v+ecl/7zkn5f885J/Xrt/lrhErD3IP4P8U/zPLv5nF/+zi//Zxf/s
4n928T+7+J/9xf8saYlau/xT/M8u/mcX/7OL/9nF/+zif3bxP7v4n138z/7if5a8RK1d/in+Zxf/
s4v/2cX/7EH+Kf5nF/+zi//Zxf/sL/5nuZeotcs/xf/sAfNLPaB/1AP6Rz389o/S9qQ+U/4Z0D/q
Af2jHvb+UXmWqLWjf9TF/+wB/aMe0D/qYe8flbJE/NsRcH+zB/lnkH+G3/mlsT2p/ZR/iv/Zxf/s
L/5nqUvEfor/2cX/7FH9o6j+Udz7R6UtEfsZ1T+K8s+o+mdU/VP8zy7+Z4+qf0bVP+Ne/yx9idpP
1T+j6p9R/hnln1H1z6j6p/ifXfzPHlX/jKp/xr3+WcYStXbVP6PqnxHznz1i/rPHff6zzCXqu3Tr
u6T8PWL+s8dH+yn/FP+zR8x/9oj5zx73+c/6FbWfVfuJ+c8eFX9GxZ9R/aOo/pH4n138zx7VP4rq
H8W9f1S/T2rt6h9F9Y+i/DPKP6P6R1H9I/E/u/ifPal/lNQ/Snv/qJ5LxNqT+kdJ/aOk+DPJP5P8
M8k/k/wzyT+T/DPJP9Pun/VaotYu/0zyT/E/u/ifXfzPnuSf4n928T+7+J9d/M/+4n/W9ZnyzyT/
FP+zJ8WfSfFnUv0zqf6ZVP9M8s+k+mdS/TPt9c8al6i1q/6ZVP9M6r8n9d/T3n+vaYn4tyOp/57k
n0n+meSfSf6Z5J9J/pnkn+nln3mJ2k/5Z5J/iv/Zxf/s4n/2JP8U/7OL/9nF/+zif/YX/7PeS8Ta
s/xT/M+e5Z9Z/pnln1n+meWfWf6Z5Z9Z/plf/vksUWuXf2b5p/ifXfzPnuWfWf6Z5Z9Z/pnln1n+
mV/+WZaotcs/xf/sWf6Z5Z9Z/pnln+J/dvE/e5Z/ZvlnfvlnXaLWLv/M8s+s/D0rf8+qf2bVP7Pi
zyz/zKp/ZtU/817/rG2JWrvqn1n1z4z7mz3j/mbP+/3N2peIfzsy3t/Rxf/sWf6Z5Z9Z/pnln7f8
85Z/3i//HEvEft7yT/E/+y3/vOWft/zzln+K/9nF/+y3/POWf94v/5xL1Nrln7f885Z/3vLPW/55
yz9v+ect/7zln7f88979s31FrV3+ecs/xf/s4n928T/7Lf8U/7OL/9nF/+zif/YX/7N9n9Ta5Z/i
f/Zb/nnLP2/55y3/vOWft/zzln/e8s979892LlFrl3/e8k/xP7v4n/1W/fNW/+hW/HnLP2/VP2/V
P++9/tmuJWLtj+qf4n/2R/2jR/2jR/2jR/0j8T+7+J/9Uf/oUf/o2ftHbX2m+keP+keP+kcP+CH9
AT+kPzs/pMUl4t9N8T+7+J9d/M8u/mcX/7OL/9nF/+zif/YX/7OlJWo/5Z/if3bxP7v4n138zy7+
Zxf/s4v/2cX/7OJ/9hf/s+Ulau3yT/E/u/ifXfzPLv5nF/+zi//Zxf/s4n928T/7i//Z7iVq7fJP
8T/7o/jzUfz57PFne5ao35HiT/E/+6P481H8+Sj+fBR/FsWfRfFn2ePPVpaI/SyKP4viz4L7773g
/nsv+/33VpeI/Szg1/Wi+LPg/nsv4Nf1ov57Uf+94P57L7j/3st+/721JWo/wa/rBfffe8H733vB
+9972d//3voStZ94/3sX/7MX9d+L+u9F/lnkn0X996L+e9n7720sUfup/rv4n72of1TUPyrqvxfc
3+xF/in+Zy/qvxf138vef29ziVq7+u9F/ffSdO6qfxbw53vB++N6UfxZFH8W8Od7AX++l50/37+i
1o73x/UC/nwX/7OL/9kr+HW94v1xvSr+rIo/K/h1vYJf1+vOr+vfJ7H2Cv5Sr+Av9Qp+Xa94f1yv
4Nf1qvizKv6sij/rHn/2c4nwpar8vSr+rIo/F/8zl3hsT+ozFX9WxZ9V8Wfd489+LVFnBP5Sr4o/
K/h1ffE//60o/j4Jfl0X/7NX3H/vFfffe93vv/f1mbj/3qv8s8o/q/xz8T//rejZntRnyj+r/LPK
P+vunz0uUWcE/lKv8s8Kfl1f/M9/K/p1RfE/u/ifvSr+rIo/6x5/9rREnZHy96r4syr+XPzPXNL2
O5J/iv/Zm+LPpviz7fFnz0vEGTXwl3pT/NnAr+uL//lvRb+/I/E/u/ifvYFf1xv4db3t/Lp+LxFn
1BR/NsWfTfOfi//5b0XP9qQ+U/7ZNP/ZNP/Z9vnP/ixRZwT+Um+a/2zg1/XF//y3ot/fkfifXfzP
3jS/1DS/1Pb5pV6WqDNS/t6UvzfNLy3+Zy752J7UZ8o/m+aXmuaX2j6/1OsSdUbg1/Wm+aUGfl1f
/M9/K9p+R/JP8T970/xn0/xn2+c/e1uizkjxZ1P82VT/XPzPfyvafkfyT/E/e1P9s6n+2fb6Z+9L
xBl18Ot6V/2zg1/XF//z34p+f0fif3bxP3tX/t6Vv/c9f+9jiTijrv5RV/7elb8v/mcu97E9qc+U
f3bl7135e9/z9z6XqDMCv6535e8d/Lq++J//VvT7OxL/s4v/2bvub3bd3+z7/c3xFXVGyt+78veu
+ufif/5b0bM9qc+Uf3bVP7vqn32vf47vkzojvD+ud9U/O94f1xf/89+Ktt+R/FP8z97x/rje8f64
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
hPnPkTD/OZL8M8k/k/pHSf2jFPYzupeIMxL/c4j/OcT/HOl3/jNuT+oz5Z/ifw7xP8fO/7yOZ4k6
I8wvDfE/R8L850jf+c/fOeqR5J9J/pkw/zkS5j9HevYzKkvUGWF+aSTML42E+c+RvvOfW90myT+T
/DNh/nMkzH+OVPczqkvUGWF+aSTML42E+c+RvvOf9/Y7kn8m+WfC/OdImP8caexn1JaoM1L9U/zP
If7n2PifaXtSnyn/FP9ziP85dv7ndfQl4ozE/xzifw7xP4f4n0P8z/Hlf243a4b4n0P8zyH+5xD/
c+z8z+sYS9TaFX+K/zmy8vf8zd9/bz+NrPw9K3/Pyt+z8ve85+/HXCK+n1nxZ1b8mZW/52/+/ntD
bYj/OcT/HFn5e1b+nvf8/fyKOiPFn1nxZ1b+nr/5++8twpGVv4v/ObLy96z8Pe/5+7meVP4u/ucQ
/3Nk5e/5m7/n7Xek/D0rf8/K37Py97zn7+e5RJ2R4s+s+DMrf1/8z1fHISt/z8rfs/L3rPz93vP3
81oizujW/NKt+PPW/Kf4n+PG/Py4v/Pz49dDbsWft+LPG/Pz48b8/Livfe3rMzE/P+5La1f/6Nb8
5635zzvs36W4RHyXbvCXxi3/vDX/eUftp+Y/b/WPbvWPbvWP7r1/dKYlaj/VPxL/c9yKP2/Fn7fy
98X/fP2ObvnnLf+8lb/fyt/vPX8/8xK1dvXfxf8ct/pHt/pHN+bnx+J/vteu+PNW/Hljfn7cmJ8f
d9/Xfi9Ra+9au/pHt/pHt/pH994/Op8l6nek+c9b/nmrf3R/+0fbvzKP+kfif45H/aNH/aNn7x+d
ZYnYT/E/h/if41H8+Xzjzy0SeBR/Poo/H8Wfj+LPZ48/z7pEnNGj+PNR/Pko/ny+8ecWrT2KPx/5
56P481H8+ezx59mWqDNS/Pko/nwUfz7f+HOLqMX/HOJ/jkfx56P483nFn32JOiP55yP/fBR/Pt/4
c8t6HsWf4n+OR/Hno/jzecWfY4k6I8Wf4n+OR/Hn840/t6z8Ufz5KP58FH8+ij+fV/w5l6gzUvz5
KP58FH8+3/7R9m/Ho/jzkX8+ij8fxZ9ljz+vr4gzKoo/i+LPovhT/M9RFH+Wb/y5uWJR/FkUfxbF
n0XxZ9njz2s9qfhT/M8h/ucoml8q3/ub279cRfXPovpn0fxS0fxS2eeXrnOJ+H4WxZ9F8WfB/c1R
vvc3t1plUf2zqP5ZcH9zFNzfHOXez+haos5I80tF80sF9zdH+d7f3OrJ4n8O8T9Hwf3NUXB/c5Sy
n9H6TNzfHEXxZ1H8WRR/lu/9za3mXxR/iv85iuLPoviz7PHnFZeoM9L8kvifo2j+s3zvb259maL6
Z1H9s2j+s2j+s+zzn1daIs6oKv6sij+r7m/W7/3NrXdW5Z9V/ll1f7Pq/mY99zPKS8QZVcWfVfFn
1f3NCn7yqPLPKv+syt+r8ve65+/XvUSdkfL3qvizKv6sij/rHn9ezxK1n+Anj6r4syr+rJqfr4o/
q+LPqvizKv6se/x5lSVqPzU/XxV/vvmfX1F/p/pHFfzkIf7nEP9ziP85xP8cO//zuuoStXbwk4f4
n6Mq/qyKP6vmPyv4yaPKP6v8syp/r8rf656/X22JWrvy96r4syr+rIo/2yv+7EvE76gp/myKP5vm
l5rm55vy96b8vWl+qWl+qe3zS9dYIvazaX6+qf/e1H9v6r+3vf9+zSVqP3V/U/zP0dR/b9/++/Yv
V1P/van/3tR/b+q/t73/Hr6i9lPxp/ifo6n/3n7779s3RPXPpvpnU/+9qf/e9v57WE+q/y7+5xD/
czT5Z/v237cIsMk/m/yzyT+b/LPt/hnOJeqMFH+K/zma+u/t23/fovSm/ntT/72p/97Uf297/z1c
S9QZKf4U/3M09d/bl7+0ZVJN/fem/ntX/72r/973/nsIS8QZif85xP8cXfl7/83ff8+oK3/vyt+7
8veu/L3v+XuIS8QZif85xP8cXfl7/83fn+1Jfab8syt/78rf+56/h7REnZHyd/E/R1f+3r/5+/av
YZd/dvlnV/7elb/3PX8PeYk6I+Xv4n+Orvy9f/P3rQbY5Z9d/tmVv3fl733P38O9RJ2R8nfxP0dX
/t6/+ftWp+3yzy7/7Mrfu/L3vufv4VmizkjxZ1f82ZW/92/+vtXSu/yzyz+78veu/L3v+XsoS8QZ
DeXvQ/n7UP4+wE8eQ/455J9D+ftQ/j72/D3UJeKMhvL3ofx9KH8fX/7SNp885J9D/jmUvw/l72PP
30Nbos5I/aOh/H2o/z6+/fdthnzIP4f8c6j/PtR/H3v/PfQl6oyUvw/l70P3N8f3/uY25z/kn0P+
OXR/c+j+5tjvb4axRJ2R+kdD/aOh+5vje39zu4sx5J9D/jl0f3Po/ubY72+GuUSdkfL3ofx9KH8f
3/ub232ZIf8c8s+h/H0ofx97/h6/os5I/aOh/H2o/z6+/fftTtOUf07551T/far/Pvf+e1xPqv8+
lb9P5e9T/ff57b9v986m/HPKP6f671P997n33+O5RJzRVP99qv8+1X+fv/c3f39HU/455Z9T9c+p
+ufc65/xWqLOSP33qfrnVP1zfvvv2/TUlH9O+edU/XOq/jn3+mdcn6n651T9c6r+OVX/FP9zTOXv
U/XPqfx9Kn+fyt+n8ve55+8xLlFrV/1T/M8x5Z9T/jnln1P1T/E/h/ifY8o/p/xzvvwzLVFrV/1z
yj+n6p8T9c9/9rn/jvIS//6O5gf1z/lB/XN+UP+cH9Q/5wf+OT/wz58X2f1Z0fyg/jk/e/0z3kv8
u5/zg/rn/KD+OT+of84P6p/zs9c/47NE7Sfqn/OD/H1+UP+cH/Dr5gf1z/lB/XN+UP+cH9Q/52ev
f8ayRO0n+HXzg/x9fpC/zw/y93//aO/7WZeo/by1n4g/5wf5+1z8z/d+In+fH/jn/CB/nx/k7/Oz
5++xLVH7WbWfiD+n+J9T/M+58z+v2Jeo/cT7O6b4n1P8z/mBf07xP6f4n1P8zyn+5/y8/HMsUfsJ
/5zif84P6p/zg/rnPHB/cx7f+5u/UdA8cH9ziv85D9zfnAfub85jv78Z5xKx9gP1z3mg/jkP3N+c
x/f+5m+kOg/c35zif07xP6f4n3Pnf17pK+L7eaD+OcX/nOJ/zi//c8smpvifU/zPKf7nFP9z7vzP
K32f1Bmh/jnF/5wH+kfz+PaPfjO+eaB/NA/0j+aB/tE80D+ax94/SucSdUbyz0P+eSD+nMe3f1S3
3xHizyn+5zwQf84D8ec89vgzXUvUGaH+OQ/En/NA/2gev+/v2H5H6B9N8T/ngf7RPNA/msfeP0rr
M9E/muJ/TvE/54H+0Tx+39+x/Y7kn4f880T/aJ7oH81z7x+luESc0Yn65zxR/5wn+kfz/PaPfiuQ
85R/nvLPE/2jeaJ/NM+9f5TSEnFG4n9O8T+n+J/z/O0f9e1Jfab8U/zPKf7n3PmfV8pL1Bmh/jnF
/5wn+kfz/O0f/TrDKf885Z+n4s9T8ee5x5/pXqLOCPXPeSr+PBV/nr/9o+1bJ/885Z+n4s9T8ee5
x5/pWaLOCPXPeSr+PNE/mudv/+jXGU755yn/PNE/mif6R/Pc+0epLFFnpPhT/M8p/uc8f/tH2+9I
/in+5xT/c4r/OV/8z1SXiDO6UP+c4n/OC/2jef32j37P6JJ/XvLPC/2jeaF/NK+9f5TaEnFGF+qf
80L9c17oH83r2z/67f5P8T+n+J/zQv9oXugfzWvvH6W+RJ0R6p/zQv1zXugfzevbP/qd0JiX/FP8
zyn+5xT/c774n2ksUWeE+ucU/3OK/zl/+Z/PdkbyT/E/p/ifU/zP+eJ/prlEnRH6R1P8zyn+5/zl
fz7b70j+Kf7nFP9ziv85X/zP/BV1Rqh/TvE/p/if85f/+TuNNsX/nOJ/TvE/p/if88X/zN8ndUbo
H03xP6f4n/OX//k7MTjF/5zif07xP6f4n/PF/8znEnFG4n9O8T+n+J/zy//cayzif07xP6f4n1P8
z/nif+ZriTijN//zK2o/Vf8Mij+D8vfF/8z3FqUH5e9B+XtQ/h6Uv4c9f8/rM5W/B9U/g+LPoPgz
KP4Me/yZ4xL1XVL9M8g/g+LP8I0/91+H4s+g+DMo/gyKP8Mef+a0RO2n/DPIP4Piz/B7/2j7dSj+
DIo/g+LPoPgz7PFnzkvUGck/g/wzKP4Mv/ePnu1Jfabiz6D4Myj+DHv8me8l4oyi/DPKP6Piz/iN
P7dIICr+jIo/o+LPqPgz7vFnfpaIM4ryzyj/jIo/4zf+3KK1qPgzKv6Mij+j4s+4x5+5LFFnpPgz
Kv6Mij/jN/7cIuqo+DMq/oyKP6Piz7jHn7kuUWek+DMq/oyKP+M3/tyynqj4M8o/o+LPqPgz7vFn
bkvUGSn+jIo/o+LPiPe/zyj/jPLPqPgzKv6Mr/izL1FnpPgzKv6Mij/jN/7cqgdR/hnln1HxZ1T8
GV/x51iizkjxZ1T8GRV/xm/8uVV4kvwzyT+T4s+k+DO94s+5RJxRUvyZFH8mxZ/pl193bE/qM+Wf
SfFnUvyZ9vjzV8QZJcwvzaT4M2F+aSbwQ2aSfyb5Z8L80kyYX5ppn1+615OYX5oJ80szYX5pJswv
zfSdX9ri5CT/TPLPhPmlmTC/NNM+v3SfS9QZgR8yE+aXZgI/ZKYvP2TrOCT5Z5J/JvBDZgI/ZKad
H3JfS9QZgR8yE/ghM4EfMtOXH7J1hZL8M8k/E/ghM4EfMtPOD7nXZ4IfMhP4ITOBHzIT+CEz/fLn
N2eQfyb5Z8L80kyaX8r7/NIdl4gzyuq/Z/Xfs+aXMvjzU/zPKf7nzJpfyppfyvv80p2WiDPK6r9n
9d8z+PMz//Lnf39H4n9O8T9nBn9+ZvDnZ97583deos5I+XtW/p7Bn5/5y5/fphTE/5zif84M/vzM
4M/PvPPn73uJOiP137P67xn8upm//PltkkT8zyn+58zg180Mft3MO7/ufpaoM1L/Pav/nsGfn/nL
nx/biuSf4n/ODP78zODPz7zz5++yRJ0R3h83s/rvGfy6mRV/ZuXvi//5qlll5e9Z+XtW/p6Vv+c9
f7/rErH2G++Pm7fiz1vx5634897jz7stEd+l+8B+3vLPW/Hn4n++9vNW/Hkr/rwVf96KP+9X/NmX
qP1U/fOWf97yz1v+eb/8cyxR+xm1n/LPW/65+J/v/ZR/3vLPW/55yz/vl3/OJWo/b+2n/PPW/NKt
+aV7n196vqL2E/Pz81b989b80uJ/vvdT/in+57w1v3Rrfune55ee75PaT8zPT/E/p/ifU/zP+eJ/
PucStZ/yT/E/5y3/vOWft/zzln/e8s9b/nnv/vlcS8R+PvJP8T+n+J9T/M/54n8+YYnYz0f+Kf7n
FP9zPvJP8T+n+J9T/M8p/ud88T+fuETtp/xT/M/5yD8f+eez++eTlqj9lH8+8s9H/vnIP8X/nOJ/
zkf++cg/n90/n7xE7af885F/Pqp/Pqp/PuofLf7ne+3qHz3yz0f9o0f9o2fvHz33ErV2zc8/qn+K
/znF/5zif84v//O1duXv4n9O8T+n+J/zxf98niVq7UNrV/7+yD8f+eej+c/F/3yvXfOfj+Y/i+Y/
i+Y/yz7/+ZQlYu0F7++Y4n/Oov5RUf+o7P2jpy4RHlJOeEiRfxb1jxb/87Wf4n9O8T9nUf+oqH9U
9v7R05ao/QS/bhbVP4vy9yL/LPLPIv8s8s8i/yzyzyL/LC//7EvU2uWfRf4p/ucU/3OK/zmL/FP8
zyn+5xT/c4r/OV/8z2csUWuXf4r/OYv8s8g/i/yzyD+L/LPIP4v8s8g/y8s/5xK1dvlnkX+K/znF
/5xF/lnkn0X+WeSfVf5Z5Z9198/yFbH2Kv8U/3NW1T+r4s+q+LMq/hT/c4r/Oaviz6r4s+7xZ/k+
qbUr/qyKP6viz6r4s+7xZzmXiH87quLPKv+s8s8q/6zyT/E/Z5V/Vvln3f2zXEvUfso/q/yzKn+v
yt/rnr+XtSLl7+J/TvE/p/ifsyp/F/9ziv85xf+c4n/OF/+zxCVqP5W/i/85q/L3qvy97vl7SUvU
fip/F/9zVuXvVfl7lX9W+WdV/l6Vv9c9fy95idjPpvy9KX9v6h+J/znF/5xf/ue+dvE/p/ifU/zP
Kf7nfPE/y71ErV3338X/nE3xZ1P82XT/aPE/32vX/SPxP2fT/aOm+0dtv39UniVq7Ulr1/xS0/xS
0/xS2+eXSlkifkcN7z+aTf33pvmlxf9876fiz6b4s2l+qWl+qe3zS6UuUftZtJ/qv4v/OcX/nE39
o8X/fK9d8WdT/NnUP2rqH7W9f1TaErV29Y/E/5xN80tN/tnkn03+Kf7nFP9zNvlnk3+2l3/2JWLt
Xf7Z5Z9d/tnln13+2eWfXf7Z5Z9d/tnln/3ln2OJWrv8s8s/xf+c4n9O8T9nl3+K/znF/5zif07x
P+eL/1nmErV2+af4n7Mr/uyKP7vmlxb/8712zS91+WfX/FLX/FLf55fqV9TawV+aXf138T+n+J+z
K/7sij+7/LPLP7viz674s+/xZ/0+qbUr/hT/c3bl7135e9f85+J/vtcu/xT/c3bNf3bNf/Z9/rOe
S9TaxQ/pml/qyt+78vchfsjif77WPuSfQ/45xA8Z4oeMnR9SryVi7ePE2ofuvw/dfx+6/z72++91
rUj33wfevznF/5xD/jnkn0P+OeSfQ/455J9j988al6j9lH+K/zmH/HPIP4f8c8g/xf+c4n/OIf8c
8s/x8s+0RK1d/jnkn0P+OeSfQ/455J9D/jnkn0P+OeSf4+WfeYlau/xzyD/F/5zif07xP+cv/3Ob
sxL/c4r/OcX/nOJ/zhf/s95L1Nrln+J/ziH/HPLPKf+c8s8p/5zyzyn/nPLP+fLPZ4lY+5R/Tvmn
+J9T/M851T+a6h9NxZ9T/jnVP5rqH829f1TLErV29Y/E/5xT/aOp+udU/XOq/in+5xT/c07VP6fq
n3Ovf9a6RK1d9c+p+udU/j6Vv0/1j6b6R1P+Kf7nnOofTfWP5t4/qm2JWrv6R1P9o6n7R1P3j+Z+
/6j2JSJmmOLXif85xf+cU/Gn+J9T/M8p/ucU/3O++J91LFH7Kf8U/3NO+ef865////H/u/Yf8c/a
f8Q/n/kj6jP/+ueP+GftP+K+9rnEP2v/9z//+ueP+GftP6L+zr/++U/8658/4p9/N39EfeZf//wn
/vXPH1Fr3/2zfUWt/a9//oha+1///BH1d/71zx9R5/7XP39EfeZf//wRtfbdP9v3Sa39r3/+iFr7
X//8EfV3/vXPH1Fr/+ufP6I+869//oha++6f7Vyi1v7XP39Erf2vf/6If/zzn7j7Z7uW+Mc/f8Q/
/vkjau1//fNHXL+j782FH1H7+dc//4l//fNH1H7u/tnWZ/71z3//869//ojaz7/++SPi7zzkn4f8
E/zPH1GfKf8E//NH3Ncel4i1H/JP8D9/RHyXjr/5+z9xz99bWiK+S8ff/P1H1Nr/5u8/ovbzb/7+
I+oz/+bvP6L2c8/fW16i9vNv/v4jaj//9o9+RO3n3j9q9xK1n3/7Rz+i1v63f/Qjaj/ln4f88/jb
P/oRtZ97/6g9S9R+/u0f/Yjaz7/3N39E7ed+f7OVJWo/q/bzb//on/h3fulH1H7+zd9/RH3m3/ml
H1H7uc8vtbpE7eff+aUfUfs5tJ9D+zn3/WxL1H5O7af885R/nvLPU/55yj9P+ecp/zxf/tmXiP08
5Z/gf/6I2E/wP/+JL/8cS8R+nvJP8D//ifLPU/4J/uePqM+Uf4L/+SPu+zmXqP2Uf4L/+SNqP+Wf
5+6f/StqP+Wfp/zzlH+e8k/wP39Efab885R/nrt/9u+T2k/55yn/POWfp/zz3P2zn0vUfso/T/nn
Kf885Z+n/POUf57yz1P+ee7+2a8laj/ln6f885R/nvLPc/fPvlYk/zzln6f885J/XvLPS/55yT8v
+ecl/7x2/+xxidjPS/55yT8v+ecl/7x2/+xpidjPS/4J/uc/Uf55yT8v+ecl/7zkn5f889r9s+cl
aj/ln+B//ojaT/nni//Z7yVqP+Wf4H/+E+Wfl/wT/M8fUZ8p/wT/80fc9/NZovZT/gn+54+o/ZR/
Xi//LEvUfso/L/nnJf+85J/gf/6I+kz55yX/vF7+WZeo/ZR/XvLPS/55yT+vl3+2JWo/5Z+X/DPI
P4P8M8g/g/wzyD+D/DO8/LMvEfsZ5J9B/hnkn0H+GV7+OZaI/QzyzyD/DPLPIP8M8k/wP/+J8s8g
/wwv/5xL1H7KP4P8M8g/g/wz7P45vqL2U/4Z5J9B/hnkn0H+Cf7nP1H+GeSfYffP8X1S+yn/DPLP
IP8M8s+w++c4l6j9lH8G+WeQfwb5Z5B/BvlnkH8G+WfY/XNcS9R+yj+D/DPIP4P8M+z+OdaK5J9B
/hnkn1H+GeWfUf4Z5Z9R/hnln3H3zxGXiP2M8s8o/4zyzyj/jLt/jrRE7GeUf4L/+U+Uf0b5Z5R/
RvlnlH9G+Wfc/XPkJWo/5Z/gf/6I2k/554v/Oe4laj/ln+B//hPln1H+Cf7nj6jPlH+C//kj7vv5
LFH7Kf8E//NH1H7KP+PLP8sStZ/yzyj/jPLPKP8E//NH1GfKP6P8M778sy5R+yn/jPLPKP+M8s/4
8s+2RO2n/DPKP5P8M8k/k/wzyT+T/DPJP9PLP/sSsZ9J/pnkn+B//oj6O9V/T3/nl35Efab8M6n/
ntR/T3v/fYwlau3qv4P/+SPq71T/Pan/ntR/B//zR9Rnqv+e1H9Pe/99zCVq7eq/J/Xf09/7mz8i
fkdpv785vyJ+R+nv/c0fUWv/O//5I2o//85//oj6zL/znz+i9nOf/5zfJ7Wff+c/f0Ttp/wT/M9/
ovrv6e/80o+oz1T/Pan/ntR/T3v/fZ5L1NrVfwf/80fUd+kv//P4vPif81oivkv57/uLf0SsHfzP
HxH7Cf7nj6jP/Hv/6EfEfr74n3N95t/7R//Ev/ePfkTsZ/77/s0fUfu5v39zxiVqP/++v+NH1Nr/
vr/jR9R+yj/B//wn/n1/x4+o/dzf3zHTErWff9/f8SNqP//Oz/+I+jsVf2bFn1nxZ1b8mRV/ZsWf
eY8/Z16i1q74Myv+zIo/s+LPvMef816ivkuKP8H//Ccq/syKP7P8M8s/s+LPrPgz7/HnfJao/VT8
mRV/gv/5I+rv/MsP+RG1ds0vZcWf919+yM//xtrvnR8yyxKx9vsvP+RHxNpv+Sf4n//Ev/yQHxFr
B//zR9Rn/uWH/Iha+84PmXWJWvtffsiPqLUrf7/ln7f885Z/3vJP8D//ifLPW/55v/yzLVFrl3/e
8s9b/nnLP2/55y3/vOWft/zzln/e8s/75Z99iVq7/POWf97yz1v+eb/8cywR/nnLP2/55y3/vOWf
t/zzln/e8s9b/nm//HMuUfsp/7zln+B//oj6O+Wft/zzln/e8s9H/vnIP5/NP8Pv/x1rf+Sfj/zz
kX+C//lPlH+C//kj6jPln+B//oha+7Wv/fuk1i7/BP/zR9TfKf985J+P/PORf4L/+U+Ufz7yzyft
az+XqLXLPx/55yP/fOSfj/zzkX+C//kj6jPln4/883n2tV9L1Nrln4/881H+/ih/f/7yQ35Erf0v
P+RH1Gf+5Yf8iFp729e+PvMvP+Sf+Jcf8iNq7crfH+Xvz19+yI+otcs/wf/8J/7lh/yIWvvc1x6X
iLWXv/yQHxFrL6p/FuXvRfl7Uf5e5J9F/lmUvxfl7+Xc156WqLUrfy/K34vy96L8vWz5e/jkJSJm
KMrfi/yzyD+L/BP8zx9Rnyn/LPLP8vLPe4naT/lnkX8W+WeRfxb5Z5F/gv/5I+oz5Z9F/lle/vks
UWuXfxb5Z1H8WRR/lrp/l8oS9V1S/An+5z9R8Sf4nz+i9lPxJ/ifP6L2s+/7WZeo/VT8Cf7nj6i/
U/4J/uePqLUr/gT/8/iA//kjYu31FX+2JWLt4H/+iFg7+J8/ov5OxZ/gf/6I+kzFn+B//oha+yv+
7EvU2hV/gv/5I+rvlH9W+WeVf1b5J/if/0T5Z5V/1pd/jiVq7fLPKv+s6r9X+WeVf1b5Z5V/Vvln
lX9W+Wd9+edcotYu/6zyT/A/f0T9nYo/q+LPqvizyj+r4s+q+LPu8efxFbV2xZ9V8WdV/An+5z9R
8Sf4nz+iPlP+Cf7nj6i17/Hn8X0Sawf/80fE2sH//BHxd4L/+SNi7eB//oj6TMWf4H/+iPvazyVq
7Yo/wf/8EfV3qv8O/uePqLXLP8H//Cdqfgn8zx9xX/u1RK1d80vgf/6I+jvVf29/+Us/otau+BP8
z3/iX/7Sj6i13/va12f+5S/9E//yl35ErV3335v6703996b+O/ifP6I+U/33pv57q/va4xK1dvXf
m/rvTfFnU/zZ1H9v6r+D//kj6jPVf2/qv7exrz0tUWtX/72p/97Uf2/qv/et/x6OvETkCF39d/A/
/4nyT/A/f0TsJ/if/0T5J/ifP+K+n/cSsZ/gf/6I2E/wP39E/Z3yz1/+579/Vn+f1GfKP8H//BG1
9pd/PkvU2uWf4H/+iPo75Z/gf/6IOnf5J/if/0T5J/ifP+K+9rJErV3+Cf7nj6i/U/4J/uePqLXL
P8H//CfKP8H//BH3tdclau3yT/A/f0T9nfJP8D9/RK1d/gn+5z9R/gn+54+4r70tUWuXf4L/+SPq
71T+Dv7nj4i1g//5I+ozNf8J/uePuK+9LxFrB//zR8Tah/L3ofx9aP5zaP5zyD/B//wnav5zaP5z
hH3tY4lau+Y/h+Y/h/L3ofx9aP5zaP4T/M8fUZ+p+c+h+c+R97XPJWrtmv8cmv8cmv8cmv8c2/xn
OL8iYoah+U/wP/+J8k/wP39E7af8E/zPH1H7ufvn+X1S+yn/BP/zR9TfKf8E//NH1Nrln+B//hPl
n+B//oj72s8lau3yT/A/f0T9nfJP8D9/RKwd/M8fUZ8p/wT/80fc134tEWsH//NHxNrB//wR9XfK
P8H//BH1mfJP8D9/RK19989zfab8E/zPH1Frl3+C//lPlH/+8j+3OBn8zx9Rnyn/BP/zR9zXHpeo
tcs/wf/8EeGfU/45X/6Zlgj/nPJP8D+Pz5R/TvnnlH9O+eeUf07553z5Z16i9lP+OeWf8+/7j35E
7Wff9/Neovbz7/uPfkStXfXPqfrnVP1zqv45Vf+cqn/Ovf55Pkv8u58///vPiv6Jf/fz+Px9f/GP
+Hc/f6h223+9LPHvfh6fv+8v/hH/rv2H9PRnP48P+keH+J+H+J/HB/2j44P+0fHZ+0dnXaL2E/2j
44P+0fFB/n58kL8fH/SPjs+3f/TLVzzE/zzE/zw+6B8dH/SPjs/ePzrbErX2V/9o/dfRPzr+43/+
z4r+889/K9pO89Znwj+PD/zz+MA/j8/LP/sS9f1E/n6I/3l84J/H5+uf7dme1GfCP48P/PP4wD+P
z8s/xxJ1Rk37Cf88/uN//s+K2veM+u+TXZ+J/tHxH//zf1bUdUZjP6O5RJ0R/PP4wD+PD/rvx+fb
f+/b7wjx5yH+53Gg/34c6L//fBd/V3R9RZzRcWA/D/Tfj//4n+8VLf7nvxX9/o7e/M/1mYg/D/E/
D/E/j53/Ga71JO6/Hwfiz0P8z0P8z+OX/9mf7Ul9pvxT/M9D/M9j53+G61yizihpP1H/PBb/872i
9D2j39/RIf885J//8T//Z0VZZ3TvZ3QtUWeE/vsh/udxgJ98HF9+8i83+zjkn4f88wA/+TjATz6O
sp/R+kzwk4+jaj/BTz7+43/+z4rqOqOx/Y7kn4f880D8eRyIP49jjz+vuESdEfL340D8eRyIP4/j
G3+O7Xck/zzknwfiz+NA/Hkce/x5pSXijM4P9vNU/Pkf//O9osX//Lei39/RKf885Z/n3/e//4g4
o/PczygvEWd0Kv48FX+eyN+P85u/z2N7Up8p/zyRvx8n8vfj3PP3616izihqP5G/H//xP/9nRXGd
0fz9HZ3yT/E/D/E/D/E/j53/Ga5niToj9I8O8T8P8T+PX/7nfLYn9ZnyT/E/D/E/j53/Ga6yRJ1R
0X5ifulY/M/3isr3jLbfkfzzlH+e4M8fJ/jzx9n2M6pL1Bmh/nmI/3mcqH8ei/+Zn8/2O5J/nvLP
E/XP40T98zj3+ufVlqgzmtpP1D+P//if/7Oi//zz34p+f0eX/POSf17K3y/l79eev199iTijC/33
41L+fil/X/zPfyt6tif1mfLPS/n7pfz92vP3aywRZ3QF7afy9//4n/+zovA9o9/f0SX/vOSf//E/
/2dFUWeU9jOaS9QZof55XKh/Hhf678eF/vtxyT/F/zwu9N+PC/3349r77+Er6ozQfz8u9N+PC/XP
41L8eSl/v1D/PC7l75fy90v5+6X8/drz9/B9UmtH/fO4FH+K/3mI/3lc8s/r1z+3b7L885J/XvLP
S/557f4ZziVq7fLPS/55yT+vX//8dZsg/wzyzyD/DPLPsPtnuJaI32aQfwb5Z5B/hl//jNuT+kz5
Z5B/Bvln2P0zrM+Ufwb5Z5B/Bvln+PXP33+1g/wzyD+D/DPIP8PunyEuUWck/wzyzyD/DF//3CKr
IP8U//MI8s8g/wwv/0xL1Bk92k/553/8z/9Z0fONFbffkeJP8T8P8T8P8T+Pnf8ZQl6izgjz84f4
n4f4n8cv/3PLUMT/PMT/PMT/PMT/PHb+57/v/xJ1RkP7iftHx+J/vlc0vme0/Y7kn0H+GTD/eQTM
fx5xn/8MzxJxRuJ/HuJ/HhHzn0f8zn9umX6Uf0b5Z8T85xEx/3nEff4zlCXijOKF/YyY/zz+43/+
z4qub+3i93cU5Z9R/vkf//N/VhR0RnE/o7pEnZH6R1H9o4j++xG//fetYhbln1H+GdF/PyL670fc
+++hLVFnpP5RVP/oP/7n/6zo/p7R7+8oyj+j/PM//uf/rOjRGZX9jPoSdUaKP6Piz4j7R0f83j/a
Ks9R/in+5xFx/+iIuH90xP3+URhL1BmpfxTVP/qP//k/K+rfWvr2O5J/iv95iP95iP957PzPEOYS
dUbqH4n/eYj/efzyP7cOjvifh/ifh/ifh/ifx87//BdlLRFnlNQ/Ev/z+I//+T8rOr9n9Ps7SvLP
JP9MuP9+JNx/P9J+/z2uJ3H//UjqHyX1j5L67+m3/963J/WZ8s+k/ntS/z3t/fd4LlFnpP5RUv8o
qf+efvvvv7+jJP8U//MQ//MQ//PY+Z8hXkvUGal/JP7nIf7n8cv/3CYKxP88xP88xP88xP88dv7n
v8RkiToj9Y/E/zyS+u/pt/++/Y7kn0n+mdR/T+q/p73/HuMSdUbqHyX1j5L67+nbf/+d2TuS/DPJ
P7P671n997z332NaIs4o4/77kdU/yppfEv/zyMrfs+aXsvL3rPw9K3/Pyt/znr/HvEStXfNLWfFn
VvyZFX/mPf6M9xLxXXrzP7+i1q74M2N+/siKP7Piz6z4Myv+zHv8GZ8laj8x/3lk+WeWf2b5Z375
Z1mi9lP1zyz/zPLPrPpnln9m+WeWf2b5Z375Z12i9lP1zyz/zOq/Z/Xf895/j22J2k/Mfx5Z9c+s
/nvG/Och/uch/ueR1X/P6r/nvf8e+xKxn7fmP2/VP2/Fn7fiz1v5+33A58X/PMT/PG7l77fy93vP
3+NYotaO+5vHrfjzVv/9Vv/91vzSjfvvh/ifh/ifx635pVvzS/c+vxTnErV23N88bvXfb/Xfb/Xf
773/nr4ifkc3+CGH+J+H+J+H+J+H+J+H+J+H+J+H+J/Hzv8M6fuk9hP8kEP8z0P8z0P8z2Pnf4Z0
LlH7Cf7SIf7nIf7nIf7nIf7nIf7nIf7nIf7nsfM/Q7qWqP0Ef+kQ//O4lb/fyt/vPX9Pa0XK32+8
v+MQ//N4lL8/uH90PPLPR/75KH9/lL8/e/6e4hKxnw/uHx2P8vdH85+P5j+fff4zpSViPx+8/+h4
5J+P/PORf4r/eYj/eTzyz0f++ez+mfIStZ/yz0f++cg/H/nn8/LPe4naT/mn+J+H+J+H+J+H+J+H
+J+H+J+H+J/Hi/+ZniVqP+Wf4n8e4n8e4n8e4n8ev/zPLYMW//MQ//MQ//MQ//N48T9TWaLWrvxd
/M/jUf3z+dY/tyrHo/rnI/985J+P/PN5+Wddor6fyt8f+WeRf5avf26VKPE/D/E/jyL/LPLP8vLP
tkScUVH9s8g/i+qf5Vv/3KqFRfVP8T8P8T8P8T+PF/8z9SXijIr8U/zPQ/zP45f/uVV0xf88xP88
xP88xP88XvzPNJaoM1L9U/zPo6j+Wb71z63qXlT/LMrfi/L3ovy97Pl7mkvUGan+WZS/F+Xv5Zu/
b52RIv8s8s+i/L0ofy97/p6/os5I9c+i/L2o/lm+9c+te1Xkn0X+WVT/LKp/lr3+mdeTqn+K/3mI
/3mI/3n88j+3DqP4n4f4n4f4n4f4n8eL/5nPJeKMqubnxf88qu4f1e/9o60LXOWfVf5ZFX9WxZ91
jz/ztUScUVX+XhV/VsWf9Rt/bp168T8P8T+PqvizKv6se/yZ12cq/qyan6+KP6vuH9Xv/aNtmqLK
P8X/PKruH1XdP6r7/aMcl6gzUvwp/udRdf+ofu8fbRMvVf5Z5Z9V94+q7h/V/f5RTkvUGWl+vmp+
vur+Uf3eP9qmkqr8s8o/q+qfVfXPutc/c16izkjzn+J/HuJ/Hr/8z21yTPzPQ/zPQ/zPQ/zP48X/
zPcScUZN85/ifx5N94/a9/7RNt3X5J9N/tl0/6jp/lHb7x/lZ4k4o6b+UVP/qOn+0eJ/viYwxf88
xP88mu4fNd0/avv9o1yWqDPS/GfT/GfT/aPF/3xNyTb5p/ifR1P+3pS/tz1/z3WJOiPNf4r/eTTl
74v/+ZpkbvLPJv9syt+b8ve25++5LVFnpPnPpvy96f7R4n++ps2b/LPJP5vuHzXdP2r7/aPcl6gz
Uv1T/M9D/M9D/M9D/M9D/M9D/M9D/M/jxf/MY4k6I/CXDvE/j6b6Z1P82ZW/d9U/u/J38T+Prvy9
K3/ve/6e5xKx9q76Z1f82RV/dsWffY8/f0V8l7rqn+J/HuJ/HuJ/HuJ/HuJ/HuJ/HuJ/Hi/+5/19
Uvup+qf4n4f4n4f4n4f4n4f4n4f4n4f4n4f4n4f4n8eL/3mfS9Tadf9I/M9D/M9D/M9D/M9D/M9D
/M9D/M9D/M9D/M/jxf+8ryVq7eq/i/95iP95iP95iP95dN0/Ev/zEP/zEP/zEP/zePE/7/WZ8s+u
+XnxP4+u+0dd94+G4s+h+HPo/tHQ/aOx3z+64xLhS0P996H++9D80tD9I/E/D/E/j6H5paH5pbHP
L91piTijofn5ofmloftHQ/ePhuJP8T+PoftHQ/ePxn7/6M5L1BnJP8X/PIb8c+j+0ZB/DvnnkH8O
+ed4+ee9RJ2R5ueH/HPo/tHQ/aOh+HMo/hzqvw/138fef7+fJeqM1D8a6h8N9d+H7h+J/3mI/3kM
9d+H+u9j77/fZYk6I/WPhvpHQ/ePhu4fDfmn+J/H0P2joftHc79/dNcl4ozE/zzE/zym5pem7h9N
+eeUf07NL03NL819fuluS8QZTfWPpvpHU/ePpu4fTfnnlH9OzX9OzX/Off7z7kvUGal/JP7nIf7n
MXX/SPzPQ/zPQ/zPQ/zP48X/vMcSdUbqH4n/eUzdP5q6fzTln1P+OXX/aOr+0dzvH91ziTojxZ/i
fx5T/fep+0dT/jnln1P996n++9z7789X1BmpfzTVP5rqv0/dP5ryzyn/nOq/T/Xf595/f9aT6r9P
9Y8m8vefB/6s6J/4PaO4Pfn3M88P/PP8IH8/P8jfz8+evz/nEv+e0flB/+j8IH8/P+i/nx/cPzo/
8M/zA/88P+i/nx/038/P3n9/riX+PaNT/M9T/M9T/M/zg/tHp/ifp/ifp/ifp/if54v/+azPRP/9
FP/zFP/zFP/z/OD+0fmBf57if57if57if54v/ucTl6gzQv5+iv95iv95fnD/6BT/8xT/8xT/8xT/
83zxP5+0RJ0R+ken+J+n+J/nB/ePTvE/T/E/T/E/T/E/zxf/88lL1Bmhf3SK/3mK/3l+cP/oFP/z
FP/zFP/zFP/zfPE/n3uJOKMD949O8T/PA/2j80D/6Dz2/tHzLBH7ebzy96+otaN/dB7gz5/if57i
f54H+kfngf7Reez9o6csUfsJ/vx5IH8/D9w/Og/554H48zxw/+g8EH+eB+LP80D8eR6IP89jjz+f
ukStHfePzkP+Kf7nKf7nKf7n+cv/3Ncu/xT/8xT/8xT/83zxP5+2RK29au3oH50H+kfngf7Reez9
o6cvUb+jpu8S8vfzQP3zPNA/OsX/PMX/PA/UP88D9c/z2Oufz1ii9hP9o/NA/n4eL/88l4i/81T8
ef7Ofx7bk1j7qfjzVPx5Kv48X/HnXCLWfqJ/dJ6KP0/0j84T/aPz3PtH5Sviu/Tmf55L1NrRPzrP
oP1U/Hkq/jzRPzpP9I/Oc+8fle+T2s9X/2itCP2j88T80nl+55e26PdU/Hkq/jwxv3SemF86z31+
qay/E/NL55v/+X1S+yn/PL/+uUW/p/zzlH+e8s9T/nnu/lmuJeqMqs5I/nlifuk8K2LFU/Hnqfjz
xPzSeWJ+6Tz3+aWyPhPzS+eb/7lWJP88Mb90nt/5pS2LPBV/noo/T8wvnSfml85zn18qcYk4owv3
N0/xP0/xP0/xP88X/7OkJWI/3/zPc4lYu/if55f/ue+n+J+n+J+n+J+n+J/ni/9Z8hK1n7j/for/
eV6of54X6p/ntdc/y71E7afiz0vx56X481L8Kf7nKf7neSn+vBR/Xnv8WZ4laj8Vf16KPy/Fn5f8
85J/Xo++S/JP8T/PS/55yT+vl3+WJWrtmF86L/nnJf9c/M88zt9/4y75p/if5yX/vOSf18s/6xL1
/VT8Kf7neck/r4E45JJ/XvLPS/55yT+vl3+2JeKMxP88xf88A+Y/z/Cd/9z+1Q6Y/zyD8veg/D0o
fw97/l76EnFG4n+e4n+eQfl7+ObvW2QVlL8HxZ9B+XtQ/h72/L2MJeqM0H8/xf88A+Y/z/Dlz29V
uID5zzMo/gyY/zwD5j/PsM9/lrlEnRH676f4n2fA/OcZvvc3t/p8kH8G+WfA/OcZMP95hn3+s35F
nRH676f4n2fA/OcZvvz5vv2O5J9B/hmUvwfl72HP3+t6Uvm7+J+n+J9nUP4evvl7335H8s8g/wzK
34Py97Dn7/Vcos4I/fdT/M8zYH7pXPzPvRd5RvlnlH9GxZ9R8Wfc4896LRFnJP7nKf7nGRV/xm/8
+dsvPqP8M8o/o+LPqPgz7vFnXZ+p+FP8z1P8zzNifulc/M+9p39G+WeUf0bML50R80tn3OeXalyi
zkjxp/ifZ8T80hm/80u/cxdnlH9G+WfE/NIZMb90xn1+qaYl6ozQfz/F/zwj5pfO+Du/tP2O5J9R
/hkxv3RGzC+dcZ9fqnmJOiP030/xP8+I+aUzYn7pjPLPKP+MmF86I+aXzrjPL9V7iToj9N9P8T/P
iPmlM/7OL22/I/lnlH9GzC+dEfNLZ9rnl+qzRJyR+J+n+J9nwvzSmb7zS79zgGeSfyb5Z8L80pkw
v3SmfX6pliXijMT/PMX/PBPml87F/9xnNc8k/0zyz6T8PSl/T3v+XusSdUbqv4v/eSbl74v/uc/T
nkn+meSfSfl7Uv6e9vy9tiXqjNR/F//zTJhfOhf/c595PpP8M8k/E+aXzoT5pTPt80u1L1FnpP67
+J9nwvzSufifedxte1KfKf9MmF86E+aXzrTPL9WxRJ3Rq//+FbWf4NedSfFnUv6ewK87xf88xf88
k/L3pPw97fl7nUvE2rPqn1nxZ5Z/Zvlnln8u/ufrm5zln+J/nln+meWfeffP9hW1dvlnln9m+Wf+
+ufPW6SWKP8U//MU//MU//N88T/belL+Kf7nKf7nmZW/Z+XvWf2jxf98r139o6z+UVb/KKt/lPf+
UTuXqLXfWrvy96z8PSt/z3v+3q4l6rsE/tKZFX9m5e+5wOez8ves/D0rf8/K3/Oev7f1mcrfs+LP
rPgzK3/P3/tH+zdE+bv4n2dW/p6Vv+c9f29xiToj9d+z4s+s+aWs/vut/vvif77WLv7nKf7neav/
fqv/fu/995aWiLXf6r/f6r/fyt9v5e+36p+35pfE/zzF/zxv1T9v1T/vvf7Z8hK1ds0v3crfb8Wf
t/zzVvx5J/wbdyv+vBV/3oo/b8Wf9x5/tnuJWrviz1vx56348/6NP7fTVPx5K/68FX/eij/vPf5s
zxLhS7fiz1vx5634c/E/X1nPrfhT/M/zVvx5K/689/izlSXqjDT/eSv+vDE/f97f+fktM72Vv4v/
eYr/eYr/eb74n60uUWck/xT/8xT/8/zlf27VA/E/T/E/T/E/T/E/zxf/s7Ul4owezc+L/3k+mp9/
vvPzW4XnUfz5KP58ND//aH7+2efnW18izkj8z1P8z/PR/PzznZ/fqnCP/PORfz6an380P//s8/Nt
LFFnpPjzUfz5aH7++c7Pb5XSR/75yD8fzc8/mp9/9vn5NpeoM1L//VH//dH8/POdn9+q2eJ/nuJ/
no/m5x/Nzz/7/Hz/ijoj9d8f9d8fzc8/3/n5reMg/ucp/uf5aH7+0fz8s8/P9/Wk5ucf5e+P8vdH
8/MP+HWn+J+n+J9n0fx80fx82efn+7lEnFFR/72o/17ArzvLl1+3de7E/zzF/zyL5j+L5j/LPv/Z
ryXijIriz6L4s2j+s3znP7fuqvifp/ifZ9H8Z9H8Z9nnP/v6TM1/FuXvRfl7Uf5evvOfWwdc/M9T
/M+zKH8vyt/Lnr/3uESdkfrvRfl70fxS+Z3/3FYk/xT/8yyaXyqaXyr7/FJPS9QZKX8vyt+L5pfK
7/zn9juSf4r/eRbNLxXNL5V9fqnnJeqMlL8X5e9F9c/yO7+0/Y7kn+J/nkX1z6L6Z9nrn/1eIs6o
qv9eVf+sml+qv/NLv+4t/ucp/udZNb9UNb9U9/ml/iwRZ1SVv1fl71X5++J/vqbmxP88xf88q/L3
qvy97vl7L0vUGan/XpW/V80v1e/80jbZKP7nKf7nWTW/VDW/VPf5pV6XqDNS/72q/141v7T4n3lc
dXtSnyn/rKp/VtU/617/7G2JOiPVP6vqn/UVf35F/Z3K3+v3/vtWX6rK36vy96r8vSp/r3v+3vsS
tXb1j6riT/E/T/E/T/E/z6r+kfifp/ifp/ifp/if54v/2ccSsfam/pH4n2fT/FLT/FLb55f6XCJ+
Rw3vjzub+kdN80uL//n6HYn/eYr/eTbNLzXNL7V9fml8Re2n5ueb+kdN8WdT/NmUv7eI71JT/t6U
vzfl7035e9vz9/F9UmvPWrviT/E/T/E/T/E/z4b3d5zif57if57if57if54v/uc4l6i1yz/F/zyb
8vcm/2zyzyb/bPLPJv9s8s8m/2y7f45riVq7/LPJP5vy96b8ve35+1grUv7ehjxE/tmUv7ep/VT+
Lv7n2ZW/d+Xvfc/fR1wi9rPr/ntX/NkVf3bFn32PP0daIvaz6/57l392xZ9d/aOu+FP8z7Mr/uyK
P/sef468RO2n+kdd8WeXf3b5Z1f/qOv+kfifp/ifZ1f/qKt/1Pf+0biXqLXr/lFX/bOr/tlV/+x7
/XM8S9R3Ce/fPMX/PMX/PMX/PMX/PMX/PMX/PMX/PF/8z1GWqP0E//MU//Psyt+78ve+5++jLlH7
qfub4n+eXfFn1/2jrvizyz+74s+u+LPv8edoS8R+vvmf5xKxn0P5+1D+PpS/D/nnkH8O+ed4+Wdf
Is5oyD/F/zzHpbWrfzQ0vzS+/LqtviT+5yn+5zk0vzQ0vzT2+aUxlqi1R3w/h/xzyD/H1z+3GqD4
n6f4n+eQfw7553j551yivp+3zkj+OdR/H19+3VanFf/zFP/zHOq/D/Xfx95/n19RZ/Tyz7RE7afi
z/HLr3u2J3VGij+H4s+h+HPs8ef8PqkzUvw5FH8O+eeQfw755xhau/xzyD+H/HPIP8fun3P9nfLP
qfx9yj+n8vep/H3u+fu8lojv0lT+Lv7nOZW/T7z//ZzK36f8cyp/n8rf556/z/WZyt+n8nfxP8+p
/H0qf5/K32fEd0n8z1P8z3Mqf5/K3+eev8+4RK1d/aOp/H2q/774n3mU33+PxP88xf88p+LPqfhz
7vHnTEvU91P9o6n4cyr+nL/vj9u+n4o/xf88p+LPqfhz7vHnzEvUGal/NBV/TvXf5y+/bluR+u/i
f55T+ftU/j73/H3eS9QZyT+n/HMqf5/f/H3rDoj/eYr/+TPe+WdF/8S/Z3R99vx9Pkv8e0bXB/Hn
9UH8eX3Qf78+x9+47vqg/36J/3l90H+/Pui/X5+9/z7LEv+e0fVB/n59kL9fH/Tfr88vf+nZntRn
wj+vD/rv1wf99+uz999nXaLOCP2j64P+0fVB//36/PKXjt8n4Z+X+J/XB/3364P++/XZ+++zLVFn
hPrn9UH98/qg/34t/ufeN7zE/7zE/7w+6L9fH/Tfr8/ef599iToj9N+vD/rv1wf99+vz7b/3bUXw
z0v8z+uD/P36IH+/Pnv+PscSdUboH10fxJ/XB/Hn9fnGn2P71sE/L/E/rw/iz+uD+PP6vOLPuUSc
0YH++3Ug/rwO5O/X8c3ff+fBrkP+Kf7nJf7nJf7ntfM/4/f/jvz9OhB/XuJ/XuJ/Xr/8z9+ZvUv8
z0v8z0v8z0v8z2vnf8bfJ3VG6L9f4n9eB/rv1/Htv//OVV6H/POQfx7ov18H+u/XkfczOpeoM0L/
6DrQP7oO9I+u49s/+p19vcT/vMT/vA70j64D/aPrePYzupaoM8L99+tA/+g6cP/oOr78kLn9juSf
4n9e4n9e4n9eO/8zfj8T94+uA/ePLvE/L/E/r1/+59x+R/JP8T8v8T8v8T+vnf8ZP3GJOiPcf7/E
/7wO8EOu48sP+Z3zv0755yn/PJG/Xyfy9+s89jNKS8QZnbi/eZ3I368T+ft1/r7/6Nie1GfKP0/k
79eJ/P06r/2M8hJxRifqn9eJ/P06wQ+5zt/3H/3+jk755yn/PMEPuU7wQ64z7Wd0L1FnhPrndaL+
eZ3gh1yL/5lHvbYn9ZnyzxP8kOsEP+Q67/2MniXqjPD+uOtE/fM60T+6xP+8TuTv14n+0XUif79O
5O/Xifz9OpG/X2fd116WqLWjf3SJ/3md8s9T/nnKP0/wk69T/in+53XKP0/55/nyz7pErR33N69T
/nkif79O5e8X7h9d1/f+5vYrvnD/6Lpw/+i6cP/ounD/6LqOfe1tiVj7pfz9Uv5+4f7RtfifL6e9
cP/outA/ui7cP7ou3D+6rrD7Ul8ifOlS/n4pf79Q/7yu3/tHfXtSn4n653Wh/nldqH9eV9rPaCxR
Z6T8/VL+fqH+eV3f+0dbxHKh/nmJ/3ldqH9eF+qf1/XsZzSXqDNS/i7+53XJP6+vf25R5SX/vOSf
l/zzkn9eu38eX1FnpPxd/M/rQv3zur71zy3yv1D/vC7UP68L9c/rQv3zurb6ZzzWk6h/XuJ/XuJ/
Xhfqn9f1e/9o+x3JPy/5Z1D9M6j+GT77GZ1LxBmJ/3mJ/3kF1T/Dt/65ZdBB/hnkn0H1z6D6Z7j2
M7qWiDMS//MS//MKqn+Gb/1zq3IE+WeQfwbVP4PqnyHuZ7Q+U/VP8T8v8T+voPpn+NY/t0pUkH8G
+WdQ/TOo/hnu/YziEnVGyt/F/7yC6p/hl5/ctyf1mfLPoPpnUP0zlP2M0hJ1Rsrfxf+8guqfAfzk
K8g/g/wzqP4ZVP8MfT+jvESdkeJP8T+voPpnwPzSFeSfQf4ZVP8Mqn+GuZ/RvUSckfifl/ifV1T9
M4KffEX5Z5R/RtU/o+qfca9/Hs8ScUbif17if15R9c8IfvIV5Z9R/hlV/4yqf8a9/nmUJeqMlL+L
/3lF1T8j7h9dUf4Z5Z9R9c+o+mfc659HXaLOSPm7+J9XVP0zfuufv13gK8o/o/wzqv4ZVf+Me/3z
aEvUGan+Kf7nFVX/jL/85G1F8s8o/4yqf0bVP+Ne/zz6EnVGyt/F/7yi8vfF/9ynKa4o/4zyz6j8
PSp/j3v+fowl6oxU/xT/84qqf8Zv/fN34uVK8s8k/0yqfybVP9Ne/zzmEnFGCfNLl/ifVwJ/6UqK
P5Py9/Tlh2zVGPE/L/E/r6T8PSl/T3v+fn5FrT1o7Yo/k+LPpPgz7fHn+X0S36WUtJ/yz6T4MyXt
p+LPpPgzKf5Mij/THn+e5xK1n+DXXUn+mVT/FP/zSuAnX4v/uRM4ryT/TPLPBH7ylcBPvlLd134t
UWuvWjvmP6/0ij/Xfir+TMrfU4PPJ+Xv4n9eSfl7Uv6e9vz9XJ+p/P3N/1wrUvyZlL+n3/mlbUXK
35Py96z8PSt/z3v+fsYl4reZcf/oyoo/s+LPrPgz7/HnmZaI/cwn9jMr/syKP/OF/cyKP7Piz6z4
Myv+zHv8eeYlaj8jvvNZ8WdW/Jkj/t0U//MS//PKij+z4s+8x5/nvUSdUdYZKf7Mij8z3t9xZcWf
4n9e4n9e4n9eO/8zns8SdUZFZyT/FP/zyoo/xf+8xP+8xP+8xP+8dv5nPMsSdUav+HP94hR/iv95
5d/3d2zfOsWf4n9e4n9e4n9eO/8znnWJOiP1j8T/vDL481cGf/66P/t+tiViP9/8z3OJWPsNfvJ1
H/jO3+q/34o/b/CTrxv85Os+9/3sS8R+3hf281b8+eZ/piXq71T98w5au+qft+LPW/HnrfjzfsWf
Y4lau+LPW/755n9+Rf2d6r/f3/77Fq3dyt9v+eet/vut/vu999/PuUStXfGn+J/X/eg7r/rnrf7R
/ds/OrYntXb1j271j271j+69f3R9Ra1d8eet+PNW/HmDX3eJ/3mJ/3ndij9vxZ/3Hn9e60nFnzfu
v1+34s9b9c9b9c97r39ea5dU/3xwf/N6lL8/qn8+3/rn1jN9VP98FH8+ij8fxZ/PHn9e1xKxn88J
r3sUfz6KP5/f+uexPYnv/CP/fBR/Poo/nz3+vNZnKv58FH8+ij8fxZ9PRGzzKP585J+P4s9H8eez
x59XXKLOSPHnI/98FH8+mv98FH8+ij8fxZ+P4s9njz+v9V1S/PmAH3I9ij/F/7zE/7we3N+8Fv8z
X2VsT+ozlb8/uL95Pbi/eT1tX3teotaO+5uX+J/Xg/ub16P481H/6Pm9v9m3J7V2+ecj/3zkn8/L
P+8lYu0F9zevIv8sij+L4s+i+LP8xp/P9iTWXhR/FsWfRfFn2ePP61mi1o7771dR/Flw//0q3/vv
26+4aP6zaP6z4P77VXD//Spx96WyRPhSwfs7rqL5pYL3v1/if17if15f/udGqr/E/7zE/7zE/7zE
/7x2/me86hK1drz//RL/8xL/8/rlf25TH+J/XuJ/XuJ/XuJ/Xjv/M15tifp+4v3vl/ifl/if1y//
c5uREP/zEv/zEv/zEv/z2vmf8epL1Bl1xDbif17if14b/zNuT+qM5J/if17if17l5Z9jiTijqvhT
/M9L/M/ry//c5yrF/7zE/7zE/7zE/7zqK/6cS8QZVcWf4n9e4n9eX/7nHlGL/3mJ/3mJ/3mJ/3nt
/M8YvqLOSPGn+J+X+J/XL/9z83nxPy/xPy/xPy/xP6+d/xnDelLx55v/+RW1n8rfq/L3uufvYe2S
8vf6aD+Vv1f1j+rv+ze3b4j6R+J/XlX9o6r+Ud37R+Faovaz4t8O8T+vivdvXov/+f4Vq/9eVf+s
eP/mVfH+zav2/YzWZ+L9m1cdOiO8v+OqeP/mtfifOR7n75Pqv1fVP6vqn1X1z7bXP0NcIs6ofeBL
TfFnU/zZDvzb0RR/iv95NcWfTfFn2+PPsP5OxZ9N8WdT/NkUf7Zv/LnNBTXFn+J/Xk3xZ1P82fb4
M+Ql6owUf4r/eTX5Z5N/NsWfi//5yiKb4k/xP6+m+LMp/mx7/BnuJWrt6r+L/3mJ/3mJ/3nt/M8Y
niXqu6T+kfifV1P/aPE/X7OaTf2jpvizqX/U1D9qe/8olCVqP5v2U/7ZVP8U//NqeP/Rtfif7+8S
3n90Nflnw/uProb3H11t7muvS9Tap9au/nvX/FJX/NkVfy7+52vtXfGn+J+X+J+X+J/Xzv+MoS0R
axf/8xL/8+ryzy7/7PLPLv/s8s8u/+zyzy7/7C//7EvU2uWf4n9e/eWfaYn6O+WfPWnt8s8u/+zy
zy7/7C//HEvU2uWfXf7Z5Z9d/tlf/jmXCP/s8s8u/+zyz160n/LPLv/s8s8u/+y7f8avqP2Uf3b5
Z+9au/yzyz9719rln13+2eWfXf7Zd/+M60n5Z5d/dvnnm/+Zloi/U/zP65f/ua1d/M9L/M9L/M9L
/M9r53/GeC4Rax/K38X/vIby9/Gbv/ftScTJQ/n7UP4+lL+PPX+P1xLx2xzgJ19D+bv4n5f4n5f4
n9cv/3Nfu+6/i/95if95if957fzPGNdngv95DfCTL/E/r6H655B/DtU/x6O1q/45VP8cqn8O1T/H
Xv+McYlae9Xa5Z9D85/if15D+fvif76ioKH8fcg/h/L3ofx97Pl7XL9N5e9jaO3yz6H+u/if19D8
5+J/vteu+c8h/5ya/5ya/5z7/GfMS8Tap+Y/p/zzzf9MS9TfKX7IL/9zqwmI/3mJ/3mJ/3mJ/3nt
/M8Y7yVq7eB/XuJ/XlPx51T8Off4Mz5LxL8db/7n2k/555R/TvCTryn/nPLPKf+c8s/58s+yRO2n
/FP8z2veWrv8c8o/J94fd4n/eYn/eU3555R/zpd/1iVq7eofTfnnVP9oVsQ24n9e4n9eU/2jqf7R
3PtHsS1R30/136f6R1P9oznwb5z4n5f4n9dU/2iqfzT3/lHsS/x7RuGD/vs/8e9+hg/qn+GD+mf4
oP4ZPsfftYcP6p/hA/8MH9Q/wwf1z/DZ659xLFFrR/4ePsjfwwf5e/ggfw8f5O/hA/8MH/hn+MA/
w+fln3OJf7+f4YP8PXzgn+GD/D2I/xnE/wwf5O9B/M8g/mcQ/zOI/xk+e/6evqLWjvw9iP8ZPsjf
wwf5e/js+Xv6PqnvEvL38EH+Hj7I38MH+XsQ/zOI/xk+yN/DB/l7+Oz5e1p/J/L38EH+Hj6IP8MH
9c/wQf4ePsjfwwf1z/BB/h4+iD/DB/l7+CB/D589f0/XErV25O/hg/gzHIg/w4H4Mxx7/JnCEvFd
evM/zyVi7Qf4IeE48F06wA8JB+5vhgP8kHCAHxKOnR+S4hKxn2/+51fUfgatXf55gF8XFv/z9a+M
+J9B/M9wgF8XDvDrwrHz61Jaotae/sYM4UD8GQ7Mz4fF/9zjuiD+ZxD/Mxzov4cD/fdw7P33lJeo
7yfm58OB/ns48P6OcOD9HeEo+37eS9R+Fu0n5j/DgfnPcFTtJ+Y/w4H8PRyY/wwH5j/Dsc9/pmeJ
2k/Mf4ZD/nkg/gzif4YD8Wc4ML8UDsSf4UD8GQ7En+FA/BmOPf5MZYlY+4n5pSD+ZzhR/wznB7/3
E/XPcMo/T9Q/w4n6Zzj3+meqS8T388T9zSD+ZzhR/wzn7/3NY3sSZ3TKP0/UP8OJ+mc49/pnakvU
GaH+GcT/DCfy93Aq/jyRv4cT+XsQ/zOI/xlO5O/hRP4ezj1/T32JWjvefxRO5O/hxPuPwuJ/7n3t
cOL9R0H8z3DKP0/55/nyz7FEfT/x/uIg/mc4kb+HU/Hnifw9nMjfw4n8PYj/GU7k7+FE/h7OPX9P
c4lae9fa5Z/ifwbxP8OL/5m/or5LuL8ZxP8MJ/ghYfE/X3Hyhf57uOSfF/gh4QI/JFw7PySvJ8EP
CRf4IeFS/v7mf6Yl6u8EPyR8+Z/7d0n8zyD+ZxD/M4j/GV78z3wuUWvH/c0g/mcQ/zN8+Z+7M4j/
GcT/DOJ/BvE/w4v/ma8l4vsp/mcQ/zOI/xk2/ue2IvA/g/ifQfzPIP5nePE/8/pM8D+D+J9B/M8g
/mf48j+3KcQg/mcQ/zOI/xnE/wwv/meOS9QZyT/F/wzif4Yv/3ObFA3ifwbxP4P4n0H8z/Dif+b1
e8f9zSD+ZxD/M4j/GX75n7/TvEH8zyD+ZxD/M4j/GV78z5yXiDMS/zOI/xnE/wy//M/fee8g/mcQ
/zOI/xnE/wwv/me+l4gzEv8ziP8ZxP8Mv/zP37tXQfzPIP5nEP8ziP8ZXvzP/CxRZ4T5zyD+ZxD/
M4j/GcT/DOJ/BvE/g/if4cX/zGWJOiPc3wzifwbxP0PA/aMg/mcQ/zOI/xnE/wwv/meuS9QZqf4p
/mcQ/zN8+Z/bHbEg/mcQ/zOI/xnE/wwv/mduS9QZgR8SxP8M4n+GL/9z47oH8T+D+J9B/M8g/md4
8T9zXyLOSPzPIP5nEP8ziP8ZxP8M4n8G8T+D+J/hxf/MY4k4I/E/g/ifQfzPIP5nEP8ziP8ZxP8M
4n+GF/8zzyXqjFT/FP8ziP8ZfvmfvxT0IP5nEP8ziP8ZxP8ML/7nr6gzUv1T/M8g/mf48j83tmQQ
/zOI/xnE/wzif4YX//P+Pqkzwv2jIP5nEP8z/PI/x3ZG8k/xP4P4n0H8z/Dif97nEnVGmF8K4n8G
8T9D/OUvbWck/xT/M4j/GcT/DC/+530tUWeE+0dB/M8g/mf45X/+kjGC+J9B/M8g/mcQ/zO8+J/3
+kzl70n9d/E/Q8L8Ukjf+aVfMkZI8s8k/0yYXwoJ80sh7fNLd1wiziip/57UP0rqHy3+5/0TxH+f
lH8m+WdS/yipf5T2/tGdlqgzAn8pJNU/3/zPr6i/U/n74n++6ktJ+XtS/p6Uvyfl72nP3++8RK0d
7z8KSfGn+J9B/M+Q5J+L//leu/wzyT+T/DPJP9PLP+8lau3qvyf5Z8L8Z0iY/wxpn/+8nyXqd4T5
z5DUf0+4vxkW//O9n/LPJP9MuL8ZEu5vhrzf37zLErGf+YP9zJpfynj/Uch4/1HI+/uP7rpE7GcG
Pzlk5e9Z9c/F/3ztZ1b9M6v+mVX/zKp/5r3+ebclaj/BTw5Z+XtW/p6Vv+c9f7/7ErWf4NcF8T9D
Vv6ecX8zZOXvWf6Zlb9n5e95z9/vsUTtp+aXxP8MWf2jrP5Rxv33sPif77XLP8X/DBn330PG/feQ
9/vv91yi1o75+ZDVf8/g14Ws/D2r/rn4n/cPhOX7pOqfWfXPrPpnVv0z7/XP5ytq7ZifD1n5e5Z/
iv8ZsuLPrP7RrfjzVvx5K/68FX/ee/z5rCcVf97qH4n/GW7VP2/55y3/XPzP17nf8k/xP8Mt/7zl
n/fun8+5RK1d9U/xP8Ot/tH9fX/cFnvf6h/d6h/d6h/d6h/de//ouZYIT77ln7f881b8eX/7R1t+
dCv+vBV/3oo/b8Wf9x5/PuszFX/eqn+K/xnE/wy//M8thxX/M4j/GcT/DOJ/hhf/84lL1Bmp/in+
ZxD/M4j/GcT/DOJ/BvE/g/if4cX/fNISdUaqf4r/GW71jxb/81ULutU/utU/etQ/etQ/evb+0ZOX
iDMS/zOI/xke9Y+e3/7R7xk98s9H/vmof/Sof/Ts/aPnXiLOSPzPIP5neNQ/er79o62m+sg/H/nn
o/jzUfz57PHn8yxRZ6T6p/if4VH8+Xz7R1vd+5F/PvLPR/Hno/jz2ePPpyxRZ6T6p/if4VH/aPE/
X72JR/75yD8f9Y8e9Y+evX/01CXqjJS/P8rfH/WPHvWPHvnnI/981D961D969v7R05aoM1L9U/zP
IP5n+OV/bj0+8T+D+J9B/M8g/md48T+fvkScUVH8Kf5nKOoflW//aOvDFvlnkX8W9Y+K+kdl7x89
Y4k4o6L6Z1H9s6h/VH7nP5/tSX2m/LOof1TUPyp7/+iZS9QZqf5ZVP8s6h8V8OtCkX+K/xmK+kdF
/aOy94/KV9QZqX9U1D8q6h+VX37ydkbyT/E/Q1H/qKh/VPb+Ufk+qTNS/l6UvxfVPxf/8zUXVOSf
4n+GovpnUf2z7PXPci5RZ6T+UVH9s6h/tPifr9mtIv8U/zMU9Y+K+kdl7x+Va4k6I+XvRfl7Uf5e
vv2jbb6uyj/F/wxV+XtV/l73/L2sz1T+XtU/qsrfq/pHi//5moGs8k/xP0NV/6iqf1T3/lGJS8QZ
VfWPqvpHVf2jqv5RlX+K/xmq+kdV/aO6949KWqLOSP2jqv5RVf+oKv6syt+r+kdV+XtV/l6Vv1fl
73XP30teotau/lFV/FkVf1bFn3WPP8u9RH2XwA8JVf5ZFX8u/ud7PxV/VsWfVfFnVfxZ9/izPEvU
fmp+vso/q/yzyj/ryz/LErWfmp8X/zNU+WdV/bPJP5v8s8k/m/yzvfyzLhH72VT/FP8ztFf+fi5R
f6fqn4v/+XLapvqn+J+hqf7ZVP9se/2ztCVq7eofNeXvTfl7U/7e9vy99CXiu9TAnw/ifwbxP8OX
/7n/Wyz+ZxD/M4j/GcT/DC/+ZxlL1H6CvxTE/wxN+fvif77ipab8vck/m/yzyT/byz/nEnVGun8k
/mdo8s/2vX+0RelN/tnkn03+2eSfbffP+hV1Rrq/2eSfTfl7++WHHNuTOiPl7035e1P+3vb8vX6f
xBl13d8U/zOI/xk63n8UxP8M4n8G8T+D+J/hxf+s6+9U/i7+ZxD/M4j/GcT/DOJ/hl/+5752xZ/i
fwbxP4P4n+HF/6zXErV28UPE/wxd/aOu/lHf+0d1rUj9o674U/zP0BV/dsWfXfFnV/zZFX92xZ99
jz9rXKL2U/Fnl3925e/ifwbxP8Mv/3P/Lil/F/8ziP8ZxP8ML/5nTUvU2pW/i/8ZuvL3jve/h678
vcs/u+LPrviz7/FnzUvU91P5e1f82RV/9t/8/de9h+JP8T/DUPw5FH+OPf6s9xJxRkP5+1D8OZS/
D+XvQ/m7+J9hKH8fyt/Hnr/XZ4k4oyH/HPLPofx98T9fdbCh/F38zzCUvw/l72PP32tZos5I99/F
/wxD/JDF/3zFdUP1z6H65xA/ZIgfMnZ+SK1L1Blpfmlofmlofmn8vr9j+9bJP4f8c2h+aWh+aezz
S7UtUWckfoj4n0H8z/Dlf+41f/E/g/ifQfzPIP5nePE/a1+izkj8JfE/w9D85+J/vvoyQ/455J9D
859D859zn/+sY4k4o/nBfk7Nf07x6+aXX7f1zqb8U/zPMMWvm+LXzZ1fV+cScUZT+ftU/DkVfy7+
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
c/c68T+j+J9R/M8o/md88T9nXKLOSPVP8T9j1vyS+J9R/M+4+J/5vH4jQPE/o/ifUfzPKP5nfPE/
5/rWaX5J/M8o/mfMij+z4s+8x58zLxHfpVvxp/if8Vb8ufifr1/HrfjzVvx5K/68FX/ee/w57yVi
P2/c34y3/PPG/c0o/me8MT8fF//zvXbMz8db/nljfj7emJ+P9z4/P58lau24vxnF/4zif0bxP+OL
/znLEvVdytpP9Y/E/4xf/udrPzX/Kf5nFP8ziv8ZX/zPWZeo/cT9zSj+Z7wL/t285Z+34s+7aO2K
P2/Fn7fiz1vx573Hn7MtUWvX/NKt+PNW/+hW/+je+0ezL1HfJfXfb9U/b/XfF//zvZ/qv9+KP2/1
32/135+9/z7HErGfD/jz8VH988H736P4n1H8z/jlf+5rF/8ziv8Zxf+M4n/GF/9zziVq7Xj/exT/
Mz6KPx/556P48wlau+LPR/Hno/jzUfz5bPFn+v7fFX8+6h89ij/f/M+1dvnnI/985J+P/PORfz7y
z0f++Tz72teT8s83/3OtSP75aH7+0fz8o/n5R/XPR/Pzj+bnn21+Pn1/cZqff/M/v6L2s2nt8s9H
+fvif77Xrvxd/M/4KH9/lL8/Y1/7tUStXfPzj/zzUf/oUf+oqH+0+J+vtRf1j4r8s6h/VNQ/Kse+
9vWZ6h8V9Y+K/LOo/in+ZxT/My7+53vtqn+K/xnF/4zif8ad/5k+cYlau/pH4n/GovizKP4s6h8t
/ucrOyvqHxX5Z1H/qKh/VPK+9rRErf3W2uWfBe/viOJ/xqL5pcX/fK9d80tF/lk0v1Q0v1TKvva8
RK1d80vif8ai+c+i/L1ofmnxP1//con/GcX/jEXxZ1H8Wfq+9nuJWrvml4rizzK0duXvRfNL5fv+
4q0GWDS/VOSfVfNLVfNL9bOv/Vki1l41v1QVf1bdPxL/M4r/Gb/8z/07L/5nFP8ziv8Zxf+MO/8z
fcoStfagtSv+rODXxar5z6r5z8X/fK9d859V/lmVv1fl7zXta69L1No1/yn+Z6xZa1f9s6p/VG+t
Xf2jKv+s6h9V9Y/qs6+9LVFrL1q78vdatHbFn1X998X/fK9d/fcq/6zqv1f132vb196XqLWr/15V
/xT/M4r/Gav673Vo7eq/V/lnVf2zqv5Z5772sUSs/c3//IpYe1P+3hR/Ns3PL/7na+1N8/Pif8am
+fmm+fl27mufS9TaNT8v/mdsyt+b4s+G93fExf98r133N8X/jOJ/RvE/487/TMdX1Nrx/rgo/mds
6h81xZ9N/aPF/3zF8039oyb/bOofNfWP2r2v/fuk1v5o7eofNeXv4n/Gpvy9KX9vyt+b/LMpf2/K
39uevx/nErV25e/if0bxP6P4n3Hnf6bjWiLqIeJ/RvE/o/ifcfE/3/sp/xT/M4r/GcX/jDv/Mx3r
M+WfXf4p/mfsun/U5Z9d/tm//rl1Lbv8s8s/u/yzyz/77p9HXKLW/vLPtEStXf2jrv6R+J9R/M8o
/mcU/zPu/M90rL9T/aOu+U/xP2NX/t6/85/bhEZX/t7ln135e1f+3vf8/chL1Blp/lP8z9g1/9l/
+UvbijT/2eWfXfOfXfOfvexndC9RZ6T4s8s/u/yzyz/7yz+fJWo/m77z8s+u/ntv+s6r/94Vf3b1
37v6733s+1mWqP0c+Deuyz+78veu/L0rf+/K34fy96H8fez5+1GXiDMa6h8N5e9D/aPF/3z9KzPU
Pxqqfw71j4b6R+Paz6gtEWc0FH8OxZ9D94/E/4zif8bF/3yvXf0j8T+j+J9R/M+48z/T0Zeotat/
JP5nHPLPIf8cL/8cS9R3Sf455J9D/rn4n+/9lH+K/xmH/HPIP8fLP+cStZ/yzyH/HODPx6H65wB/
Pi7+53vtml8a8s+h+HMo/hx7/Hl+Ra1d+ftQ/DnUfxf/M4r/GRf/87129d/F/4zif0bxP+PO/0zn
sUSsfSp/F/8zTvWPpvpHc+8fnecS8TuaeH9HnPLPKf7S4n++ol/xP6P4n3Hq/vvU/fcZ9v28lqj9
DIgVp/L3qfrn/NY/t0lR8T+j+J9xqv45Vf+ce/3zXJ+p+ufU/NJU/XOq/z7Vfxf/M4r/Gaf671P9
97n338+4RJ2R5pem8vep+fmp+ufU/NL8nZ/fTlPzS1P+OTW/NDW/NNu+9rRErV3zS1P9o6n7m+J/
RvE/45f/+Tp33d8U/zOK/xnF/4w7/zOdeYla+yv+XLuE+PPniuKfFf0T//ttbszwJP5nEv8zif+Z
xP9Mn5d/3kv8+9tMH/hnEv8zif+ZPvDPJP5nEv8zif+ZxP9Mn5d/Pkv8e0bpA/9M4n8m8T/TL//z
N+9I4n8m8T+T+J9J/M/0eflnWaLOCPNLSfzPJP5nWvzPPWZIH/hnEv8zif+ZxP9Mn5d/1iXqjFD/
TOJ/JvE/0+J/7s6QxP9M4n8m8T+T+J9p53+msy1RZ4T6ZxL/M30Qf6YP4s/0ecWffYnaT9Q/0wfx
Z/qg/pk+qH+mD+qfSfzP9EH9M31Q/0yfvf55jiViPw/UP5P4n+lA/TMd8s8D9c+0+J+vtR+ofybx
P9OB+mc6UP9Mx17/POcStXb0j5L4n+m48Ds6kL+nA/2jtPif77Wjf5TE/0wH+kfpQP8oHXv/6PqK
Wjv6R+lA/ygd4NelA/l7OtA/Sgf6R0n8zyT+ZzrQP0oH+kfp2PtH1/dJrR39o3Qgf08H5pfSIf88
5J/H1z9/+4bpkH8e8s9D/nnIP4/dP691RvLPQ/55yD8PzC8l8T/TgfnPtPif77Vj/jMd8s8D85/p
wPxnOvb5z+taotaO+c90IH9PB+qfSfzPdCr+XPzP19pPxZ+n/PNU/Hkq/jz3+PNan6n488T8ZzoV
f56YX0rifybxP9OX/7m99yqJ/5nE/0zifybxP9PO/0xXXKLWjvpnEv8znbj/nhb/8+VgJ+6/p1P+
eeL+ezpx/z2d2/33dKUlIg4R/zOJ/5lOzC+l80Zcd2J+KZ2YX0on5pfSifmldO7zS1deos4I9zeT
+J/pRP6eFv/zlfGdyN/Tifw9ncjf04n8PZ17/n7dS9QZyT/F/0yn/PP83n/f8qNT/nnKP0/55yn/
PF/++SxRZ4T6ZxL/M524/54W//OVw164/54uxZ8X7r+nC/ff03XsZ1SWiDMS/zOJ/5kuzH+m6zv/
+Vs1Spf885J/Xpj/TBfmP9O1z39edYk4owv993Shf5Qu9I/S9eXX/faL0yX/vOSfF/pH6UL/KF17
/+hqS9QZof+eLsWfl+LP68tP/uVIpEv+eck/L8Wfl+LP6xV/9iXqjNA/Spfizwv339P1y0/eViT/
vOSfF+6/pwv339NV9zMaS9QZYf4zif+ZxP9MX/7nxjVK4n8m8T+T+J9J/M+08z/TNZeoM0L9M4n/
mS70j9L1+/64339hL/nnJf+80D9KF/pHKez9o/AVcUZB8WdQ/BmUvy/+5/6uzBTkn+J/pqD8PSh/
D3v+Hr5P4oyC6p9B+XvA/FIKv+8v/vW6IP8U/zMFzC+lgPmlFPb5pXAuUWek+mdQ/TNgfimF3/fH
bSuSf4r/mcT/TOJ/pp3/+W8fl6gzUv1T/M8k/mcKv/NL27dO/in+ZxL/M4n/mXb+579TXKLOSPm7
+J9J/M/0y//s24rkn+J/JvE/k/ifaed//vsOLVFnhPmlJP5nEv8zffmf/7KS3yfln+J/JvE/k/if
aed//vsGL1FnpPxd/M8k/mf68j/PH3/9ivhM8T+T+J9J/M+08z///X6WiDOKmF9K4n+mqP5R/H1/
3K8zRPlnlH9G9Y+i+kdx7x+Fe4k4o6j6Z1T9M6p/tPifdwjbiuSf4n+mqP5RVP8o7v2j8CxRZ4T7
RymqfxRx/yhFxZ9R+XvE/aMUlb9H5e9R+XtU/h73/D2UJWrtuH+UouLPiPmlJP5nEv8zRdw/SuJ/
JvE/k/ifSfzPFF/+WZeoteP+URL/M0XMf6aI+c8U9/nP0Jao3xH4S0n8zxQx/5kW//O9n/LPKP9M
mP9MCfOfKe3zn6EvEfuZcH8zif+ZxP9M4n+mnf/571+XJWI/E/hLSfzPJP5n+vI/9/0U/zOJ/5nE
/0zif6ad//nv37Ylaj9x/z2J/5mS8vek/D3t+Xv8itpPzH+mpPgzKX9PWfup/F38z5SUvyfl72nP
3+P3Se2n+kdJ8WdS/yipf5TUP0rqHyXFn0n+mdQ/Suofpb1/FM8lau3qHyX1j5Lyd/E/k/ifKal/
JP5nEv8zif+ZxP9MO//zX0yzRK1d/SPxP1OSfyb5Z1b8mdU/yoo/s+LPrPgzK/7Me/wZ12cq/szq
H2XFn+J/JvE/U5Z/Zvlnln9m+WeWf2b5Z979M8Ylau3yT/E/U1b8mRV/ZuXvGfyQlJW/i/+ZsvL3
rPw97/l7TEvU2sEPSVn5e1b8mRV/ZvBDUgY/JGX5Z5Z/ZvBDUgY/JOWdHxLzErV28ENSVv8oK/4U
/zNl1T9z09rln1n+mVX/zKp/5r3+Ge8lau3gh6Ss/D0rf8/K3/Oev8dniYgZMt6/mbL885Z/3vLP
W/55yz9v+ect/7xf/lmWiP285Z+3/POWf4r/mW755y3/vOWft/zzln/e8s/75Z91iVq7/POWf97y
T/E/0y3/vOWft/zzln/e8s9b/nm//LMtUWuXf4r/mW755y3/vOWft/zzln+K/5lu+ect/7xf/tmX
qLXLP8X/TLf885Z/3vLPW/55yz/F/0zifybxP9P98s+xRK1d/in+Z7rln7f8837551wi/POWf97y
z0f++cg/H/mn+J/pkX8+8s9n98/0FbGfj/xT/M8k/mcS/zPt/M+U1pO4v5nE/0zif6ZH858P+CHp
Uf3zUf3z0fzno/nPZ5//TOcStZ+a/3w0v/TIP8X/TI/y90f5+6P8/VH+/ih/f5S/P3v+nq4lau3K
3x/l74/8U/zPJP5nepS/i/+ZxP9M4n8m8T/Ti/+Z1mcqfxf/M4n/mR75p/ifSfzP9Ch/F/8zif+Z
xP9M4n+mF/8zxSVq7crfxf9Mj/J38T+T+J+pyD/F/0zifybxP5P4n+nF/0xpiVi7+J9J/M9U5J9F
/lle/pmXCP8s8k/xP1ORfxb5Z5F/FvlnkX8W+Wd5+ee9RO2n/LPIP8X/TOJ/piL/LPLPIv8s8s8i
/yzyz/Lyz2eJWrv8s8g/xf9M4n+mIv8s8s8i/yzyzyL/LPLP8vLPskStXf5Z5J/ifybxP1ORfxb5
Z5F/FvlnkX8W+Wd5+WddotYu/yzyT/E/k/ifqco/q/yzyj+r/LPKP6v8s778sy0Ra6/yzyr/FP8z
if+ZqvL3qvy9Kn+v8s+q/L0qf697/p76ErV25e9V+bv4n0n8z1SVv1fl71X+WeWfVfl7Vf5e9/w9
jSVq7crfq/L3qvubVfc3635/M80l4t/Nivvvqco/q/yzyj+r/FP8z1Tln1X+WXf/zF9R+yn/rPLP
qvubVfc3635/M68ndX9T/M8k/mcS/zOJ/5nE/0zifybxP5P4n+nF/8znErGf4n8m8T9Tk3+K/5nE
/0zifybxP5P4n0n8zyT+Z3rxP/O1RK1d9zfF/0xN80tN80ttn1/Ka0WaX2rgJyfxP1PT/FIDPzk1
+WeTfzbNLzXNL7V9finHJWo/Nb/UNL8k/mcS/zM1zS81zS811T+b6p9N80tN80ttn1/KaYlau+aX
muaXxP9M4n+mpvmlpvmlpvpnU/2zaX6paX6p7fNLOS9Ra9f8UtP8UlP8Kf5nEv8zNfmn+J9J/M8k
/mcS/zO9+J/5XiLWLv5nEv8zdd0/6rp/1Pf7R/lZIjykgz+fxP9MXfePOvjzqSv+7Io/u+4fdd0/
6vv9o1yWqP0Efz6J/5m68vcu/+zyzy7/7PJP8T9Tl392+Wd/+WddotYu/+zyzy7/7PLPLv/s8s8u
/+zyzy7/7PLP/vLPtkStXf7Z5Z9d/in+Z+ryzy7/7PLPLv/s8s8u/+wv/+xL1Nrln+J/pi7/7PLP
Lv/s8s8u/xT/M3X5Z5d/9pd/jiVi7UP+OeSfQ/HnUPw5FH8OxZ9D8eeQfw7Fn0Px53jFn3OJWrvi
z6H4cyj+HIo/xx5//or4t2Mo/hzyzyH/HPLPIf8c8s8h/xzyz7H75/19Uvsp/xzyzyH/HPLPIf8c
8s8h/xzyzyH/HPLPsfvnfS5Ra5d/DvnnkH+K/5mG/HPIP4f8c8g/h/xzyD/H7p/3tUStXf455J9D
/in+ZxryzyH/HPLPIf8c8s8h/xy7f97rM+WfU/455Z9T/in+Z5ryzyn/nPLPKf+c8s8p/5y7f95x
iVq7/FP8zzRV/5yqf071j6b6R1Pxp/ifaap/NNU/mnv/6E5L1NrVP5rqH03VP6fqn1P9o6n+0ZR/
TvnnVP9oqn809/7RnZeotat/NNU/muofif+ZpuqfU/XPKf+c8s+p+udU/XPu9c/7XqLWrvrnVP1z
qn8k/mea6h9N9Y+m/HPKP6f6R1P9o7n3j+5niVq7+kdT/aOp/pH4n/mD/tE/8e/as/ifWfzPLP5n
Fv8zv/ifd1ni37XnD/pHWfzP/EH+nj/I3/MH/aP8Qf8of+Cf+QP/zB/0j/IH/aP82ftHd12i1o7+
Uf6gf5TF/8zif+YP+kf5g/5R/sA/8wf+mT/oH+UP+kf5s/eP7rZErR39oyz+Zxb/M4v/mV/8z7sv
8W+OkD/oH2XxP7P4n/kD/8zif2bxP7P4n1n8z/zif95jidpP+GcW/zN/4J/5A//MH/hn/sA/8wf+
mcX/zB/4Z/7AP/Pn5Z9ziVo7/DN/4J/5A//MH/nnIf885J+H/FP8z3zIPw/557H75/MVsfZD/nnI
Pw/55yH/POSfh/zzkH+K/5kP+ech/zx2/3y+T2rt8s9D/nnIPw/55yH/POSfh/xT/M98yD8P+eex
++dzLlFrl38e8s8D+Xs+kL/nA/Pz+cD8fBb/M4v/mQ/Mz+cD8/P52Ofnn2uJWjvm5/OB+fl8gF+X
D/Dr8rHz6561IvDr8gH+fBb/M4v/mcX/zOJ/ZvE/s/ifWfzP/OJ/PnGJ2k/5p/ifWfzPLP5nPuWf
4n9m8T+z+J9Z/M8s/md+8T+ftESsXfzPLP5nFv8zi/+Zxf/Mp/xT/M8s/mcW/zOL/5lf/M8nL1Fr
l3+K/5lP+ecp/zzln6f885R/nvLPU/55yj/Pl3/eS9Ta5Z+n/FP8zyz+Zz7ln6f885R/nvLPU/55
yj/Pl38+S9Ta5Z/if+YT9c98ov6ZT9w/yifuH2XxP7P4n/nE/aN84v5RPvf7R09ZotaO+0f5xP2j
fKL+mU/UP/MJfkg+wQ/Jp/zzlH9e4IfkC/yQfO38kKcuEWu/wA/JF/ghWfzPLP5nFv8zX+i/Z/E/
s/ifWfzPLP5nfvE/n7ZErR399yz+Z75Q/8wX6p/5Qv8oX+gf5Uv+eck/L/SP8oX+Ub72/tHTl6i1
o3+UL/SPsvifWfzPfKF/lC/0j/Il/7zknxf6R/lC/yhfe//oGUvU2tE/yuJ/ZvE/s/if+cX/fOYS
ESu++Z9fUWuXf17yT/E/s/ifWfzPLP5nfvE/y1fUfso/xf/Ml/zzkn9e8s9L/nnJPy/5Z5B/Bvln
2P2zfJ/E2oP8M8g/xf/M4n/mIP8M8s8g/wzyzyD/DPLPsPtnOZeotcs/xf/MQf4Z5J9B/hnkn+J/
ZvE/c5B/Bvln2P2zXEvU2uWfQf4Z5J9B/hnkn0H+GeSfQf4Z5J9B/hl2/yzrM+WfQf4Z5J/if2bx
P7P4nzmg/57F/8zif2bxP7P4n/nF/yxxiVo7+u9Z/M8cMD+fg/L3gP57Dui/5yD/DPLPgP57Dui/
57D330taItYe0X/PEf33LP5nFv8zR/Tfc0T/PUf5Z5R/RvTfc0T/Pce9/17yErV29N+z+J85Kn+P
yt8j+u85ov+exf/M4n/miP57jui/57j338u9RK0d/fcc0X/PUfl7VP4e0X/PEf33HOWf4n/miP57
jui/57j338uzRK0d/fcc0X/PUfl7VP4e1T+K6h9F+af4nzmqfxTVP4p7/6iUJWrt6h9F9Y+i4s+o
+DOq/hlV/4yqf0b5Z1T9M6r+Gff6Z6lL1NpV/4yqf4r/mcX/zEn1z6T6Z5J/JvlnUv0zqf6Z9vpn
aUvE2pPqn0n1z6T4U/zPLP5nFv8zi/+Zxf/M4n9m8T/zi/9Z+hK1dtU/xf/MSfFnUvyZVP9Mqn8m
+af4nzmp/plU/0x7/bOMJWrtqn8m1T+T+u9J/fe099/LXCLy4qT+u/ifWfzPLP5nFv8zi/+Zxf/M
4n/mF/+zfkXtp/xT/M8s/mcW/zOL/5nF/8zif2bxP7P4n1n8z/zif9bvk1q7/FP8z5zw/o6c8P6O
nPf3d9RzifguZbz/PYv/mbPiz6z4Myv+zIo/s+LPrPgz7/FnvZaI/cyKP7PiT/E/s/ifOSv+zIo/
s+LPrPgzK/7Mij/zHn/W9ZmKP7Piz6z4U/zPLP5nzoo/s+LPrPgzK/7Mij+z4s+8x581LlFrV/yZ
FX+K/5nF/8xZ/pnln1n+meWfWf6Z5Z/55Z9piVq7/DPLPzPuv+eM++857/ffa16iPET5e5Z/ZuXv
i/+Z79q3J7Wfyt+z8ves/D3v+Xu9l4j9vJW/38rfxf/M4n/mW/55yz9v+ect/7zln7f8837557NE
rV3+ecs/b9w/yjfuH+V7v39UyxLxXbpx/yjf8s9b9c9b9U/xP7P4n/lW/fNW/fPe65+1LlH7qfrn
rfrnf/zP//mvZ+3nve9nW6L289Z+qv4p/mcW/zOL/5nF/8zif2bxP/OL/1n7ErWf6r+L/5lvzS/d
ml+69/mlOpao/XzFn+cStXbFn/f3/Zu9bU9qP+Wft+LPW/Hn/Yo/5xK1n4o/b8Wft+LPW/Hns8ef
7StiPx/Fn+J/5kf++cg/H/nnI/985J+P/PPZ/bN9n8R+PvLPR/4p/mcW/zOL/5nF/8zif2bxP7P4
n1n8z/zif7ZziVq74k/xP7P4n1n8zyz+Z/7yP/ffkfifWfzPLP5nFv8zv/if7Vqi1o73x2XxP/OD
92/mxf/8t7Hl90m8fzM/6h896r8/6r8/e/+9rc9U//1R/+hR/+hR/33xP/+taGxP6jPln4/674/6
78/ef29xiTojvD8uP+q/P3j/Zl78z39f1PP3Sbx/M4v/mR/55yP/LC//TEvEGYn/mcX/zEX+ufif
/1aUtif1mfLPIv8s8s/y8s+8RJxRwfvjcpF/Frx/My/+578V/f6OCt6/mYv67wXv38wF79/MZX//
ZruXqDNS/FkUfxbVP8v3/ZtpbE/qM+WfRfXPovpn2euf7Vmizgjv38xF9c+C92/mxf/8Z86/v6Mi
/xT/Mxe8fzMXvH8zl/39m60sUWek/F38z1zUf1/8z38r2n5H8s8i/yzqvxf138vef291iTojvH8z
F/XfC96/mRf/89+Ktt+R/LPIPwv487mAP5/Lzp9vbYk6I/WPxP/M4n/mL//zyWN7Ep8p/mcW/zOL
/5lf/M/Wl4gzqnj/Zhb/M1e8fzMv/ue/gOT3d1Tln1X+WZW/V+Xvdc/f21gizqgq/qyKP6vy98X/
/LeitD2pz5R/VuXvVfl73fP3NpeoM8raT+Xv//E//2dF+XtGv7+jKv8U/zOL/5nF/8wv/mf/ijoj
5e/if2bxP/OX//nc2+9I/in+Zxb/M4v/mV/8z/59UmfUtJ+qfy7+53tFbZ3Rs/2O5J9V/lnx/s1c
8f7NXPf3b/ZziToj1T/F/8xV85+L//lvRdvvSP5Z5Z9N859N859tn//s1xJxRu3AfjbNf/7H/3yv
aPE/X9lEk382+WcDfz438Odz2/nzfX0m+PO5KX9vyt+b4s+m+PM//uf/rD0g72hRn6n+e8P7N3PD
+zdz29+/2eMStXbFn03xZ1P+vvifr2xX/M8s/mduyt+b8ve25+89LVHfT8WfTfFnU/6++J+vikRT
/i7+Z27K35vy97bn7z0vUWek+FP8z9yUv7dv/v5sZ6T8vSl/b8rfm/L3tufv/V6izkjxZ1P82ZS/
t2/+/mweovy9KX9vyt+b8ve+5+/9WSLOqCv+7Io/u/L3/s3fy7k9qc9U/t6Vv3fl733P33tZIs6o
K/7sij+78vf+zd/L779cXf4p/mfuyt+78ve+5++9LlFnpPhT/M/clb/33/x9W5H8s8s/u/L3rvy9
7/l7b0vUGSn+7Io/u/L3/s3fy68zdPlnl3925e9d+Xvf8/fel6gzUvwp/mcW/zN/+Z9PGduT+kz5
p/ifWfzP/OJ/9rFEnZHiT/E/c1f+3r/5e92cQf7Z5Z9d+XtX/t73/L3PJeqMFH92xZ9D+fv45u81
bU/iM8X/zEP5+1D+Pvb8fXxFnNFQ/DkUfw7l7+Obv2+1yiH/FP8zi/+Zxf/ML/7nWE8qfx/K38X/
zOJ/5i//86nbiuSf4n9m8T+z+J/5xf8c5xJ1Rsrfxf/MQ/n7+Obv9dcZhvxzyD+H8veh/H3s+fu4
lqgzUv4+lL8P5e/jm7+3c3tSnyn/HMrfh/L3sefvY32m8veh/H0ofx/K38c3f2+bM8g/xf/MQ/n7
UP4+9vx9xCXqjJS/i/+Zh/L38c3f2/Y7kn8O+edU/j6Vv889fx9piTijqfx9Kn+fyt/nN39vv7+j
Kf+c8s+p/H0qf597/j7yEnFG4n9m8T+z+J/5y//c+zLif2bxP7P4n1n8z/zif457iToj9d/F/8z/
8T//57+etJ95389nidrPV/7+FbV23d+cur85dX9zan5p6v7m1P3Nud/fHGWJ2k/d35zK36fy96n8
fe75+6hL1H7q/vtU/DmVv0/dfxf/M4v/mafy96n8fe75+2hL1H7q/vtU/Dnln1P+OeWfU/ffxf/M
4n/+rPjP2v/9z79rvz8v/+xL/Lv2+4P77/cH/nl/kL/fH+Tv9wf33+8P7r/f4n/e4n/eH9x/vz+4
/35/9vvvYyxRa8f99/uD/P3+IH+/P8jf78+ev4+5xL+/o/vN//yKWjvy91v8z1v8z1v8z1v8z1v8
z/vF/5xfUfuJ+0e3+J/3B/55f+Cf9wfzn/cH85/3B/HnLf7n/cH85/3B/Of92ec/5/dJrR3zn/cH
85/3B/n7/YF/3h/45/2Bf97if97if94f+Of9gX/en90/57lErR3+eX/gn/cH/nl/4J/3B/55f+Cf
t/ift/if9yH/POSfx+6f81oi1n7IPw/55yH/POSfh/zzkH+K/3mL/3kf8s9D/nns/jnXZ8o/D/nn
If88EH/eB+LP+0D+fh+Yn7/F/7zF/7wP5O/3gfz9Pvb8fcYlau2Yn78P5O/3gfn5+8D8/H3s8/Mz
LRH/dhyYn7/F/7zF/7zF/7zF/7zF/7zF/7zF/7xf/M+Zl6j9lH+K/3kf8s9D/nnIPw/55yH/FP/z
PuSfh/zzePnnvUStXf55yD8P1D/vA/XP+9jrn/NZor5LU98l+eeJ+uct/uct/uct/uct/uct/uf9
4n/OskTsp/ift/ift/ift/ift/ift/ift/ift/ift/ift/if94v/OesStXbcf7/F/7zF/7zF/7zF
/7zF/7zF/7zF/7zF/7zF/7xf/M/Zlqi1K/4U//MW//MW//MW//MW//MW//MW//MW//MW//N+8T9n
X6LWLv8U//MW//MW//MW//MW//MW//MW//MW//MW//N+8T/nWKLWLv8U//MW//MW//MW//MW//MW
//MW//MW//MW//N+8T/nXCLWLv7nLf7n/R//83/+6wf+7fiP//n///X8/b+f+Lfjzf/8ilq7/POS
f17yz0v+eck/L/nntfln/n1S+yn/vOSf4n/e4n/el/zzkn9e8s9L/nnJPy/555X3tZ9L1Nrln5f8
U/zPW/zP+5J/XvLPS/55yT8v+ecl/7zKvvZriVq7/POSf17yT/E/b/E/b/E/b/E/b/E/b/E/b/E/
753/mb+fKf8U//MW//MW//MW//MW//P+8j+33sQt/uct/uct/uct/ue98z/zJy4Raw/oH93if94B
/aM7oH90B/SP7qD4M6B/dAf0j+5w7Z6clghPDvLPIP8M6B/d4ds/+u3x3eJ/3uJ/3gH9ozugf3SH
uJ9RXqLOKGk/0T+6/+N//s+K0t8+7B3Qf7/F/7yD8veg/D3c+xndS9QZyT/F/7yD/HPxP/de+R3k
n0H+GeSfQf4ZXv75LFFnVLWf8s//+J//s6L6d57hDui/3wH99zuAH3IH8EPu0PczKkvUGeH++y3+
5y3+5/3lf24zJ7f4n7f4n7f4n7f4n/fO/8yfukSc0Zv/GZaI/fyP//le0eJ/7nNBd5R/RvlnVPwZ
FX/GV/zZlogzisrfo+LPqPhz8T/32a1b/M9b/M87Kv6Mij/jK/7sS9QZYX7+joo//+N//s+K4t/5
ujvKP8X/vCP673dE//2OeT+jsUSdEebnb/E/74j++734n/sM5B3ln1H+GdF/vyP673d89jOaS9QZ
YX7+jui/3//xP/9nRWWdUdl+R/LPKP+M4IfcEfyQO278kHx8RZ2R4k/xP2/xP+8v/3ObJb7F/7zF
/7zF/7zF/7x3/mc+vk/qjDA/f4v/ef/H//yfFc2v1/1+65L8M8k//+N/vlf04n+u/9B//M//VnQu
EWeU1D9K6h8l9Y8W/3OfYL/F/7zF/7yT+kdJ/aN07Wd0LRFnlDA/fyf1jxLuH93pe//o95bBneSf
4n/eCfeP7oT7R3dK+xmtz8T9o1v8z1v8zzvh/tGdvvePnu1bJ/9M8s+E+0d3wv2jO937GcUl6oww
P38nzM/fCfeP7vTlh/ze1rmT/DPJPxPml+6E+aU71f2M0hJ1Rsrfk/L3pPx98T/3G1W3+J+3+J93
Uv6elL+nPX8/8hJ1Rpifv5Py94T7R3f63j+K2xnJP8X/vMX/vMX/vHf+Zz7uJeKM/q+4f9mdL+nS
+765r6IvIfc5omcUKcKECVLobguQDQ/iCAgQbEOG799VZK3M2G99AA096EEv7Mr3HxGZz+9Zh/ju
R/0j8T+T+J/p+fFD9uVJfab0U/zPJP5nWvmfz5YjiDN6MD+fxP9MD+4fped7/+h3zzQ90s9H+vlo
funR/NJzrWdUIqgzUv3zUf3zUf3z+d4/+t0FTuJ/JvE/06P656P657PWP7caQZ0R5ufTo/rng/tH
6fneP8rLt076Kf5nenD/KD24f5Sesp5Ri6DOCPPzSfzP9OD+UXq+94/S8q2Tfj7Szwf3j9KD+0fp
aesZ9QjqjDA/nx7Mz6cH94/S871/tNTrHunnI/181H9/1H9/5npGI4I6I/XfH9U/k/yn+J8pKX9P
3/x9qewl5e9J+XtS/p6Uv6c1f99mBLH2JP+Z5D+T8vf0zd/TsiLl70n5e1L+npS/pzV/379BfD+T
/GeS/0zK39M3f/+RRlJS/p6Uvyfl70n5e1rz9z2eVP6e5D+T/GdS/p6++fuPBpOS8nfxP1NS/p6U
v6c1f9/3COqM5D+T/GdS/p6++fuP2JOS8nfxP5P4n0n8z7TyP5/9iKDOSP5T/M8k/mf68j8XqlIS
/zOJ/5nE/0zif6aV//mHoYqgzkj+U/zPlJS/B//zT4rp98ks/czSz6z8PSt/z2v+vl8RxBm9+Z/f
IPYzq3+U1T/KuL+Z8vf+5tIdyPKf4n+mjPubKeP+ZsrnuvY7glq7+kfif6as+c/gf/5Jr12e1GfK
f2bNf2bNf+Z7/X4+EcT3M2v+M6t/JP5nEv8zZeln/urn0kfI0s8s/czSzyz9zC/9TBHU2qWf4n+m
LP0M/uefgOLfk9LPLP3M0s8s/cwv/cwR1PcT739P4n+mLP+Z5T+z/Gf++s+lhyL+ZxL/M2X5zyz/
mVf/uZcIau3qv2f5z6L5z+B/rpz8JP5nEv8zFc1/Fs1/lm39ftYI4vtZNP9ZpJ9F/rPIfxb5z/Lr
H43lSX2m/GeR/yzyn+XlP1sEtXb5zyL/WeQ/g//5J3v896T8Z5H/LPKfRf6zvPxnjyC+nwX3N1OR
for/mcT/TOJ/ph//c5kTEP8zif+ZxP9M4n+mlf/57COCWrvyd/E/k/if6cv/TIsTEP8zif+ZxP9M
4n+mlf/57DOC+n7i/ZtJ/M9U5D+L/GdR/738+u/Laar/XtR/L+q/F/Xfy9p/P75BrL3Kf1b5z6r8
Pfiff74C4Pek8veq/L0qf6/K3+uavx/xpPL3qvnPKv0U/zOJ/5mq6p/1W/9c+tpV9c+q+mdV/bOq
/lnX+uexR1Brl/8U/zNV1T+r5j+r6p9V9c+q+mdV/bOu9c/jiKC+n5r/FP8zVfnPKv9ZNb9Uv/NL
Swdc/M8k/meqml+qml+q6/zSEZ+p+aUq/1nlP6vml+p3fqkv30/NL4n/marml6rml+o6v3RcEdT3
E+8/SlX6WeU/q/xnVf+o/vjzP6Wtyt+r8veq/lFV/6it/aPjjiDW3uQ/m/xnU/+offtH/Vie1Gcq
f2/qHzX1j9raPzqeCOL72fD+jtSkn03+U/zP1DT/2b7zn8ucQFP+3pS/N81/Ns1/tnX+80gR1Nrl
P5v8Z9P8Z/vOf/bf382m+c+m/L1p/rNp/rOt859HjqC+n7q/2aSf4n8m8T+T+J+p/frvvwxF/M8k
/mcS/zOJ/5lW/udzlAhq7fKf4n8m8T/Tl/+ZFpcu/mcS/zOJ/5nE/0wr//M5agT1/dT8vPifqcl/
NvnPpvn59p2f79fypD5T+XvX/HzX/Hxf5+ePFkGsvev+UZf/7PKfXf6zv/xnjyC+S13+s8t/duXv
/Zu/L7+OLv3s0s+u/L0rf+9r/n6MCGo/lb935e9d+Xv/9o8W9e7Szy797Mrfu/L3vubvx4ygzkj1
z678vav+2b/1z8VddPnPLv3sqn921T/7Wv88v0GdkfSzSz+76p9d859d/rPLf3bVP7vqn32tf57x
pOqfXfrZpZ9d/aP+7R8t2VlX/t7lP7v6R139o772j849gjoj+c8u/9nVP+rf+c9FaYfy96H8fah/
NNQ/Gmv/6DwiiDMa6h8N+c8h/znkP8fqP89YkfznkP8U/zMN5e9D+ftQ/j6Uvw/l70P5+1jz9/OK
oPZT+bv4n2kofx/f+aXlVzyUvw/l70P5+1D+Ptb8/bwjqDNS/VP8zzRU/xzf+ueitEP+c8h/DtU/
h+qfY61/nk8EdUaqf4r/mYbqn+PHT15WJP855D+H6p9D9c+x1j/PFEGdkfpH4n+mof5R8D9f3Zah
/H3Ifw71j4b6R2PtH505gjojzS+J/5nE/0zif6aV//mcJYLYzyn/Kf5nEv8z/fifyzdE/M8k/mcS
/zOJ/5lW/udz1ghiP8X/TOJ/JvE/08L/XFak/F38zyT+ZxL/M638z+dsEdQZyX+K/5mm8vd5wy9N
5e9T+ftU/j6Vv881fz97BHVG8p/if6ap+ufM8EtT9c+p+udU/XOq/jnX+uc5Iqgzkv+c8p9T9c/5
rX8umdRU/XOq/jlV/5yqf861/nnOCOqMVP+c8p9T/nPKf87Vf17foPYT7y9OU/5zyn/O+ff9zB/4
zz+Cf//M/IH/zB/4z/xZ/ecVT8J//hH8+35m8T/zB/4zf+A/82f1n9cewb/vZ/7Af+YP/Gf+wH/m
z6H9hP/M4n9m8T+z+J955X8+1xFB7Sf8Zxb/M4v/mb/8z0VDsvifWfzPLP5nFv8zr/zP54rPhP/M
H/jPLP5n/sB/5g/e35E/8J/5A/+ZP/Cf+QP/mT+r/7yuCOqM4D/zB/4zf+A/86f+/W9xFv8zi/+Z
P/Cf+QP/mT+r/7zuCOqM4D/zB/4zf+A/86f/3S/lD/xnFv8zf+A/8wf+M39W/3k9EdQZof6Zxf/M
G+aX8ob3d+QN/aO8oX+UN8wv5Q3zS3lb55euFEGc0Qb/mTf4z7xh/jNvv/nPZUXov+dN+rlh/jNv
mP/M2zr/eeUI4ozE/8zif2bxP/P2e3/HWJ7UZ0o/xf/M4n/mlf/5XCWCOiP4zyz+Z97w/o68fd/f
8ZsDzJv0c5N+bnh/R97w/o685fWMagR1RvCfWfzPvOH9HXn7vr+jLiuSfm7Szw3v78gb3t+Rt7qe
UYugzgj+M2/wn3nD+zvy9n1/x68GmDfp5yb93PD+jrzh/R15G+sZ9QjqjAY82Ib+Ud5Q/8wb/Gfe
4D/z9vWfy2nu8p+7/Ocu/7nLf+4v/zkiiLXv6L/nXf5zx/33vH/vvy+/OPE/s/ifecf997zj/nve
1/vv14wgvp+7/Ocu/7nj/nvev/ffF1Xc0T/K4n/mHfff847773lf77/f36DOSP5T/M+84/573r/3
35e/XDv6R3lH/yjvuP+ed9x/z/t6//3+Pqkzkv/c5T939N/z/u2/L+5iR/8o7+gf5R3997yj/573
tf9+7xHUGcl/iv+Zxf/MX/7nqorif2bxP7P4n1n8z7zyP5/7iKDOCP33LP5n3uU/d/nPffWfd6xI
/nNH/TOL/5kP+c9D/vOQ/zzkPw/5z0P+81j9531FEPt5yH8e8p+H/Och/3nIfx7yn4f85yH/eaz+
874jiDM65D8P+c9D/vOQ/xT/M4v/mQ/5z0P+81j95/1EUGck/3nIfx7yn4f85yH/Kf5nPuQ/D/nP
Y/Wfd4qgzkj+U/zPfMh/HvKfh/znIf95yH8e8p/H6j/vHEGdUYMuHfKf4n9m8T/zgf57PrrWjv57
PlD/zAfqn/lA/TMfa/3zLhHU2uU/D/nPQ/7zmPh+nvKfp/znKf95yn+eq/+8awTx/TzlP0/5z1P+
89yhIaf85yn/ecp/nvKf5+o/7xZBnNEp/3nKf57yn+cJnT/lP0/5z1P+85T/PF/+s0dQZyT/ecp/
nvKfwf9cu6v5lP885T9P+c9T/vN8+c8RQZ1Rhoac8p+n6p+n6p/nWv+8ZwS1nwXe5pR+nqp/nhVe
8ZT/POU/T9U/T9U/z7X++XyD2k/cP8qn8nfxP7P4n1n8z/zjf65rx/xnFv8zi/+Zxf/ML/7n830S
a3/zP79BrP2S/7zkPy/Mz+drw9ov6ecl/bzUP7rUP7rW/tGzR1BrV//okv8U/zOL/5kv9N/zdWrt
8p+X/OeF/nu+0H/P19p/f44Iau14/2YW/zNf0s9L+nlJP69Ha5d+iv+ZL+nnJf28Vv184jOln5f0
85J+XvKfl/znJf95Fa1d/vOSfl7yn5f857X6z+eKoNYu/3nJf4r/mcX/zOJ/5h//c1279FP8zyz+
Zxb/M7/4n88dQa0d/fcs/me+1D+6lL/fyt/vD9Z+Sz9v6eet/P1W/n6v+fvzRBBrv3H/Pd/K38X/
zOJ/5hvz8/k+tHbp5y39vDE/n2/Mz+d7nZ9/UgS1dry/I4v/mW/l77fy91v99/vW2qWf4n/mW/33
W/33e+2/PzmCWjvub+Zb+fuN+aV8Y34p35hfynfW2qWft/TzxvxSvjG/lO91fukpEdTa8f6OfGN+
KYv/mcX/zOJ/5lv1T/E/s/ifWfzPLP5nfvE/nxpBrV31T/E/8y3/ect/3rh/lG/cP8q39POWfj6Y
/8wP5j/zs85/Pi2CWPuD+c/8YP4zi/+Zxf/Mj/L3Z8faH+nnI/18lL8/yt+fNX9/egS1drx/M4v/
mcX/zOJ/5hf/8xkRRG744P3FWfzPLP5n/vE/l+qB+J9Z/M8s/mcW/zO/+J/PjKD2U/VP8T+z+J/5
x/9cKjzif2bxP7P4n1n8z/zif/6COiP5T/E/s/if+cf/XKpw4n9m8T+z+J9Z/M/84n+m75M6I/Xf
xf/M4n/mH/9zqZSK/5nF/8zif2bxP/OL/5n2COqMpJ/if+Yk/5nUP0ryn0n+M8l/JvnPtPrPdEQQ
Z5TUP0ryn0n9o/TtHy0zZkn9o6T8Pal/lNQ/Smv/KMVnqn+UlL8n5e9J/aP07R8tc4BJ/jNJP5P6
R0n9o7T2j9IVQZ2R+kdJ/aOk/lH69o+WWc0k/UzSz6T+UVL/KK39o3RHUGck/5nkP5Py9/TrH+3L
k/pM6WdS/p6Uv6c1f09PBHVGml9Kyt+T5pfSd35pmXlO0s8k/UyaX0qaX0rr/FJKEdQZyX8m+c8k
/xn8z5VOlpP0M0k/s/xnlv/Mq/9MOYI4owz+Us7ynxn3j3LwP1emUxb/M4v/mTPuH+WM+0c5r/eP
Uokgzigrf8/K37Pqn8H/fP7EYfye1GdKP7Pqn1n1z7zWP1ONoM4I949yVv0z4/5RDv7nyqvMWfop
/mfOuH+UM+4f5bzeP0otgjoj5e/if+as/D34nytPNWfpZ5Z+ZuXvWfl7XvP31COoM8L9oyz+Z864
f5SD//mkvvyOpJ9Z+plx/yhn3D/Keb1/lEYEdUaqf2bVP7P6R8H/XAnGOUs/s/Qzq3+U1T/Ka/8o
zQjijIr670X9owJ+XS5fft3vzSm5SD+L9LOAH5IL+CG5rPyQ/A3ijMT/zOJ/ZvE/85f/+d9ej/AN
6jOln+J/ZvE/84v/mb9P6ozUfxf/M4v/mX/8z/H7HYn/mcX/zOJ/ZvE/84v/mfcI6ozUPxL/Mxfw
Q3LwP189/SL9LNLPAn5ILuCH5LLyQ/IRQZ3Ra/7zG9R+qv8u/mcW/zMX9d/F/8zif2bxP7P4n/nF
/8zxmcrfxf/M4n9m8T+z+J9Z/M9c1H8X/zOL/5nF/8zif+YX/zNfEcTaq/rv4n/mqvmlqvmlus4v
5TuC+B1V3d+sqn9W1T+r6p9V+in+Z66qf1bVP+ta/8xPBLWfqn+K/5mr/GeV/6zK3+ultSt/F/8z
V+XvVfl7XfP3nCKotYM/n6v8Z5V+VulnlX7WpLVLP8X/zFX6WaWf9aWfOYJau/SzSj+r8vcq/azS
zyr9rNLPKv2s0s8q/awv/SwR1Nqln1X6WaWf4n/mKv2s0s8q/azSzyr9rNLP+tLPGkGsvUk/m/RT
/M8s/mcW/zM3zS+J/5nF/8zif2bxP/OL/5lbBLV2zS+J/5mb6p9N9c+21j9zjyD+drz5n9+g1i79
bNLPJv1s0s8m/WzSz/bSzxFB7af0U/zP3KSfTfrZpJ9N+tmkn+J/5ib9bNLP9tLPGUGtXfop/mdu
0s8m/WzSzyb9FP8zi/+Zm/SzST/bqp/lG9TapZ9N+tlU/2yqf7a1/lniSdU/m+5viv+Zxf/M4n9m
8T+z+J9Z/M8s/md+8T/LHkHsp/ifWfzP3KWfXfrZ5T+7/GeX/xT/M3f5zy7/2Vf/WY4Iau3yn13+
s6v/3tV/72v/vcSK1H/v6r936WdX/71rfqmr/97Vf+/qv3f13/vafy9XBLWfml/q6h+J/5nF/8xd
9c+u+aWu+mdX/bOr/tlV/+xr/bPcEdTaNb8k/mfu0s8u/eyaX+qaXxL/M4v/mbvml7rml/o6v1Se
CGrtml/q6r93+c8u/ezSzy797NLPLv0c0s8h/Rwv/UwRxNqH9HNIP4f0U/zPPKSfQ/o5pJ9D+jmk
n0P6OV76mSOotUs/xf/MQ/n7kP8c8p9D/lP8zyz+Zx7yn0P+c6z+s5QIau3yn0P+c8h/DvnPIf85
5D+H9HNIP4f855D/HKv/LDWCWrv855D/FP8zi/+Zxf/MQ/5T/M8s/mcW/zOL/5lf/M/SIqi1y3+K
/5mH8veh/H0ofx/K34f0c0g/h/L3ofx9rPl76RHE2qfy96n8far+OVX/nGv9s4wIwi9N1T+n9HNK
P6f0c0o/p/RzSj+n9HO+9HNGUPsp/ZzST/E/s/ifeUo/p/RzSj+n9HNKP6f0c676Wb9BrV36Kf5n
ntLPKf2c0s8p/RT/M4v/maf0c0o/56qf9fuk1i79nNLPKX7IFD9krvyQukdQv6Oq35H0c8p/TvnP
Kf855T+n/OeU/5yr/6xHBLWf8p9T/nNKP6f0c8p/TvnPKf854T//HLT729r/CP597eWz+s96RvDv
ay8f+M/ygf8sH/jPIv5n+UA/ywf6WT7Qz/KBfpYP9LN8oJ/ls+pnvSKotUM/i/ifRfzPIv5nefE/
6x3Bv/+Oygf5exH/s4j/WT7I34v4n0X8zyL+ZxH/s7z4n/WJoPYT+XsR/7N8oJ/lA/0sH+Tv5YP8
vXyQv5cP8vfyQf5ePsjfy2fN32uKoNaO/L18kL8X8T+L+J/lA/0sH+hn+UA/ywf6WT7Qz/KBfpbP
Sz9zBLV26GcR/7N8oJ/lA/0sH+hn+UA/i/ifRfzPskk/N+nn9tLPEkGsfZN+btLP7aWfewT175R+
Bv9zncwpm/Rzk35u0s9N+rm99LNGUGuXfm7ST/E/i/ifRfzPssF/FvE/i/ifRfzPIv5nefE/a4ug
1g7/WcT/LBvmP8uG+c+yrfOftUcQfzs2vD+ubNLPTfq5ST/F/yzif5ZN+rlJP7eXfo4Iaj+ln5v0
c5N+btLPTfq5fd8f95sHK5v0c5N+btLPTfq5vfRzRlBrl35u0s9N+in+Z9mkn5v0c5N+btLPXfq5
Sz/3VT/bN4i179LPXfq5Y/6z7Jj/LPs6/9niScx/lh3vjyvif5Yd859lx/33smP+s+yY/yw75j/L
jvnPsq/zn22PoPYT99+L+J9F/M8i/md58T/bEUHt5639lP8U/7Ps4IcU8T+L+J9F/M8i/md58T9b
fCb4IWUHP6SI/1l26ecu/dxx/6js4IeUHfXPsqP+WXbcPyo77h+Vfb1/1K4Iau3gh5Qd8/Nlx/x8
2TE/X/Z1fr7dEdR3qcMv7ah/lh31z7L/5ufb8qT2U/q5o/5ZdtQ/y77WP9sTQezn8ap/7hHEfh6Y
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
n1X+883/vCOof6fuH9Xv/c2ld1Z1/6jq/lHV/aOq+0d1uX+Ufv+51i7/WeU/q/xn8D9fWXmVflbp
Z5X/rPKfbfGfKZ5s8p9N/lP8zyL+Z/nyP0fdlidxRuJ/FvE/i/ifZeV/pu+/U/6zqf4p/mdpqn8G
/zPtSxejqf7ZVP9sqn821T/btZ7REUGd0YXfkfifpWn+s33vvy+dpqb5z6b5z6b5z6b5z/asZxSf
qfnPpvn5Jv/ZlL+37/z8MlvYlL835e9N+XtT/t7KekZXBHVGRb8j+U/xP8uX/7nmHeJ/FvE/i/if
RfzPsvI/0/e7pP7Rm/8ZK5L/bJr/bN/3xy3q3TT/2aSfTfOfTfOfba5n9ERQZzR1Rqp/ds1/Bv8z
7WksT+KMuvSza/6za/6zb+sZpQjijLr8Z5f/7PKffcffoy7/2aWfXf6zy3/2cz2jHEGcUZf/7PKf
/VX/vCOof6fqn/1b/1y8d1f9s8t/dtU/u+qf/VnXXiKotT/4fnbVP7v67z1B58X/LOJ/lq7+e1f/
vef1+1kjqO9n0Rmp//4X//MfVlSQF3fNL4n/Wf7if/7DiqrOqK1n1CKoM2o6I/nPjve/l+B/vjVE
/feu+mfH+99Lx/vfSx/rGfUI6ozw/vfS5T/F/yzif5Yh/Qz+Z9r2tjyJzxzSzyH9HNLP8dLPEUGs
feD972VIP4f6R0P9o3Gs36UZQXyXxoHv0lD/aGj+M/ifr++S+J9F/M8ylL8P5e9jyd/T9g1qP2/t
p/Rz3Fq7/OfQ/ffgf75uAIn/WcT/LEP334fuv4+0rv37pNau++9D/nO88vc7gvp3qv4Z/M/32lX/
FP+zDNU/h+qfo65rjzNS/XPo/vtQ/XM0rV36OaSfwf98r136Kf5nGdLPIf0cq35uRwS1dunnkH4O
+c8h/ZzSzyn/OaWfU/o5pZ9T+jlX/dziM6WfU/o5pZ9T+jmln3PVz+2KIPRzSj+n9HNKP6f0U/zP
Iv5nmdLPKf2cL/28I6j9lH5O6ee88Tua0s8p/Qz+53vt0k/xP8uUfk7p53zp5xNBrV36OaWfU/2j
Kf2c0s8p/ZzSzyn9nNLPKf2cL/1MEdTapZ9T+jmln+J/lin9nNLPKf2c0s8p/ZzSz/nSzxxBrV36
OaWfb/5nrB36+Wfh7m9r/yP497XXD/SzfqCf9QP9rB/oZ/289LNE8O9rrx/oZ/1AP+ub/7lHUP9O
zM/X4H++1475+fqBftYP5pfqB/NL9XOua68R1Npx/71+kL/XD/hL9QP+Uv3c69+OFsG//+2oH/CX
qvif9QP9rMH/XHOZ+oF+1g/0s36gn/UD/ayfl372CGo/oZ/1A/2s4n9W8T/rB/pZP9DP+oF+1g/0
s36gn/UD/ayfl36OCGrtmF+qH+hn/aD/XoP/uf41rB/03+sH9c/6Qf+9ftB/r5+xfj9nBPX9xPx8
Ff+ziv9Zv/zPpXJSxf+s4n9W8T+r+J915X+m/RvEGW24f1TF/6wb5j/r9p3//FW36ob5z7pJPzf4
z7rBf9Zt9Z97PAn/WTfp5yb93OA/6/a9v5mXFcF/VvE/6wb/WTf4z7qt/nPfI6gzQv2zbvCfdUP/
vW7f+5u/enLd0H+v4n9W8T+r+J915X+m/Yigzgj1zyr+ZxX/s264v1nF/6zif1bxP6v4n3Xlf6Y9
PhP997qh/lnF/6wb5j/r9nv/+/Kk9HOTfm6Y/6wb5j/r1tczuiKoM4L/rBv8Z91w/6gG/zPtP4pF
Ff+ziv9ZN9w/qhvuH9Vtrmd0RxBntGN+qe6YX6o77m/W/cuv+/U36y79FP+ziv9Zxf+sK/8z7U8E
cUY77m9W8T+r+J/1y/9c+DZV/M8q/mcV/7OK/1lX/ucff84jqDPC/c0q/mfd0T+qwf9c5wTqLv3c
pZ87+kd1R/+o7mv/aM8R1BnJf4r/WXf0j2rwP//4H3mWJ/WZ0s8d/aO6o39U97V/tJcI6oyK9hP9
o7qjf1SD/7lOp9Rd+rlLP3f0j+qO/lHd1/7RXiOoM8L8Ut2Rv9cd+XsN/uc64VZ36af4n3VH/l53
5O91X/P3vUVQZ4T5pbojf6875j9r8D//+NYd3ycP6af4n/XA/Gc9MP9Zj209ox5BnNGB+aV6YH6p
HuDP1+PLn/8Re+oh/RT/sx7gz9cD/Pl6HOsZjQjijMT/rOJ/1uB/vld0fn3dzwUd0s9D+nkofz+U
vx9r/r7PCOqMML9Uxf+sh/L348tP/rFT6iH9PKSfh/L3Q/n7sebvxzeoM8L8UhX/swb/872i/PUM
y5PSz0P6eeD9R/XA+4/qsbz/KB3xJN5/VMX/rOJ/1gPznzX4n8+TruVJfab088D8Zz0w/1mPdf7z
2COoMwJ/vh6YX6oH5uer+J9V/M8a/M9XfUn8zyr+ZxX/s4r/WVf+ZzqOCGLt4n9W8T/rKf08pZ+n
9DP4n6+1n9JP8T/rKf08pZ/nqp9HfKb088T7O+op/TyVv5/K30/cP6rn9/7RWJ/UZ2L+s564f1RP
3D+q572u/Yqg1q78/VT+fuL+UT1/999/Siv+ZxX/s564f1RP3D+qZ1516Y4gdOlU/n4qfz9V/zy/
94+Wv4bif1bxP+up+uep+ue51j+PJ4I6I+Xvp/L3U/XP83f/aPnFqf4p/mc9Vf88Vf881/rnkSKo
M1L+fko/T+ln8D9frlL8zyr+Z72kn5f083rpZ44gzuhS/n5JPy/VP4P/+XL+4n9W8T/rpfrnpfrn
tdY/jxJBnNGl/P1S/n6p/hn8z1d2Jv5nFf+zXqp/Xqp/Xmv986gR1Bkpf7+Uv1+qfwb/85VBi/9Z
xf+sl+qfl+qf11r/PFoEdUbK3y/l75fqn8H/fFU5xP+s4n/WS/XPS/XPa61/Hj2COiPl75fy90v1
z+tb/1wqUeJ/VvE/66X656X657XWP48RQZ2R8vdL+ful+uf1fX/HUi0U/7OK/1kv1T8v1T+vtf55
zAjijG7l77fy91v1z+B/viq64n9W8T/rrfrnrfrnvdY/z28QZ3TLf97yn7fqn/e3/tnXJ/WZ0s9b
9c9b9c97rX+e3yd1Rsrfb+Xvt+qf948f8nNB4n9W8T/rrfrnrfrnvdY/zz2COiPl77fy91v1z/s3
P1+WJ/WZ0s9b9c9b9c97rX+eRwR1Rsrfb+Xvt+qfwf98dRjF/6zif9Zb9c9b9c97rX+e8Zmqf97K
32/l77fqn8H/fHWBxf+s4n/WW/XPW/XPe61/nlcEdUaqf96qf96qfwb/89WpF/+ziv9ZH9U/H9U/
n7X+ed4RxBk9yt8f5e+P8vfgf76mKcT/rOJ/1kf5+6P8/Vnz9/OJIM7oUf3zUf7+qP4Z/M/XxIv4
n1X8z/qo/vmo/vms9c8zRVBnpPrno/rno/rno/kl8T+r+J/1Uf3zUf3zWeufZ46gzkjzS4/qn8/L
f36D+ncqfw/+53vtyt/F/6yP8vdH+fuz5u9niaDWjvnP+sh/PvKfj/zns/rPs0ZQ3yXwl6r4n1X8
z/rlf75+HfKf4n9W8T+r+J915X+ms0UQ+5mkn+J/1iT/mb7+c1GwJP+Z5D+T/GeS/0wv/9kjiDNK
0s8k/Uzyn+nnP9PypD5T/jPJfyb5z/TynyOCOiPpZ5J+JvnPBH5yTfKfSf4zyX8m+c/08p8zgjoj
6WeSfib5z/T1n4tbS/KfSf4zyX8m+c+0+s/rG9QZyX8m+c8k/5m+/nNx1En+M8l/JvnPJP+ZVv95
xZPyn0n+M8l/JvnP9PWfS9aT5D+T9DPJfyb5z7T6z2uPoM5I/jPJfyb5z/Tzn78ns/QzSz+z/GeW
/8yr/7yOCOKMsvxnlv/M8p/56z+X6kGWfmbpZ5b/zPKfefWfV3ym/GeW/8zyn1n+M3/959IJzdJP
8T9rlv/M8p959Z/XFUGdkebns/xnVv0zq/6Z1T8K/ufLrWX1j8T/rFn9o6z+UV77R9cdQa1d/jPL
f2bpZ5Z+Zuln8D/fa5d+iv9Zs/QzSz/zSz+fCGrtTWuXfmb1j7L6Rxn8kBr8z/fawQ+p4n/WDH5I
zeCH1LzyQ64UQa19au3qHxXpZ5F+FvnP4H++1l7kP4v8Z5H/LPKfZfWfV44g1l7w/s1apJ8F/JAq
/mct4C/V4H++1y79LNLPAv5SLeAv1bLyl64SQa0d/Pkq/mct8p9F/rOofxT8z/fapZ/if9ai/lFR
/6is/aOrRlBrT1q7/GeR/yzyn+XlP1sE8XezvPRzj6DWLv0sBd6mSD+L9LNIP4v0s7z0s0dQ+yn9
LNJP8T+r+J+1SD+L9LNIP4v0s0g/i/SzvPRzRFBrl34W6af4n1X8z1qln1X6WaWfVfpZpZ9V+llf
+jkjiLVX6WeVfor/WcX/rFX6WaWfVfpZpZ9V+lmln3XVz/sb1Nqln1X6WaWf4n9W8T9rlX6K/1nF
/6zif1bxP+vK/0x3PCn9rNJP8T9rzdC6qvpn1fxn8D9fWU+V/6zSz6r5z6r5z7rOf97x79T8Z9X8
p/ifVfzP+uV/ruot/mcV/7OK/1nF/6wv/ud9RBB/j6r0U/zPKv5n/fE/l+qB+J9V/M8q/mcV/7O+
+J/3GUGcUdP9d/E/q/ifteH9R1X8zyr+ZxX/s4r/WV/8z/uKIM6oST/F/6zif9b2ff/RUoUT/7OK
/1nF/6zif9YX//O+I6gz0vyn+J9V/M/65X/O816e1Gcqfxf/s4r/WV/8z/uJoM7olb9/g9pP5e9N
+Xtb8/c7RVD7CX5Ibcrfm/pH7Tv/uX5D1D8S/7M29Y+a+kdt7R/dOYLaT80vNfWPmuY/g/+Zjpp/
T8p/iv9Zm+Y/m+Y/2zr/eZcI6ozUP2rqHzXNfwb/89WTapr/FP+zds1/ds1/9nX+864RxBl1+c8u
/9k1/9l/999/Sts1/yn+Z+2a/+ya/+zr/OfdIogz6uofdfWPuuY/+/f++/LXsGv+U/zP2jX/2TX/
2df5z7tHUGcE/lIV/7OK/1nF/6wv/uc9Iqj9BP+ziv9Zxf+sXfNL4n9W8T+r+J9V/M/64n/eM4La
T/lP8T+r+J/1y/9cf8Xif1bxP6v4n1X8z/rifz7foM5I/lP8zyr+Z/3yP1elFf+ziv9Zxf+s4n/W
F//z+T6pM5L/FP+zdvWPgv/5+ms4lL8P5e9D/aOh/tFY+0fPHkGc0ZD/HPKfQ/2j8bu/uT6pz1T+
PtQ/GuofjbV/9BwRxBkN+c8h/znUPwr+5ysvHuofDfWPhvpHQ/2jsfaPnvhM9Y+G+kfif9Yh/znk
P8fqP58rgtpP8OfrkP8c4M/XkfSd1/1N8T/rAH++DvDn61j5888dQe2n/Kf4n3WAP1+D//nHN6Qv
T+ozlb8P8OfrAH++jpU//zwR1Bnh/cV1yH8O+c8h/zlW//mkCGo/dX9zyH8O+c/xff/m+g2R/xT/
s075zyn/OVf/+eQIYj+n/OeU/5zyn/P3/s2fW5vyn+J/VvE/q/if9cX/fEoEcUZT/lP8zyr+Z/3y
P9e/xeJ/VvE/q/ifVfzP+uJ/PjWCOiPVP8X/rFP1z+B/vvzSVP1zqv45Vf+cqn/Otf75tAjqjOQ/
p/zn1P2j+eUvLZ526v6R+J916v7R1P2jud4/enoEdUbyn1P+c+r+UfA/X0o7lb+L/1mn5j+n5j/n
Ov/5jAjqjDT/Kf5nnap/TtU/p+qfE+8/qlP+U/zPOlX/nKh//mlylrXPCP597U38zyb+Z/ug/tmC
/7n+4toH/rN94D/bB/XP9kH9s33W+ucv+PfvZ/ug/tk+qH+2D+qfLfifqyq2D/xn+8B/tg/qn+2D
+mf7rPXPFE+i/tk+qH+2D+qf7YP6Z/t833/0+8vVPqh/NvE/2wf+s33gP9tn9Z9pj6DOCPNL7QP/
2T7wn+0D/9k+8J9N/M/2gf9sH/jP9ln9ZzoiqDOC/2zif7YP/Gf7wH+2D/xn+8B/tg/8Z/vAf7bP
6j9TfCb8Z/vAfzbxP9sH+Xv7QD/bB/PzLfif79NE/bOJ/9k+mJ9vH8zPt886P5+uCGLtG/L3tiF/
bxv67y34n69fnPifTfzPtqH/3jb039u29t/THUF8Pzfk721D/t42zM+34H++VFH8zyb+Z9swP982
zM+3bZ2fT08EdUbI39uG/L1tmJ9vwf98/eUS/7OJ/9k21D/bhvpn29b6Z0oR1Blhfr5tqH+2DfXP
tqH+2cT/bOJ/tg31z7ah/tm2tf6ZcgR1RgUasqH+2Tbp5yb93KSfwf98r136uUk/N+nnJv3cXvpZ
Iqi1Sz836eeG/L1tyN/btubvqUZQ3yXk7038z7Yhf2/bxN+jDfl725C/tx35e9uRv7d9zd9TiyD2
cwd/qYn/2Xb5z13+c0f9s+071i7+ZxP/s+2of7Yd9c+2r/XP1COotYO/1Hb5zx35e9uRv7cd/KW2
4/3vbZf/3OU/d/CX2g7+UttX/lIaEdTakb+3Hfl72zE/3/Yff+mnDLv85y7/uaP/3nb039u+9t/T
jCB+mzvy97Yjf287+u9tB3++7dLPXfq5o//edvTf27723/M3qDNC/t525O9tR/+97ei/tx3997ZL
P3fp5y793Ff9zPGk9HOX/9yln7v0c//WPxcHuEs/d+nnIf08pJ/Hqp95jyDO6JD/PKSfB+qf7fjW
PxeXfqD+2Q7UP9uB+mc7UP9sx1r/zEcEcUaH/Och/3mg/tmO7/uPfhOD7ZB+HtLPA/XPdqD+2Y61
/pnjM1H/bIf85yH/eaD+2Y4ff345I+nnIf08UP9sB+qf7Vjrn/mKoM5I/vOQ/zxQ/2zH9/3vv3u7
7ZB+HtLPA/XPdqD+2Y61/pnvCOqMUP9sB+qf7UD9swX/c71b3Q7p5yH9PFD/bAfqn+1Y65/5iaDO
SPn7ofz9UP5+gL/UDumn+J/tUP5+KH8/1vw9pwjijE7l76fy91P5+/nlz/8YWe2Ufor/2U7l76fy
93PN33OOIM5I/M8m/mc7lb8H/3PlmLVT+nlKP0/l76fy93PN33OJoM5I+fup/P1U/n7++PPP70np
5yn9PJW/n8rfzzV/zzWCOiPl76fy91P5e/A/Vx5gO6Wfp/TzVP5+Kn8/1/w9twjqjDC/1E7l7yfm
l9r5vX/0Yza2U/p5Sj9PzC+1E/NL7Vznl3KPoM4I80vtxPxSOzG/1M7v+4t/XM12Sj9P6eeJ+aV2
Yn6pnev8Uh4R1Bmhf9RO9I/aifmldv7uv/+07pJ+XtLPC/NL7cL8UrvW+aU8I4gzupS/X8rfL+Xv
wf9c+bTtkn5e0s9L+ful/P1a8/fyDeKMLvWPLuXvF+aX2vXjz++/J6Wfl/TzwvxSuzC/1K51fqnE
k5hfapf6R5f6Rxf4Sy34n+tMfrukn5f08wJ/qV3gL7Vr5S+VPYI6I/CX2qX+0YX77038z3Ypf79+
/KW+PKm1K3+/lL9fyt+vNX8vRwS1dvCXmvifTfzPJv5ne/E/S6xI/vNC/72J/9nE/2zB/3zvp/yn
+J9N/M8m/md78T/LFUHs55v/+Q1iP2/p5y39vFf9LHcEsZ/3Sz/3CGLtt/Tzln6K/9nE/2y39POW
ft4v/XwiqP1U/fOWft7qv9/qv99r/72kCGo/L+2n6p+3+u/B/3z9hb2ln7f081b//Vb//V777yVH
UPuJ+0ftVv3zVv3zVv3zXuufpURQ+yn9vKWft/Tzln7e0s9b+nlLP2/p5/3SzxpB7af085Z+3tLP
W/p5v/SzRVD7Kf0U/7Pd0s9b+nlLP2/p5y39vKWf90s/ewSxn4/0U/zPJv5nE/+zvfifZUQQ+/nm
f36DWLv4n+1R/0j8zyb+ZxP/s4n/2V78zzIjqP2Ufor/2R7p5yP9fFb9rN+g9hP339sj/Xykn8H/
fO+n9FP8z/ZIPx/p57PqZ/0+qf2Ufj7Sz0f6+Ug/n1U/6x5B7af0U/zPJv5ne6Sf4n828T+b+J9N
/M/24n/WI4LaT+mn+J9N/M8m/md78T9rrEj6Kf5nE/+zif/ZHumn+J9N/M8m/mcT/7O9+J/1iiD2
M0k/xf9sSfqZpJ9p1c96RxD7maSfSfqZpJ9J+in+ZxP/syXpZ5J+plU/6xNB7af0M0k/k/QzST/T
Sz9TBLWf8p9J+pmkn+k7/7lUD5L0M0k/k/QzST/TSz9zBLWfuH/UkvQzaf4zfec/1xVp/jMpf0+a
/0ya/0zr/GctEdQZFX3npZ9v/mesXfXPpP5R+r2/41dTTeofJelnkn4m6Wd66WeNoNbe9f2Ufibp
Z/A/X3XvJP1M0s8k/UzSz/TSzxZBfD/f/M89gtjPrP5R/vKTl95EVv8oq3+U1T/K6h/ltX9UewRx
Rm/+5x1B7GdW/yirf5TVP8rqH2X1j7L6R3ntH9URQZ3RBU0W/7OJ/9nE/2wv/medEdR+3vjOi//Z
suqfwf9876fqn1n1z6z6Z1b9M6/1z/YNaj9V/8zSzwx+SBP/s2X5z+B/vtcu/5mln1n+M8t/5tV/
tu+TWrv8Z5Z+Zulnln7mVT9b7JL0M8t/Zulnln5m+c8s/czSzyz9zNLPvOpnOyKI/Szyn+J/tqL7
R0X3j4ruHwX/8/VdKuofFfnPovtHRfePynr/qMVn6v6R+J9N/M8m/mcrun8k/mcT/7OJ/9nE/2wv
/me7IojvZ9H8p/ifrch/Bv/z9dewyH8W6WeR/yzyn2X1n+2OoM5I859F/rPIf5af//xVyIv8Z5F+
FvnPIv9ZVv/ZngjqjKSfRfpZND8f/M+XByuany+any+any+any/r/HxLEdQZaf5T/M8m/mcL/ufL
J4v/2cT/bOJ/NvE/24v/2XIEdUaa/xT/s/3F/3yvKPifr9mDKv2s0s+/+J/vFb34n9//oW09oxJB
nFHV/GfV/Odf/M9/WNGOPE78zyb+Zwv+53tFB84o+J//fUU1gjijqvnPqvnPqvn5+pufb8uT+kzp
Z9X8fNX8fF3n51uLoM5I85/if7aq+fngf75m4ar0s0o/q+qfVfXPutY/W4+gzkjzn1X+s8p/Bv/z
Na9YpZ9V+lnlP6v8Z335zxFBnZHy9yr/WTU/H/zP10xplX5W6WfV/HzV/Hxd5+fbjKDOSP6zyn9W
zc8H//M191uln1X62TQ/3zQ/39b5+f4N4oya8vem/L1pfr79+HW/M2rSzyb9bJqfb5qfb+v8fI8n
NT/flL835e9N8/NN8/NN+tmkn03z803z822dn+97BHVGmv9smv9smp9v3/n55Y5Dk3426WfT/HzT
/Hxb5+f7EUGdkeY/m+Y/m+bn25cfstxDadJP8T9b0/x80/x8W+fne3ym5ueb5j+b6p9N9c/gf75u
P4n/2cT/bE35e1P+3tb8vV8R1Blp/rMpf2/K39v3/vtyQ038zyb+Z2vK35vy97bm7/2OIM6oa/6z
K3/vqn/27/z8cotQ/M8m/mfrqn921T/7Wv/sTwRxRl39o676Z1f9M/ifz3jq8qQ+U/rZVf/sqn/2
tf7ZUwR1Rqp/dtU/u/rvXf6zK3/v6r935e9d+XtX/t6Vv/c1f+85glq7+u9d/lP8zyb+Z+vSz/67
f7Q+qc+UfnbpZ5d+9pd+lghq7dJP8T9bl34G/zMdn+U0pZ9d+tmln1362V/6WSOo36bqn+J/tq78
vSt/7+AvteB/vteu+XnxP1sHf6l18ZfGyl/qLYJY+/hg7UP5+5B+DunnkP8M/ufrVzzkP4f855D/
HPKf4+U/ewS19kNrl36++Z97BPXv1Pz8wPuLm/ifTfzPJv5nE/+zvfiffURQa1f/SPzPNtQ/Cv7n
e0XqHw31j4b6R0P9o7H2j/qMIHRpqH8k/mcT/7OJ/9le/M/xDWo/X/n7HUGtXfXP4H++91P1T/E/
m/ifTfzP9uJ/ju+T2s+u77zy96H6Z/A/X65ySD+H9HOo/jlU/xxr/XPEv1P1zzf/8/sk9nOq/hn8
z9cZTdU/p/Rzqv45Vf+ca/1zHBHEGb35n3sEsZ9T9c/gf75XpPrnVP1zqv45Vf+ca/1zxGeq/vnm
f8aKlL9P1T+D//n61k3VP6f851T9c6r+Odf657giqDN6oEvif7YJ/nyb0s+p+5tT/CXxP5v4n23q
/ubU/c253t8cdwS1dvGXpu5vTrz/qE28/6jN9f1H44mgvktV+yn9nHj/UQv+53s/dX9z6v7mxPuP
2sT7j9pc3380UgS1n0P7Kf2cQ2tX/j5V/5xTa1f9c0I//zR4f1v7H8G/r71/1vrnyBH8+9r7B/yl
/oH/7B/cP/ojqH8n5j/758uf/3Xu+gf5e/8gf+8fzH/2D+Y/+2ed/xwlglo7/GcX/7N/4D978D/X
rlD/wH/2D/xn/8B/9g/8Z/+s/nPUCP79t9k/4M938T+7+J9d/M/+4n+OFkHtJ+Y/u/ifXfzP/kH/
vYv/2cX/7OJ/dvE/+4v/OXoEtZ/wn138zy7+Zw/+59rv6OJ/dvE/u/ifXfzP/uJ/jhFBnRH8Zxf/
s3/gP/sH/ff+gf/sH+hn/8B/9g/8Z/+8/OeMoM4I/rN/pJ8b/GcP/mf69Lk8iTPa4D/7Bv/ZN/jP
vq3+c36DOKNthyZv8J9d/M8u/mcX/7N/+Z+fX6+ni//Zxf/s4n928T/7i/85v09q7ah/dvE/+4b5
+b7Bf/YN9c++YX6+b6h/9k36uUk/N+nnturnjH+n9HND/bNv0s83/zM+E/6zb6h/9uB/rrNbfUP9
s2+of/YN9c++of7Zt7X+OY8Iau2Yn+8b6p99Q/2zb1/+0roi1D/7hvpn31D/7Bvqn31b658zPhP1
z76h/tk31D/79tLPO4L6d6L+2bcvf/7X3+wb6p99Q/2zb6h/9g31z76v9c95RRBr3z/4fu7Szx3z
n33/zX8ey5P4for/2XfMf/Yd8599X+c/5x1BfD/3A7/NHfl735G/9x35e9/X/H0+EdR+In/v4n92
8T978D/f+4n8vYv/2cX/7OJ/9hf/c6YIaj+Rv3fxP/uO/L3vyN/7jvy9B/9znaLpO/L3vks/d+Tv
fUf+3vc1f585glp7we99R/7ed/CXevA/1wmNvqN/1Hfp5w7+Ut/BX+r7yl+aJYL6fr7y91gR8ve+
g7/Ud7w/ru/ov/dd+rmDv9R38Jf6vvKXZo2gzmji79Eu/dzBX+r7j7/0e/JA/70f6L/3A/c3+4H7
m/1Y72/OFkGc0aH8/ZB+Hsrfjy8/ZPkrc8h/HvKfh/L3Q/n7sebvs0cQZ3Qofz+Uvx/K34P/+VLF
Q/n7If95KH8/lL8fa/4+RwR1Rugf9UP+80D/qAf/8/2tQ/+oH9LPA/2jfqB/1I+1fzRnBHVGeP97
P5S/H3j/ew/+53tF4Nf1Q/p5oP7ZD9Q/+7HUP/P3P0f9sx8Vvu5Q/v7mf8ba5T8PzH/2o+n7ifnP
fih/PzD/2Q/Mf/ZjrGuPJzH/2d/8zzuCWjvqnz34n+8Vof7ZD+Xvp+qfp+qf51L/zLHzp+qfp+qf
4n/2U/p5Sj9P6eeJ92928T+7+J/9lH6e0s/zWNd+RFBrx/33fko/T9w/6ifuH/XzWr9LsSLcP+qn
8vdT/vNU/n7e2k/l76f081T+fip/P591P68Iaj+Vv5/K30/l7+J/9lP5+4n5pX4qfz+Vv5/K30/l
72dZ135HUGtX/i7+Zz+Vv5/gJ/dT+fsp/TyVv5/K38++fj+fCOr7qfxd/M9+Kn8/lb+fyt+D//le
u/J38T/7qfz9VP5+fda1pwhi7Rfml/ql/P3acO6X9PPC/FIP/ufrL8KF+aV+qf55YX6pX5hf6tex
rj1HUGvH/FK/VP+85D/F/+zif/ZL/lP8zy7+Zxf/s4v/2Vf+Z/6UCGrt6h+J/9mvB9/5S/n7hftH
Pfif77Xj/lG/pJ8X7h/1C/eP+pXXtdcIau3gL3XxP/ul/P2S/7yUv19Fa1f+fkk/L+Xvl/L3q61r
bxHU2hv+Hl3K3y/l78H/fP09upS/i//ZL+Xvl/L3a6x/j3oE8ffomvhbfEk/L+nnJf28X/o5Ioj9
vFX/vKWft+qfwf987eet+qf4n/1W/fNW/fPe1/2cEcR+3qp/3qp/3i/9vCOofyfuH/Xgf77XjvtH
/Vb988b9o37j/lG/l/tHefsGtfYbOn/j/lG/cf+oB//zGX8SuCOI+0f9ln7euH/Ub9w/6vdy/yhv
8STuH/Vb/vOW/7zlP+/v/aOlFnTLf4r/2W/5z1v+81795xb/TvnPu+r7Kf28q76fyt9vzC/1u2nt
mF/qt/TzxvxSvzG/1O++rv2IoNaO+aV+y3/e6r/f6r/fc/0uxYrUf7/Vf7+Vvz/qvz/f+++L+33U
f3+kn4/674/678+27ucVQezno/77I//55n/uEdS/U/3359Da1X9/pJ+P+u+P+u/Pua79jqDWrv77
I//5KH8X/7OL/9m//M/X2pW/i//Zxf/s4n/2lf+ZtyeCWrvyd/E/+5OgIY/085F+Pllrl36K/9kf
6ecj/Xxe+pkiqLVLPx/p5yP9fKSfj/Qz+J/vtUs/H+nnI/18pJ/PSz9zBLV26ecj/XxU/xT/sz+q
fz5Ta1f985F+JtU/k+qfaa1/biWCWHtS/TMpf3/zP+8I6t+p+ueX/7muXfzPLv5nF/+zi//ZV/5n
3moEtXbVP8X/7OnU2uU/k/rv6dLa1X8X/7Mn9d+T+u/pXtfeIqi1q/+e5D+T/GeS/0wv/9kjCM+Q
5D+T9DNJP5P0M0k/k/QzST+T9DO99HNEUPv50s/4hkg/xf/sX/7n6irF/+zif3bxP7v4n33lf+Zt
RlBnpPqn+J89KX9Pyt/Tmr/v36D2U/33pPw9qf8e/M/1Dk7P6r+L/9mz+u9Z/fe89N/zHk+q/57V
P8rSzyz9zNLPLP0U/7Nn6WeWfuZVP/f4d0o/s/QzSz+z+kdZ/aO89o/2I4LazwuanKWfWf4zy39m
+U/xP3uW/8zyn3n1n3t8pvxnlv/M8p9Z+pmln1n6maWfWfop/mfP0s8s/cyrfu5XBLV2+c8s/cy4
f9Sz/GeW/8xf/7lUX7P8Z5b/zPKfWf4zr/5zj++n/Gce0Los/5nVPwr+56tiltU/ytLPrPpnVv2z
rPXP/YkgfptF9U/xP7v4n/3L/1znwcT/7OJ/dvE/u/iffeV//qGlEcQZFdU/xf/s5dDalb8X1T+L
6p9F9c8i/1lU/yyqf5a1/rnnCGrtt9au+ueb/3lHUP9OzS8VzS8VzS8VzS8VzS8VzS+VtK69RFBr
1/yS+J+9aH4p+J/vb7Lml4r6R0XzS0XzS2WdX9prBPXblH6K/9mL9DP4n39kveuTOiPpZ5F+Fuln
eelni6DOSPm7+J+94P5mL8rfi/L34H++T1P5u/ifvSp/r8rf65q/7z2CWHtV/l6Vv1f5zyr9rPKf
wf98rb3Kf1b5zyr/WeU/68t/jghq7fKfVf6zan5e/M8u/mf/8j/X77z4n138zy7+Zxf/s6/8z7zP
CGrtD3RJ/M8u/mev3/774gDF/+zif3bxP7v4n33lf/5huCIIXXrzP+8Iaj/B/+y1wNeJ/9nF/+zi
f3bxP/vK/8zH90mdEfjzXfzPXjU/X6WfVf33ivcX96r+e1X+XpW/V+Xvdc3fj/jWKX+v6r9X+c+q
/pH4n72pf9TAD+lN/aMm/9nUP2rqH7W1f3QcEcTam/pH4n928T+7+J995X/+kbZHEL+jpv67+J9d
/M/+438u3yXxP7v4n138zy7+Z1/5n/m4Iqj9lP8U/7M3+c8m/9nkP9ujtct/NvnPJv/Z5D/b6j+P
+HfKfzb5zyb/2eQ/g//5/nXIfzb5zyb/2eQ/2+o/jyeC+n7Kfzb5zyb/2dQ/avKfTfrZ5D+b/Gdb
/eeRIqgzkv9s8p9N/lP8z97kP5v6R03+s0k/u/xnl//sq/88cgSx9i7/Kf5n7/KfXf6zy3921T/F
/+zif/Yu/9nlP/vqP48SQa1d/rPLf3bVP7vqn32tfx41gvgddfXfxf/s4n/2fkPrxP/s4n928T+7
+J995X/mo0VQ+yl+iPifvYsfEvzPV/Wgix/SpZ9d/JAufkgv6xn1COqM8P643uU/u/pH4n928T97
r1q7+kfif3bxP7v4n33lf+ZjRFBrV/9I/M/eNT8v/mcX/7N31T/F/+zif3bxP7v4n33lf+ZjRhBr
H6p/iv/Zh+qfwf9M836WJ/HbHNLPofrnUP1zrPXP8xvEb3Mc+G0O1T8H3n/Ug//5Uu+B9x918T/7
kH4O6edY9fOMJ6WfA/zkPqSf48b3c8h/Ds1/Bv/zvXbNfw7l70P996H++1j772eckfrvI2nt6h+9
+Z+xdunnkP8M/ud77fKfQ/5zyH8O+c+x+s/ziKDWrvub4n/2ofubQ/o5dH8z+J/vX7Hub4r/2Yfu
bw7d3xzr/c0zPlP3N4fml4b855D/HL/3d6xPSpfkP6f855T/nKv/PK8IQpem7h9N+c+p+0fB/3xV
9qbuH4n/2afy96n8fa75+3lHEGc01T+ayt+n8vfgf76mzafyd/E/+1T+PpW/zzV/P58I6oyUv0/p
51T+PuU/p/L34H++1678XfzPPpW/T+Xvc83fzxRBrR385D6lnxPv3+xT9c+p+mfwP99rV/1zyn9O
1T+n6p9zrX+eOYJau/RzSj+n9DP4n+/fpvRzSj+n9HNKP+dLP0sE9duUfor/2cX/7FP338X/7OJ/
/vkH9G8r+iP49zMan5d+1gj+/YyG+J9D/M/xwfs7xgfv7xiffd3PFsG/7+f44P3FQ/zP8cH8/Pgc
f9/P8cH8/PhAP8cH8/Pjg/n58Vnn588eQe0n5ueH+J/jg/ml8YH/HB/k7+OD/H18kL8P8T+H+J9D
/M+x8j/zOSKotWN+aYj/OT6Ynx8f+M/xwfzS+GStHfNL4wP9HB/ML40P5pfGZ51fOmcEtXbML40P
8vfxQf1ziP85Pqh/jg/67+OD+uf4oP45Pqh/jg/qn+Oz1j+vb1Brx/zSEP9zfJC/jw/y9/FB/j4+
yN/HB/n7+CB/H9uav19bBKFLG/L3If7n2JC/j+3Lr/tlPWND/j425O9jQ/4+NuTvY1vz9yv+ncjf
x4b5pbEhfx8b+HVjA79ubOe6n0cEtZ/ov48N/nNs6L+PDfPzY0P/fYj/OTb038eG/vvY1v77FZ+J
/vvYMD8/NuTvYwO/bmzwn2MDv24E/3P1dWMDv26I/zk28OvGBn7d2PK69iuCWjv482ND/j425O9j
Q/4+tjV/v+4I6rsk/dykn5v0c8P859ikn5v0c5N+btLP7aWfTwS1n9JP8T+H+J9jk36K/znE/xzi
fw7xP8f+0s8UQZyR+J9D/M8h/ufYUf8c4n8O8T+H+J9D/M+xv/QzRxBnJP7nEP9z7Oi/j13+c0f+
PoL/+V478vch/ufYkb+PHfn72Nf8/SoR1NqRv48d+fvYwa8bu/znjvx97Mjfx478fYj/OXbk72NH
/j72NX+/agS1dvTfx478feyof44d859jR/1ziP85dunnLv3cX/rZIqjfpvRzl37u0s/gf77UZpd+
iv85dunnLv3cX/rZI6gzQv997NLPHf33sSN/Hzvy97Gj/jl25O9jV/5+KH8/lL8fa/5+jQhi7Yfy
90P5u/ifQ/zPIf7nOMCvG+J/DvE/h/ifQ/zPsfI/8zUjqLWj/z7E/xyH/Och/TzkP48LunTIfx7y
n4f85yH/eaz+8/4GtXbMf45D/vPA/Oc4MP85Dsx/jkP5+4H5z3Fg/nMc6/znHU9i/nMc4C+NQ/n7
Af7SEP9zHOAvjaNo7eAvjUP5+wH+0jjAXxrHyl+644zAXxpH09qlnwfe3zHE/xwH3t8xjg6veOD9
HeOQfh7gh4wD/JBxrPyQ+4ig1o75zyH+5zgx/zmC//n6C3ti/nOc8p8n5j/HifnPca7zn3d8JuY/
x4n3x40T/aNx4v1xI/ifLwd44v1x45T/PJW/n8rfzzV/v68I4ozOE9/PU/p5yn+e8p/n6j/vO4La
T/CXxin/eaL/PoL/+d5P9N/HKf080X8fJ/rv41z77/cTQe0n+u9D/M9xyn+e8p+n/GfwP99rl/88
pZ+n/Ocp/3mu/vNOEdTa0X8fp/znif7REP9znOgfjbNB50/0j8Yp/TzRPxon+kfjXPtHd46g1j60
dvnPE/ffh/if48T993GCPz8u3H8fF+6/jwv338eF++/jWu+/3yWCWPsl/3nJf17yn9d3/nOp21zy
n5f85yX/ecl/Xqv/vGsEoUvifw7xP4f4nyP4n69KvvifQ/zPIf7nEP9zvPifd4ugzgj8zyH+5xD/
c4j/OcT/HMH/fK9d/lP8zyH+5xD/c7z4n3ePoNYu/yn+53jzP+PcpZ/if44v/3N1LOJ/DvE/h/if
Q/zP8eJ/3iOCWjv4n0P8zyH+57hw/2iI/znE/xzifw7xP8eL/3nPCOq3Kf0U/3Nc0s/gf74yvlv6
eUs/b+nnLf28V/18vkGc0Zv/+Q1iP8X/HOJ/jhf/8/k+if28Mf85xP8cN+Y/R/A/3/uJ+c9xSz9v
zH+OG/Of417nP5/4d2L+c9yY/xy38vcb859D/M8h/ucQ/3OI/znE/xzifw7xP8eL//kcEdTa5T/F
/xw35pfGLf95y38G/zN9Wvo9Kf95Sz9v+c9b/vNe/ecTnyn/ect/iv85brx/c9x4/+a42/o7uiKo
31HXfsp/3srfg//53k/l7+J/DvE/h/if48X/fOI7r/z9zf/8BrGfj/TzkX7+xf98rz34n6/f0bPp
M1X/fDS/9Gh+6Vnnl54nglj7I/8p/ucQ/3N8+Z9rdib+5xD/c4j/OcT/HC/+55MiiO/nI/8p/uf4
i//5Dyu64OueW58p/fyL//kPK7p1Rs96RjmCOiP1jx71jx7134P/+XJrj/rv4n+OR/33R/33Z+2/
PyWCOiPp5yP9fOQ/H/DnxyP/Kf7neOQ/H/nPZ/WfT42gzkj9I/E/xyP/+YA/Px75z0f+85H/fOQ/
n9V/Pi2COiP13x/5z0f+M/ifr9pFkn4m6WeS/0zyn+nlP3sEcUZJ/XfxP4f4nyP4n+tN5CH+5xD/
c4j/OcT/HC/+5zMiiDNK8p/if46k/D34nyuzcSTpZ5J+JuXvSfl7WvP3Z0ZQZ6T5z6T8Pan/HvzP
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
Py/p5yX9vKSf16qf/RvUGeH9HfOSfl6Y/5zif84L85/z+r6/Yz1NzH/OS/n7hfnPeWH+c17r/Gf/
Pqm1Sz8v6ecl/bzAT56X9FP8z3lJPy/p57XqZ49/p/TzwvznvKSfl/pH148fUpcndUaqf17qH13q
H11r/6gfEdQZYf5zXsrfL+Xvl/L3a83fe6xI+fs19Z2Xft6Y/5zB/3x9Q27Mf85b/vPG/Oe8Mf85
73X+s18RxH7eO/bzln7e0s9b+nmv+tnvCGI/b+nnLf28pZ833n80b+nnLf28pZ+39PN+6ecTQe2n
9FP8z3mr/nmr/nmv9c+eIqj9xPzSvKWfN+aXZvA/3/uJ+aUp/ue8Mb80b8wvzXudX+o5gtpPzC9N
8T+n+J9T/M/54n/2EkHtp/RT/M95Sz+D//neT+nnLf28pZ+39PN+6WeNoPZT+in+57zx/uJ5y3/e
8p/B/3yvXf5T/M/5yH8+8p/P6j97iyDW/sh/iv85H/nPR/33R/7zkX4+0s9H+vm89LNHEN/PR/13
8T/no/rno/rno/pn8D9fpyn+5xT/cz6qfz6qfz5r/bOPCGrtqn8+8p+P6p+P8vdH9c/gf77Xrvrn
o/rno/rno/rns9Y/+4yg1q7++6P656P+u/ifU/zP+eV/vtau/rv4n1P8zyn+53zxP8c3qLWDPz/F
/5zif87ny59f8mLxP6f4n1P8zyn+53zxP8f3SekS7m9O8T+n+J/zwf3NmXB/c4r/OcX/nOJ/zhf/
c+wRxBklzX+K/zmT6p9J9c+01j/HEUHsZzrwe0+qfybw62bwP9/7CX7dFP9zJs1/Js1/pnX+c8Rn
av4zaf4zaf4zaf4z/d7/Xpcn8Z0X/3MmzX8mzX+mdf5zXBHUGSWdkfQzqf8e/M/1NsQU/3OK/zmT
+u9J/fe09t9H/DvVf0+Yn59J/aOk/lFS/yit/aPxRFD72bSfqn8m1T+D//neT9U/k+qfSfXPpPpn
WuufI0VQ+4n3H80k/5nUP0rqH6W1fzRyBLGfWfNLWfqZ1X/P4M/PrP57lv/M6r9n9d/z2n8fJYLY
z6z+e1b/PeP9HVP8zyn+5wz+58sni/85xf+c4n9O8T/ni/85agS1dry/Y4r/ObP6R1n5e1b/KPif
L6XN6h9l+c+s/lFW/yiv/aPRIqi1q3+Ulb9n5e9Z+Xte8/fRI6jfkfxnlv/M8p8Z79+cWf4zy39m
+c8s/5lf/nNEUPsp/5nlP7P8Z/A/378O+c8s/5nlP7P8Z375zxlBndHLf36D2k/Nz2fNz5d1fn5+
g9jPov67+J+zqP8e/M/XN6So/17kP4v8Z5H/LKv/nN8nsZ9F/XfxP2dR/bMofy+qfwb/8/VdKqp/
iv85i+qfRfXPstY/Z/w7Vf8seP/RFP9zFulnwfuPZpF+FulnkX4W6WdZ9XMeEdT3U/pZpJ9F+lmk
n2XVzxkrkn4W6WeRfhbpZ8H746b4n1P8z1mkn0X6WVb9nFcEtZ/SzyL9LNLPovy9SD/F/5xF+lmk
n2XVzxnfZOlnkX6K/zmL+kdF9c+q/lH9YO1V/SPxP2dV/6iqf1TX/tF8Ioi1V/WPxP+cdcfaq/xn
1fx8xfuPZtX8vPifs2p+vmp+vq7z8zNFUGu/oHXif86q+fngf75+m1Xz81X6WdU/quof1bV/NHME
8dus6h9V9Y+q+kfB/3ypd1X/qEo/q/SzSj/rSz9LBHVG6h9V6WfV/Lz4n7Nqfr5WrV3z81X9o6r5
+ar5+brOz88aQa0d999nVf4u/ucU/3OK/zmD//leu+Y/xf+c4n9O8T/ni/85WwSx9qb5T/E/Z/tg
7U362eQ/g//50qUm/9nkP5v8Z5P/bC//2SOotSt/b/KfTfl78D9ff2Wa8vem/L0pf2/K39uav88R
QehSU/2zKX9vqn821T+b6p9N9c+m+mdT/bOt9c85I6gz0v138T9nU/+oqX/Ulv5R+f7n6h818JNn
U/+oaX6+FfiQpvl58T9nU/2zqf7Zlvpn+T2p/dT8p/ifs6n+GfzP19/ipvpnk3421T+b6p9trGcU
/07VP5v670362dR/b+q/N/Xfm/xnV/+9q//eP+sZHRHEGfUN3/mu+mdX/bOr/tn3dT/PCGI/u/yn
+J+zy38G//P1Denyn13+s8t/dvnPfq77eUVQ+6n7m+J/zi7/2X/v3/z91e7yn13+s8t/dvnP/qxn
FDsv//nmf36f1H7Kfwb/86VLXf6zy392+c8u/9nzekZPBHVG8p/if07xP6f4n3Plf5ZPiqD2U/wQ
8T+n+J+zN+2n5pfE/5zif07xP+fK/yyfHEHtp+aXxP+cXfrZpZ9d+tmln136Kf7nHNLPIf0cL/0s
EcTah/ghQ/o5NL80Nvzeh+aXxP+cQ/NLQ/NL41i/nzWC+H4O3T8a0s+h+mfwP1++bqj+Kf7nHKp/
DtU/x7WeUYugzkjzn0P6OW54sCH/OTQ/H/zP99o1Pz+kn0Pz80Pz8yOta+8R1Nrx/vc51H8f8p/i
f84h/znw/o455D+H/OeQ/xzyn+PlP0cEtXbd3xT/c4r/OcX/nCv/s3xmBPU7Uv4u/ucU/3N++Z+v
/VT+Lv7nFP9ziv85V/5n2b5B7OdU/i7+55yqf07l71P5e/A/X6y5qfx9Kn+fyt+n8ve5r2v/Pqm1
q380lb+L/znF/5xT+jmln1P6OaWfU/o5pZ9z1c9tj6DWLv8p/uec6h/Nb/99cSxT/aOp/tFU/2iq
fzSX/lHZjgjityn+5xT/c07x64L/+fqrPcWvm9LPKX7dFL9ulvWM4jPFr5vqH031jyb4yTP4ny9n
NcFPnlP6OaWfU/o5V/3crgjqjNQ/Ev9ziv85g/+5vq98iv85xf+c4n9O8T/nfOnnHcH3Gf1P/+v/
e/zT//3z//jn/9M//dO//6//5T/+8z+1+J/7p3/613/59//8T5/zj//JY84//v//87/913/7d//5
j9Cdnz/Df4b+h//87/7L/+Ud+tf/5b/8+d9deX6u/c/I/xz/3bnnvz7qf47/bgn99d+dn+OP//vj
n/a/lf/n79/2X/7tX/75n/7b+yzO//5v+7d/+U//4X/85/+2vO2v0H/6v/0V+Ovf/z/91399/f//
7j/8h395Bf71//ovf6z4s9W+/ffAv/2n//w//tf/+B+Xh/79//d////8v/739z/jz3/CH385n+//
xPYnCPS4/vj//4d/969//hv2z+i/7d3+D7d3e23vle5/3N4lFNt7/m17jz0+6ru9S+iv/+7Y0x//
t8f2buv25v+/be/6z9j+D7f3U+d/q6v8/wCL+LCK0dgMAA==

--MP_/7P+D6MDvabUSe5j7xKYK4Ba
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=dmesg_1.txt

Dec  2 07:16:52 sf kernel: [    0.000000] Linux version 3.2.0-rc3-00099-g88=
3381d (slyfox@sf) (gcc version 4.5.3 (Gentoo 4.5.3-r1 p1.0, pie-0.4.5) ) #1=
63 SMP PREEMPT Tue Nov 29 21:38:56 FET 2011
Dec  2 07:16:52 sf kernel: [    0.000000] Command line: root=3D/dev/sda2 vi=
deo=3DSVIDEO-1:d
Dec  2 07:16:52 sf kernel: [    0.000000] BIOS-provided physical RAM map:
Dec  2 07:16:52 sf kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 00=
0000000009fc00 (usable)
Dec  2 07:16:52 sf kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00=
000000000a0000 (reserved)
Dec  2 07:16:52 sf kernel: [    0.000000]  BIOS-e820: 00000000000e0000 - 00=
00000000100000 (reserved)
Dec  2 07:16:52 sf kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 00=
0000007e7b0000 (usable)
Dec  2 07:16:52 sf kernel: [    0.000000]  BIOS-e820: 000000007e7b0000 - 00=
0000007e7c5400 (reserved)
Dec  2 07:16:52 sf kernel: [    0.000000]  BIOS-e820: 000000007e7c5400 - 00=
0000007e7e7fb8 (ACPI NVS)
Dec  2 07:16:52 sf kernel: [    0.000000]  BIOS-e820: 000000007e7e7fb8 - 00=
0000007f000000 (reserved)
Dec  2 07:16:53 sf kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00=
000000fec01000 (reserved)
Dec  2 07:16:53 sf kernel: [    0.000000]  BIOS-e820: 00000000fed20000 - 00=
000000fed9a000 (reserved)
Dec  2 07:16:53 sf kernel: [    0.000000]  BIOS-e820: 00000000feda0000 - 00=
000000fedc0000 (reserved)
Dec  2 07:16:53 sf kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00=
000000fee01000 (reserved)
Dec  2 07:16:53 sf kernel: [    0.000000]  BIOS-e820: 00000000ffb00000 - 00=
000000ffc00000 (reserved)
Dec  2 07:16:53 sf kernel: [    0.000000]  BIOS-e820: 00000000fff00000 - 00=
00000100000000 (reserved)
Dec  2 07:16:53 sf kernel: [    0.000000] NX (Execute Disable) protection: =
active
Dec  2 07:16:53 sf kernel: [    0.000000] DMI 2.4 present.
Dec  2 07:16:53 sf kernel: [    0.000000] DMI: Hewlett-Packard HP Compaq 25=
10p Notebook PC/30C9, BIOS 68MSP Ver. F.0E 11/04/2008
Dec  2 07:16:53 sf kernel: [    0.000000] e820 update range: 00000000000000=
00 - 0000000000010000 (usable) =3D=3D> (reserved)
Dec  2 07:16:53 sf kernel: [    0.000000] e820 remove range: 00000000000a00=
00 - 0000000000100000 (usable)
Dec  2 07:16:53 sf kernel: [    0.000000] No AGP bridge found
Dec  2 07:16:53 sf kernel: [    0.000000] last_pfn =3D 0x7e7b0 max_arch_pfn=
 =3D 0x400000000
Dec  2 07:16:53 sf kernel: [    0.000000] MTRR default type: uncachable
Dec  2 07:16:53 sf kernel: [    0.000000] MTRR fixed ranges enabled:
Dec  2 07:16:53 sf kernel: [    0.000000]   00000-9FFFF write-back
Dec  2 07:16:53 sf kernel: [    0.000000]   A0000-BFFFF uncachable
Dec  2 07:16:53 sf kernel: [    0.000000]   C0000-CFFFF write-protect
Dec  2 07:16:53 sf kernel: [    0.000000]   D0000-EFFFF uncachable
Dec  2 07:16:53 sf kernel: [    0.000000]   F0000-FFFFF write-protect
Dec  2 07:16:53 sf kernel: [    0.000000] MTRR variable ranges enabled:
Dec  2 07:16:53 sf kernel: [    0.000000]   0 base 000000000 mask F80000000=
 write-back
Dec  2 07:16:53 sf kernel: [    0.000000]   1 base 07F000000 mask FFF000000=
 uncachable
Dec  2 07:16:53 sf kernel: [    0.000000]   2 base 07E800000 mask FFF800000=
 uncachable
Dec  2 07:16:53 sf kernel: [    0.000000]   3 base 0FEDA0000 mask FFFFE0000=
 uncachable
Dec  2 07:16:53 sf kernel: [    0.000000]   4 disabled
Dec  2 07:16:53 sf kernel: [    0.000000]   5 disabled
Dec  2 07:16:53 sf kernel: [    0.000000]   6 disabled
Dec  2 07:16:53 sf kernel: [    0.000000]   7 disabled
Dec  2 07:16:53 sf kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x704=
0600070406, new 0x7010600070106
Dec  2 07:16:53 sf kernel: [    0.000000] initial memory mapped : 0 - 20000=
000
Dec  2 07:16:53 sf kernel: [    0.000000] Base memory trampoline at [ffff88=
000009a000] 9a000 size 20480
Dec  2 07:16:53 sf kernel: [    0.000000] init_memory_mapping: 000000000000=
0000-000000007e7b0000
Dec  2 07:16:53 sf kernel: [    0.000000]  0000000000 - 007e600000 page 2M
Dec  2 07:16:53 sf kernel: [    0.000000]  007e600000 - 007e7b0000 page 4k
Dec  2 07:16:53 sf kernel: [    0.000000] kernel direct mapping tables up t=
o 7e7b0000 @ 1fffc000-20000000
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: RSDP 00000000000f7980 00024=
 (v02 HP    )
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: XSDT 000000007e7c81c8 0007C=
 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: FACP 000000007e7c8084 000F4=
 (v04 HP     30C9     00000003 HP   00000001)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: DSDT 000000007e7c8538 13484=
 (v01 HP       nc2500 00010000 MSFT 03000001)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: FACS 000000007e7e7d80 00040
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: SLIC 000000007e7c8244 00176=
 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: HPET 000000007e7c83bc 00038=
 (v01 HP     30C9     00000001 HP   00000001)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: APIC 000000007e7c83f4 00068=
 (v01 HP     30C9     00000001 HP   00000001)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: MCFG 000000007e7c845c 0003C=
 (v01 HP     30C9     00000001 HP   00000001)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: TCPA 000000007e7c8498 00032=
 (v02 HP     30C9     00000001 HP   00000001)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: ASF! 000000007e7c84cc 00069=
 (v16 HP     CHIMAYU  00000001 HP   00000000)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: SSDT 000000007e7db9bc 002BE=
 (v01 HP       HPQPAT 00000001 MSFT 03000001)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: SSDT 000000007e7dc5fe 0025F=
 (v01 HP      Cpu0Tst 00003000 INTL 20060317)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: SSDT 000000007e7dc85d 000A6=
 (v01 HP      Cpu1Tst 00003000 INTL 20060317)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: SSDT 000000007e7dc903 004D7=
 (v01 HP        CpuPm 00003000 INTL 20060317)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: Local APIC address 0xfee000=
00
Dec  2 07:16:53 sf kernel: [    0.000000]  [ffffea0000000000-ffffea0001ffff=
ff] PMD -> [ffff88007be00000-ffff88007ddfffff] on node 0
Dec  2 07:16:53 sf kernel: [    0.000000] Zone PFN ranges:
Dec  2 07:16:53 sf kernel: [    0.000000]   DMA      0x00000010 -> 0x000010=
00
Dec  2 07:16:53 sf kernel: [    0.000000]   DMA32    0x00001000 -> 0x001000=
00
Dec  2 07:16:53 sf kernel: [    0.000000]   Normal   empty
Dec  2 07:16:53 sf kernel: [    0.000000] Movable zone start PFN for each n=
ode
Dec  2 07:16:53 sf kernel: [    0.000000] early_node_map[2] active PFN rang=
es
Dec  2 07:16:53 sf kernel: [    0.000000]     0: 0x00000010 -> 0x0000009f
Dec  2 07:16:53 sf kernel: [    0.000000]     0: 0x00000100 -> 0x0007e7b0
Dec  2 07:16:53 sf kernel: [    0.000000] On node 0 totalpages: 517951
Dec  2 07:16:53 sf kernel: [    0.000000]   DMA zone: 64 pages used for mem=
map
Dec  2 07:16:53 sf kernel: [    0.000000]   DMA zone: 5 pages reserved
Dec  2 07:16:53 sf kernel: [    0.000000]   DMA zone: 3914 pages, LIFO batc=
h:0
Dec  2 07:16:53 sf kernel: [    0.000000]   DMA32 zone: 8031 pages used for=
 memmap
Dec  2 07:16:53 sf kernel: [    0.000000]   DMA32 zone: 505937 pages, LIFO =
batch:31
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x1008
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: Local APIC address 0xfee000=
00
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_=
id[0x00] enabled)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_=
id[0x01] enabled)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] hi=
gh edge lint[0x1])
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] hi=
gh edge lint[0x1])
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: IOAPIC (id[0x01] address[0x=
fec00000] gsi_base[0])
Dec  2 07:16:53 sf kernel: [    0.000000] IOAPIC[0]: apic_id 1, version 32,=
 address 0xfec00000, GSI 0-23
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq =
0 global_irq 2 dfl dfl)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq =
9 global_irq 9 high level)
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: IRQ0 used by override.
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: IRQ2 used by override.
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: IRQ9 used by override.
Dec  2 07:16:53 sf kernel: [    0.000000] Using ACPI (MADT) for SMP configu=
ration information
Dec  2 07:16:53 sf kernel: [    0.000000] ACPI: HPET id: 0x8086a201 base: 0=
xfed00000
Dec  2 07:16:53 sf kernel: [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug C=
PUs
Dec  2 07:16:53 sf kernel: [    0.000000] nr_irqs_gsi: 40
Dec  2 07:16:53 sf kernel: [    0.000000] PM: Registered nosave memory: 000=
000000009f000 - 00000000000a0000
Dec  2 07:16:53 sf kernel: [    0.000000] PM: Registered nosave memory: 000=
00000000a0000 - 00000000000e0000
Dec  2 07:16:53 sf kernel: [    0.000000] PM: Registered nosave memory: 000=
00000000e0000 - 0000000000100000
Dec  2 07:16:53 sf kernel: [    0.000000] Allocating PCI resources starting=
 at 7f000000 (gap: 7f000000:7fc00000)
Dec  2 07:16:53 sf kernel: [    0.000000] setup_percpu: NR_CPUS:2 nr_cpumas=
k_bits:2 nr_cpu_ids:2 nr_node_ids:1
Dec  2 07:16:53 sf kernel: [    0.000000] PERCPU: Embedded 25 pages/cpu @ff=
ff88007e400000 s71296 r8192 d22912 u1048576
Dec  2 07:16:53 sf kernel: [    0.000000] pcpu-alloc: s71296 r8192 d22912 u=
1048576 alloc=3D1*2097152
Dec  2 07:16:53 sf kernel: [    0.000000] pcpu-alloc: [0] 0 1=20
Dec  2 07:16:53 sf kernel: [    0.000000] Built 1 zonelists in Zone order, =
mobility grouping on.  Total pages: 509851
Dec  2 07:16:53 sf kernel: [    0.000000] Kernel command line: root=3D/dev/=
sda2 video=3DSVIDEO-1:d
Dec  2 07:16:53 sf kernel: [    0.000000] PID hash table entries: 4096 (ord=
er: 3, 32768 bytes)
Dec  2 07:16:53 sf kernel: [    0.000000] Dentry cache hash table entries: =
262144 (order: 9, 2097152 bytes)
Dec  2 07:16:53 sf kernel: [    0.000000] Inode-cache hash table entries: 1=
31072 (order: 8, 1048576 bytes)
Dec  2 07:16:53 sf kernel: [    0.000000] Checking aperture...
Dec  2 07:16:53 sf kernel: [    0.000000] No AGP bridge found
Dec  2 07:16:53 sf kernel: [    0.000000] Memory: 2026084k/2072256k availab=
le (4327k kernel code, 452k absent, 45720k reserved, 4164k data, 452k init)
Dec  2 07:16:53 sf kernel: [    0.000000] SLUB: Genslabs=3D15, HWalign=3D64=
, Order=3D0-3, MinObjects=3D0, CPUs=3D2, Nodes=3D1
Dec  2 07:16:53 sf kernel: [    0.000000] Preemptible hierarchical RCU impl=
ementation.
Dec  2 07:16:53 sf kernel: [    0.000000] NR_IRQS:4352 nr_irqs:512 16
Dec  2 07:16:53 sf kernel: [    0.000000] Extended CMOS year: 2000
Dec  2 07:16:53 sf kernel: [    0.000000] Console: colour VGA+ 80x25
Dec  2 07:16:53 sf kernel: [    0.000000] console [tty0] enabled
Dec  2 07:16:53 sf kernel: [    0.000000] hpet clockevent registered
Dec  2 07:16:53 sf kernel: [    0.000000] Fast TSC calibration using PIT
Dec  2 07:16:53 sf kernel: [    0.000000] Detected 1197.136 MHz processor.
Dec  2 07:16:53 sf kernel: [    0.001006] Calibrating delay loop (skipped),=
 value calculated using timer frequency.. 2394.27 BogoMIPS (lpj=3D1197136)
Dec  2 07:16:53 sf kernel: [    0.001204] pid_max: default: 32768 minimum: =
301
Dec  2 07:16:53 sf kernel: [    0.002057] Mount-cache hash table entries: 2=
56
Dec  2 07:16:53 sf kernel: [    0.002377] CPU: Physical Processor ID: 0
Dec  2 07:16:53 sf kernel: [    0.002470] CPU: Processor Core ID: 0
Dec  2 07:16:53 sf kernel: [    0.002562] mce: CPU supports 6 MCE banks
Dec  2 07:16:53 sf kernel: [    0.002661] CPU0: Thermal monitoring handled =
by SMI
Dec  2 07:16:53 sf kernel: [    0.002667] using mwait in idle threads.
Dec  2 07:16:53 sf kernel: [    0.002814] ACPI: Core revision 20110623
Dec  2 07:16:53 sf kernel: [    0.014557] ..TIMER: vector=3D0x30 apic1=3D0 =
pin1=3D2 apic2=3D-1 pin2=3D-1
Dec  2 07:16:53 sf kernel: [    0.025139] CPU0: Intel(R) Core(TM)2 Duo CPU =
    U7600  @ 1.20GHz stepping 0d
Dec  2 07:16:53 sf kernel: [    0.025998] Performance Events: PEBS fmt0+, C=
ore2 events, Intel PMU driver.
Dec  2 07:16:53 sf kernel: [    0.025998] PEBS disabled due to CPU errata.
Dec  2 07:16:53 sf kernel: [    0.025998] ... version:                2
Dec  2 07:16:53 sf kernel: [    0.025998] ... bit width:              40
Dec  2 07:16:53 sf kernel: [    0.025998] ... generic registers:      2
Dec  2 07:16:53 sf kernel: [    0.025998] ... value mask:             00000=
0ffffffffff
Dec  2 07:16:53 sf kernel: [    0.025998] ... max period:             00000=
0007fffffff
Dec  2 07:16:53 sf kernel: [    0.025998] ... fixed-purpose events:   3
Dec  2 07:16:53 sf kernel: [    0.025998] ... event mask:             00000=
00700000003
Dec  2 07:16:53 sf kernel: [    0.032132] NMI watchdog enabled, takes one h=
w-pmu counter.
Dec  2 07:16:53 sf kernel: [    0.040022] Booting Node   0, Processors  #1 =
Ok.
Dec  2 07:16:53 sf kernel: [    0.040166] smpboot cpu 1: start_ip =3D 9a000
Dec  2 07:16:53 sf kernel: [    0.001999] CPU1: Thermal monitoring handled =
by SMI
Dec  2 07:16:53 sf kernel: [    0.112030] NMI watchdog enabled, takes one h=
w-pmu counter.
Dec  2 07:16:53 sf kernel: [    0.113997] Brought up 2 CPUs
Dec  2 07:16:53 sf kernel: [    0.114090] Total of 2 processors activated (=
4788.15 BogoMIPS).
Dec  2 07:16:53 sf kernel: [    0.115311] PM: Registering ACPI NVS region a=
t 7e7c5400 (142264 bytes)
Dec  2 07:16:53 sf kernel: [    0.115588] NET: Registered protocol family 16
Dec  2 07:16:53 sf kernel: [    0.116073] ACPI FADT declares the system doe=
sn't support PCIe ASPM, so disable it
Dec  2 07:16:53 sf kernel: [    0.116164] ACPI: bus type pci registered
Dec  2 07:16:53 sf kernel: [    0.117058] PCI: MMCONFIG for domain 0000 [bu=
s 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
Dec  2 07:16:53 sf kernel: [    0.117174] PCI: not using MMCONFIG
Dec  2 07:16:53 sf kernel: [    0.117266] PCI: Using configuration type 1 f=
or base access
Dec  2 07:16:53 sf kernel: [    0.123088] bio: create slab <bio-0> at 0
Dec  2 07:16:53 sf kernel: [    0.124087] ACPI: Added _OSI(Module Device)
Dec  2 07:16:53 sf kernel: [    0.124126] ACPI: Added _OSI(Processor Device)
Dec  2 07:16:53 sf kernel: [    0.124220] ACPI: Added _OSI(3.0 _SCP Extensi=
ons)
Dec  2 07:16:53 sf kernel: [    0.124314] ACPI: Added _OSI(Processor Aggreg=
ator Device)
Dec  2 07:16:53 sf kernel: [    0.129283] ACPI: EC: Look up EC in DSDT
Dec  2 07:16:53 sf kernel: [    0.163871] ACPI: SSDT 000000007e7dbd42 0023D=
 (v01 HP      Cpu0Ist 00003000 INTL 20060317)
Dec  2 07:16:53 sf kernel: [    0.165264] ACPI: Dynamic OEM Table Load:
Dec  2 07:16:53 sf kernel: [    0.165456] ACPI: SSDT           (null) 0023D=
 (v01 HP      Cpu0Ist 00003000 INTL 20060317)
Dec  2 07:16:53 sf kernel: [    0.165881] ACPI: SSDT 000000007e7dc004 005FA=
 (v01 HP      Cpu0Cst 00003001 INTL 20060317)
Dec  2 07:16:53 sf kernel: [    0.167251] ACPI: Dynamic OEM Table Load:
Dec  2 07:16:53 sf kernel: [    0.167441] ACPI: SSDT           (null) 005FA=
 (v01 HP      Cpu0Cst 00003001 INTL 20060317)
Dec  2 07:16:53 sf kernel: [    0.168004] ACPI: SSDT 000000007e7dbc7a 000C8=
 (v01 HP      Cpu1Ist 00003000 INTL 20060317)
Dec  2 07:16:53 sf kernel: [    0.169376] ACPI: Dynamic OEM Table Load:
Dec  2 07:16:53 sf kernel: [    0.169567] ACPI: SSDT           (null) 000C8=
 (v01 HP      Cpu1Ist 00003000 INTL 20060317)
Dec  2 07:16:53 sf kernel: [    0.169919] ACPI: SSDT 000000007e7dbf7f 00085=
 (v01 HP      Cpu1Cst 00003000 INTL 20060317)
Dec  2 07:16:53 sf kernel: [    0.171285] ACPI: Dynamic OEM Table Load:
Dec  2 07:16:53 sf kernel: [    0.171476] ACPI: SSDT           (null) 00085=
 (v01 HP      Cpu1Cst 00003000 INTL 20060317)
Dec  2 07:16:53 sf kernel: [    0.202106] ACPI: Interpreter enabled
Dec  2 07:16:53 sf kernel: [    0.202202] ACPI: (supports S0 S3 S4 S5)
Dec  2 07:16:53 sf kernel: [    0.203238] ACPI: Using IOAPIC for interrupt =
routing
Dec  2 07:16:53 sf kernel: [    0.203367] PCI: MMCONFIG for domain 0000 [bu=
s 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
Dec  2 07:16:53 sf kernel: [    0.204534] PCI: MMCONFIG at [mem 0xf8000000-=
0xfbffffff] reserved in ACPI motherboard resources
Dec  2 07:16:53 sf kernel: [    0.225072] ACPI: Power Resource [C29F] (on)
Dec  2 07:16:53 sf kernel: [    0.232089] ACPI: Power Resource [C1C7] (off)
Dec  2 07:16:53 sf kernel: [    0.236173] ACPI: Power Resource [C3AD] (off)
Dec  2 07:16:53 sf kernel: [    0.236217] ACPI: Power Resource [C3B0] (off)
Dec  2 07:16:53 sf kernel: [    0.237137] ACPI: Power Resource [C3C3] (off)
Dec  2 07:16:53 sf kernel: [    0.237207] ACPI: Power Resource [C3C4] (off)
Dec  2 07:16:53 sf kernel: [    0.237208] ACPI: Power Resource [C3C5] (off)
Dec  2 07:16:53 sf kernel: [    0.238219] ACPI: Power Resource [C3C6] (off)
Dec  2 07:16:53 sf kernel: [    0.238219] ACPI: Power Resource [C3C7] (off)
Dec  2 07:16:53 sf kernel: [    0.240118] ACPI: EC: GPE =3D 0x16, I/O: comm=
and/status =3D 0x66, data =3D 0x62
Dec  2 07:16:53 sf kernel: [    0.240440] ACPI: No dock devices found.
Dec  2 07:16:53 sf kernel: [    0.240537] PCI: Using host bridge windows fr=
om ACPI; if necessary, use "pci=3Dnocrs" and report a bug
Dec  2 07:16:53 sf kernel: [    0.246139] ACPI: PCI Root Bridge [C003] (dom=
ain 0000 [bus 00-ff])
Dec  2 07:16:53 sf kernel: [    0.254766] pci_root PNP0A08:00: host bridge =
window [io  0x0000-0x0cf7]
Dec  2 07:16:53 sf kernel: [    0.254867] pci_root PNP0A08:00: host bridge =
window [io  0x0d00-0xffff]
Dec  2 07:16:53 sf kernel: [    0.254965] pci_root PNP0A08:00: host bridge =
window [mem 0x000a0000-0x000bffff]
Dec  2 07:16:53 sf kernel: [    0.254976] pci_root PNP0A08:00: host bridge =
window [mem 0x7e800000-0xfedfffff]
Dec  2 07:16:53 sf kernel: [    0.255109] pci_root PNP0A08:00: host bridge =
window [mem 0xfee01000-0xffffffff]
Dec  2 07:16:53 sf kernel: [    0.255243] pci_root PNP0A08:00: host bridge =
window [mem 0x000d0000-0x000dffff]
Dec  2 07:16:53 sf kernel: [    0.255397] pci 0000:00:00.0: [8086:2a00] typ=
e 0 class 0x000600
Dec  2 07:16:53 sf kernel: [    0.255477] pci 0000:00:02.0: [8086:2a02] typ=
e 0 class 0x000300
Dec  2 07:16:53 sf kernel: [    0.255503] pci 0000:00:02.0: reg 10: [mem 0x=
e0400000-0xe04fffff 64bit]
Dec  2 07:16:53 sf kernel: [    0.255519] pci 0000:00:02.0: reg 18: [mem 0x=
d0000000-0xdfffffff 64bit pref]
Dec  2 07:16:53 sf kernel: [    0.255531] pci 0000:00:02.0: reg 20: [io  0x=
2000-0x2007]
Dec  2 07:16:53 sf kernel: [    0.255590] pci 0000:00:02.1: [8086:2a03] typ=
e 0 class 0x000380
Dec  2 07:16:53 sf kernel: [    0.255611] pci 0000:00:02.1: reg 10: [mem 0x=
e0500000-0xe05fffff 64bit]
Dec  2 07:16:53 sf kernel: [    0.255711] pci 0000:00:03.0: [8086:2a04] typ=
e 0 class 0x000780
Dec  2 07:16:53 sf kernel: [    0.255763] pci 0000:00:03.0: reg 10: [mem 0x=
e0600000-0xe060000f 64bit]
Dec  2 07:16:53 sf kernel: [    0.256042] pci 0000:00:03.0: PME# supported =
from D0 D3hot D3cold
Dec  2 07:16:53 sf kernel: [    0.256051] pci 0000:00:03.0: PME# disabled
Dec  2 07:16:53 sf kernel: [    0.256084] pci 0000:00:03.2: [8086:2a06] typ=
e 0 class 0x000101
Dec  2 07:16:53 sf kernel: [    0.256114] pci 0000:00:03.2: reg 10: [io  0x=
2008-0x200f]
Dec  2 07:16:53 sf kernel: [    0.256129] pci 0000:00:03.2: reg 14: [io  0x=
2010-0x2013]
Dec  2 07:16:53 sf kernel: [    0.256144] pci 0000:00:03.2: reg 18: [io  0x=
2018-0x201f]
Dec  2 07:16:53 sf kernel: [    0.256161] pci 0000:00:03.2: reg 1c: [io  0x=
2020-0x2023]
Dec  2 07:16:53 sf kernel: [    0.256178] pci 0000:00:03.2: reg 20: [io  0x=
2030-0x203f]
Dec  2 07:16:53 sf kernel: [    0.256268] pci 0000:00:03.3: [8086:2a07] typ=
e 0 class 0x000700
Dec  2 07:16:53 sf kernel: [    0.256310] pci 0000:00:03.3: reg 10: [io  0x=
2040-0x2047]
Dec  2 07:16:53 sf kernel: [    0.256332] pci 0000:00:03.3: reg 14: [mem 0x=
e0601000-0xe0601fff]
Dec  2 07:16:53 sf kernel: [    0.256567] pci 0000:00:19.0: [8086:1049] typ=
e 0 class 0x000200
Dec  2 07:16:53 sf kernel: [    0.256600] pci 0000:00:19.0: reg 10: [mem 0x=
e0620000-0xe063ffff]
Dec  2 07:16:53 sf kernel: [    0.256618] pci 0000:00:19.0: reg 14: [mem 0x=
e0640000-0xe0640fff]
Dec  2 07:16:53 sf kernel: [    0.256636] pci 0000:00:19.0: reg 18: [io  0x=
2060-0x207f]
Dec  2 07:16:53 sf kernel: [    0.256730] pci 0000:00:19.0: PME# supported =
from D0 D3hot D3cold
Dec  2 07:16:53 sf kernel: [    0.256738] pci 0000:00:19.0: PME# disabled
Dec  2 07:16:53 sf kernel: [    0.256766] pci 0000:00:1a.0: [8086:2834] typ=
e 0 class 0x000c03
Dec  2 07:16:53 sf kernel: [    0.256844] pci 0000:00:1a.0: reg 20: [io  0x=
2080-0x209f]
Dec  2 07:16:53 sf kernel: [    0.256900] pci 0000:00:1a.1: [8086:2835] typ=
e 0 class 0x000c03
Dec  2 07:16:53 sf kernel: [    0.256982] pci 0000:00:1a.1: reg 20: [io  0x=
20a0-0x20bf]
Dec  2 07:16:53 sf kernel: [    0.257061] pci 0000:00:1a.7: [8086:283a] typ=
e 0 class 0x000c03
Dec  2 07:16:53 sf kernel: [    0.257095] pci 0000:00:1a.7: reg 10: [mem 0x=
e0641000-0xe06413ff]
Dec  2 07:16:53 sf kernel: [    0.257217] pci 0000:00:1a.7: PME# supported =
from D0 D3hot D3cold
Dec  2 07:16:53 sf kernel: [    0.257225] pci 0000:00:1a.7: PME# disabled
Dec  2 07:16:53 sf kernel: [    0.257268] pci 0000:00:1b.0: [8086:284b] typ=
e 0 class 0x000403
Dec  2 07:16:53 sf kernel: [    0.257300] pci 0000:00:1b.0: reg 10: [mem 0x=
e0644000-0xe0647fff 64bit]
Dec  2 07:16:53 sf kernel: [    0.257414] pci 0000:00:1b.0: PME# supported =
from D0 D3hot D3cold
Dec  2 07:16:53 sf kernel: [    0.257422] pci 0000:00:1b.0: PME# disabled
Dec  2 07:16:53 sf kernel: [    0.257460] pci 0000:00:1c.0: [8086:283f] typ=
e 1 class 0x000604
Dec  2 07:16:53 sf kernel: [    0.257576] pci 0000:00:1c.0: PME# supported =
from D0 D3hot D3cold
Dec  2 07:16:53 sf kernel: [    0.257584] pci 0000:00:1c.0: PME# disabled
Dec  2 07:16:53 sf kernel: [    0.257626] pci 0000:00:1c.1: [8086:2841] typ=
e 1 class 0x000604
Dec  2 07:16:53 sf kernel: [    0.257742] pci 0000:00:1c.1: PME# supported =
from D0 D3hot D3cold
Dec  2 07:16:53 sf kernel: [    0.257750] pci 0000:00:1c.1: PME# disabled
Dec  2 07:16:53 sf kernel: [    0.257797] pci 0000:00:1d.0: [8086:2830] typ=
e 0 class 0x000c03
Dec  2 07:16:53 sf kernel: [    0.257875] pci 0000:00:1d.0: reg 20: [io  0x=
20c0-0x20df]
Dec  2 07:16:53 sf kernel: [    0.257931] pci 0000:00:1d.1: [8086:2831] typ=
e 0 class 0x000c03
Dec  2 07:16:53 sf kernel: [    0.258015] pci 0000:00:1d.1: reg 20: [io  0x=
20e0-0x20ff]
Dec  2 07:16:53 sf kernel: [    0.258071] pci 0000:00:1d.2: [8086:2832] typ=
e 0 class 0x000c03
Dec  2 07:16:53 sf kernel: [    0.258147] pci 0000:00:1d.2: reg 20: [io  0x=
2100-0x211f]
Dec  2 07:16:53 sf kernel: [    0.258222] pci 0000:00:1d.7: [8086:2836] typ=
e 0 class 0x000c03
Dec  2 07:16:53 sf kernel: [    0.258255] pci 0000:00:1d.7: reg 10: [mem 0x=
e0648000-0xe06483ff]
Dec  2 07:16:53 sf kernel: [    0.258376] pci 0000:00:1d.7: PME# supported =
from D0 D3hot D3cold
Dec  2 07:16:53 sf kernel: [    0.258385] pci 0000:00:1d.7: PME# disabled
Dec  2 07:16:53 sf kernel: [    0.258419] pci 0000:00:1e.0: [8086:2448] typ=
e 1 class 0x000604
Dec  2 07:16:53 sf kernel: [    0.258536] pci 0000:00:1f.0: [8086:2811] typ=
e 0 class 0x000601
Dec  2 07:16:53 sf kernel: [    0.258682] pci 0000:00:1f.0: quirk: [io  0x1=
000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
Dec  2 07:16:53 sf kernel: [    0.258823] pci 0000:00:1f.0: quirk: [io  0x1=
100-0x113f] claimed by ICH6 GPIO
Dec  2 07:16:53 sf kernel: [    0.258924] pci 0000:00:1f.0: ICH7 LPC Generi=
c IO decode 1 PIO at 0500 (mask 007f)
Dec  2 07:16:53 sf kernel: [    0.258982] pci 0000:00:1f.0: ICH7 LPC Generi=
c IO decode 4 PIO at 02e8 (mask 0007)
Dec  2 07:16:53 sf kernel: [    0.260017] pci 0000:00:1f.1: [8086:2850] typ=
e 0 class 0x000101
Dec  2 07:16:53 sf kernel: [    0.260042] pci 0000:00:1f.1: reg 10: [io  0x=
0000-0x0007]
Dec  2 07:16:53 sf kernel: [    0.260059] pci 0000:00:1f.1: reg 14: [io  0x=
0000-0x0003]
Dec  2 07:16:53 sf kernel: [    0.260077] pci 0000:00:1f.1: reg 18: [io  0x=
0000-0x0007]
Dec  2 07:16:53 sf kernel: [    0.260095] pci 0000:00:1f.1: reg 1c: [io  0x=
0000-0x0003]
Dec  2 07:16:53 sf kernel: [    0.260113] pci 0000:00:1f.1: reg 20: [io  0x=
2120-0x212f]
Dec  2 07:16:53 sf kernel: [    0.260255] pci 0000:00:1c.0: PCI bridge to [=
bus 08-08]
Dec  2 07:16:53 sf kernel: [    0.260546] pci 0000:10:00.0: [8086:4229] typ=
e 0 class 0x000280
Dec  2 07:16:53 sf kernel: [    0.260667] pci 0000:10:00.0: reg 10: [mem 0x=
e0000000-0xe0001fff 64bit]
Dec  2 07:16:53 sf kernel: [    0.261106] pci 0000:10:00.0: PME# supported =
from D0 D3hot D3cold
Dec  2 07:16:53 sf kernel: [    0.261142] pci 0000:10:00.0: PME# disabled
Dec  2 07:16:53 sf kernel: [    0.261267] pci 0000:00:1c.1: PCI bridge to [=
bus 10-10]
Dec  2 07:16:53 sf kernel: [    0.261371] pci 0000:00:1c.1:   bridge window=
 [mem 0xe0000000-0xe00fffff]
Dec  2 07:16:53 sf kernel: [    0.261460] pci 0000:02:06.0: [1180:0476] typ=
e 2 class 0x000607
Dec  2 07:16:53 sf kernel: [    0.261493] pci 0000:02:06.0: proprietary Ric=
oh MMC controller disabled (via cardbus function)
Dec  2 07:16:53 sf kernel: [    0.261628] pci 0000:02:06.0: MMC cards are n=
ow supported by standard SDHCI controller
Dec  2 07:16:53 sf kernel: [    0.261785] pci 0000:02:06.0: reg 10: [mem 0x=
e0100000-0xe0100fff]
Dec  2 07:16:53 sf kernel: [    0.261825] pci 0000:02:06.0: supports D1 D2
Dec  2 07:16:53 sf kernel: [    0.261829] pci 0000:02:06.0: PME# supported =
from D0 D1 D2 D3hot D3cold
Dec  2 07:16:53 sf kernel: [    0.261838] pci 0000:02:06.0: PME# disabled
Dec  2 07:16:53 sf kernel: [    0.261872] pci 0000:02:06.1: [1180:0832] typ=
e 0 class 0x000c00
Dec  2 07:16:53 sf kernel: [    0.261908] pci 0000:02:06.1: reg 10: [mem 0x=
e0101000-0xe01017ff]
Dec  2 07:16:53 sf kernel: [    0.262055] pci 0000:02:06.1: supports D1 D2
Dec  2 07:16:53 sf kernel: [    0.262059] pci 0000:02:06.1: PME# supported =
from D0 D1 D2 D3hot D3cold
Dec  2 07:16:53 sf kernel: [    0.262068] pci 0000:02:06.1: PME# disabled
Dec  2 07:16:53 sf kernel: [    0.262103] pci 0000:02:06.2: [1180:0822] typ=
e 0 class 0x000805
Dec  2 07:16:53 sf kernel: [    0.262139] pci 0000:02:06.2: reg 10: [mem 0x=
e0102000-0xe01020ff]
Dec  2 07:16:53 sf kernel: [    0.262277] pci 0000:02:06.2: supports D1 D2
Dec  2 07:16:53 sf kernel: [    0.262281] pci 0000:02:06.2: PME# supported =
from D0 D1 D2 D3hot D3cold
Dec  2 07:16:53 sf kernel: [    0.262290] pci 0000:02:06.2: PME# disabled
Dec  2 07:16:53 sf kernel: [    0.262382] pci 0000:00:1e.0: PCI bridge to [=
bus 02-03] (subtractive decode)
Dec  2 07:16:53 sf kernel: [    0.262488] pci 0000:00:1e.0:   bridge window=
 [mem 0xe0100000-0xe03fffff]
Dec  2 07:16:53 sf kernel: [    0.262501] pci 0000:00:1e.0:   bridge window=
 [io  0x0000-0x0cf7] (subtractive decode)
Dec  2 07:16:53 sf kernel: [    0.262506] pci 0000:00:1e.0:   bridge window=
 [io  0x0d00-0xffff] (subtractive decode)
Dec  2 07:16:53 sf kernel: [    0.262511] pci 0000:00:1e.0:   bridge window=
 [mem 0x000a0000-0x000bffff] (subtractive decode)
Dec  2 07:16:53 sf kernel: [    0.262516] pci 0000:00:1e.0:   bridge window=
 [mem 0x7e800000-0xfedfffff] (subtractive decode)
Dec  2 07:16:53 sf kernel: [    0.262521] pci 0000:00:1e.0:   bridge window=
 [mem 0xfee01000-0xffffffff] (subtractive decode)
Dec  2 07:16:53 sf kernel: [    0.262526] pci 0000:00:1e.0:   bridge window=
 [mem 0x000d0000-0x000dffff] (subtractive decode)
Dec  2 07:16:53 sf kernel: [    0.262600] pci_bus 0000:03: [bus 03-06] part=
ially hidden behind transparent bridge 0000:02 [bus 02-03]
Dec  2 07:16:53 sf kernel: [    0.262765] pci_bus 0000:00: on NUMA node 0
Dec  2 07:16:53 sf kernel: [    0.262773] ACPI: PCI Interrupt Routing Table=
 [\_SB_.C003._PRT]
Dec  2 07:16:53 sf kernel: [    0.263068] ACPI: PCI Interrupt Routing Table=
 [\_SB_.C003.C0B2._PRT]
Dec  2 07:16:53 sf kernel: [    0.263200] ACPI: PCI Interrupt Routing Table=
 [\_SB_.C003.C11F._PRT]
Dec  2 07:16:53 sf kernel: [    0.263263] ACPI: PCI Interrupt Routing Table=
 [\_SB_.C003.C133._PRT]
Dec  2 07:16:53 sf kernel: [    0.264107]  pci0000:00: Requesting ACPI _OSC=
 control (0x1d)
Dec  2 07:16:53 sf kernel: [    0.266107]  pci0000:00: ACPI _OSC control (0=
x1d) granted
Dec  2 07:16:53 sf kernel: [    0.295102] ACPI: PCI Interrupt Link [C12F] (=
IRQs *10 11)
Dec  2 07:16:53 sf kernel: [    0.295522] ACPI: PCI Interrupt Link [C130] (=
IRQs *10 11)
Dec  2 07:16:53 sf kernel: [    0.296104] ACPI: PCI Interrupt Link [C131] (=
IRQs 10 *11)
Dec  2 07:16:53 sf kernel: [    0.296517] ACPI: PCI Interrupt Link [C132] (=
IRQs 10 11) *5
Dec  2 07:16:53 sf kernel: [    0.297012] ACPI: PCI Interrupt Link [C142] (=
IRQs *10 11)
Dec  2 07:16:53 sf kernel: [    0.297418] ACPI: PCI Interrupt Link [C143] (=
IRQs 10 11) *0, disabled.
Dec  2 07:16:53 sf kernel: [    0.297931] ACPI: PCI Interrupt Link [C144] (=
IRQs 10 *11)
Dec  2 07:16:53 sf kernel: [    0.298281] ACPI Exception: AE_NOT_FOUND, Eva=
luating _PRS (20110623/pci_link-184)
Dec  2 07:16:53 sf kernel: [    0.298722] vgaarb: device added: PCI:0000:00=
:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
Dec  2 07:16:53 sf kernel: [    0.298995] vgaarb: loaded
Dec  2 07:16:53 sf kernel: [    0.299085] vgaarb: bridge control possible 0=
000:00:02.0
Dec  2 07:16:53 sf kernel: [    0.299413] SCSI subsystem initialized
Dec  2 07:16:53 sf kernel: [    0.299413] libata version 3.00 loaded.
Dec  2 07:16:53 sf kernel: [    0.299990] usbcore: registered new interface=
 driver usbfs
Dec  2 07:16:53 sf kernel: [    0.300112] usbcore: registered new interface=
 driver hub
Dec  2 07:16:53 sf kernel: [    0.300112] usbcore: registered new device dr=
iver usb
Dec  2 07:16:53 sf kernel: [    0.300112] PCI: Using ACPI for IRQ routing
Dec  2 07:16:53 sf kernel: [    0.304142] PCI: pci_cache_line_size set to 6=
4 bytes
Dec  2 07:16:53 sf kernel: [    0.304321] Expanded resource reserved due to=
 conflict with PCI Bus 0000:00
Dec  2 07:16:53 sf kernel: [    0.304423] reserve RAM buffer: 000000000009f=
c00 - 000000000009ffff=20
Dec  2 07:16:53 sf kernel: [    0.304428] reserve RAM buffer: 000000007e7b0=
000 - 000000007fffffff=20
Dec  2 07:16:53 sf kernel: [    0.304565] HPET: 3 timers in total, 0 timers=
 will be used for per-cpu timer
Dec  2 07:16:53 sf kernel: [    0.304565] hpet0: at MMIO 0xfed00000, IRQs 2=
, 8, 0
Dec  2 07:16:53 sf kernel: [    0.305152] hpet0: 3 comparators, 64-bit 14.3=
18180 MHz counter
Dec  2 07:16:53 sf kernel: [    0.310083] Switching to clocksource hpet
Dec  2 07:16:53 sf kernel: [    0.310171] pnp: PnP ACPI init
Dec  2 07:16:53 sf kernel: [    0.310190] ACPI: bus type pnp registered
Dec  2 07:16:53 sf kernel: [    0.310405] pnp 00:00: [mem 0x00000000-0x0009=
ffff]
Dec  2 07:16:53 sf kernel: [    0.310410] pnp 00:00: [mem 0x000e0000-0x000f=
ffff]
Dec  2 07:16:53 sf kernel: [    0.310414] pnp 00:00: [mem 0x00100000-0x7e7f=
ffff]
Dec  2 07:16:53 sf kernel: [    0.310561] system 00:00: [mem 0x00000000-0x0=
009ffff] could not be reserved
Dec  2 07:16:53 sf kernel: [    0.310662] system 00:00: [mem 0x000e0000-0x0=
00fffff] could not be reserved
Dec  2 07:16:53 sf kernel: [    0.310787] system 00:00: [mem 0x00100000-0x7=
e7fffff] could not be reserved
Dec  2 07:16:53 sf kernel: [    0.310895] system 00:00: Plug and Play ACPI =
device, IDs PNP0c01 (active)
Dec  2 07:16:53 sf kernel: [    0.315180] pnp 00:01: [bus 00-ff]
Dec  2 07:16:53 sf kernel: [    0.315185] pnp 00:01: [io  0x0cf8-0x0cff]
Dec  2 07:16:53 sf kernel: [    0.315193] pnp 00:01: [io  0x0000-0x0cf7 win=
dow]
Dec  2 07:16:53 sf kernel: [    0.315198] pnp 00:01: [io  0x0d00-0xffff win=
dow]
Dec  2 07:16:53 sf kernel: [    0.315203] pnp 00:01: [mem 0x000a0000-0x000b=
ffff window]
Dec  2 07:16:53 sf kernel: [    0.315207] pnp 00:01: [mem 0x7e800000-0xfedf=
ffff window]
Dec  2 07:16:53 sf kernel: [    0.315212] pnp 00:01: [mem 0xfee01000-0xffff=
ffff window]
Dec  2 07:16:53 sf kernel: [    0.315216] pnp 00:01: [mem 0x000d0000-0x000d=
ffff window]
Dec  2 07:16:53 sf kernel: [    0.315408] pnp 00:01: Plug and Play ACPI dev=
ice, IDs PNP0a08 PNP0a03 (active)
Dec  2 07:16:53 sf kernel: [    0.315730] pnp 00:02: [io  0x00f0-0x00ff]
Dec  2 07:16:53 sf kernel: [    0.315746] pnp 00:02: [irq 13]
Dec  2 07:16:53 sf kernel: [    0.315863] pnp 00:02: Plug and Play ACPI dev=
ice, IDs PNP0c04 (active)
Dec  2 07:16:53 sf kernel: [    0.315887] pnp 00:03: [io  0x0000-0x000f]
Dec  2 07:16:53 sf kernel: [    0.315891] pnp 00:03: [io  0x0080-0x008f]
Dec  2 07:16:53 sf kernel: [    0.315895] pnp 00:03: [io  0x00c0-0x00df]
Dec  2 07:16:53 sf kernel: [    0.315899] pnp 00:03: [dma 4]
Dec  2 07:16:53 sf kernel: [    0.316025] pnp 00:03: Plug and Play ACPI dev=
ice, IDs PNP0200 (active)
Dec  2 07:16:53 sf kernel: [    0.316043] pnp 00:04: [io  0x0061]
Dec  2 07:16:53 sf kernel: [    0.316157] pnp 00:04: Plug and Play ACPI dev=
ice, IDs PNP0800 (active)
Dec  2 07:16:53 sf kernel: [    0.316176] pnp 00:05: [io  0x0070-0x0071]
Dec  2 07:16:53 sf kernel: [    0.316180] pnp 00:05: [io  0x0072-0x0073]
Dec  2 07:16:53 sf kernel: [    0.316190] pnp 00:05: [irq 8]
Dec  2 07:16:53 sf kernel: [    0.316309] pnp 00:05: Plug and Play ACPI dev=
ice, IDs PNP0b00 (active)
Dec  2 07:16:53 sf kernel: [    0.316413] pnp 00:06: [mem 0xfed00000-0xfed0=
03ff]
Dec  2 07:16:53 sf kernel: [    0.316534] pnp 00:06: Plug and Play ACPI dev=
ice, IDs PNP0103 (active)
Dec  2 07:16:53 sf kernel: [    0.316554] pnp 00:07: [io  0x0060]
Dec  2 07:16:53 sf kernel: [    0.316558] pnp 00:07: [io  0x0064]
Dec  2 07:16:53 sf kernel: [    0.316568] pnp 00:07: [irq 1]
Dec  2 07:16:53 sf kernel: [    0.316681] pnp 00:07: Plug and Play ACPI dev=
ice, IDs PNP0303 (active)
Dec  2 07:16:53 sf kernel: [    0.316705] pnp 00:08: [irq 12]
Dec  2 07:16:53 sf kernel: [    0.316830] pnp 00:08: Plug and Play ACPI dev=
ice, IDs SYN0130 SYN0100 SYN0002 PNP0f13 (active)
Dec  2 07:16:53 sf kernel: [    0.317001] pnp 00:09: [io  0x0010-0x001f]
Dec  2 07:16:53 sf kernel: [    0.317022] pnp 00:09: [io  0x0024-0x003f]
Dec  2 07:16:53 sf kernel: [    0.317026] pnp 00:09: [io  0x004e-0x004f]
Dec  2 07:16:53 sf kernel: [    0.317030] pnp 00:09: [io  0x0050-0x0053]
Dec  2 07:16:53 sf kernel: [    0.317033] pnp 00:09: [io  0x0063]
Dec  2 07:16:53 sf kernel: [    0.317037] pnp 00:09: [io  0x0065]
Dec  2 07:16:53 sf kernel: [    0.317040] pnp 00:09: [io  0x0067]
Dec  2 07:16:53 sf kernel: [    0.317044] pnp 00:09: [io  0x0074-0x0077]
Dec  2 07:16:53 sf kernel: [    0.317048] pnp 00:09: [io  0x0090-0x009f]
Dec  2 07:16:53 sf kernel: [    0.317051] pnp 00:09: [io  0x00a4-0x00bd]
Dec  2 07:16:53 sf kernel: [    0.317055] pnp 00:09: [io  0x0500-0x057f]
Dec  2 07:16:53 sf kernel: [    0.317059] pnp 00:09: [io  0x0800-0x080f]
Dec  2 07:16:53 sf kernel: [    0.317063] pnp 00:09: [mem 0xffb00000-0xffbf=
ffff]
Dec  2 07:16:53 sf kernel: [    0.317067] pnp 00:09: [mem 0xfff00000-0xffff=
ffff]
Dec  2 07:16:53 sf kernel: [    0.317250] system 00:09: [io  0x0500-0x057f]=
 has been reserved
Dec  2 07:16:53 sf kernel: [    0.317350] system 00:09: [io  0x0800-0x080f]=
 has been reserved
Dec  2 07:16:53 sf kernel: [    0.317447] system 00:09: [mem 0xffb00000-0xf=
fbfffff] has been reserved
Dec  2 07:16:53 sf kernel: [    0.317547] system 00:09: [mem 0xfff00000-0xf=
fffffff] has been reserved
Dec  2 07:16:53 sf kernel: [    0.317647] system 00:09: Plug and Play ACPI =
device, IDs PNP0c02 (active)
Dec  2 07:16:53 sf kernel: [    0.318624] pnp 00:0a: [irq 23]
Dec  2 07:16:53 sf kernel: [    0.318793] pnp 00:0a: Plug and Play ACPI dev=
ice, IDs HPQ0004 (active)
Dec  2 07:16:53 sf kernel: [    0.318834] pnp 00:0b: [io  0x04d0-0x04d1]
Dec  2 07:16:53 sf kernel: [    0.318839] pnp 00:0b: [io  0x02f8-0x02ff]
Dec  2 07:16:53 sf kernel: [    0.318843] pnp 00:0b: [io  0x03f8-0x03ff]
Dec  2 07:16:53 sf kernel: [    0.318847] pnp 00:0b: [io  0x1000-0x107f]
Dec  2 07:16:53 sf kernel: [    0.318851] pnp 00:0b: [io  0x1100-0x113f]
Dec  2 07:16:53 sf kernel: [    0.318854] pnp 00:0b: [io  0x1200-0x121f]
Dec  2 07:16:53 sf kernel: [    0.318862] pnp 00:0b: [mem 0xf8000000-0xfbff=
ffff]
Dec  2 07:16:53 sf kernel: [    0.318866] pnp 00:0b: [mem 0xfec00000-0xfec0=
00ff]
Dec  2 07:16:53 sf kernel: [    0.318870] pnp 00:0b: [mem 0xfed20000-0xfed3=
ffff]
Dec  2 07:16:53 sf kernel: [    0.318874] pnp 00:0b: [mem 0xfed45000-0xfed8=
ffff]
Dec  2 07:16:53 sf kernel: [    0.318878] pnp 00:0b: [mem 0xfed90000-0xfed9=
9fff]
Dec  2 07:16:53 sf kernel: [    0.319106] system 00:0b: [io  0x04d0-0x04d1]=
 has been reserved
Dec  2 07:16:53 sf kernel: [    0.319204] system 00:0b: [io  0x02f8-0x02ff]=
 has been reserved
Dec  2 07:16:53 sf kernel: [    0.319302] system 00:0b: [io  0x03f8-0x03ff]=
 has been reserved
Dec  2 07:16:53 sf kernel: [    0.319400] system 00:0b: [io  0x1000-0x107f]=
 has been reserved
Dec  2 07:16:53 sf kernel: [    0.319496] system 00:0b: [io  0x1100-0x113f]=
 has been reserved
Dec  2 07:16:53 sf kernel: [    0.319593] system 00:0b: [io  0x1200-0x121f]=
 has been reserved
Dec  2 07:16:53 sf kernel: [    0.319691] system 00:0b: [mem 0xf8000000-0xf=
bffffff] has been reserved
Dec  2 07:16:53 sf kernel: [    0.319790] system 00:0b: [mem 0xfec00000-0xf=
ec000ff] could not be reserved
Dec  2 07:16:53 sf kernel: [    0.319889] system 00:0b: [mem 0xfed20000-0xf=
ed3ffff] has been reserved
Dec  2 07:16:53 sf kernel: [    0.319987] system 00:0b: [mem 0xfed45000-0xf=
ed8ffff] has been reserved
Dec  2 07:16:53 sf kernel: [    0.320099] system 00:0b: [mem 0xfed90000-0xf=
ed99fff] has been reserved
Dec  2 07:16:53 sf kernel: [    0.320200] system 00:0b: Plug and Play ACPI =
device, IDs PNP0c02 (active)
Dec  2 07:16:53 sf kernel: [    0.321308] pnp 00:0c: [mem 0x000cee00-0x000c=
ffff]
Dec  2 07:16:53 sf kernel: [    0.321314] pnp 00:0c: [mem 0xfeda0000-0xfedb=
ffff]
Dec  2 07:16:53 sf kernel: [    0.321318] pnp 00:0c: [mem 0xfee00000-0xfee0=
0fff]
Dec  2 07:16:53 sf kernel: [    0.321530] system 00:0c: [mem 0x000cee00-0x0=
00cffff] has been reserved
Dec  2 07:16:53 sf kernel: [    0.321632] system 00:0c: [mem 0xfeda0000-0xf=
edbffff] has been reserved
Dec  2 07:16:53 sf kernel: [    0.321730] system 00:0c: [mem 0xfee00000-0xf=
ee00fff] has been reserved
Dec  2 07:16:53 sf kernel: [    0.321831] system 00:0c: Plug and Play ACPI =
device, IDs PNP0c02 (active)
Dec  2 07:16:53 sf kernel: [    0.321867] pnp: PnP ACPI: found 13 devices
Dec  2 07:16:53 sf kernel: [    0.321960] ACPI: ACPI bus type pnp unregiste=
red
Dec  2 07:16:53 sf kernel: [    0.334196] PCI: max bus depth: 2 pci_try_num=
: 3
Dec  2 07:16:53 sf kernel: [    0.334263] pci 0000:00:1e.0: BAR 9: assigned=
 [mem 0x80000000-0x83ffffff pref]
Dec  2 07:16:53 sf kernel: [    0.334405] pci 0000:00:1e.0: BAR 7: assigned=
 [io  0x3000-0x3fff]
Dec  2 07:16:53 sf kernel: [    0.334503] pci 0000:00:1c.0: PCI bridge to [=
bus 08-08]
Dec  2 07:16:53 sf kernel: [    0.334616] pci 0000:00:1c.1: PCI bridge to [=
bus 10-10]
Dec  2 07:16:53 sf kernel: [    0.334717] pci 0000:00:1c.1:   bridge window=
 [mem 0xe0000000-0xe00fffff]
Dec  2 07:16:53 sf kernel: [    0.334830] pci 0000:02:06.0: BAR 10: assigne=
d [mem 0x84000000-0x87ffffff]
Dec  2 07:16:53 sf kernel: [    0.334928] pci 0000:02:06.0: BAR 9: assigned=
 [mem 0x80000000-0x83ffffff pref]
Dec  2 07:16:53 sf kernel: [    0.335110] pci 0000:02:06.0: BAR 8: assigned=
 [io  0x3000-0x30ff]
Dec  2 07:16:53 sf kernel: [    0.335208] pci 0000:02:06.0: BAR 7: assigned=
 [io  0x3400-0x34ff]
Dec  2 07:16:53 sf kernel: [    0.335305] pci 0000:02:06.0: CardBus bridge =
to [bus 03-06]
Dec  2 07:16:53 sf kernel: [    0.335401] pci 0000:02:06.0:   bridge window=
 [io  0x3400-0x34ff]
Dec  2 07:16:53 sf kernel: [    0.335501] pci 0000:02:06.0:   bridge window=
 [io  0x3000-0x30ff]
Dec  2 07:16:53 sf kernel: [    0.335603] pci 0000:02:06.0:   bridge window=
 [mem 0x80000000-0x83ffffff pref]
Dec  2 07:16:53 sf kernel: [    0.335741] pci 0000:02:06.0:   bridge window=
 [mem 0x84000000-0x87ffffff]
Dec  2 07:16:53 sf kernel: [    0.335843] pci 0000:00:1e.0: PCI bridge to [=
bus 02-03]
Dec  2 07:16:53 sf kernel: [    0.335940] pci 0000:00:1e.0:   bridge window=
 [io  0x3000-0x3fff]
Dec  2 07:16:53 sf kernel: [    0.336066] pci 0000:00:1e.0:   bridge window=
 [mem 0xe0100000-0xe03fffff]
Dec  2 07:16:53 sf kernel: [    0.336167] pci 0000:00:1e.0:   bridge window=
 [mem 0x80000000-0x83ffffff pref]
Dec  2 07:16:53 sf kernel: [    0.336332] pci 0000:00:1c.0: PCI INT A -> GS=
I 16 (level, low) -> IRQ 16
Dec  2 07:16:53 sf kernel: [    0.336435] pci 0000:00:1c.0: setting latency=
 timer to 64
Dec  2 07:16:53 sf kernel: [    0.336454] pci 0000:00:1c.1: PCI INT B -> GS=
I 17 (level, low) -> IRQ 17
Dec  2 07:16:53 sf kernel: [    0.336555] pci 0000:00:1c.1: setting latency=
 timer to 64
Dec  2 07:16:53 sf kernel: [    0.336569] pci 0000:00:1e.0: setting latency=
 timer to 64
Dec  2 07:16:53 sf kernel: [    0.336588] pci 0000:02:06.0: PCI INT A -> GS=
I 18 (level, low) -> IRQ 18
Dec  2 07:16:53 sf kernel: [    0.336692] pci_bus 0000:00: resource 4 [io  =
0x0000-0x0cf7]
Dec  2 07:16:53 sf kernel: [    0.336696] pci_bus 0000:00: resource 5 [io  =
0x0d00-0xffff]
Dec  2 07:16:53 sf kernel: [    0.336701] pci_bus 0000:00: resource 6 [mem =
0x000a0000-0x000bffff]
Dec  2 07:16:53 sf kernel: [    0.336706] pci_bus 0000:00: resource 7 [mem =
0x7e800000-0xfedfffff]
Dec  2 07:16:53 sf kernel: [    0.336710] pci_bus 0000:00: resource 8 [mem =
0xfee01000-0xffffffff]
Dec  2 07:16:53 sf kernel: [    0.336715] pci_bus 0000:00: resource 9 [mem =
0x000d0000-0x000dffff]
Dec  2 07:16:53 sf kernel: [    0.336720] pci_bus 0000:10: resource 1 [mem =
0xe0000000-0xe00fffff]
Dec  2 07:16:53 sf kernel: [    0.336725] pci_bus 0000:02: resource 0 [io  =
0x3000-0x3fff]
Dec  2 07:16:53 sf kernel: [    0.336729] pci_bus 0000:02: resource 1 [mem =
0xe0100000-0xe03fffff]
Dec  2 07:16:53 sf kernel: [    0.336734] pci_bus 0000:02: resource 2 [mem =
0x80000000-0x83ffffff pref]
Dec  2 07:16:53 sf kernel: [    0.336739] pci_bus 0000:02: resource 4 [io  =
0x0000-0x0cf7]
Dec  2 07:16:53 sf kernel: [    0.336743] pci_bus 0000:02: resource 5 [io  =
0x0d00-0xffff]
Dec  2 07:16:53 sf kernel: [    0.336748] pci_bus 0000:02: resource 6 [mem =
0x000a0000-0x000bffff]
Dec  2 07:16:53 sf kernel: [    0.336752] pci_bus 0000:02: resource 7 [mem =
0x7e800000-0xfedfffff]
Dec  2 07:16:53 sf kernel: [    0.336757] pci_bus 0000:02: resource 8 [mem =
0xfee01000-0xffffffff]
Dec  2 07:16:53 sf kernel: [    0.336761] pci_bus 0000:02: resource 9 [mem =
0x000d0000-0x000dffff]
Dec  2 07:16:53 sf kernel: [    0.336766] pci_bus 0000:03: resource 0 [io  =
0x3400-0x34ff]
Dec  2 07:16:53 sf kernel: [    0.336770] pci_bus 0000:03: resource 1 [io  =
0x3000-0x30ff]
Dec  2 07:16:53 sf kernel: [    0.336775] pci_bus 0000:03: resource 2 [mem =
0x80000000-0x83ffffff pref]
Dec  2 07:16:53 sf kernel: [    0.336779] pci_bus 0000:03: resource 3 [mem =
0x84000000-0x87ffffff]
Dec  2 07:16:53 sf kernel: [    0.336833] NET: Registered protocol family 2
Dec  2 07:16:53 sf kernel: [    0.337035] IP route cache hash table entries=
: 65536 (order: 7, 524288 bytes)
Dec  2 07:16:53 sf kernel: [    0.337767] TCP established hash table entrie=
s: 262144 (order: 10, 4194304 bytes)
Dec  2 07:16:53 sf kernel: [    0.341221] TCP bind hash table entries: 6553=
6 (order: 8, 1048576 bytes)
Dec  2 07:16:53 sf kernel: [    0.342280] TCP: Hash tables configured (esta=
blished 262144 bind 65536)
Dec  2 07:16:53 sf kernel: [    0.342378] TCP reno registered
Dec  2 07:16:53 sf kernel: [    0.342472] UDP hash table entries: 1024 (ord=
er: 3, 32768 bytes)
Dec  2 07:16:53 sf kernel: [    0.342601] UDP-Lite hash table entries: 1024=
 (order: 3, 32768 bytes)
Dec  2 07:16:53 sf kernel: [    0.342855] NET: Registered protocol family 1
Dec  2 07:16:53 sf kernel: [    0.342980] pci 0000:00:02.0: Boot video devi=
ce
Dec  2 07:16:53 sf kernel: [    0.343260] PCI: CLS 64 bytes, default 64
Dec  2 07:16:53 sf kernel: [    0.355498] HugeTLB registered 2 MB page size=
, pre-allocated 0 pages
Dec  2 07:16:53 sf kernel: [    0.382698] Btrfs loaded
Dec  2 07:16:53 sf kernel: [    0.382801] msgmni has been set to 3957
Dec  2 07:16:53 sf kernel: [    0.383882] Block layer SCSI generic (bsg) dr=
iver version 0.4 loaded (major 253)
Dec  2 07:16:53 sf kernel: [    0.384038] io scheduler noop registered
Dec  2 07:16:53 sf kernel: [    0.384245] io scheduler cfq registered (defa=
ult)
Dec  2 07:16:53 sf kernel: [    0.384551] pcieport 0000:00:1c.0: setting la=
tency timer to 64
Dec  2 07:16:53 sf kernel: [    0.384637] pcieport 0000:00:1c.0: irq 40 for=
 MSI/MSI-X
Dec  2 07:16:53 sf kernel: [    0.384893] pcieport 0000:00:1c.1: setting la=
tency timer to 64
Dec  2 07:16:53 sf kernel: [    0.384973] pcieport 0000:00:1c.1: irq 41 for=
 MSI/MSI-X
Dec  2 07:16:53 sf kernel: [    0.385409] pcieport 0000:00:1c.0: Signaling =
PME through PCIe PME interrupt
Dec  2 07:16:53 sf kernel: [    0.385516] pcie_pme 0000:00:1c.0:pcie01: ser=
vice driver pcie_pme loaded
Dec  2 07:16:53 sf kernel: [    0.385553] pcieport 0000:00:1c.1: Signaling =
PME through PCIe PME interrupt
Dec  2 07:16:53 sf kernel: [    0.385651] pci 0000:10:00.0: Signaling PME t=
hrough PCIe PME interrupt
Dec  2 07:16:53 sf kernel: [    0.385753] pcie_pme 0000:00:1c.1:pcie01: ser=
vice driver pcie_pme loaded
Dec  2 07:16:53 sf kernel: [    0.386346] intel_idle: MWAIT substates: 0x22=
220
Dec  2 07:16:53 sf kernel: [    0.386351] intel_idle: does not run on famil=
y 6 model 15
Dec  2 07:16:53 sf kernel: [    0.390329] ACPI: Deprecated procfs I/F for A=
C is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
Dec  2 07:16:53 sf kernel: [    0.390698] ACPI: AC Adapter [C23B] (off-line)
Dec  2 07:16:53 sf kernel: [    0.391280] input: Sleep Button as /devices/L=
NXSYSTM:00/device:00/PNP0C0E:00/input/input0
Dec  2 07:16:53 sf kernel: [    0.391422] ACPI: Sleep Button [C2BF]
Dec  2 07:16:53 sf kernel: [    0.391655] input: Lid Switch as /devices/LNX=
SYSTM:00/device:00/PNP0C0D:00/input/input1
Dec  2 07:16:53 sf kernel: [    0.391842] ACPI: Lid Switch [C155]
Dec  2 07:16:53 sf kernel: [    0.392098] input: Power Button as /devices/L=
NXSYSTM:00/LNXPWRBN:00/input/input2
Dec  2 07:16:53 sf kernel: [    0.392237] ACPI: Power Button [PWRF]
Dec  2 07:16:53 sf kernel: [    0.392591] ACPI: Fan [C3B1] (off)
Dec  2 07:16:53 sf kernel: [    0.392826] ACPI: Fan [C3B2] (off)
Dec  2 07:16:53 sf kernel: [    0.393088] ACPI: Fan [C3C8] (off)
Dec  2 07:16:53 sf kernel: [    0.393324] ACPI: Fan [C3C9] (off)
Dec  2 07:16:53 sf kernel: [    0.393558] ACPI: Fan [C3CA] (off)
Dec  2 07:16:53 sf kernel: [    0.393789] ACPI: Fan [C3CB] (off)
Dec  2 07:16:53 sf kernel: [    0.394040] ACPI: Fan [C3CC] (off)
Dec  2 07:16:53 sf kernel: [    0.396645] Monitor-Mwait will be used to ent=
er C-1 state
Dec  2 07:16:53 sf kernel: [    0.396693] Monitor-Mwait will be used to ent=
er C-2 state
Dec  2 07:16:53 sf kernel: [    0.396736] Monitor-Mwait will be used to ent=
er C-3 state
Dec  2 07:16:53 sf kernel: [    0.396749] Marking TSC unstable due to TSC h=
alts in idle
Dec  2 07:16:53 sf kernel: [    0.396863] ACPI: acpi_idle registered with c=
puidle
Dec  2 07:16:53 sf kernel: [    0.403092] thermal LNXTHERM:00: registered a=
s thermal_zone0
Dec  2 07:16:53 sf kernel: [    0.403191] ACPI: Thermal Zone [TZ6] (25 C)
Dec  2 07:16:53 sf kernel: [    0.413470] thermal LNXTHERM:01: registered a=
s thermal_zone1
Dec  2 07:16:53 sf kernel: [    0.413568] ACPI: Thermal Zone [TZ0] (44 C)
Dec  2 07:16:53 sf kernel: [    0.417394] thermal LNXTHERM:02: registered a=
s thermal_zone2
Dec  2 07:16:53 sf kernel: [    0.417491] ACPI: Thermal Zone [TZ1] (44 C)
Dec  2 07:16:53 sf kernel: [    0.421423] thermal LNXTHERM:03: registered a=
s thermal_zone3
Dec  2 07:16:53 sf kernel: [    0.421521] ACPI: Thermal Zone [TZ3] (29 C)
Dec  2 07:16:53 sf kernel: [    0.432467] thermal LNXTHERM:04: registered a=
s thermal_zone4
Dec  2 07:16:53 sf kernel: [    0.432565] ACPI: Thermal Zone [TZ4] (22 C)
Dec  2 07:16:53 sf kernel: [    0.436193] thermal LNXTHERM:05: registered a=
s thermal_zone5
Dec  2 07:16:53 sf kernel: [    0.436290] ACPI: Thermal Zone [TZ5] (0 C)
Dec  2 07:16:53 sf kernel: [    0.437543] Linux agpgart interface v0.103
Dec  2 07:16:53 sf kernel: [    0.437763] agpgart-intel 0000:00:00.0: Intel=
 965GM Chipset
Dec  2 07:16:53 sf kernel: [    0.438052] agpgart-intel 0000:00:00.0: detec=
ted gtt size: 524288K total, 262144K mappable
Dec  2 07:16:53 sf kernel: [    0.439165] agpgart-intel 0000:00:00.0: detec=
ted 8192K stolen memory
Dec  2 07:16:53 sf kernel: [    0.439486] agpgart-intel 0000:00:00.0: AGP a=
perture is 256M @ 0xd0000000
Dec  2 07:16:53 sf kernel: [    0.439978] ata_piix 0000:00:1f.1: version 2.=
13
Dec  2 07:16:53 sf kernel: [    0.439985] ata_piix 0000:00:1f.1: quirky BIO=
S, skipping spindown on poweroff and hibernation
Dec  2 07:16:53 sf kernel: [    0.440232] ata_piix 0000:00:1f.1: PCI INT A =
-> GSI 16 (level, low) -> IRQ 16
Dec  2 07:16:53 sf kernel: [    0.440384] ata_piix 0000:00:1f.1: setting la=
tency timer to 64
Dec  2 07:16:53 sf kernel: [    0.441410] scsi0 : ata_piix
Dec  2 07:16:53 sf kernel: [    0.441740] scsi1 : ata_piix
Dec  2 07:16:53 sf kernel: [    0.442464] ata1: PATA max UDMA/100 cmd 0x1f0=
 ctl 0x3f6 bmdma 0x2120 irq 14
Dec  2 07:16:53 sf kernel: [    0.442566] ata2: PATA max UDMA/100 cmd 0x170=
 ctl 0x376 bmdma 0x2128 irq 15
Dec  2 07:16:53 sf kernel: [    0.442873] ata2: port disabled--ignoring
Dec  2 07:16:53 sf kernel: [    0.443078] e100: Intel(R) PRO/100 Network Dr=
iver, 3.5.24-k2-NAPI
Dec  2 07:16:53 sf kernel: [    0.443175] e100: Copyright(c) 1999-2006 Inte=
l Corporation
Dec  2 07:16:53 sf kernel: [    0.443399] ehci_hcd: USB 2.0 'Enhanced' Host=
 Controller (EHCI) Driver
Dec  2 07:16:53 sf kernel: [    0.443524] ehci_hcd 0000:00:1a.7: PCI INT C =
-> GSI 18 (level, low) -> IRQ 18
Dec  2 07:16:53 sf kernel: [    0.443642] ehci_hcd 0000:00:1a.7: setting la=
tency timer to 64
Dec  2 07:16:53 sf kernel: [    0.443649] ehci_hcd 0000:00:1a.7: EHCI Host =
Controller
Dec  2 07:16:53 sf kernel: [    0.443752] ehci_hcd 0000:00:1a.7: new USB bu=
s registered, assigned bus number 1
Dec  2 07:16:53 sf kernel: [    0.443924] ehci_hcd 0000:00:1a.7: debug port=
 1
Dec  2 07:16:53 sf kernel: [    0.447925] ehci_hcd 0000:00:1a.7: cache line=
 size of 64 is not supported
Dec  2 07:16:53 sf kernel: [    0.447952] ehci_hcd 0000:00:1a.7: irq 18, io=
 mem 0xe0641000
Dec  2 07:16:53 sf kernel: [    0.457027] ehci_hcd 0000:00:1a.7: USB 2.0 st=
arted, EHCI 1.00
Dec  2 07:16:53 sf kernel: [    0.457156] usb usb1: New USB device found, i=
dVendor=3D1d6b, idProduct=3D0002
Dec  2 07:16:53 sf kernel: [    0.457264] usb usb1: New USB device strings:=
 Mfr=3D3, Product=3D2, SerialNumber=3D1
Dec  2 07:16:53 sf kernel: [    0.457398] usb usb1: Product: EHCI Host Cont=
roller
Dec  2 07:16:53 sf kernel: [    0.457493] usb usb1: Manufacturer: Linux 3.2=
.0-rc3-00099-g883381d ehci_hcd
Dec  2 07:16:53 sf kernel: [    0.457591] usb usb1: SerialNumber: 0000:00:1=
a.7
Dec  2 07:16:53 sf kernel: [    0.457955] hub 1-0:1.0: USB hub found
Dec  2 07:16:53 sf kernel: [    0.458077] hub 1-0:1.0: 4 ports detected
Dec  2 07:16:53 sf kernel: [    0.458322] ehci_hcd 0000:00:1d.7: PCI INT A =
-> GSI 20 (level, low) -> IRQ 20
Dec  2 07:16:53 sf kernel: [    0.458478] ehci_hcd 0000:00:1d.7: setting la=
tency timer to 64
Dec  2 07:16:53 sf kernel: [    0.458484] ehci_hcd 0000:00:1d.7: EHCI Host =
Controller
Dec  2 07:16:53 sf kernel: [    0.458586] ehci_hcd 0000:00:1d.7: new USB bu=
s registered, assigned bus number 2
Dec  2 07:16:53 sf kernel: [    0.458760] ehci_hcd 0000:00:1d.7: debug port=
 1
Dec  2 07:16:53 sf kernel: [    0.462727] ehci_hcd 0000:00:1d.7: cache line=
 size of 64 is not supported
Dec  2 07:16:53 sf kernel: [    0.462752] ehci_hcd 0000:00:1d.7: irq 20, io=
 mem 0xe0648000
Dec  2 07:16:53 sf kernel: [    0.472026] ehci_hcd 0000:00:1d.7: USB 2.0 st=
arted, EHCI 1.00
Dec  2 07:16:53 sf kernel: [    0.472174] usb usb2: New USB device found, i=
dVendor=3D1d6b, idProduct=3D0002
Dec  2 07:16:53 sf kernel: [    0.472279] usb usb2: New USB device strings:=
 Mfr=3D3, Product=3D2, SerialNumber=3D1
Dec  2 07:16:53 sf kernel: [    0.473183] usb usb2: Product: EHCI Host Cont=
roller
Dec  2 07:16:53 sf kernel: [    0.473277] usb usb2: Manufacturer: Linux 3.2=
.0-rc3-00099-g883381d ehci_hcd
Dec  2 07:16:53 sf kernel: [    0.473417] usb usb2: SerialNumber: 0000:00:1=
d.7
Dec  2 07:16:53 sf kernel: [    0.473776] hub 2-0:1.0: USB hub found
Dec  2 07:16:53 sf kernel: [    0.473874] hub 2-0:1.0: 6 ports detected
Dec  2 07:16:53 sf kernel: [    0.474245] uhci_hcd: USB Universal Host Cont=
roller Interface driver
Dec  2 07:16:53 sf kernel: [    0.474373] uhci_hcd 0000:00:1a.0: PCI INT A =
-> GSI 16 (level, low) -> IRQ 16
Dec  2 07:16:53 sf kernel: [    0.474478] uhci_hcd 0000:00:1a.0: setting la=
tency timer to 64
Dec  2 07:16:53 sf kernel: [    0.474485] uhci_hcd 0000:00:1a.0: UHCI Host =
Controller
Dec  2 07:16:53 sf kernel: [    0.474589] uhci_hcd 0000:00:1a.0: new USB bu=
s registered, assigned bus number 3
Dec  2 07:16:53 sf kernel: [    0.474772] uhci_hcd 0000:00:1a.0: irq 16, io=
 base 0x00002080
Dec  2 07:16:53 sf kernel: [    0.474924] usb usb3: New USB device found, i=
dVendor=3D1d6b, idProduct=3D0001
Dec  2 07:16:53 sf kernel: [    0.475037] usb usb3: New USB device strings:=
 Mfr=3D3, Product=3D2, SerialNumber=3D1
Dec  2 07:16:53 sf kernel: [    0.475174] usb usb3: Product: UHCI Host Cont=
roller
Dec  2 07:16:53 sf kernel: [    0.475293] usb usb3: Manufacturer: Linux 3.2=
.0-rc3-00099-g883381d uhci_hcd
Dec  2 07:16:53 sf kernel: [    0.475391] usb usb3: SerialNumber: 0000:00:1=
a.0
Dec  2 07:16:53 sf kernel: [    0.475744] hub 3-0:1.0: USB hub found
Dec  2 07:16:53 sf kernel: [    0.475841] hub 3-0:1.0: 2 ports detected
Dec  2 07:16:53 sf kernel: [    0.476080] uhci_hcd 0000:00:1a.1: PCI INT B =
-> GSI 17 (level, low) -> IRQ 17
Dec  2 07:16:53 sf kernel: [    0.476186] uhci_hcd 0000:00:1a.1: setting la=
tency timer to 64
Dec  2 07:16:53 sf kernel: [    0.476192] uhci_hcd 0000:00:1a.1: UHCI Host =
Controller
Dec  2 07:16:53 sf kernel: [    0.476293] uhci_hcd 0000:00:1a.1: new USB bu=
s registered, assigned bus number 4
Dec  2 07:16:53 sf kernel: [    0.476515] uhci_hcd 0000:00:1a.1: irq 17, io=
 base 0x000020a0
Dec  2 07:16:53 sf kernel: [    0.476668] usb usb4: New USB device found, i=
dVendor=3D1d6b, idProduct=3D0001
Dec  2 07:16:53 sf kernel: [    0.476767] usb usb4: New USB device strings:=
 Mfr=3D3, Product=3D2, SerialNumber=3D1
Dec  2 07:16:53 sf kernel: [    0.476900] usb usb4: Product: UHCI Host Cont=
roller
Dec  2 07:16:53 sf kernel: [    0.476994] usb usb4: Manufacturer: Linux 3.2=
.0-rc3-00099-g883381d uhci_hcd
Dec  2 07:16:53 sf kernel: [    0.477119] usb usb4: SerialNumber: 0000:00:1=
a.1
Dec  2 07:16:53 sf kernel: [    0.477482] hub 4-0:1.0: USB hub found
Dec  2 07:16:53 sf kernel: [    0.477579] hub 4-0:1.0: 2 ports detected
Dec  2 07:16:53 sf kernel: [    0.477798] uhci_hcd 0000:00:1d.0: PCI INT A =
-> GSI 20 (level, low) -> IRQ 20
Dec  2 07:16:53 sf kernel: [    0.477904] uhci_hcd 0000:00:1d.0: setting la=
tency timer to 64
Dec  2 07:16:53 sf kernel: [    0.477910] uhci_hcd 0000:00:1d.0: UHCI Host =
Controller
Dec  2 07:16:53 sf kernel: [    0.478029] uhci_hcd 0000:00:1d.0: new USB bu=
s registered, assigned bus number 5
Dec  2 07:16:53 sf kernel: [    0.478197] uhci_hcd 0000:00:1d.0: irq 20, io=
 base 0x000020c0
Dec  2 07:16:53 sf kernel: [    0.478388] usb usb5: New USB device found, i=
dVendor=3D1d6b, idProduct=3D0001
Dec  2 07:16:53 sf kernel: [    0.478491] usb usb5: New USB device strings:=
 Mfr=3D3, Product=3D2, SerialNumber=3D1
Dec  2 07:16:53 sf kernel: [    0.478625] usb usb5: Product: UHCI Host Cont=
roller
Dec  2 07:16:53 sf kernel: [    0.478719] usb usb5: Manufacturer: Linux 3.2=
.0-rc3-00099-g883381d uhci_hcd
Dec  2 07:16:53 sf kernel: [    0.478817] usb usb5: SerialNumber: 0000:00:1=
d.0
Dec  2 07:16:53 sf kernel: [    0.479190] hub 5-0:1.0: USB hub found
Dec  2 07:16:53 sf kernel: [    0.479353] hub 5-0:1.0: 2 ports detected
Dec  2 07:16:53 sf kernel: [    0.479581] uhci_hcd 0000:00:1d.1: PCI INT B =
-> GSI 22 (level, low) -> IRQ 22
Dec  2 07:16:53 sf kernel: [    0.479688] uhci_hcd 0000:00:1d.1: setting la=
tency timer to 64
Dec  2 07:16:53 sf kernel: [    0.479694] uhci_hcd 0000:00:1d.1: UHCI Host =
Controller
Dec  2 07:16:53 sf kernel: [    0.479795] uhci_hcd 0000:00:1d.1: new USB bu=
s registered, assigned bus number 6
Dec  2 07:16:53 sf kernel: [    0.479974] uhci_hcd 0000:00:1d.1: irq 22, io=
 base 0x000020e0
Dec  2 07:16:53 sf kernel: [    0.480157] usb usb6: New USB device found, i=
dVendor=3D1d6b, idProduct=3D0001
Dec  2 07:16:53 sf kernel: [    0.480287] usb usb6: New USB device strings:=
 Mfr=3D3, Product=3D2, SerialNumber=3D1
Dec  2 07:16:53 sf kernel: [    0.480422] usb usb6: Product: UHCI Host Cont=
roller
Dec  2 07:16:53 sf kernel: [    0.480516] usb usb6: Manufacturer: Linux 3.2=
.0-rc3-00099-g883381d uhci_hcd
Dec  2 07:16:53 sf kernel: [    0.480614] usb usb6: SerialNumber: 0000:00:1=
d.1
Dec  2 07:16:53 sf kernel: [    0.480947] hub 6-0:1.0: USB hub found
Dec  2 07:16:53 sf kernel: [    0.481066] hub 6-0:1.0: 2 ports detected
Dec  2 07:16:53 sf kernel: [    0.481289] uhci_hcd 0000:00:1d.2: PCI INT C =
-> GSI 18 (level, low) -> IRQ 18
Dec  2 07:16:53 sf kernel: [    0.481441] uhci_hcd 0000:00:1d.2: setting la=
tency timer to 64
Dec  2 07:16:53 sf kernel: [    0.481447] uhci_hcd 0000:00:1d.2: UHCI Host =
Controller
Dec  2 07:16:53 sf kernel: [    0.481548] uhci_hcd 0000:00:1d.2: new USB bu=
s registered, assigned bus number 7
Dec  2 07:16:53 sf kernel: [    0.481713] uhci_hcd 0000:00:1d.2: irq 18, io=
 base 0x00002100
Dec  2 07:16:53 sf kernel: [    0.481867] usb usb7: New USB device found, i=
dVendor=3D1d6b, idProduct=3D0001
Dec  2 07:16:53 sf kernel: [    0.481966] usb usb7: New USB device strings:=
 Mfr=3D3, Product=3D2, SerialNumber=3D1
Dec  2 07:16:53 sf kernel: [    0.482134] usb usb7: Product: UHCI Host Cont=
roller
Dec  2 07:16:53 sf kernel: [    0.482260] usb usb7: Manufacturer: Linux 3.2=
.0-rc3-00099-g883381d uhci_hcd
Dec  2 07:16:53 sf kernel: [    0.482358] usb usb7: SerialNumber: 0000:00:1=
d.2
Dec  2 07:16:53 sf kernel: [    0.482703] hub 7-0:1.0: USB hub found
Dec  2 07:16:53 sf kernel: [    0.482801] hub 7-0:1.0: 2 ports detected
Dec  2 07:16:53 sf kernel: [    0.483214] usbcore: registered new interface=
 driver libusual
Dec  2 07:16:53 sf kernel: [    0.483799] ACPI: Deprecated procfs I/F for b=
attery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
Dec  2 07:16:53 sf kernel: [    0.483851] i8042: PNP: PS/2 Controller [PNP0=
303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,12
Dec  2 07:16:53 sf kernel: [    0.484128] ACPI: Battery Slot [C23D] (batter=
y present)
Dec  2 07:16:53 sf kernel: [    0.485570] i8042: Detected active multiplexi=
ng controller, rev 1.1
Dec  2 07:16:53 sf kernel: [    0.486366] serio: i8042 KBD port at 0x60,0x6=
4 irq 1
Dec  2 07:16:53 sf kernel: [    0.486533] serio: i8042 AUX0 port at 0x60,0x=
64 irq 12
Dec  2 07:16:53 sf kernel: [    0.486725] serio: i8042 AUX1 port at 0x60,0x=
64 irq 12
Dec  2 07:16:53 sf kernel: [    0.486880] serio: i8042 AUX2 port at 0x60,0x=
64 irq 12
Dec  2 07:16:53 sf kernel: [    0.487050] serio: i8042 AUX3 port at 0x60,0x=
64 irq 12
Dec  2 07:16:53 sf kernel: [    0.487478] mousedev: PS/2 mouse device commo=
n for all mice
Dec  2 07:16:53 sf kernel: [    0.488086] rtc_cmos 00:05: RTC can wake from=
 S4
Dec  2 07:16:53 sf kernel: [    0.488407] rtc_cmos 00:05: rtc core: registe=
red rtc_cmos as rtc0
Dec  2 07:16:53 sf kernel: [    0.488541] rtc0: alarms up to one month, y3k=
, 114 bytes nvram, hpet irqs
Dec  2 07:16:53 sf kernel: [    0.489257] cpuidle: using governor ladder
Dec  2 07:16:53 sf kernel: [    0.490383] cpuidle: using governor menu
Dec  2 07:16:53 sf kernel: [    0.491077] leds_ss4200: no LED devices found
Dec  2 07:16:53 sf kernel: [    0.492538] usbcore: registered new interface=
 driver usbhid
Dec  2 07:16:53 sf kernel: [    0.492634] usbhid: USB HID core driver
Dec  2 07:16:53 sf kernel: [    0.493598] TCP cubic registered
Dec  2 07:16:53 sf kernel: [    0.493693] NET: Registered protocol family 17
Dec  2 07:16:53 sf kernel: [    0.494202] PM: Hibernation image not present=
 or could not be loaded.
Dec  2 07:16:53 sf kernel: [    0.494215] registered taskstats version 1
Dec  2 07:16:53 sf kernel: [    0.504224] console [netcon0] enabled
Dec  2 07:16:53 sf kernel: [    0.504322] netconsole: network logging start=
ed
Dec  2 07:16:53 sf kernel: [    0.515984] input: AT Translated Set 2 keyboa=
rd as /devices/platform/i8042/serio0/input/input3
Dec  2 07:16:53 sf kernel: [    0.612701] ata1.00: ATA-8: SAMSUNG HM641JI, =
2AJ10001, max UDMA/133
Dec  2 07:16:53 sf kernel: [    0.612819] ata1.00: 1250263728 sectors, mult=
i 16: LBA48 NCQ (depth 0/32)
Dec  2 07:16:53 sf kernel: [    0.632717] ata1.00: configured for UDMA/100
Dec  2 07:16:53 sf kernel: [    0.633133] scsi 0:0:0:0: Direct-Access     A=
TA      SAMSUNG HM641JI  2AJ1 PQ: 0 ANSI: 5
Dec  2 07:16:53 sf kernel: [    0.633952] sd 0:0:0:0: [sda] 1250263728 512-=
byte logical blocks: (640 GB/596 GiB)
Dec  2 07:16:53 sf kernel: [    0.634278] sd 0:0:0:0: [sda] Write Protect i=
s off
Dec  2 07:16:53 sf kernel: [    0.634387] sd 0:0:0:0: [sda] Mode Sense: 00 =
3a 00 00
Dec  2 07:16:53 sf kernel: [    0.634442] sd 0:0:0:0: [sda] Write cache: en=
abled, read cache: enabled, doesn't support DPO or FUA
Dec  2 07:16:53 sf kernel: [    0.657436]  sda: sda1 sda2 sda3
Dec  2 07:16:53 sf kernel: [    0.658788] sd 0:0:0:0: [sda] Attached SCSI d=
isk
Dec  2 07:16:53 sf kernel: [    1.148035] input: PS/2 Generic Mouse as /dev=
ices/platform/i8042/serio1/input/input4
Dec  2 07:16:53 sf kernel: [    1.160094] usb 5-2: new full-speed USB devic=
e number 2 using uhci_hcd
Dec  2 07:16:53 sf kernel: [    1.309518] usb 5-2: New USB device found, id=
Vendor=3D08ff, idProduct=3D2580
Dec  2 07:16:53 sf kernel: [    1.309637] usb 5-2: New USB device strings: =
Mfr=3D0, Product=3D1, SerialNumber=3D0
Dec  2 07:16:53 sf kernel: [    1.309749] usb 5-2: Product: Fingerprint Sen=
sor
Dec  2 07:16:53 sf kernel: [    1.815341] psmouse serio4: synaptics: Touchp=
ad model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04711/0xa00000/0x0
Dec  2 07:16:53 sf kernel: [    1.857172] input: SynPS/2 Synaptics TouchPad=
 as /devices/platform/i8042/serio4/input/input5
Dec  2 07:16:53 sf kernel: [    1.900534] device fsid f6a8e615-1ecc-465c-ac=
4e-cf1ecf6733b0 devid 1 transid 79586 /dev/root
Dec  2 07:16:53 sf kernel: [    1.901431] btrfs: disk space caching is enab=
led
Dec  2 07:16:53 sf kernel: [    7.632115] VFS: Mounted root (btrfs filesyst=
em) readonly on device 0:12.
Dec  2 07:16:53 sf kernel: [    7.633673] Freeing unused kernel memory: 452=
k freed
Dec  2 07:16:53 sf kernel: [    7.633935] Write protecting the kernel read-=
only data: 8192k
Dec  2 07:16:53 sf kernel: [    7.644763] Freeing unused kernel memory: 180=
0k freed
Dec  2 07:16:53 sf kernel: [    7.648410] Freeing unused kernel memory: 436=
k freed
Dec  2 07:16:53 sf kernel: [   14.465778] cfg80211: Calling CRDA to update =
world regulatory domain
Dec  2 07:16:53 sf kernel: [   14.582756] sdhci: Secure Digital Host Contro=
ller Interface driver
Dec  2 07:16:53 sf kernel: [   14.582762] sdhci: Copyright(c) Pierre Ossman
Dec  2 07:16:53 sf kernel: [   14.583831] sdhci-pci 0000:02:06.2: SDHCI con=
troller found [1180:0822] (rev 21)
Dec  2 07:16:53 sf kernel: [   14.583860] sdhci-pci 0000:02:06.2: PCI INT C=
 -> GSI 20 (level, low) -> IRQ 20
Dec  2 07:16:53 sf kernel: [   14.584902] sdhci-pci 0000:02:06.2: Will use =
DMA mode even though HW doesn't fully claim to support it.
Dec  2 07:16:53 sf kernel: [   14.585981] Registered led device: mmc0::
Dec  2 07:16:53 sf kernel: [   14.589074] mmc0: SDHCI controller on PCI [00=
00:02:06.2] using DMA
Dec  2 07:16:53 sf kernel: [   14.620649] [drm] Initialized drm 1.1.0 20060=
810
Dec  2 07:16:53 sf kernel: [   14.718180] i915 0000:00:02.0: PCI INT A -> G=
SI 16 (level, low) -> IRQ 16
Dec  2 07:16:53 sf kernel: [   14.718195] i915 0000:00:02.0: setting latenc=
y timer to 64
Dec  2 07:16:53 sf kernel: [   14.807333] i915 0000:00:02.0: irq 42 for MSI=
/MSI-X
Dec  2 07:16:53 sf kernel: [   14.807345] [drm] Supports vblank timestamp c=
aching Rev 1 (10.10.2010).
Dec  2 07:16:53 sf kernel: [   14.807349] [drm] Driver supports precise vbl=
ank timestamp query.
Dec  2 07:16:53 sf kernel: [   14.807418] vgaarb: device changed decodes: P=
CI:0000:00:02.0,olddecodes=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
Dec  2 07:16:53 sf kernel: [   14.813147] e1000e: Intel(R) PRO/1000 Network=
 Driver - 1.5.1-k
Dec  2 07:16:53 sf kernel: [   14.813153] e1000e: Copyright(c) 1999 - 2011 =
Intel Corporation.
Dec  2 07:16:53 sf kernel: [   14.838869] yenta_cardbus 0000:02:06.0: CardB=
us bridge found [103c:30c9]
Dec  2 07:16:53 sf kernel: [   14.960880] yenta_cardbus 0000:02:06.0: ISA I=
RQ mask 0x0cb8, PCI irq 18
Dec  2 07:16:53 sf kernel: [   14.960889] yenta_cardbus 0000:02:06.0: Socke=
t status: 30000006
Dec  2 07:16:53 sf kernel: [   14.960896] pci_bus 0000:02: Raising subordin=
ate bus# of parent bus (#02) from #03 to #06
Dec  2 07:16:53 sf kernel: [   15.131274] [drm] initialized overlay support
Dec  2 07:16:53 sf kernel: [   15.131336] [drm] forcing SVIDEO-1 connector =
OFF
Dec  2 07:16:53 sf kernel: [   15.144476] iwl4965: Intel(R) Wireless WiFi 4=
965 driver for Linux, in-tree:
Dec  2 07:16:53 sf kernel: [   15.144482] iwl4965: Copyright(c) 2003-2011 I=
ntel Corporation
Dec  2 07:16:53 sf kernel: [   15.144653] iwl4965 0000:10:00.0: PCI INT A -=
> GSI 17 (level, low) -> IRQ 17
Dec  2 07:16:53 sf kernel: [   15.144666] iwl4965 0000:10:00.0: setting lat=
ency timer to 64
Dec  2 07:16:53 sf kernel: [   15.144719] iwl4965 0000:10:00.0: Detected In=
tel(R) Wireless WiFi Link 4965AGN, REV=3D0x4
Dec  2 07:16:53 sf kernel: [   15.149283] fbcon: inteldrmfb (fb0) is primar=
y device
Dec  2 07:16:53 sf kernel: [   15.185874] iwl4965 0000:10:00.0: device EEPR=
OM VER=3D0x36, CALIB=3D0x5
Dec  2 07:16:53 sf kernel: [   15.185900] iwl4965 0000:10:00.0: Tunable cha=
nnels: 13 802.11bg, 19 802.11a channels
Dec  2 07:16:53 sf kernel: [   15.186015] iwl4965 0000:10:00.0: irq 43 for =
MSI/MSI-X
Dec  2 07:16:53 sf kernel: [   15.289845] iwl4965 0000:10:00.0: loaded firm=
ware version 228.61.2.24
Dec  2 07:16:53 sf kernel: [   15.290253] Registered led device: phy0-led
Dec  2 07:16:53 sf kernel: [   15.290413] ieee80211 phy0: Selected rate con=
trol algorithm 'iwl-4965-rs'
Dec  2 07:16:53 sf kernel: [   15.560256] Console: switching to colour fram=
e buffer device 160x50
Dec  2 07:16:53 sf kernel: [   15.565517] fb0: inteldrmfb frame buffer devi=
ce
Dec  2 07:16:53 sf kernel: [   15.565521] drm: registered panic notifier
Dec  2 07:16:53 sf kernel: [   15.567505] ACPI Exception: AE_AML_PACKAGE_LI=
MIT, Index (0x0000000000000004) is beyond end of object (20110623/exoparg2-=
418)
Dec  2 07:16:53 sf kernel: [   15.567527] ACPI Error: Method parse/executio=
n failed [\_SB_.C003.C09A._DOD] (Node ffff88007b82c988), AE_AML_PACKAGE_LIM=
IT (20110623/psparse-536)
Dec  2 07:16:53 sf kernel: [   15.567546] ACPI Exception: AE_AML_PACKAGE_LI=
MIT, Evaluating _DOD (20110623/video-1147)
Dec  2 07:16:53 sf kernel: [   15.568635] acpi device:01: registered as coo=
ling_device9
Dec  2 07:16:53 sf kernel: [   15.569123] input: Video Bus as /devices/LNXS=
YSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
Dec  2 07:16:53 sf kernel: [   15.569182] ACPI: Video Device [C09A] (multi-=
head: yes  rom: no  post: no)
Dec  2 07:16:53 sf kernel: [   15.569258] [drm] Initialized i915 1.6.0 2008=
0730 for 0000:00:02.0 on minor 0
Dec  2 07:16:53 sf kernel: [   15.569298] e1000e 0000:00:19.0: PCI INT A ->=
 GSI 22 (level, low) -> IRQ 22
Dec  2 07:16:53 sf kernel: [   15.569313] e1000e 0000:00:19.0: setting late=
ncy timer to 64
Dec  2 07:16:53 sf kernel: [   15.569508] e1000e 0000:00:19.0: irq 44 for M=
SI/MSI-X
Dec  2 07:16:53 sf kernel: [   15.886427] e1000e 0000:00:19.0: eth0: (PCI E=
xpress:2.5GT/s:Width x1) 00:1e:68:51:e5:60
Dec  2 07:16:53 sf kernel: [   15.886435] e1000e 0000:00:19.0: eth0: Intel(=
R) PRO/1000 Network Connection
Dec  2 07:16:53 sf kernel: [   15.886466] e1000e 0000:00:19.0: eth0: MAC: 6=
, PHY: 6, PBA No: FFFFFF-0FF
Dec  2 07:16:53 sf kernel: [   15.891479] snd_hda_intel 0000:00:1b.0: power=
 state changed by ACPI to D0
Dec  2 07:16:53 sf kernel: [   15.891492] snd_hda_intel 0000:00:1b.0: power=
 state changed by ACPI to D0
Dec  2 07:16:53 sf kernel: [   15.891508] snd_hda_intel 0000:00:1b.0: PCI I=
NT A -> GSI 17 (level, low) -> IRQ 17
Dec  2 07:16:53 sf kernel: [   15.891605] snd_hda_intel 0000:00:1b.0: irq 4=
5 for MSI/MSI-X
Dec  2 07:16:53 sf kernel: [   15.891658] snd_hda_intel 0000:00:1b.0: setti=
ng latency timer to 64
Dec  2 07:16:53 sf kernel: [   17.529976] tun: Universal TUN/TAP device dri=
ver, 1.6
Dec  2 07:16:53 sf kernel: [   17.529981] tun: (C) 1999-2004 Max Krasnyansk=
y <maxk@qualcomm.com>
Dec  2 07:16:53 sf kernel: [   17.612868] Initializing USB Mass Storage dri=
ver...
Dec  2 07:16:53 sf kernel: [   17.612999] usbcore: registered new interface=
 driver usb-storage
Dec  2 07:16:53 sf kernel: [   17.613023] USB Mass Storage support register=
ed.
Dec  2 07:16:53 sf kernel: [   17.729671] fuse init (API version 7.17)
Dec  2 07:16:53 sf kernel: [   17.917206] loop: module loaded
Dec  2 07:16:53 sf kernel: [   18.560962] btrfs: disk space caching is enab=
led
Dec  2 07:16:53 sf kernel: [   40.870346] Adding 2096476k swap on /dev/sda3=
.  Priority:-1 extents:1 across:2096476k=20
Dec  2 07:17:18 sf kernel: [   68.400658] e1000e 0000:00:19.0: irq 44 for M=
SI/MSI-X
Dec  2 07:17:19 sf kernel: [   68.451337] e1000e 0000:00:19.0: irq 44 for M=
SI/MSI-X
Dec  2 08:23:29 sf kernel: [ 4036.409488] PM: Syncing filesystems ... done.
Dec  2 08:23:29 sf kernel: [ 4038.444199] PM: Preparing system for mem sleep
Dec  2 17:39:41 sf kernel: [ 4038.685503] Freezing user space processes ...=
 (elapsed 0.01 seconds) done.
Dec  2 17:39:41 sf kernel: [ 4038.696091] Freezing remaining freezable task=
s ... (elapsed 0.01 seconds) done.
Dec  2 17:39:41 sf kernel: [ 4038.707198] PM: Entering mem sleep
Dec  2 17:39:41 sf kernel: [ 4038.707238] Suspending console(s) (use no_con=
sole_suspend to debug)
Dec  2 17:39:41 sf kernel: [ 4038.708269] sd 0:0:0:0: [sda] Synchronizing S=
CSI cache
Dec  2 17:39:41 sf kernel: [ 4038.708456] sd 0:0:0:0: [sda] Stopping disk
Dec  2 17:39:41 sf kernel: [ 4038.760223] ------------[ cut here ]---------=
---
Dec  2 17:39:41 sf kernel: [ 4038.760240] WARNING: at drivers/pci/pci-drive=
r.c:607 pci_has_legacy_pm_support.clone.4+0x39/0x60()
Dec  2 17:39:41 sf kernel: [ 4038.760246] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 17:39:41 sf kernel: [ 4038.760250] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 17:39:41 sf kernel: [ 4038.760331] Pid: 6193, comm: kworker/u:9 Not =
tainted 3.2.0-rc3-00099-g883381d #163
Dec  2 17:39:41 sf kernel: [ 4038.760337] Call Trace:
Dec  2 17:39:41 sf kernel: [ 4038.760350]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 17:39:41 sf kernel: [ 4038.760360]  [<ffffffff81046a75>] warn_slowpa=
th_null+0x15/0x20
Dec  2 17:39:41 sf kernel: [ 4038.760369]  [<ffffffff81273749>] pci_has_leg=
acy_pm_support.clone.4+0x39/0x60
Dec  2 17:39:41 sf kernel: [ 4038.760379]  [<ffffffff8127400f>] pci_pm_susp=
end+0x3f/0x120
Dec  2 17:39:41 sf kernel: [ 4038.760388]  [<ffffffff8103eb51>] ? get_paren=
t_ip+0x11/0x50
Dec  2 17:39:41 sf kernel: [ 4038.760398]  [<ffffffff812ff4c9>] pm_op+0x1b9=
/0x220
Dec  2 17:39:41 sf kernel: [ 4038.760407]  [<ffffffff812ff67c>] __device_su=
spend+0xbc/0x200
Dec  2 17:39:41 sf kernel: [ 4038.760417]  [<ffffffff8106a210>] ? async_sch=
edule+0x20/0x20
Dec  2 17:39:41 sf kernel: [ 4038.760425]  [<ffffffff812ff7da>] async_suspe=
nd+0x1a/0x90
Dec  2 17:39:41 sf kernel: [ 4038.760433]  [<ffffffff8106a28f>] async_run_e=
ntry_fn+0x7f/0x180
Dec  2 17:39:41 sf kernel: [ 4038.760443]  [<ffffffff8105c422>] process_one=
_work+0x112/0x390
Dec  2 17:39:41 sf kernel: [ 4038.760452]  [<ffffffff8105e711>] worker_thre=
ad+0x161/0x340
Dec  2 17:39:41 sf kernel: [ 4038.760460]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 17:39:41 sf kernel: [ 4038.760468]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 17:39:41 sf kernel: [ 4038.760477]  [<ffffffff810632a6>] kthread+0x9=
6/0xa0
Dec  2 17:39:41 sf kernel: [ 4038.760488]  [<ffffffff814373d4>] kernel_thre=
ad_helper+0x4/0x10
Dec  2 17:39:41 sf kernel: [ 4038.760497]  [<ffffffff81063210>] ? kthread_w=
orker_fn+0x190/0x190
Dec  2 17:39:41 sf kernel: [ 4038.760505]  [<ffffffff814373d0>] ? gs_change=
+0xb/0xb
Dec  2 17:39:41 sf kernel: [ 4038.760511] ---[ end trace 7a713f1eaae7159c ]=
---
Dec  2 17:39:41 sf kernel: [ 4038.762188] uhci_hcd 0000:00:1d.0: PCI INT A =
disabled
Dec  2 17:39:41 sf kernel: [ 4038.763116] ACPI handle has no context!
Dec  2 17:39:41 sf kernel: [ 4038.763131] sdhci-pci 0000:02:06.2: PCI INT C=
 disabled
Dec  2 17:39:41 sf kernel: [ 4038.763144] ACPI handle has no context!
Dec  2 17:39:41 sf kernel: [ 4038.791296] uhci_hcd 0000:00:1d.2: PCI INT C =
disabled
Dec  2 17:39:41 sf kernel: [ 4038.791348] uhci_hcd 0000:00:1a.1: PCI INT B =
disabled
Dec  2 17:39:41 sf kernel: [ 4038.791403] uhci_hcd 0000:00:1a.0: PCI INT A =
disabled
Dec  2 17:39:41 sf kernel: [ 4038.791410] uhci_hcd 0000:00:1d.1: PCI INT B =
disabled
Dec  2 17:39:41 sf kernel: [ 4038.791442] ehci_hcd 0000:00:1a.7: PCI INT C =
disabled
Dec  2 17:39:41 sf kernel: [ 4038.811225] ehci_hcd 0000:00:1d.7: PCI INT A =
disabled
Dec  2 17:39:41 sf kernel: [ 4038.863174] snd_hda_intel 0000:00:1b.0: PCI I=
NT A disabled
Dec  2 17:39:41 sf kernel: [ 4038.878998] snd_hda_intel 0000:00:1b.0: power=
 state changed by ACPI to D3
Dec  2 17:39:41 sf kernel: [ 4039.000891] e1000e 0000:00:19.0: PCI INT A di=
sabled
Dec  2 17:39:41 sf kernel: [ 4039.000912] e1000e 0000:00:19.0: PME# enabled
Dec  2 17:39:41 sf kernel: [ 4039.000990] e1000e 0000:00:19.0: wake-up capa=
bility enabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.732140] ata_piix 0000:00:1f.1: PCI INT A =
disabled
Dec  2 17:39:41 sf kernel: [ 4039.732204] PM: suspend of devices complete a=
fter 1024.454 msecs
Dec  2 17:39:41 sf kernel: [ 4039.732549] ------------[ cut here ]---------=
---
Dec  2 17:39:41 sf kernel: [ 4039.732565] WARNING: at drivers/pci/pci-drive=
r.c:607 pci_has_legacy_pm_support.clone.4+0x39/0x60()
Dec  2 17:39:41 sf kernel: [ 4039.732571] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 17:39:41 sf kernel: [ 4039.732575] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 17:39:41 sf kernel: [ 4039.732656] Pid: 6180, comm: sh Tainted: G   =
     W    3.2.0-rc3-00099-g883381d #163
Dec  2 17:39:41 sf kernel: [ 4039.732661] Call Trace:
Dec  2 17:39:41 sf kernel: [ 4039.732674]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 17:39:41 sf kernel: [ 4039.732683]  [<ffffffff81046a75>] warn_slowpa=
th_null+0x15/0x20
Dec  2 17:39:41 sf kernel: [ 4039.732693]  [<ffffffff81273749>] pci_has_leg=
acy_pm_support.clone.4+0x39/0x60
Dec  2 17:39:41 sf kernel: [ 4039.732702]  [<ffffffff81273b43>] pci_pm_susp=
end_noirq+0x43/0x160
Dec  2 17:39:41 sf kernel: [ 4039.732717]  [<ffffffff812feca5>] pm_noirq_op=
+0x145/0x240
Dec  2 17:39:41 sf kernel: [ 4039.732725]  [<ffffffff812ff0e8>] dpm_suspend=
_noirq+0xe8/0x250
Dec  2 17:39:41 sf kernel: [ 4039.732735]  [<ffffffff810805d5>] suspend_dev=
ices_and_enter+0xa5/0x240
Dec  2 17:39:41 sf kernel: [ 4039.732743]  [<ffffffff810808ce>] enter_state=
+0x15e/0x190
Dec  2 17:39:41 sf kernel: [ 4039.732753]  [<ffffffff8107f6e6>] state_store=
+0xc6/0x140
Dec  2 17:39:41 sf kernel: [ 4039.732764]  [<ffffffff81251067>] kobj_attr_s=
tore+0x17/0x20
Dec  2 17:39:41 sf kernel: [ 4039.732773]  [<ffffffff81145cb4>] sysfs_write=
_file+0xf4/0x170
Dec  2 17:39:41 sf kernel: [ 4039.732783]  [<ffffffff810e4016>] vfs_write+0=
xc6/0x180
Dec  2 17:39:41 sf kernel: [ 4039.732791]  [<ffffffff810e432c>] sys_write+0=
x4c/0x90
Dec  2 17:39:41 sf kernel: [ 4039.732801]  [<ffffffff814362fb>] system_call=
_fastpath+0x16/0x1b
Dec  2 17:39:41 sf kernel: [ 4039.732808] ---[ end trace 7a713f1eaae7159d ]=
---
Dec  2 17:39:41 sf kernel: [ 4039.744377] ehci_hcd 0000:00:1d.7: PME# enabl=
ed
Dec  2 17:39:41 sf kernel: [ 4039.744401] ehci_hcd 0000:00:1d.7: wake-up ca=
pability enabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.755454] uhci_hcd 0000:00:1d.2: wake-up ca=
pability enabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.755630] uhci_hcd 0000:00:1d.1: wake-up ca=
pability enabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.755796] uhci_hcd 0000:00:1d.0: wake-up ca=
pability enabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.755871] ehci_hcd 0000:00:1a.7: PME# enabl=
ed
Dec  2 17:39:41 sf kernel: [ 4039.755891] ehci_hcd 0000:00:1a.7: wake-up ca=
pability enabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.766365] uhci_hcd 0000:00:1a.1: wake-up ca=
pability enabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.766535] uhci_hcd 0000:00:1a.0: wake-up ca=
pability enabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.766908] PM: late suspend of devices compl=
ete after 34.693 msecs
Dec  2 17:39:41 sf kernel: [ 4039.767466] ACPI: Preparing to enter system s=
leep state S3
Dec  2 17:39:41 sf kernel: [ 4039.767679] PM: Saving platform NVS memory
Dec  2 17:39:41 sf kernel: [ 4039.767924] Disabling non-boot CPUs ...
Dec  2 17:39:41 sf kernel: [ 4039.769750] CPU 1 is now offline
Dec  2 17:39:41 sf kernel: [ 4039.770729] Extended CMOS year: 2000
Dec  2 17:39:41 sf kernel: [ 4039.770729] ACPI: Low-level resume complete
Dec  2 17:39:41 sf kernel: [ 4039.770729] PM: Restoring platform NVS memory
Dec  2 17:39:41 sf kernel: [ 4039.770729] CPU0: Thermal monitoring handled =
by SMI
Dec  2 17:39:41 sf kernel: [ 4039.770729] Extended CMOS year: 2000
Dec  2 17:39:41 sf kernel: [ 4039.770729] Enabling non-boot CPUs ...
Dec  2 17:39:41 sf kernel: [ 4039.773147] Booting Node 0 Processor 1 APIC 0=
x1
Dec  2 17:39:41 sf kernel: [ 4039.773153] smpboot cpu 1: start_ip =3D 9a000
Dec  2 17:39:41 sf kernel: [ 4039.769568] Calibrating delay loop (skipped) =
already calibrated this CPU
Dec  2 17:39:41 sf kernel: [ 4039.769568] CPU1: Thermal monitoring handled =
by SMI
Dec  2 17:39:41 sf kernel: [ 4039.784665] NMI watchdog enabled, takes one h=
w-pmu counter.
Dec  2 17:39:41 sf kernel: [ 4039.787176] CPU1 is up
Dec  2 17:39:41 sf kernel: [ 4039.788296] ACPI: Waking up from system sleep=
 state S3
Dec  2 17:39:41 sf kernel: [ 4039.845125] i915 0000:00:02.0: restoring conf=
ig space at offset 0x8 (was 0x1, writing 0x2001)
Dec  2 17:39:41 sf kernel: [ 4039.845146] i915 0000:00:02.0: restoring conf=
ig space at offset 0x1 (was 0x900403, writing 0x900407)
Dec  2 17:39:41 sf kernel: [ 4039.845207] pci 0000:00:02.1: restoring confi=
g space at offset 0x4 (was 0x4, writing 0xe0500004)
Dec  2 17:39:41 sf kernel: [ 4039.845220] pci 0000:00:02.1: restoring confi=
g space at offset 0x1 (was 0x900000, writing 0x900007)
Dec  2 17:39:41 sf kernel: [ 4039.845250] pci 0000:00:03.0: restoring confi=
g space at offset 0xf (was 0x100, writing 0x1ff)
Dec  2 17:39:41 sf kernel: [ 4039.845276] pci 0000:00:03.0: restoring confi=
g space at offset 0x4 (was 0xfed12004, writing 0xe0600004)
Dec  2 17:39:41 sf kernel: [ 4039.845314] pci 0000:00:03.2: restoring confi=
g space at offset 0xf (was 0x300, writing 0x30b)
Dec  2 17:39:41 sf kernel: [ 4039.845334] pci 0000:00:03.2: restoring confi=
g space at offset 0x8 (was 0x1, writing 0x2031)
Dec  2 17:39:41 sf kernel: [ 4039.845343] pci 0000:00:03.2: restoring confi=
g space at offset 0x7 (was 0x1, writing 0x2021)
Dec  2 17:39:41 sf kernel: [ 4039.845353] pci 0000:00:03.2: restoring confi=
g space at offset 0x6 (was 0x1, writing 0x2019)
Dec  2 17:39:41 sf kernel: [ 4039.845363] pci 0000:00:03.2: restoring confi=
g space at offset 0x5 (was 0x1, writing 0x2011)
Dec  2 17:39:41 sf kernel: [ 4039.845373] pci 0000:00:03.2: restoring confi=
g space at offset 0x4 (was 0x1, writing 0x2009)
Dec  2 17:39:41 sf kernel: [ 4039.845386] pci 0000:00:03.2: restoring confi=
g space at offset 0x1 (was 0xb00000, writing 0xb00005)
Dec  2 17:39:41 sf kernel: [ 4039.845419] pci 0000:00:03.3: restoring confi=
g space at offset 0xf (was 0x200, writing 0x20a)
Dec  2 17:39:41 sf kernel: [ 4039.845443] pci 0000:00:03.3: restoring confi=
g space at offset 0x5 (was 0x0, writing 0xe0601000)
Dec  2 17:39:41 sf kernel: [ 4039.845453] pci 0000:00:03.3: restoring confi=
g space at offset 0x4 (was 0x1, writing 0x2041)
Dec  2 17:39:41 sf kernel: [ 4039.845466] pci 0000:00:03.3: restoring confi=
g space at offset 0x1 (was 0xb00000, writing 0xb00007)
Dec  2 17:39:41 sf kernel: [ 4039.845506] e1000e 0000:00:19.0: restoring co=
nfig space at offset 0xf (was 0x100, writing 0x10b)
Dec  2 17:39:41 sf kernel: [ 4039.845537] e1000e 0000:00:19.0: restoring co=
nfig space at offset 0x6 (was 0x1, writing 0x2061)
Dec  2 17:39:41 sf kernel: [ 4039.845548] e1000e 0000:00:19.0: restoring co=
nfig space at offset 0x5 (was 0x0, writing 0xe0640000)
Dec  2 17:39:41 sf kernel: [ 4039.845567] e1000e 0000:00:19.0: restoring co=
nfig space at offset 0x1 (was 0x100000, writing 0x100007)
Dec  2 17:39:41 sf kernel: [ 4039.845602] uhci_hcd 0000:00:1a.0: restoring =
config space at offset 0xf (was 0x100, writing 0x10a)
Dec  2 17:39:41 sf kernel: [ 4039.845628] uhci_hcd 0000:00:1a.0: restoring =
config space at offset 0x8 (was 0x1, writing 0x2081)
Dec  2 17:39:41 sf kernel: [ 4039.845657] uhci_hcd 0000:00:1a.0: restoring =
config space at offset 0x1 (was 0x2800000, writing 0x2800001)
Dec  2 17:39:41 sf kernel: [ 4039.845740] uhci_hcd 0000:00:1a.0: wake-up ca=
pability disabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.845758] uhci_hcd 0000:00:1a.1: restoring =
config space at offset 0xf (was 0x200, writing 0x20a)
Dec  2 17:39:41 sf kernel: [ 4039.845784] uhci_hcd 0000:00:1a.1: restoring =
config space at offset 0x8 (was 0x1, writing 0x20a1)
Dec  2 17:39:41 sf kernel: [ 4039.845809] uhci_hcd 0000:00:1a.1: restoring =
config space at offset 0x1 (was 0x2800000, writing 0x2800001)
Dec  2 17:39:41 sf kernel: [ 4039.845881] uhci_hcd 0000:00:1a.1: wake-up ca=
pability disabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.845910] ehci_hcd 0000:00:1a.7: restoring =
config space at offset 0xf (was 0x300, writing 0x30b)
Dec  2 17:39:41 sf kernel: [ 4039.845945] ehci_hcd 0000:00:1a.7: restoring =
config space at offset 0x4 (was 0x0, writing 0xe0641000)
Dec  2 17:39:41 sf kernel: [ 4039.845962] ehci_hcd 0000:00:1a.7: restoring =
config space at offset 0x1 (was 0x2900000, writing 0x2900002)
Dec  2 17:39:41 sf kernel: [ 4039.845996] ehci_hcd 0000:00:1a.7: wake-up ca=
pability disabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.846028] ehci_hcd 0000:00:1a.7: PME# disab=
led
Dec  2 17:39:41 sf kernel: [ 4039.846069] snd_hda_intel 0000:00:1b.0: resto=
ring config space at offset 0xf (was 0x100, writing 0x10a)
Dec  2 17:39:41 sf kernel: [ 4039.846106] snd_hda_intel 0000:00:1b.0: resto=
ring config space at offset 0x3 (was 0x0, writing 0x10)
Dec  2 17:39:41 sf kernel: [ 4039.846120] snd_hda_intel 0000:00:1b.0: resto=
ring config space at offset 0x1 (was 0x100000, writing 0x100002)
Dec  2 17:39:41 sf kernel: [ 4039.846177] pcieport 0000:00:1c.0: restoring =
config space at offset 0xf (was 0x100, writing 0x4010a)
Dec  2 17:39:41 sf kernel: [ 4039.846200] pcieport 0000:00:1c.0: restoring =
config space at offset 0x9 (was 0x10001, writing 0x1fff1)
Dec  2 17:39:41 sf kernel: [ 4039.846212] pcieport 0000:00:1c.0: restoring =
config space at offset 0x8 (was 0x0, writing 0xfff0)
Dec  2 17:39:41 sf kernel: [ 4039.846223] pcieport 0000:00:1c.0: restoring =
config space at offset 0x7 (was 0x0, writing 0x200000f0)
Dec  2 17:39:41 sf kernel: [ 4039.846235] pcieport 0000:00:1c.0: restoring =
config space at offset 0x6 (was 0x0, writing 0x80800)
Dec  2 17:39:41 sf kernel: [ 4039.846252] pcieport 0000:00:1c.0: restoring =
config space at offset 0x3 (was 0x810000, writing 0x810010)
Dec  2 17:39:41 sf kernel: [ 4039.846266] pcieport 0000:00:1c.0: restoring =
config space at offset 0x1 (was 0x100000, writing 0x100407)
Dec  2 17:39:41 sf kernel: [ 4039.846353] pcieport 0000:00:1c.1: restoring =
config space at offset 0xf (was 0x200, writing 0x4020a)
Dec  2 17:39:41 sf kernel: [ 4039.846377] pcieport 0000:00:1c.1: restoring =
config space at offset 0x9 (was 0x10001, writing 0x1fff1)
Dec  2 17:39:41 sf kernel: [ 4039.846388] pcieport 0000:00:1c.1: restoring =
config space at offset 0x8 (was 0x0, writing 0xe000e000)
Dec  2 17:39:41 sf kernel: [ 4039.846400] pcieport 0000:00:1c.1: restoring =
config space at offset 0x7 (was 0x0, writing 0xf0)
Dec  2 17:39:41 sf kernel: [ 4039.846418] pcieport 0000:00:1c.1: restoring =
config space at offset 0x3 (was 0x810000, writing 0x810010)
Dec  2 17:39:41 sf kernel: [ 4039.846433] pcieport 0000:00:1c.1: restoring =
config space at offset 0x1 (was 0x100000, writing 0x100407)
Dec  2 17:39:41 sf kernel: [ 4039.846502] uhci_hcd 0000:00:1d.0: restoring =
config space at offset 0xf (was 0x100, writing 0x10a)
Dec  2 17:39:41 sf kernel: [ 4039.846527] uhci_hcd 0000:00:1d.0: restoring =
config space at offset 0x8 (was 0x1, writing 0x20c1)
Dec  2 17:39:41 sf kernel: [ 4039.846553] uhci_hcd 0000:00:1d.0: restoring =
config space at offset 0x1 (was 0x2800000, writing 0x2800001)
Dec  2 17:39:41 sf kernel: [ 4039.846625] uhci_hcd 0000:00:1d.0: wake-up ca=
pability disabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.846641] uhci_hcd 0000:00:1d.1: restoring =
config space at offset 0xf (was 0x200, writing 0x20b)
Dec  2 17:39:41 sf kernel: [ 4039.846667] uhci_hcd 0000:00:1d.1: restoring =
config space at offset 0x8 (was 0x1, writing 0x20e1)
Dec  2 17:39:41 sf kernel: [ 4039.846692] uhci_hcd 0000:00:1d.1: restoring =
config space at offset 0x1 (was 0x2800000, writing 0x2800001)
Dec  2 17:39:41 sf kernel: [ 4039.846761] uhci_hcd 0000:00:1d.1: wake-up ca=
pability disabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.846777] uhci_hcd 0000:00:1d.2: restoring =
config space at offset 0xf (was 0x300, writing 0x30b)
Dec  2 17:39:41 sf kernel: [ 4039.846802] uhci_hcd 0000:00:1d.2: restoring =
config space at offset 0x8 (was 0x1, writing 0x2101)
Dec  2 17:39:41 sf kernel: [ 4039.846828] uhci_hcd 0000:00:1d.2: restoring =
config space at offset 0x1 (was 0x2800000, writing 0x2800001)
Dec  2 17:39:41 sf kernel: [ 4039.846896] uhci_hcd 0000:00:1d.2: wake-up ca=
pability disabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.846925] ehci_hcd 0000:00:1d.7: restoring =
config space at offset 0xf (was 0x100, writing 0x10a)
Dec  2 17:39:41 sf kernel: [ 4039.846960] ehci_hcd 0000:00:1d.7: restoring =
config space at offset 0x4 (was 0x0, writing 0xe0648000)
Dec  2 17:39:41 sf kernel: [ 4039.846977] ehci_hcd 0000:00:1d.7: restoring =
config space at offset 0x1 (was 0x2900000, writing 0x2900002)
Dec  2 17:39:41 sf kernel: [ 4039.847028] ehci_hcd 0000:00:1d.7: wake-up ca=
pability disabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.847040] ehci_hcd 0000:00:1d.7: PME# disab=
led
Dec  2 17:39:41 sf kernel: [ 4039.847086] pci 0000:00:1e.0: restoring confi=
g space at offset 0x9 (was 0x10001, writing 0x83f18001)
Dec  2 17:39:41 sf kernel: [ 4039.847098] pci 0000:00:1e.0: restoring confi=
g space at offset 0x8 (was 0x0, writing 0xe030e010)
Dec  2 17:39:41 sf kernel: [ 4039.847109] pci 0000:00:1e.0: restoring confi=
g space at offset 0x7 (was 0x228000f0, writing 0x22803030)
Dec  2 17:39:41 sf kernel: [ 4039.847132] pci 0000:00:1e.0: restoring confi=
g space at offset 0x1 (was 0x100007, writing 0x100107)
Dec  2 17:39:41 sf kernel: [ 4039.847232] ata_piix 0000:00:1f.1: restoring =
config space at offset 0xf (was 0x100, writing 0x10a)
Dec  2 17:39:41 sf kernel: [ 4039.847258] ata_piix 0000:00:1f.1: restoring =
config space at offset 0x8 (was 0xc01, writing 0x2121)
Dec  2 17:39:41 sf kernel: [ 4039.847399] iwl4965 0000:10:00.0: restoring c=
onfig space at offset 0xf (was 0x100, writing 0x10a)
Dec  2 17:39:41 sf kernel: [ 4039.847450] iwl4965 0000:10:00.0: restoring c=
onfig space at offset 0x4 (was 0x4, writing 0xe0000004)
Dec  2 17:39:41 sf kernel: [ 4039.847465] iwl4965 0000:10:00.0: restoring c=
onfig space at offset 0x3 (was 0x0, writing 0x10)
Dec  2 17:39:41 sf kernel: [ 4039.847483] iwl4965 0000:10:00.0: restoring c=
onfig space at offset 0x1 (was 0x100000, writing 0x100006)
Dec  2 17:39:41 sf kernel: [ 4039.847589] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0xf (was 0x3000100, writing 0x580010b)
Dec  2 17:39:41 sf kernel: [ 4039.847602] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0xe (was 0x0, writing 0x30fc)
Dec  2 17:39:41 sf kernel: [ 4039.847615] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0xd (was 0x0, writing 0x3000)
Dec  2 17:39:41 sf kernel: [ 4039.847627] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0xc (was 0x0, writing 0x34fc)
Dec  2 17:39:41 sf kernel: [ 4039.847639] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0xb (was 0x0, writing 0x3400)
Dec  2 17:39:41 sf kernel: [ 4039.847652] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0xa (was 0x0, writing 0x87fff000)
Dec  2 17:39:41 sf kernel: [ 4039.847665] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0x9 (was 0x0, writing 0x84000000)
Dec  2 17:39:41 sf kernel: [ 4039.847677] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0x8 (was 0x0, writing 0x83fff000)
Dec  2 17:39:41 sf kernel: [ 4039.847690] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0x7 (was 0x0, writing 0x80000000)
Dec  2 17:39:41 sf kernel: [ 4039.847703] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0x6 (was 0x0, writing 0xb0060302)
Dec  2 17:39:41 sf kernel: [ 4039.847718] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0x4 (was 0x0, writing 0xe0100000)
Dec  2 17:39:41 sf kernel: [ 4039.847730] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0x3 (was 0x820000, writing 0x82a800)
Dec  2 17:39:41 sf kernel: [ 4039.847746] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
Dec  2 17:39:41 sf kernel: [ 4039.847826] pci 0000:02:06.1: restoring confi=
g space at offset 0xf (was 0x4020200, writing 0x4020205)
Dec  2 17:39:41 sf kernel: [ 4039.847866] pci 0000:02:06.1: restoring confi=
g space at offset 0x4 (was 0x0, writing 0xe0101000)
Dec  2 17:39:41 sf kernel: [ 4039.847879] pci 0000:02:06.1: restoring confi=
g space at offset 0x3 (was 0x800000, writing 0x804010)
Dec  2 17:39:41 sf kernel: [ 4039.847894] pci 0000:02:06.1: restoring confi=
g space at offset 0x1 (was 0x2100000, writing 0x2100006)
Dec  2 17:39:41 sf kernel: [ 4039.847937] sdhci-pci 0000:02:06.2: restoring=
 config space at offset 0xf (was 0x300, writing 0x30a)
Dec  2 17:39:41 sf kernel: [ 4039.847977] sdhci-pci 0000:02:06.2: restoring=
 config space at offset 0x4 (was 0x0, writing 0xe0102000)
Dec  2 17:39:41 sf kernel: [ 4039.847990] sdhci-pci 0000:02:06.2: restoring=
 config space at offset 0x3 (was 0x800000, writing 0x804010)
Dec  2 17:39:41 sf kernel: [ 4039.848021] sdhci-pci 0000:02:06.2: restoring=
 config space at offset 0x1 (was 0x2100000, writing 0x2100006)
Dec  2 17:39:41 sf kernel: [ 4039.848045] ------------[ cut here ]---------=
---
Dec  2 17:39:41 sf kernel: [ 4039.848060] WARNING: at drivers/pci/pci-drive=
r.c:607 pci_has_legacy_pm_support.clone.4+0x39/0x60()
Dec  2 17:39:41 sf kernel: [ 4039.848066] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 17:39:41 sf kernel: [ 4039.848070] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 17:39:41 sf kernel: [ 4039.848144] Pid: 6180, comm: sh Tainted: G   =
     W    3.2.0-rc3-00099-g883381d #163
Dec  2 17:39:41 sf kernel: [ 4039.848150] Call Trace:
Dec  2 17:39:41 sf kernel: [ 4039.848163]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 17:39:41 sf kernel: [ 4039.848173]  [<ffffffff81046a75>] warn_slowpa=
th_null+0x15/0x20
Dec  2 17:39:41 sf kernel: [ 4039.848182]  [<ffffffff81273749>] pci_has_leg=
acy_pm_support.clone.4+0x39/0x60
Dec  2 17:39:41 sf kernel: [ 4039.848191]  [<ffffffff812739c6>] pci_pm_resu=
me_noirq+0x36/0xa0
Dec  2 17:39:41 sf kernel: [ 4039.848201]  [<ffffffff812fec4e>] pm_noirq_op=
+0xee/0x240
Dec  2 17:39:41 sf kernel: [ 4039.848210]  [<ffffffff812fee5b>] dpm_resume_=
noirq+0x4b/0x1f0
Dec  2 17:39:41 sf kernel: [ 4039.848219]  [<ffffffff81080616>] suspend_dev=
ices_and_enter+0xe6/0x240
Dec  2 17:39:41 sf kernel: [ 4039.848227]  [<ffffffff810808ce>] enter_state=
+0x15e/0x190
Dec  2 17:39:41 sf kernel: [ 4039.848237]  [<ffffffff8107f6e6>] state_store=
+0xc6/0x140
Dec  2 17:39:41 sf kernel: [ 4039.848247]  [<ffffffff81251067>] kobj_attr_s=
tore+0x17/0x20
Dec  2 17:39:41 sf kernel: [ 4039.848256]  [<ffffffff81145cb4>] sysfs_write=
_file+0xf4/0x170
Dec  2 17:39:41 sf kernel: [ 4039.848266]  [<ffffffff810e4016>] vfs_write+0=
xc6/0x180
Dec  2 17:39:41 sf kernel: [ 4039.848274]  [<ffffffff810e432c>] sys_write+0=
x4c/0x90
Dec  2 17:39:41 sf kernel: [ 4039.848284]  [<ffffffff814362fb>] system_call=
_fastpath+0x16/0x1b
Dec  2 17:39:41 sf kernel: [ 4039.848290] ---[ end trace 7a713f1eaae7159e ]=
---
Dec  2 17:39:41 sf kernel: [ 4039.848670] PM: early resume of devices compl=
ete after 3.715 msecs
Dec  2 17:39:41 sf kernel: [ 4039.848797] i915 0000:00:02.0: setting latenc=
y timer to 64
Dec  2 17:39:41 sf kernel: [ 4039.850143] e1000e 0000:00:19.0: wake-up capa=
bility disabled by ACPI
Dec  2 17:39:41 sf kernel: [ 4039.850157] e1000e 0000:00:19.0: PME# disabled
Dec  2 17:39:41 sf kernel: [ 4039.850297] e1000e 0000:00:19.0: irq 44 for M=
SI/MSI-X
Dec  2 17:39:41 sf kernel: [ 4039.862645] uhci_hcd 0000:00:1a.0: PCI INT A =
-> GSI 16 (level, low) -> IRQ 16
Dec  2 17:39:41 sf kernel: [ 4039.862652] uhci_hcd 0000:00:1a.1: PCI INT B =
-> GSI 17 (level, low) -> IRQ 17
Dec  2 17:39:41 sf kernel: [ 4039.862656] uhci_hcd 0000:00:1a.0: setting la=
tency timer to 64
Dec  2 17:39:41 sf kernel: [ 4039.862665] uhci_hcd 0000:00:1a.1: setting la=
tency timer to 64
Dec  2 17:39:41 sf kernel: [ 4039.862697] usb usb3: root hub lost power or =
was reset
Dec  2 17:39:41 sf kernel: [ 4039.862710] usb usb4: root hub lost power or =
was reset
Dec  2 17:39:41 sf kernel: [ 4039.862723] ehci_hcd 0000:00:1a.7: PCI INT C =
-> GSI 18 (level, low) -> IRQ 18
Dec  2 17:39:41 sf kernel: [ 4039.862733] ehci_hcd 0000:00:1a.7: setting la=
tency timer to 64
Dec  2 17:39:41 sf kernel: [ 4039.862809] uhci_hcd 0000:00:1d.0: PCI INT A =
-> GSI 20 (level, low) -> IRQ 20
Dec  2 17:39:41 sf kernel: [ 4039.862819] uhci_hcd 0000:00:1d.0: setting la=
tency timer to 64
Dec  2 17:39:41 sf kernel: [ 4039.862853] usb usb5: root hub lost power or =
was reset
Dec  2 17:39:41 sf kernel: [ 4039.862872] uhci_hcd 0000:00:1d.1: PCI INT B =
-> GSI 22 (level, low) -> IRQ 22
Dec  2 17:39:41 sf kernel: [ 4039.862882] uhci_hcd 0000:00:1d.1: setting la=
tency timer to 64
Dec  2 17:39:41 sf kernel: [ 4039.862914] usb usb6: root hub lost power or =
was reset
Dec  2 17:39:41 sf kernel: [ 4039.862931] uhci_hcd 0000:00:1d.2: PCI INT C =
-> GSI 18 (level, low) -> IRQ 18
Dec  2 17:39:41 sf kernel: [ 4039.862941] uhci_hcd 0000:00:1d.2: setting la=
tency timer to 64
Dec  2 17:39:41 sf kernel: [ 4039.862976] ehci_hcd 0000:00:1d.7: PCI INT A =
-> GSI 20 (level, low) -> IRQ 20
Dec  2 17:39:41 sf kernel: [ 4039.862979] usb usb7: root hub lost power or =
was reset
Dec  2 17:39:41 sf kernel: [ 4039.862987] ehci_hcd 0000:00:1d.7: setting la=
tency timer to 64
Dec  2 17:39:41 sf kernel: [ 4039.863000] pci 0000:00:1e.0: setting latency=
 timer to 64
Dec  2 17:39:41 sf kernel: [ 4039.863033] ata_piix 0000:00:1f.1: PCI INT A =
-> GSI 16 (level, low) -> IRQ 16
Dec  2 17:39:41 sf kernel: [ 4039.863043] ata_piix 0000:00:1f.1: setting la=
tency timer to 64
Dec  2 17:39:41 sf kernel: [ 4039.863067] ------------[ cut here ]---------=
---
Dec  2 17:39:41 sf kernel: [ 4039.863074] WARNING: at drivers/pci/pci-drive=
r.c:607 pci_has_legacy_pm_support.clone.4+0x39/0x60()
Dec  2 17:39:41 sf kernel: [ 4039.863079] iwl4965 0000:10:00.0: RF_KILL bit=
 toggled to disable radio.
Dec  2 17:39:41 sf kernel: [ 4039.863082] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 17:39:41 sf kernel: [ 4039.863085] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 17:39:41 sf kernel: [ 4039.863129] Pid: 6192, comm: kworker/u:8 Tain=
ted: G        W    3.2.0-rc3-00099-g883381d #163
Dec  2 17:39:41 sf kernel: [ 4039.863132] Call Trace:
Dec  2 17:39:41 sf kernel: [ 4039.863139]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 17:39:41 sf kernel: [ 4039.863145]  [<ffffffff81046a75>] warn_slowpa=
th_null+0x15/0x20
Dec  2 17:39:41 sf kernel: [ 4039.863151]  [<ffffffff81273749>] pci_has_leg=
acy_pm_support.clone.4+0x39/0x60
Dec  2 17:39:41 sf kernel: [ 4039.863158]  [<ffffffff8103eb01>] ? thread_gr=
oup_times+0x71/0xb0
Dec  2 17:39:41 sf kernel: [ 4039.863163]  [<ffffffff81273df4>] pci_pm_resu=
me+0x44/0xb0
Dec  2 17:39:41 sf kernel: [ 4039.863169]  [<ffffffff812ff423>] pm_op+0x113=
/0x220
Dec  2 17:39:41 sf kernel: [ 4039.863175]  [<ffffffff812ff96f>] device_resu=
me+0x9f/0x140
Dec  2 17:39:41 sf kernel: [ 4039.863181]  [<ffffffff8106a210>] ? async_sch=
edule+0x20/0x20
Dec  2 17:39:41 sf kernel: [ 4039.863187]  [<ffffffff812ffa2c>] async_resum=
e+0x1c/0x50
Dec  2 17:39:41 sf kernel: [ 4039.863192]  [<ffffffff8106a28f>] async_run_e=
ntry_fn+0x7f/0x180
Dec  2 17:39:41 sf kernel: [ 4039.863200]  [<ffffffff8105c422>] process_one=
_work+0x112/0x390
Dec  2 17:39:41 sf kernel: [ 4039.863206]  [<ffffffff8105e711>] worker_thre=
ad+0x161/0x340
Dec  2 17:39:41 sf kernel: [ 4039.863211]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 17:39:41 sf kernel: [ 4039.863216]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 17:39:41 sf kernel: [ 4039.863223]  [<ffffffff810632a6>] kthread+0x9=
6/0xa0
Dec  2 17:39:41 sf kernel: [ 4039.863229]  [<ffffffff814373d4>] kernel_thre=
ad_helper+0x4/0x10
Dec  2 17:39:41 sf kernel: [ 4039.863235]  [<ffffffff81063210>] ? kthread_w=
orker_fn+0x190/0x190
Dec  2 17:39:41 sf kernel: [ 4039.863241]  [<ffffffff814373d0>] ? gs_change=
+0xb/0xb
Dec  2 17:39:41 sf kernel: [ 4039.863245] ---[ end trace 7a713f1eaae7159f ]=
---
Dec  2 17:39:41 sf kernel: [ 4039.863257] sdhci-pci 0000:02:06.2: PCI INT C=
 -> GSI 20 (level, low) -> IRQ 20
Dec  2 17:39:41 sf kernel: [ 4039.863262] sdhci-pci 0000:02:06.2: Will use =
DMA mode even though HW doesn't fully claim to support it.
Dec  2 17:39:41 sf kernel: [ 4039.863513] sd 0:0:0:0: [sda] Starting disk
Dec  2 17:39:41 sf kernel: [ 4039.863759] ata2: port disabled--ignoring
Dec  2 17:39:41 sf kernel: [ 4039.866701] ACPI Exception: AE_AML_PACKAGE_LI=
MIT, Index (0x0000000000000005) is beyond end of object (20110623/exoparg2-=
418)
Dec  2 17:39:41 sf kernel: [ 4039.866713] ACPI Error: Method parse/executio=
n failed [\_SB_.C2C3] (Node ffff88007b83e118), AE_AML_PACKAGE_LIMIT (201106=
23/psparse-536)
Dec  2 17:39:41 sf kernel: [ 4039.866730] ACPI Error: Method parse/executio=
n failed [\_SB_.C003.C0F6.C3F3._STM] (Node ffff88007b88bc58), AE_AML_PACKAG=
E_LIMIT (20110623/psparse-536)
Dec  2 17:39:41 sf kernel: [ 4039.866751] ata1: ACPI set timing mode failed=
 (status=3D0x300b)
Dec  2 17:39:41 sf kernel: [ 4039.869780] snd_hda_intel 0000:00:1b.0: power=
 state changed by ACPI to D0
Dec  2 17:39:41 sf kernel: [ 4039.869790] snd_hda_intel 0000:00:1b.0: power=
 state changed by ACPI to D0
Dec  2 17:39:41 sf kernel: [ 4039.869801] snd_hda_intel 0000:00:1b.0: power=
 state changed by ACPI to D0
Dec  2 17:39:41 sf kernel: [ 4039.869808] snd_hda_intel 0000:00:1b.0: power=
 state changed by ACPI to D0
Dec  2 17:39:41 sf kernel: [ 4039.869819] snd_hda_intel 0000:00:1b.0: PCI I=
NT A -> GSI 17 (level, low) -> IRQ 17
Dec  2 17:39:41 sf kernel: [ 4039.869829] snd_hda_intel 0000:00:1b.0: setti=
ng latency timer to 64
Dec  2 17:39:41 sf kernel: [ 4039.869895] snd_hda_intel 0000:00:1b.0: irq 4=
5 for MSI/MSI-X
Dec  2 17:39:41 sf kernel: [ 4040.178399] usb 5-2: reset full-speed USB dev=
ice number 2 using uhci_hcd
Dec  2 17:39:41 sf kernel: [ 4043.760766] ata1.00: ACPI cmd ef/03:01:00:00:=
00:a0 (SET FEATURES) filtered out
Dec  2 17:39:41 sf kernel: [ 4043.760777] ata1.00: ACPI cmd ef/03:45:00:00:=
00:a0 (SET FEATURES) filtered out
Dec  2 17:39:41 sf kernel: [ 4043.760786] ata1.00: ACPI cmd f5/00:00:00:00:=
00:a0 (SECURITY FREEZE LOCK) filtered out
Dec  2 17:39:41 sf kernel: [ 4043.760796] ata1.00: ACPI cmd b1/c1:00:00:00:=
00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
Dec  2 17:39:41 sf kernel: [ 4043.760975] ata1.00: ACPI cmd c6/00:10:00:00:=
00:a0 (SET MULTIPLE MODE) succeeded
Dec  2 17:39:41 sf kernel: [ 4043.800641] ata1.00: configured for UDMA/100
Dec  2 17:39:41 sf kernel: [ 4043.937209] PM: resume of devices complete af=
ter 4088.471 msecs
Dec  2 17:39:41 sf kernel: [ 4043.937622] PM: Finishing wakeup.
Dec  2 17:39:41 sf kernel: [ 4043.937626] Restarting tasks ... done.
Dec  2 17:39:41 sf kernel: [ 4043.948038] video LNXVIDEO:00: Restoring back=
light state
Dec  2 18:49:33 sf kernel: [ 8234.760231] PM: Syncing filesystems ... done.
Dec  2 18:49:33 sf kernel: [ 8236.552748] PM: Preparing system for mem sleep
Dec  2 19:18:07 sf kernel: [ 8236.857917] Freezing user space processes ...=
 (elapsed 0.01 seconds) done.
Dec  2 19:18:07 sf kernel: [ 8236.869076] Freezing remaining freezable task=
s ... (elapsed 0.01 seconds) done.
Dec  2 19:18:07 sf kernel: [ 8236.880148] PM: Entering mem sleep
Dec  2 19:18:07 sf kernel: [ 8236.880188] Suspending console(s) (use no_con=
sole_suspend to debug)
Dec  2 19:18:07 sf kernel: [ 8236.881131] sd 0:0:0:0: [sda] Synchronizing S=
CSI cache
Dec  2 19:18:07 sf kernel: [ 8236.926658] sd 0:0:0:0: [sda] Stopping disk
Dec  2 19:18:07 sf kernel: [ 8236.935876] ------------[ cut here ]---------=
---
Dec  2 19:18:07 sf kernel: [ 8236.935895] WARNING: at drivers/pci/pci-drive=
r.c:607 pci_has_legacy_pm_support.clone.4+0x39/0x60()
Dec  2 19:18:07 sf kernel: [ 8236.935901] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 19:18:07 sf kernel: [ 8236.935905] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 19:18:07 sf kernel: [ 8236.935988] Pid: 10466, comm: kworker/u:8 Tai=
nted: G        W    3.2.0-rc3-00099-g883381d #163
Dec  2 19:18:07 sf kernel: [ 8236.935994] Call Trace:
Dec  2 19:18:07 sf kernel: [ 8236.936031]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 19:18:07 sf kernel: [ 8236.936042]  [<ffffffff81046a75>] warn_slowpa=
th_null+0x15/0x20
Dec  2 19:18:07 sf kernel: [ 8236.936051]  [<ffffffff81273749>] pci_has_leg=
acy_pm_support.clone.4+0x39/0x60
Dec  2 19:18:07 sf kernel: [ 8236.936061]  [<ffffffff8127400f>] pci_pm_susp=
end+0x3f/0x120
Dec  2 19:18:07 sf kernel: [ 8236.936076]  [<ffffffff8103eb51>] ? get_paren=
t_ip+0x11/0x50
Dec  2 19:18:07 sf kernel: [ 8236.936087]  [<ffffffff812ff4c9>] pm_op+0x1b9=
/0x220
Dec  2 19:18:07 sf kernel: [ 8236.936097]  [<ffffffff812ff67c>] __device_su=
spend+0xbc/0x200
Dec  2 19:18:07 sf kernel: [ 8236.936107]  [<ffffffff8106a210>] ? async_sch=
edule+0x20/0x20
Dec  2 19:18:07 sf kernel: [ 8236.936115]  [<ffffffff812ff7da>] async_suspe=
nd+0x1a/0x90
Dec  2 19:18:07 sf kernel: [ 8236.936123]  [<ffffffff8106a28f>] async_run_e=
ntry_fn+0x7f/0x180
Dec  2 19:18:07 sf kernel: [ 8236.936133]  [<ffffffff8105c422>] process_one=
_work+0x112/0x390
Dec  2 19:18:07 sf kernel: [ 8236.936143]  [<ffffffff8105e711>] worker_thre=
ad+0x161/0x340
Dec  2 19:18:07 sf kernel: [ 8236.936150]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 19:18:07 sf kernel: [ 8236.936159]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 19:18:07 sf kernel: [ 8236.936168]  [<ffffffff810632a6>] kthread+0x9=
6/0xa0
Dec  2 19:18:07 sf kernel: [ 8236.936179]  [<ffffffff814373d4>] kernel_thre=
ad_helper+0x4/0x10
Dec  2 19:18:07 sf kernel: [ 8236.936188]  [<ffffffff81063210>] ? kthread_w=
orker_fn+0x190/0x190
Dec  2 19:18:07 sf kernel: [ 8236.936197]  [<ffffffff814373d0>] ? gs_change=
+0xb/0xb
Dec  2 19:18:07 sf kernel: [ 8236.936217] ---[ end trace 7a713f1eaae715a0 ]=
---
Dec  2 19:18:07 sf kernel: [ 8236.937885] uhci_hcd 0000:00:1d.0: PCI INT A =
disabled
Dec  2 19:18:07 sf kernel: [ 8236.938065] snd_hda_intel 0000:00:1b.0: PCI I=
NT A disabled
Dec  2 19:18:07 sf kernel: [ 8236.939120] ACPI handle has no context!
Dec  2 19:18:07 sf kernel: [ 8236.939135] sdhci-pci 0000:02:06.2: PCI INT C=
 disabled
Dec  2 19:18:07 sf kernel: [ 8236.939148] ACPI handle has no context!
Dec  2 19:18:07 sf kernel: [ 8236.955962] snd_hda_intel 0000:00:1b.0: power=
 state changed by ACPI to D3
Dec  2 19:18:07 sf kernel: [ 8236.966086] ehci_hcd 0000:00:1a.7: PCI INT C =
disabled
Dec  2 19:18:07 sf kernel: [ 8236.967214] uhci_hcd 0000:00:1d.1: PCI INT B =
disabled
Dec  2 19:18:07 sf kernel: [ 8236.967224] uhci_hcd 0000:00:1a.0: PCI INT A =
disabled
Dec  2 19:18:07 sf kernel: [ 8236.967319] uhci_hcd 0000:00:1a.1: PCI INT B =
disabled
Dec  2 19:18:07 sf kernel: [ 8236.967347] uhci_hcd 0000:00:1d.2: PCI INT C =
disabled
Dec  2 19:18:07 sf kernel: [ 8236.987147] ehci_hcd 0000:00:1d.7: PCI INT A =
disabled
Dec  2 19:18:07 sf kernel: [ 8237.176083] e1000e 0000:00:19.0: PME# enabled
Dec  2 19:18:07 sf kernel: [ 8237.176139] e1000e 0000:00:19.0: wake-up capa=
bility enabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8237.935927] ata_piix 0000:00:1f.1: PCI INT A =
disabled
Dec  2 19:18:07 sf kernel: [ 8237.936029] PM: suspend of devices complete a=
fter 1055.304 msecs
Dec  2 19:18:07 sf kernel: [ 8237.936378] ------------[ cut here ]---------=
---
Dec  2 19:18:07 sf kernel: [ 8237.936394] WARNING: at drivers/pci/pci-drive=
r.c:607 pci_has_legacy_pm_support.clone.4+0x39/0x60()
Dec  2 19:18:07 sf kernel: [ 8237.936400] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 19:18:07 sf kernel: [ 8237.936404] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 19:18:07 sf kernel: [ 8237.936479] Pid: 10455, comm: sh Tainted: G  =
      W    3.2.0-rc3-00099-g883381d #163
Dec  2 19:18:07 sf kernel: [ 8237.936489] Call Trace:
Dec  2 19:18:07 sf kernel: [ 8237.936502]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 19:18:07 sf kernel: [ 8237.936512]  [<ffffffff81046a75>] warn_slowpa=
th_null+0x15/0x20
Dec  2 19:18:07 sf kernel: [ 8237.936521]  [<ffffffff81273749>] pci_has_leg=
acy_pm_support.clone.4+0x39/0x60
Dec  2 19:18:07 sf kernel: [ 8237.936530]  [<ffffffff81273b43>] pci_pm_susp=
end_noirq+0x43/0x160
Dec  2 19:18:07 sf kernel: [ 8237.936541]  [<ffffffff812feca5>] pm_noirq_op=
+0x145/0x240
Dec  2 19:18:07 sf kernel: [ 8237.936550]  [<ffffffff812ff0e8>] dpm_suspend=
_noirq+0xe8/0x250
Dec  2 19:18:07 sf kernel: [ 8237.936560]  [<ffffffff810805d5>] suspend_dev=
ices_and_enter+0xa5/0x240
Dec  2 19:18:07 sf kernel: [ 8237.936568]  [<ffffffff810808ce>] enter_state=
+0x15e/0x190
Dec  2 19:18:07 sf kernel: [ 8237.936578]  [<ffffffff8107f6e6>] state_store=
+0xc6/0x140
Dec  2 19:18:07 sf kernel: [ 8237.936588]  [<ffffffff81251067>] kobj_attr_s=
tore+0x17/0x20
Dec  2 19:18:07 sf kernel: [ 8237.936597]  [<ffffffff81145cb4>] sysfs_write=
_file+0xf4/0x170
Dec  2 19:18:07 sf kernel: [ 8237.936608]  [<ffffffff810e4016>] vfs_write+0=
xc6/0x180
Dec  2 19:18:07 sf kernel: [ 8237.936615]  [<ffffffff810e432c>] sys_write+0=
x4c/0x90
Dec  2 19:18:07 sf kernel: [ 8237.936625]  [<ffffffff814362fb>] system_call=
_fastpath+0x16/0x1b
Dec  2 19:18:07 sf kernel: [ 8237.936632] ---[ end trace 7a713f1eaae715a1 ]=
---
Dec  2 19:18:07 sf kernel: [ 8237.947382] ehci_hcd 0000:00:1d.7: PME# enabl=
ed
Dec  2 19:18:07 sf kernel: [ 8237.947406] ehci_hcd 0000:00:1d.7: wake-up ca=
pability enabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8237.958397] uhci_hcd 0000:00:1d.2: wake-up ca=
pability enabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8237.958574] uhci_hcd 0000:00:1d.1: wake-up ca=
pability enabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8237.958744] uhci_hcd 0000:00:1d.0: wake-up ca=
pability enabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8237.958971] ehci_hcd 0000:00:1a.7: PME# enabl=
ed
Dec  2 19:18:07 sf kernel: [ 8237.958984] ehci_hcd 0000:00:1a.7: wake-up ca=
pability enabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8237.969356] uhci_hcd 0000:00:1a.1: wake-up ca=
pability enabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8237.969528] uhci_hcd 0000:00:1a.0: wake-up ca=
pability enabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8237.969914] PM: late suspend of devices compl=
ete after 33.875 msecs
Dec  2 19:18:07 sf kernel: [ 8237.970516] ACPI: Preparing to enter system s=
leep state S3
Dec  2 19:18:07 sf kernel: [ 8237.970728] PM: Saving platform NVS memory
Dec  2 19:18:07 sf kernel: [ 8237.970969] Disabling non-boot CPUs ...
Dec  2 19:18:07 sf kernel: [ 8237.973053] CPU 1 is now offline
Dec  2 19:18:07 sf kernel: [ 8237.973862] Extended CMOS year: 2000
Dec  2 19:18:07 sf kernel: [ 8237.973862] ACPI: Low-level resume complete
Dec  2 19:18:07 sf kernel: [ 8237.973862] PM: Restoring platform NVS memory
Dec  2 19:18:07 sf kernel: [ 8237.973862] CPU0: Thermal monitoring handled =
by SMI
Dec  2 19:18:07 sf kernel: [ 8237.973862] Extended CMOS year: 2000
Dec  2 19:18:07 sf kernel: [ 8237.973862] Enabling non-boot CPUs ...
Dec  2 19:18:07 sf kernel: [ 8237.976226] Booting Node 0 Processor 1 APIC 0=
x1
Dec  2 19:18:07 sf kernel: [ 8237.976230] smpboot cpu 1: start_ip =3D 9a000
Dec  2 19:18:07 sf kernel: [ 8237.972870] Calibrating delay loop (skipped) =
already calibrated this CPU
Dec  2 19:18:07 sf kernel: [ 8237.972870] CPU1: Thermal monitoring handled =
by SMI
Dec  2 19:18:07 sf kernel: [ 8237.987718] NMI watchdog enabled, takes one h=
w-pmu counter.
Dec  2 19:18:07 sf kernel: [ 8237.990202] CPU1 is up
Dec  2 19:18:07 sf kernel: [ 8237.991433] ACPI: Waking up from system sleep=
 state S3
Dec  2 19:18:07 sf kernel: [ 8238.043679] i915 0000:00:02.0: restoring conf=
ig space at offset 0x8 (was 0x1, writing 0x2001)
Dec  2 19:18:07 sf kernel: [ 8238.043701] i915 0000:00:02.0: restoring conf=
ig space at offset 0x1 (was 0x900403, writing 0x900407)
Dec  2 19:18:07 sf kernel: [ 8238.043760] pci 0000:00:02.1: restoring confi=
g space at offset 0x4 (was 0x4, writing 0xe0500004)
Dec  2 19:18:07 sf kernel: [ 8238.043773] pci 0000:00:02.1: restoring confi=
g space at offset 0x1 (was 0x900000, writing 0x900007)
Dec  2 19:18:07 sf kernel: [ 8238.043803] pci 0000:00:03.0: restoring confi=
g space at offset 0xf (was 0x100, writing 0x1ff)
Dec  2 19:18:07 sf kernel: [ 8238.043829] pci 0000:00:03.0: restoring confi=
g space at offset 0x4 (was 0xfed12004, writing 0xe0600004)
Dec  2 19:18:07 sf kernel: [ 8238.043842] pci 0000:00:03.0: restoring confi=
g space at offset 0x1 (was 0x100006, writing 0x180006)
Dec  2 19:18:07 sf kernel: [ 8238.043875] pci 0000:00:03.2: restoring confi=
g space at offset 0xf (was 0x300, writing 0x30b)
Dec  2 19:18:07 sf kernel: [ 8238.043895] pci 0000:00:03.2: restoring confi=
g space at offset 0x8 (was 0x1, writing 0x2031)
Dec  2 19:18:07 sf kernel: [ 8238.043905] pci 0000:00:03.2: restoring confi=
g space at offset 0x7 (was 0x1, writing 0x2021)
Dec  2 19:18:07 sf kernel: [ 8238.043915] pci 0000:00:03.2: restoring confi=
g space at offset 0x6 (was 0x1, writing 0x2019)
Dec  2 19:18:07 sf kernel: [ 8238.043924] pci 0000:00:03.2: restoring confi=
g space at offset 0x5 (was 0x1, writing 0x2011)
Dec  2 19:18:07 sf kernel: [ 8238.043935] pci 0000:00:03.2: restoring confi=
g space at offset 0x4 (was 0x1, writing 0x2009)
Dec  2 19:18:07 sf kernel: [ 8238.043948] pci 0000:00:03.2: restoring confi=
g space at offset 0x1 (was 0xb00000, writing 0xb00005)
Dec  2 19:18:07 sf kernel: [ 8238.043985] pci 0000:00:03.3: restoring confi=
g space at offset 0xf (was 0x200, writing 0x20a)
Dec  2 19:18:07 sf kernel: [ 8238.044044] pci 0000:00:03.3: restoring confi=
g space at offset 0x5 (was 0x0, writing 0xe0601000)
Dec  2 19:18:07 sf kernel: [ 8238.044055] pci 0000:00:03.3: restoring confi=
g space at offset 0x4 (was 0x1, writing 0x2041)
Dec  2 19:18:07 sf kernel: [ 8238.044068] pci 0000:00:03.3: restoring confi=
g space at offset 0x1 (was 0xb00000, writing 0xb00007)
Dec  2 19:18:07 sf kernel: [ 8238.044109] e1000e 0000:00:19.0: restoring co=
nfig space at offset 0xf (was 0x100, writing 0x10b)
Dec  2 19:18:07 sf kernel: [ 8238.044139] e1000e 0000:00:19.0: restoring co=
nfig space at offset 0x6 (was 0x1, writing 0x2061)
Dec  2 19:18:07 sf kernel: [ 8238.044151] e1000e 0000:00:19.0: restoring co=
nfig space at offset 0x5 (was 0x0, writing 0xe0640000)
Dec  2 19:18:07 sf kernel: [ 8238.044169] e1000e 0000:00:19.0: restoring co=
nfig space at offset 0x1 (was 0x100000, writing 0x100007)
Dec  2 19:18:07 sf kernel: [ 8238.044205] uhci_hcd 0000:00:1a.0: restoring =
config space at offset 0xf (was 0x100, writing 0x10a)
Dec  2 19:18:07 sf kernel: [ 8238.044231] uhci_hcd 0000:00:1a.0: restoring =
config space at offset 0x8 (was 0x1, writing 0x2081)
Dec  2 19:18:07 sf kernel: [ 8238.044256] uhci_hcd 0000:00:1a.0: restoring =
config space at offset 0x1 (was 0x2800000, writing 0x2800001)
Dec  2 19:18:07 sf kernel: [ 8238.044340] uhci_hcd 0000:00:1a.0: wake-up ca=
pability disabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8238.044357] uhci_hcd 0000:00:1a.1: restoring =
config space at offset 0xf (was 0x200, writing 0x20a)
Dec  2 19:18:07 sf kernel: [ 8238.044383] uhci_hcd 0000:00:1a.1: restoring =
config space at offset 0x8 (was 0x1, writing 0x20a1)
Dec  2 19:18:07 sf kernel: [ 8238.044409] uhci_hcd 0000:00:1a.1: restoring =
config space at offset 0x1 (was 0x2800000, writing 0x2800001)
Dec  2 19:18:07 sf kernel: [ 8238.044480] uhci_hcd 0000:00:1a.1: wake-up ca=
pability disabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8238.044510] ehci_hcd 0000:00:1a.7: restoring =
config space at offset 0xf (was 0x300, writing 0x30b)
Dec  2 19:18:07 sf kernel: [ 8238.044546] ehci_hcd 0000:00:1a.7: restoring =
config space at offset 0x4 (was 0x0, writing 0xe0641000)
Dec  2 19:18:07 sf kernel: [ 8238.044562] ehci_hcd 0000:00:1a.7: restoring =
config space at offset 0x1 (was 0x2900000, writing 0x2900002)
Dec  2 19:18:07 sf kernel: [ 8238.044596] ehci_hcd 0000:00:1a.7: wake-up ca=
pability disabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8238.044608] ehci_hcd 0000:00:1a.7: PME# disab=
led
Dec  2 19:18:07 sf kernel: [ 8238.044644] snd_hda_intel 0000:00:1b.0: resto=
ring config space at offset 0xf (was 0x100, writing 0x10a)
Dec  2 19:18:07 sf kernel: [ 8238.044681] snd_hda_intel 0000:00:1b.0: resto=
ring config space at offset 0x3 (was 0x0, writing 0x10)
Dec  2 19:18:07 sf kernel: [ 8238.044695] snd_hda_intel 0000:00:1b.0: resto=
ring config space at offset 0x1 (was 0x100000, writing 0x100002)
Dec  2 19:18:07 sf kernel: [ 8238.044752] pcieport 0000:00:1c.0: restoring =
config space at offset 0xf (was 0x100, writing 0x4010a)
Dec  2 19:18:07 sf kernel: [ 8238.044775] pcieport 0000:00:1c.0: restoring =
config space at offset 0x9 (was 0x10001, writing 0x1fff1)
Dec  2 19:18:07 sf kernel: [ 8238.044787] pcieport 0000:00:1c.0: restoring =
config space at offset 0x8 (was 0x0, writing 0xfff0)
Dec  2 19:18:07 sf kernel: [ 8238.044798] pcieport 0000:00:1c.0: restoring =
config space at offset 0x7 (was 0x0, writing 0xf0)
Dec  2 19:18:07 sf kernel: [ 8238.044809] pcieport 0000:00:1c.0: restoring =
config space at offset 0x6 (was 0x0, writing 0x80800)
Dec  2 19:18:07 sf kernel: [ 8238.044826] pcieport 0000:00:1c.0: restoring =
config space at offset 0x3 (was 0x810000, writing 0x810010)
Dec  2 19:18:07 sf kernel: [ 8238.044840] pcieport 0000:00:1c.0: restoring =
config space at offset 0x1 (was 0x100000, writing 0x100407)
Dec  2 19:18:07 sf kernel: [ 8238.044927] pcieport 0000:00:1c.1: restoring =
config space at offset 0xf (was 0x200, writing 0x4020a)
Dec  2 19:18:07 sf kernel: [ 8238.044950] pcieport 0000:00:1c.1: restoring =
config space at offset 0x9 (was 0x10001, writing 0x1fff1)
Dec  2 19:18:07 sf kernel: [ 8238.044962] pcieport 0000:00:1c.1: restoring =
config space at offset 0x8 (was 0x0, writing 0xe000e000)
Dec  2 19:18:07 sf kernel: [ 8238.044974] pcieport 0000:00:1c.1: restoring =
config space at offset 0x7 (was 0x0, writing 0xf0)
Dec  2 19:18:07 sf kernel: [ 8238.044994] pcieport 0000:00:1c.1: restoring =
config space at offset 0x3 (was 0x810000, writing 0x810010)
Dec  2 19:18:07 sf kernel: [ 8238.045025] pcieport 0000:00:1c.1: restoring =
config space at offset 0x1 (was 0x100000, writing 0x100407)
Dec  2 19:18:07 sf kernel: [ 8238.045098] uhci_hcd 0000:00:1d.0: restoring =
config space at offset 0xf (was 0x100, writing 0x10a)
Dec  2 19:18:07 sf kernel: [ 8238.045125] uhci_hcd 0000:00:1d.0: restoring =
config space at offset 0x8 (was 0x1, writing 0x20c1)
Dec  2 19:18:07 sf kernel: [ 8238.045151] uhci_hcd 0000:00:1d.0: restoring =
config space at offset 0x1 (was 0x2800000, writing 0x2800001)
Dec  2 19:18:07 sf kernel: [ 8238.045224] uhci_hcd 0000:00:1d.0: wake-up ca=
pability disabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8238.045241] uhci_hcd 0000:00:1d.1: restoring =
config space at offset 0xf (was 0x200, writing 0x20b)
Dec  2 19:18:07 sf kernel: [ 8238.045267] uhci_hcd 0000:00:1d.1: restoring =
config space at offset 0x8 (was 0x1, writing 0x20e1)
Dec  2 19:18:07 sf kernel: [ 8238.045292] uhci_hcd 0000:00:1d.1: restoring =
config space at offset 0x1 (was 0x2800000, writing 0x2800001)
Dec  2 19:18:07 sf kernel: [ 8238.045361] uhci_hcd 0000:00:1d.1: wake-up ca=
pability disabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8238.045377] uhci_hcd 0000:00:1d.2: restoring =
config space at offset 0xf (was 0x300, writing 0x30b)
Dec  2 19:18:07 sf kernel: [ 8238.045403] uhci_hcd 0000:00:1d.2: restoring =
config space at offset 0x8 (was 0x1, writing 0x2101)
Dec  2 19:18:07 sf kernel: [ 8238.045428] uhci_hcd 0000:00:1d.2: restoring =
config space at offset 0x1 (was 0x2800000, writing 0x2800001)
Dec  2 19:18:07 sf kernel: [ 8238.045497] uhci_hcd 0000:00:1d.2: wake-up ca=
pability disabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8238.045527] ehci_hcd 0000:00:1d.7: restoring =
config space at offset 0xf (was 0x100, writing 0x10a)
Dec  2 19:18:07 sf kernel: [ 8238.045562] ehci_hcd 0000:00:1d.7: restoring =
config space at offset 0x4 (was 0x0, writing 0xe0648000)
Dec  2 19:18:07 sf kernel: [ 8238.045578] ehci_hcd 0000:00:1d.7: restoring =
config space at offset 0x1 (was 0x2900000, writing 0x2900002)
Dec  2 19:18:07 sf kernel: [ 8238.045612] ehci_hcd 0000:00:1d.7: wake-up ca=
pability disabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8238.045623] ehci_hcd 0000:00:1d.7: PME# disab=
led
Dec  2 19:18:07 sf kernel: [ 8238.045660] pci 0000:00:1e.0: restoring confi=
g space at offset 0x9 (was 0x10001, writing 0x83f18001)
Dec  2 19:18:07 sf kernel: [ 8238.045671] pci 0000:00:1e.0: restoring confi=
g space at offset 0x8 (was 0x0, writing 0xe030e010)
Dec  2 19:18:07 sf kernel: [ 8238.045683] pci 0000:00:1e.0: restoring confi=
g space at offset 0x7 (was 0x228000f0, writing 0x22803030)
Dec  2 19:18:07 sf kernel: [ 8238.045706] pci 0000:00:1e.0: restoring confi=
g space at offset 0x1 (was 0x100007, writing 0x100107)
Dec  2 19:18:07 sf kernel: [ 8238.045805] ata_piix 0000:00:1f.1: restoring =
config space at offset 0xf (was 0x100, writing 0x10a)
Dec  2 19:18:07 sf kernel: [ 8238.045831] ata_piix 0000:00:1f.1: restoring =
config space at offset 0x8 (was 0xc01, writing 0x2121)
Dec  2 19:18:07 sf kernel: [ 8238.045972] iwl4965 0000:10:00.0: restoring c=
onfig space at offset 0xf (was 0x100, writing 0x10a)
Dec  2 19:18:07 sf kernel: [ 8238.046043] iwl4965 0000:10:00.0: restoring c=
onfig space at offset 0x4 (was 0x4, writing 0xe0000004)
Dec  2 19:18:07 sf kernel: [ 8238.046058] iwl4965 0000:10:00.0: restoring c=
onfig space at offset 0x3 (was 0x0, writing 0x10)
Dec  2 19:18:07 sf kernel: [ 8238.046075] iwl4965 0000:10:00.0: restoring c=
onfig space at offset 0x1 (was 0x100000, writing 0x100406)
Dec  2 19:18:07 sf kernel: [ 8238.046130] Monitor-Mwait will be used to ent=
er C-2 state
Dec  2 19:18:07 sf kernel: [ 8238.046181] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0xf (was 0x3000100, writing 0x580010b)
Dec  2 19:18:07 sf kernel: [ 8238.046193] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0xe (was 0x0, writing 0x30fc)
Dec  2 19:18:07 sf kernel: [ 8238.046206] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0xd (was 0x0, writing 0x3000)
Dec  2 19:18:07 sf kernel: [ 8238.046218] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0xc (was 0x0, writing 0x34fc)
Dec  2 19:18:07 sf kernel: [ 8238.046231] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0xb (was 0x0, writing 0x3400)
Dec  2 19:18:07 sf kernel: [ 8238.046244] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0xa (was 0x0, writing 0x87fff000)
Dec  2 19:18:07 sf kernel: [ 8238.046256] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0x9 (was 0x0, writing 0x84000000)
Dec  2 19:18:07 sf kernel: [ 8238.046269] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0x8 (was 0x0, writing 0x83fff000)
Dec  2 19:18:07 sf kernel: [ 8238.046281] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0x7 (was 0x0, writing 0x80000000)
Dec  2 19:18:07 sf kernel: [ 8238.046294] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0x6 (was 0x0, writing 0xb0060302)
Dec  2 19:18:07 sf kernel: [ 8238.046309] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0x4 (was 0x0, writing 0xe0100000)
Dec  2 19:18:07 sf kernel: [ 8238.046322] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0x3 (was 0x820000, writing 0x82a800)
Dec  2 19:18:07 sf kernel: [ 8238.046338] yenta_cardbus 0000:02:06.0: resto=
ring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
Dec  2 19:18:07 sf kernel: [ 8238.046417] pci 0000:02:06.1: restoring confi=
g space at offset 0xf (was 0x4020200, writing 0x4020205)
Dec  2 19:18:07 sf kernel: [ 8238.046457] pci 0000:02:06.1: restoring confi=
g space at offset 0x4 (was 0x0, writing 0xe0101000)
Dec  2 19:18:07 sf kernel: [ 8238.046470] pci 0000:02:06.1: restoring confi=
g space at offset 0x3 (was 0x800000, writing 0x804010)
Dec  2 19:18:07 sf kernel: [ 8238.046485] pci 0000:02:06.1: restoring confi=
g space at offset 0x1 (was 0x2100000, writing 0x2100006)
Dec  2 19:18:07 sf kernel: [ 8238.046528] sdhci-pci 0000:02:06.2: restoring=
 config space at offset 0xf (was 0x300, writing 0x30a)
Dec  2 19:18:07 sf kernel: [ 8238.046569] sdhci-pci 0000:02:06.2: restoring=
 config space at offset 0x4 (was 0x0, writing 0xe0102000)
Dec  2 19:18:07 sf kernel: [ 8238.046582] sdhci-pci 0000:02:06.2: restoring=
 config space at offset 0x3 (was 0x800000, writing 0x804010)
Dec  2 19:18:07 sf kernel: [ 8238.046598] sdhci-pci 0000:02:06.2: restoring=
 config space at offset 0x1 (was 0x2100000, writing 0x2100006)
Dec  2 19:18:07 sf kernel: [ 8238.046621] ------------[ cut here ]---------=
---
Dec  2 19:18:07 sf kernel: [ 8238.046635] WARNING: at drivers/pci/pci-drive=
r.c:607 pci_has_legacy_pm_support.clone.4+0x39/0x60()
Dec  2 19:18:07 sf kernel: [ 8238.046640] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 19:18:07 sf kernel: [ 8238.046645] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 19:18:07 sf kernel: [ 8238.046719] Pid: 10455, comm: sh Tainted: G  =
      W    3.2.0-rc3-00099-g883381d #163
Dec  2 19:18:07 sf kernel: [ 8238.046724] Call Trace:
Dec  2 19:18:07 sf kernel: [ 8238.046737]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 19:18:07 sf kernel: [ 8238.046747]  [<ffffffff81046a75>] warn_slowpa=
th_null+0x15/0x20
Dec  2 19:18:07 sf kernel: [ 8238.046756]  [<ffffffff81273749>] pci_has_leg=
acy_pm_support.clone.4+0x39/0x60
Dec  2 19:18:07 sf kernel: [ 8238.046765]  [<ffffffff812739c6>] pci_pm_resu=
me_noirq+0x36/0xa0
Dec  2 19:18:07 sf kernel: [ 8238.046776]  [<ffffffff812fec4e>] pm_noirq_op=
+0xee/0x240
Dec  2 19:18:07 sf kernel: [ 8238.046784]  [<ffffffff812fee5b>] dpm_resume_=
noirq+0x4b/0x1f0
Dec  2 19:18:07 sf kernel: [ 8238.046794]  [<ffffffff81080616>] suspend_dev=
ices_and_enter+0xe6/0x240
Dec  2 19:18:07 sf kernel: [ 8238.046802]  [<ffffffff810808ce>] enter_state=
+0x15e/0x190
Dec  2 19:18:07 sf kernel: [ 8238.046811]  [<ffffffff8107f6e6>] state_store=
+0xc6/0x140
Dec  2 19:18:07 sf kernel: [ 8238.046822]  [<ffffffff81251067>] kobj_attr_s=
tore+0x17/0x20
Dec  2 19:18:07 sf kernel: [ 8238.046831]  [<ffffffff81145cb4>] sysfs_write=
_file+0xf4/0x170
Dec  2 19:18:07 sf kernel: [ 8238.046841]  [<ffffffff810e4016>] vfs_write+0=
xc6/0x180
Dec  2 19:18:07 sf kernel: [ 8238.046849]  [<ffffffff810e432c>] sys_write+0=
x4c/0x90
Dec  2 19:18:07 sf kernel: [ 8238.046859]  [<ffffffff814362fb>] system_call=
_fastpath+0x16/0x1b
Dec  2 19:18:07 sf kernel: [ 8238.046866] ---[ end trace 7a713f1eaae715a2 ]=
---
Dec  2 19:18:07 sf kernel: [ 8238.047261] PM: early resume of devices compl=
ete after 3.731 msecs
Dec  2 19:18:07 sf kernel: [ 8238.047527] i915 0000:00:02.0: setting latenc=
y timer to 64
Dec  2 19:18:07 sf kernel: [ 8238.047569] e1000e 0000:00:19.0: wake-up capa=
bility disabled by ACPI
Dec  2 19:18:07 sf kernel: [ 8238.047592] e1000e 0000:00:19.0: PME# disabled
Dec  2 19:18:07 sf kernel: [ 8238.047730] e1000e 0000:00:19.0: irq 44 for M=
SI/MSI-X
Dec  2 19:18:07 sf kernel: [ 8238.052048] uhci_hcd 0000:00:1a.0: PCI INT A =
-> GSI 16 (level, low) -> IRQ 16
Dec  2 19:18:07 sf kernel: [ 8238.052057] uhci_hcd 0000:00:1a.1: PCI INT B =
-> GSI 17 (level, low) -> IRQ 17
Dec  2 19:18:07 sf kernel: [ 8238.052063] uhci_hcd 0000:00:1a.0: setting la=
tency timer to 64
Dec  2 19:18:07 sf kernel: [ 8238.052074] uhci_hcd 0000:00:1a.1: setting la=
tency timer to 64
Dec  2 19:18:07 sf kernel: [ 8238.052108] usb usb3: root hub lost power or =
was reset
Dec  2 19:18:07 sf kernel: [ 8238.052120] usb usb4: root hub lost power or =
was reset
Dec  2 19:18:07 sf kernel: [ 8238.052140] ehci_hcd 0000:00:1a.7: PCI INT C =
-> GSI 18 (level, low) -> IRQ 18
Dec  2 19:18:07 sf kernel: [ 8238.052153] ehci_hcd 0000:00:1a.7: setting la=
tency timer to 64
Dec  2 19:18:07 sf kernel: [ 8238.052257] uhci_hcd 0000:00:1d.0: PCI INT A =
-> GSI 20 (level, low) -> IRQ 20
Dec  2 19:18:07 sf kernel: [ 8238.052270] uhci_hcd 0000:00:1d.0: setting la=
tency timer to 64
Dec  2 19:18:07 sf kernel: [ 8238.052306] usb usb5: root hub lost power or =
was reset
Dec  2 19:18:07 sf kernel: [ 8238.052330] uhci_hcd 0000:00:1d.1: PCI INT B =
-> GSI 22 (level, low) -> IRQ 22
Dec  2 19:18:07 sf kernel: [ 8238.052343] uhci_hcd 0000:00:1d.1: setting la=
tency timer to 64
Dec  2 19:18:07 sf kernel: [ 8238.052379] usb usb6: root hub lost power or =
was reset
Dec  2 19:18:07 sf kernel: [ 8238.052401] uhci_hcd 0000:00:1d.2: PCI INT C =
-> GSI 18 (level, low) -> IRQ 18
Dec  2 19:18:07 sf kernel: [ 8238.052414] uhci_hcd 0000:00:1d.2: setting la=
tency timer to 64
Dec  2 19:18:07 sf kernel: [ 8238.052451] usb usb7: root hub lost power or =
was reset
Dec  2 19:18:07 sf kernel: [ 8238.052475] ehci_hcd 0000:00:1d.7: PCI INT A =
-> GSI 20 (level, low) -> IRQ 20
Dec  2 19:18:07 sf kernel: [ 8238.052488] ehci_hcd 0000:00:1d.7: setting la=
tency timer to 64
Dec  2 19:18:07 sf kernel: [ 8238.052555] pci 0000:00:1e.0: setting latency=
 timer to 64
Dec  2 19:18:07 sf kernel: [ 8238.052580] ata_piix 0000:00:1f.1: PCI INT A =
-> GSI 16 (level, low) -> IRQ 16
Dec  2 19:18:07 sf kernel: [ 8238.052591] ata_piix 0000:00:1f.1: setting la=
tency timer to 64
Dec  2 19:18:07 sf kernel: [ 8238.052651] iwl4965 0000:10:00.0: RF_KILL bit=
 toggled to disable radio.
Dec  2 19:18:07 sf kernel: [ 8238.052669] ------------[ cut here ]---------=
---
Dec  2 19:18:07 sf kernel: [ 8238.052679] WARNING: at drivers/pci/pci-drive=
r.c:607 pci_has_legacy_pm_support.clone.4+0x39/0x60()
Dec  2 19:18:07 sf kernel: [ 8238.052685] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 19:18:07 sf kernel: [ 8238.052689] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 19:18:07 sf kernel: [ 8238.052754] Pid: 10464, comm: kworker/u:6 Tai=
nted: G        W    3.2.0-rc3-00099-g883381d #163
Dec  2 19:18:07 sf kernel: [ 8238.052760] Call Trace:
Dec  2 19:18:07 sf kernel: [ 8238.052770]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 19:18:07 sf kernel: [ 8238.052779]  [<ffffffff81046a75>] warn_slowpa=
th_null+0x15/0x20
Dec  2 19:18:07 sf kernel: [ 8238.052788]  [<ffffffff81273749>] pci_has_leg=
acy_pm_support.clone.4+0x39/0x60
Dec  2 19:18:07 sf kernel: [ 8238.052799]  [<ffffffff8103eb01>] ? thread_gr=
oup_times+0x71/0xb0
Dec  2 19:18:07 sf kernel: [ 8238.052808]  [<ffffffff81273df4>] pci_pm_resu=
me+0x44/0xb0
Dec  2 19:18:07 sf kernel: [ 8238.052817]  [<ffffffff812ff423>] pm_op+0x113=
/0x220
Dec  2 19:18:07 sf kernel: [ 8238.052825]  [<ffffffff812ff96f>] device_resu=
me+0x9f/0x140
Dec  2 19:18:07 sf kernel: [ 8238.052834]  [<ffffffff8106a210>] ? async_sch=
edule+0x20/0x20
Dec  2 19:18:07 sf kernel: [ 8238.052842]  [<ffffffff812ffa2c>] async_resum=
e+0x1c/0x50
Dec  2 19:18:07 sf kernel: [ 8238.052851]  [<ffffffff8106a28f>] async_run_e=
ntry_fn+0x7f/0x180
Dec  2 19:18:07 sf kernel: [ 8238.052861]  [<ffffffff8105c422>] process_one=
_work+0x112/0x390
Dec  2 19:18:07 sf kernel: [ 8238.052870]  [<ffffffff8105e711>] worker_thre=
ad+0x161/0x340
Dec  2 19:18:07 sf kernel: [ 8238.052877]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 19:18:07 sf kernel: [ 8238.052886]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 19:18:07 sf kernel: [ 8238.052894]  [<ffffffff810632a6>] kthread+0x9=
6/0xa0
Dec  2 19:18:07 sf kernel: [ 8238.052904]  [<ffffffff814373d4>] kernel_thre=
ad_helper+0x4/0x10
Dec  2 19:18:07 sf kernel: [ 8238.052913]  [<ffffffff81063210>] ? kthread_w=
orker_fn+0x190/0x190
Dec  2 19:18:07 sf kernel: [ 8238.052921]  [<ffffffff814373d0>] ? gs_change=
+0xb/0xb
Dec  2 19:18:07 sf kernel: [ 8238.052926] ---[ end trace 7a713f1eaae715a3 ]=
---
Dec  2 19:18:07 sf kernel: [ 8238.052943] sdhci-pci 0000:02:06.2: PCI INT C=
 -> GSI 20 (level, low) -> IRQ 20
Dec  2 19:18:07 sf kernel: [ 8238.052950] sdhci-pci 0000:02:06.2: Will use =
DMA mode even though HW doesn't fully claim to support it.
Dec  2 19:18:07 sf kernel: [ 8238.059033] ACPI Exception: AE_AML_PACKAGE_LI=
MIT, Index (0x0000000000000005) is beyond end of object (20110623/exoparg2-=
418)
Dec  2 19:18:07 sf kernel: [ 8238.059045] ACPI Error: Method parse/executio=
n failed [\_SB_.C2C3] (Node ffff88007b83e118), AE_AML_PACKAGE_LIMIT (201106=
23/psparse-536)
Dec  2 19:18:07 sf kernel: [ 8238.059062] ACPI Error: Method parse/executio=
n failed [\_SB_.C003.C0F6.C3F3._STM] (Node ffff88007b88bc58), AE_AML_PACKAG=
E_LIMIT (20110623/psparse-536)
Dec  2 19:18:07 sf kernel: [ 8238.059144] snd_hda_intel 0000:00:1b.0: power=
 state changed by ACPI to D0
Dec  2 19:18:07 sf kernel: [ 8238.059154] snd_hda_intel 0000:00:1b.0: power=
 state changed by ACPI to D0
Dec  2 19:18:07 sf kernel: [ 8238.059164] snd_hda_intel 0000:00:1b.0: power=
 state changed by ACPI to D0
Dec  2 19:18:07 sf kernel: [ 8238.059171] snd_hda_intel 0000:00:1b.0: power=
 state changed by ACPI to D0
Dec  2 19:18:07 sf kernel: [ 8238.059182] snd_hda_intel 0000:00:1b.0: PCI I=
NT A -> GSI 17 (level, low) -> IRQ 17
Dec  2 19:18:07 sf kernel: [ 8238.059192] snd_hda_intel 0000:00:1b.0: setti=
ng latency timer to 64
Dec  2 19:18:07 sf kernel: [ 8238.059258] snd_hda_intel 0000:00:1b.0: irq 4=
5 for MSI/MSI-X
Dec  2 19:18:07 sf kernel: [ 8238.060039] ata1: ACPI set timing mode failed=
 (status=3D0x300b)
Dec  2 19:18:07 sf kernel: [ 8238.060820] ata2: port disabled--ignoring
Dec  2 19:18:07 sf kernel: [ 8238.066277] sd 0:0:0:0: [sda] Starting disk
Dec  2 19:18:07 sf kernel: [ 8238.369106] usb 5-2: reset full-speed USB dev=
ice number 2 using uhci_hcd
Dec  2 19:18:07 sf kernel: [ 8239.837024] e1000e: eth0 NIC Link is Up 100 M=
bps Full Duplex, Flow Control: Rx/Tx
Dec  2 19:18:07 sf kernel: [ 8239.837034] e1000e 0000:00:19.0: eth0: 10/100=
 speed: disabling TSO
Dec  2 19:18:07 sf kernel: [ 8241.955531] ata1.00: ACPI cmd ef/03:01:00:00:=
00:a0 (SET FEATURES) filtered out
Dec  2 19:18:07 sf kernel: [ 8241.955541] ata1.00: ACPI cmd ef/03:45:00:00:=
00:a0 (SET FEATURES) filtered out
Dec  2 19:18:07 sf kernel: [ 8241.955550] ata1.00: ACPI cmd f5/00:00:00:00:=
00:a0 (SECURITY FREEZE LOCK) filtered out
Dec  2 19:18:07 sf kernel: [ 8241.955559] ata1.00: ACPI cmd b1/c1:00:00:00:=
00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
Dec  2 19:18:07 sf kernel: [ 8241.955743] ata1.00: ACPI cmd c6/00:10:00:00:=
00:a0 (SET MULTIPLE MODE) succeeded
Dec  2 19:18:07 sf kernel: [ 8241.994646] ata1.00: configured for UDMA/100
Dec  2 19:18:07 sf kernel: [ 8242.137293] PM: resume of devices complete af=
ter 4089.961 msecs
Dec  2 19:18:07 sf kernel: [ 8242.137821] PM: Finishing wakeup.
Dec  2 19:18:07 sf kernel: [ 8242.137826] Restarting tasks ... done.
Dec  2 19:18:07 sf kernel: [ 8242.142893] video LNXVIDEO:00: Restoring back=
light state
Dec  2 19:18:07 sf kernel: [ 8242.449060] usb 5-1: new full-speed USB devic=
e number 3 using uhci_hcd
Dec  2 19:18:07 sf kernel: [ 8242.603211] usb 5-1: New USB device found, id=
Vendor=3D413c, idProduct=3D1003
Dec  2 19:18:07 sf kernel: [ 8242.603219] usb 5-1: New USB device strings: =
Mfr=3D1, Product=3D2, SerialNumber=3D0
Dec  2 19:18:07 sf kernel: [ 8242.603224] usb 5-1: Product: Dell USB Keyboa=
rd Hub
Dec  2 19:18:07 sf kernel: [ 8242.603229] usb 5-1: Manufacturer: Dell
Dec  2 19:18:07 sf kernel: [ 8242.610236] hub 5-1:1.0: USB hub found
Dec  2 19:18:07 sf kernel: [ 8242.611208] hub 5-1:1.0: 3 ports detected
Dec  2 19:18:07 sf kernel: [ 8242.887219] usb 5-1.1: new full-speed USB dev=
ice number 4 using uhci_hcd
Dec  2 19:18:08 sf kernel: [ 8243.008216] usb 5-1.1: New USB device found, =
idVendor=3D413c, idProduct=3D2010
Dec  2 19:18:08 sf kernel: [ 8243.008223] usb 5-1.1: New USB device strings=
: Mfr=3D1, Product=3D3, SerialNumber=3D0
Dec  2 19:18:08 sf kernel: [ 8243.008229] usb 5-1.1: Product: Dell USB Keyb=
oard
Dec  2 19:18:08 sf kernel: [ 8243.008233] usb 5-1.1: Manufacturer: Dell
Dec  2 19:18:08 sf kernel: [ 8243.017725] input: Dell Dell USB Keyboard as =
/devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/5-1.1:1.0/input/input7
Dec  2 19:18:08 sf kernel: [ 8243.017795] generic-usb 0003:413C:2010.0001: =
input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.0-=
1.1/input0
Dec  2 19:18:08 sf kernel: [ 8243.025308] input: Dell Dell USB Keyboard as =
/devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/5-1.1:1.1/input/input8
Dec  2 19:18:08 sf kernel: [ 8243.025384] generic-usb 0003:413C:2010.0002: =
input: USB HID v1.10 Device [Dell Dell USB Keyboard] on usb-0000:00:1d.0-1.=
1/input1
Dec  2 19:18:08 sf kernel: [ 8243.091219] usb 5-1.2: new low-speed USB devi=
ce number 5 using uhci_hcd
Dec  2 19:18:08 sf kernel: [ 8243.224234] usb 5-1.2: New USB device found, =
idVendor=3D045e, idProduct=3D0040
Dec  2 19:18:08 sf kernel: [ 8243.224242] usb 5-1.2: New USB device strings=
: Mfr=3D1, Product=3D3, SerialNumber=3D0
Dec  2 19:18:08 sf kernel: [ 8243.224248] usb 5-1.2: Product: Microsoft 3-B=
utton Mouse with IntelliEye(TM)
Dec  2 19:18:08 sf kernel: [ 8243.224253] usb 5-1.2: Manufacturer: Microsoft
Dec  2 19:18:08 sf kernel: [ 8243.242943] input: Microsoft Microsoft 3-Butt=
on Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5=
-1.2/5-1.2:1.0/input/input9
Dec  2 19:18:08 sf kernel: [ 8243.243120] generic-usb 0003:045E:0040.0003: =
input: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with Intelli=
Eye(TM)] on usb-0000:00:1d.0-1.2/input0
Dec  2 19:18:08 sf kernel: [ 8243.293366] e1000e 0000:00:19.0: irq 44 for M=
SI/MSI-X
Dec  2 19:18:08 sf kernel: [ 8243.344168] e1000e 0000:00:19.0: irq 44 for M=
SI/MSI-X
Dec  2 19:18:09 sf kernel: [ 8243.983424] e1000e 0000:00:19.0: irq 44 for M=
SI/MSI-X
Dec  2 19:18:09 sf kernel: [ 8244.034237] e1000e 0000:00:19.0: irq 44 for M=
SI/MSI-X
Dec  2 19:18:10 sf kernel: [ 8245.405962] e1000e: eth0 NIC Link is Up 100 M=
bps Full Duplex, Flow Control: Rx/Tx
Dec  2 19:18:10 sf kernel: [ 8245.405976] e1000e 0000:00:19.0: eth0: 10/100=
 speed: disabling TSO
Dec  2 20:00:29 sf kernel: [10784.053725] hda-intel: IRQ timing workaround =
is activated for card #0. Suggest a bigger bdl_pos_adj.
Dec  2 20:36:51 sf kernel: [12966.320024] [drm:i915_hangcheck_elapsed] *ERR=
OR* Hangcheck timer elapsed... GPU hung
Dec  2 20:36:51 sf kernel: [12966.320031] [drm] capturing error event; look=
 for more information in /debug/dri/0/i915_error_state
Dec  2 20:36:51 sf kernel: [12966.321416] [drm:init_ring_common] *ERROR* re=
nder ring initialization failed ctl 00000000 head 00000000 tail 00000000 st=
art 00000000
Dec  2 20:36:51 sf kernel: [12966.322035] ------------[ cut here ]---------=
---
Dec  2 20:36:51 sf kernel: [12966.322071] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:793 intel_enable_pipe+0x136/0x160 [i915]()
Dec  2 20:36:51 sf kernel: [12966.322077] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:36:51 sf kernel: [12966.322081] PLL state assertion failure (expe=
cted on, current off)
Dec  2 20:36:51 sf kernel: [12966.322084] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:36:51 sf kernel: [12966.322147] Pid: 10499, comm: kworker/u:29 Ta=
inted: G        W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:36:51 sf kernel: [12966.322152] Call Trace:
Dec  2 20:36:51 sf kernel: [12966.322164]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:36:51 sf kernel: [12966.322171]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:36:51 sf kernel: [12966.322180]  [<ffffffff8125b0a0>] ? delay_tsc=
+0x90/0xf0
Dec  2 20:36:51 sf kernel: [12966.322200]  [<ffffffffa012c196>] intel_enabl=
e_pipe+0x136/0x160 [i915]
Dec  2 20:36:51 sf kernel: [12966.322220]  [<ffffffffa012f217>] i9xx_crtc_m=
ode_set+0x707/0xde0 [i915]
Dec  2 20:36:51 sf kernel: [12966.322229]  [<ffffffff8103ec2d>] ? sub_preem=
pt_count+0x9d/0xd0
Dec  2 20:36:51 sf kernel: [12966.322237]  [<ffffffff81435662>] ? _raw_spin=
_unlock_irqrestore+0x12/0x40
Dec  2 20:36:51 sf kernel: [12966.322244]  [<ffffffff8103ec2d>] ? sub_preem=
pt_count+0x9d/0xd0
Dec  2 20:36:51 sf kernel: [12966.322263]  [<ffffffffa012aaca>] intel_crtc_=
mode_set+0x6a/0xa0 [i915]
Dec  2 20:36:51 sf kernel: [12966.322275]  [<ffffffffa0103059>] drm_crtc_he=
lper_set_mode+0x359/0x4d0 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.322289]  [<ffffffffa0103243>] drm_helper_=
resume_force_mode+0x73/0x160 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.322312]  [<ffffffffa0084ed8>] ? drm_irq_i=
nstall+0x178/0x250 [drm]
Dec  2 20:36:51 sf kernel: [12966.322328]  [<ffffffffa010dda0>] i915_reset+=
0x360/0x4e0 [i915]
Dec  2 20:36:51 sf kernel: [12966.322344]  [<ffffffffa0112620>] ? i915_driv=
er_irq_postinstall+0x190/0x190 [i915]
Dec  2 20:36:51 sf kernel: [12966.322359]  [<ffffffffa01126f7>] i915_error_=
work_func+0xd7/0x130 [i915]
Dec  2 20:36:51 sf kernel: [12966.322370]  [<ffffffff8105c422>] process_one=
_work+0x112/0x390
Dec  2 20:36:51 sf kernel: [12966.322377]  [<ffffffff8105e711>] worker_thre=
ad+0x161/0x340
Dec  2 20:36:51 sf kernel: [12966.322383]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.322390]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.322396]  [<ffffffff810632a6>] kthread+0x9=
6/0xa0
Dec  2 20:36:51 sf kernel: [12966.322404]  [<ffffffff814373d4>] kernel_thre=
ad_helper+0x4/0x10
Dec  2 20:36:51 sf kernel: [12966.322411]  [<ffffffff81063210>] ? kthread_w=
orker_fn+0x190/0x190
Dec  2 20:36:51 sf kernel: [12966.322418]  [<ffffffff814373d0>] ? gs_change=
+0xb/0xb
Dec  2 20:36:51 sf kernel: [12966.322422] ---[ end trace 7a713f1eaae715a4 ]=
---
Dec  2 20:36:51 sf kernel: [12966.426078] ------------[ cut here ]---------=
---
Dec  2 20:36:51 sf kernel: [12966.426113] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:930 assert_pipe+0x72/0x80 [i915]()
Dec  2 20:36:51 sf kernel: [12966.426119] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:36:51 sf kernel: [12966.426123] pipe A assertion failure (expecte=
d on, current off)
Dec  2 20:36:51 sf kernel: [12966.426127] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:36:51 sf kernel: [12966.426189] Pid: 10499, comm: kworker/u:29 Ta=
inted: G        W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:36:51 sf kernel: [12966.426194] Call Trace:
Dec  2 20:36:51 sf kernel: [12966.426205]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:36:51 sf kernel: [12966.426213]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:36:51 sf kernel: [12966.426234]  [<ffffffffa012a242>] assert_pipe=
+0x72/0x80 [i915]
Dec  2 20:36:51 sf kernel: [12966.426254]  [<ffffffffa012c1f8>] intel_enabl=
e_plane+0x38/0x90 [i915]
Dec  2 20:36:51 sf kernel: [12966.426274]  [<ffffffffa012f24d>] i9xx_crtc_m=
ode_set+0x73d/0xde0 [i915]
Dec  2 20:36:51 sf kernel: [12966.426284]  [<ffffffff8103ec2d>] ? sub_preem=
pt_count+0x9d/0xd0
Dec  2 20:36:51 sf kernel: [12966.426292]  [<ffffffff81435662>] ? _raw_spin=
_unlock_irqrestore+0x12/0x40
Dec  2 20:36:51 sf kernel: [12966.426299]  [<ffffffff8103ec2d>] ? sub_preem=
pt_count+0x9d/0xd0
Dec  2 20:36:51 sf kernel: [12966.426319]  [<ffffffffa012aaca>] intel_crtc_=
mode_set+0x6a/0xa0 [i915]
Dec  2 20:36:51 sf kernel: [12966.426331]  [<ffffffffa0103059>] drm_crtc_he=
lper_set_mode+0x359/0x4d0 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.426348]  [<ffffffffa0103243>] drm_helper_=
resume_force_mode+0x73/0x160 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.426368]  [<ffffffffa0084ed8>] ? drm_irq_i=
nstall+0x178/0x250 [drm]
Dec  2 20:36:51 sf kernel: [12966.426384]  [<ffffffffa010dda0>] i915_reset+=
0x360/0x4e0 [i915]
Dec  2 20:36:51 sf kernel: [12966.426400]  [<ffffffffa0112620>] ? i915_driv=
er_irq_postinstall+0x190/0x190 [i915]
Dec  2 20:36:51 sf kernel: [12966.426416]  [<ffffffffa01126f7>] i915_error_=
work_func+0xd7/0x130 [i915]
Dec  2 20:36:51 sf kernel: [12966.426427]  [<ffffffff8105c422>] process_one=
_work+0x112/0x390
Dec  2 20:36:51 sf kernel: [12966.426434]  [<ffffffff8105e711>] worker_thre=
ad+0x161/0x340
Dec  2 20:36:51 sf kernel: [12966.426440]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.426447]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.426454]  [<ffffffff810632a6>] kthread+0x9=
6/0xa0
Dec  2 20:36:51 sf kernel: [12966.426462]  [<ffffffff814373d4>] kernel_thre=
ad_helper+0x4/0x10
Dec  2 20:36:51 sf kernel: [12966.426470]  [<ffffffff81063210>] ? kthread_w=
orker_fn+0x190/0x190
Dec  2 20:36:51 sf kernel: [12966.426477]  [<ffffffff814373d0>] ? gs_change=
+0xb/0xb
Dec  2 20:36:51 sf kernel: [12966.426481] ---[ end trace 7a713f1eaae715a5 ]=
---
Dec  2 20:36:51 sf kernel: [12966.530495] ------------[ cut here ]---------=
---
Dec  2 20:36:51 sf kernel: [12966.530541] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:793 intel_enable_pipe+0x136/0x160 [i915]()
Dec  2 20:36:51 sf kernel: [12966.530546] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:36:51 sf kernel: [12966.530550] PLL state assertion failure (expe=
cted on, current off)
Dec  2 20:36:51 sf kernel: [12966.530553] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:36:51 sf kernel: [12966.530615] Pid: 10499, comm: kworker/u:29 Ta=
inted: G        W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:36:51 sf kernel: [12966.530620] Call Trace:
Dec  2 20:36:51 sf kernel: [12966.530632]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:36:51 sf kernel: [12966.530639]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:36:51 sf kernel: [12966.530649]  [<ffffffff8125b0a0>] ? delay_tsc=
+0x90/0xf0
Dec  2 20:36:51 sf kernel: [12966.530670]  [<ffffffffa012c196>] intel_enabl=
e_pipe+0x136/0x160 [i915]
Dec  2 20:36:51 sf kernel: [12966.530691]  [<ffffffffa012fa30>] i9xx_crtc_e=
nable+0x140/0x1a0 [i915]
Dec  2 20:36:51 sf kernel: [12966.530711]  [<ffffffffa012fa99>] i9xx_crtc_c=
ommit+0x9/0x10 [i915]
Dec  2 20:36:51 sf kernel: [12966.530722]  [<ffffffffa01030a5>] drm_crtc_he=
lper_set_mode+0x3a5/0x4d0 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.530736]  [<ffffffffa0103243>] drm_helper_=
resume_force_mode+0x73/0x160 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.530762]  [<ffffffffa0084ed8>] ? drm_irq_i=
nstall+0x178/0x250 [drm]
Dec  2 20:36:51 sf kernel: [12966.530778]  [<ffffffffa010dda0>] i915_reset+=
0x360/0x4e0 [i915]
Dec  2 20:36:51 sf kernel: [12966.530795]  [<ffffffffa0112620>] ? i915_driv=
er_irq_postinstall+0x190/0x190 [i915]
Dec  2 20:36:51 sf kernel: [12966.530810]  [<ffffffffa01126f7>] i915_error_=
work_func+0xd7/0x130 [i915]
Dec  2 20:36:51 sf kernel: [12966.530822]  [<ffffffff8105c422>] process_one=
_work+0x112/0x390
Dec  2 20:36:51 sf kernel: [12966.530829]  [<ffffffff8105e711>] worker_thre=
ad+0x161/0x340
Dec  2 20:36:51 sf kernel: [12966.530835]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.530843]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.530850]  [<ffffffff810632a6>] kthread+0x9=
6/0xa0
Dec  2 20:36:51 sf kernel: [12966.530859]  [<ffffffff814373d4>] kernel_thre=
ad_helper+0x4/0x10
Dec  2 20:36:51 sf kernel: [12966.530866]  [<ffffffff81063210>] ? kthread_w=
orker_fn+0x190/0x190
Dec  2 20:36:51 sf kernel: [12966.530873]  [<ffffffff814373d0>] ? gs_change=
+0xb/0xb
Dec  2 20:36:51 sf kernel: [12966.530877] ---[ end trace 7a713f1eaae715a6 ]=
---
Dec  2 20:36:51 sf kernel: [12966.581054] ------------[ cut here ]---------=
---
Dec  2 20:36:51 sf kernel: [12966.581095] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:930 assert_pipe+0x72/0x80 [i915]()
Dec  2 20:36:51 sf kernel: [12966.581100] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:36:51 sf kernel: [12966.581105] pipe A assertion failure (expecte=
d on, current off)
Dec  2 20:36:51 sf kernel: [12966.581108] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:36:51 sf kernel: [12966.581170] Pid: 10499, comm: kworker/u:29 Ta=
inted: G        W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:36:51 sf kernel: [12966.581174] Call Trace:
Dec  2 20:36:51 sf kernel: [12966.581186]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:36:51 sf kernel: [12966.581193]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:36:51 sf kernel: [12966.581202]  [<ffffffff81433969>] ? schedule_=
timeout_uninterruptible+0x19/0x20
Dec  2 20:36:51 sf kernel: [12966.581223]  [<ffffffffa012a242>] assert_pipe=
+0x72/0x80 [i915]
Dec  2 20:36:51 sf kernel: [12966.581242]  [<ffffffffa012c1f8>] intel_enabl=
e_plane+0x38/0x90 [i915]
Dec  2 20:36:51 sf kernel: [12966.581263]  [<ffffffffa012fa3e>] i9xx_crtc_e=
nable+0x14e/0x1a0 [i915]
Dec  2 20:36:51 sf kernel: [12966.581282]  [<ffffffffa012fa99>] i9xx_crtc_c=
ommit+0x9/0x10 [i915]
Dec  2 20:36:51 sf kernel: [12966.581294]  [<ffffffffa01030a5>] drm_crtc_he=
lper_set_mode+0x3a5/0x4d0 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.581307]  [<ffffffffa0103243>] drm_helper_=
resume_force_mode+0x73/0x160 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.581331]  [<ffffffffa0084ed8>] ? drm_irq_i=
nstall+0x178/0x250 [drm]
Dec  2 20:36:51 sf kernel: [12966.581346]  [<ffffffffa010dda0>] i915_reset+=
0x360/0x4e0 [i915]
Dec  2 20:36:51 sf kernel: [12966.581362]  [<ffffffffa0112620>] ? i915_driv=
er_irq_postinstall+0x190/0x190 [i915]
Dec  2 20:36:51 sf kernel: [12966.581378]  [<ffffffffa01126f7>] i915_error_=
work_func+0xd7/0x130 [i915]
Dec  2 20:36:51 sf kernel: [12966.581388]  [<ffffffff8105c422>] process_one=
_work+0x112/0x390
Dec  2 20:36:51 sf kernel: [12966.581395]  [<ffffffff8105e711>] worker_thre=
ad+0x161/0x340
Dec  2 20:36:51 sf kernel: [12966.581401]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.581408]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.581415]  [<ffffffff810632a6>] kthread+0x9=
6/0xa0
Dec  2 20:36:51 sf kernel: [12966.581423]  [<ffffffff814373d4>] kernel_thre=
ad_helper+0x4/0x10
Dec  2 20:36:51 sf kernel: [12966.581430]  [<ffffffff81063210>] ? kthread_w=
orker_fn+0x190/0x190
Dec  2 20:36:51 sf kernel: [12966.581436]  [<ffffffff814373d0>] ? gs_change=
+0xb/0xb
Dec  2 20:36:51 sf kernel: [12966.581440] ---[ end trace 7a713f1eaae715a7 ]=
---
Dec  2 20:36:51 sf kernel: [12966.633494] [drm] Changing LVDS panel from (+=
hsync, +vsync) to (-hsync, -vsync)
Dec  2 20:36:51 sf kernel: [12966.633653] ------------[ cut here ]---------=
---
Dec  2 20:36:51 sf kernel: [12966.633691] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:793 intel_enable_pipe+0x136/0x160 [i915]()
Dec  2 20:36:51 sf kernel: [12966.633696] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:36:51 sf kernel: [12966.633700] PLL state assertion failure (expe=
cted on, current off)
Dec  2 20:36:51 sf kernel: [12966.633704] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:36:51 sf kernel: [12966.633768] Pid: 10499, comm: kworker/u:29 Ta=
inted: G        W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:36:51 sf kernel: [12966.633773] Call Trace:
Dec  2 20:36:51 sf kernel: [12966.633785]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:36:51 sf kernel: [12966.633792]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:36:51 sf kernel: [12966.633801]  [<ffffffff8125b0a0>] ? delay_tsc=
+0x90/0xf0
Dec  2 20:36:51 sf kernel: [12966.633822]  [<ffffffffa012c196>] intel_enabl=
e_pipe+0x136/0x160 [i915]
Dec  2 20:36:51 sf kernel: [12966.633842]  [<ffffffffa012f217>] i9xx_crtc_m=
ode_set+0x707/0xde0 [i915]
Dec  2 20:36:51 sf kernel: [12966.633850]  [<ffffffff8103ec2d>] ? sub_preem=
pt_count+0x9d/0xd0
Dec  2 20:36:51 sf kernel: [12966.633857]  [<ffffffff81435662>] ? _raw_spin=
_unlock_irqrestore+0x12/0x40
Dec  2 20:36:51 sf kernel: [12966.633864]  [<ffffffff8103ec2d>] ? sub_preem=
pt_count+0x9d/0xd0
Dec  2 20:36:51 sf kernel: [12966.633884]  [<ffffffffa012aaca>] intel_crtc_=
mode_set+0x6a/0xa0 [i915]
Dec  2 20:36:51 sf kernel: [12966.633896]  [<ffffffffa0103059>] drm_crtc_he=
lper_set_mode+0x359/0x4d0 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.633910]  [<ffffffffa0103243>] drm_helper_=
resume_force_mode+0x73/0x160 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.633933]  [<ffffffffa0084ed8>] ? drm_irq_i=
nstall+0x178/0x250 [drm]
Dec  2 20:36:51 sf kernel: [12966.633948]  [<ffffffffa010dda0>] i915_reset+=
0x360/0x4e0 [i915]
Dec  2 20:36:51 sf kernel: [12966.633963]  [<ffffffffa0112620>] ? i915_driv=
er_irq_postinstall+0x190/0x190 [i915]
Dec  2 20:36:51 sf kernel: [12966.633979]  [<ffffffffa01126f7>] i915_error_=
work_func+0xd7/0x130 [i915]
Dec  2 20:36:51 sf kernel: [12966.633990]  [<ffffffff8105c422>] process_one=
_work+0x112/0x390
Dec  2 20:36:51 sf kernel: [12966.633996]  [<ffffffff8105e711>] worker_thre=
ad+0x161/0x340
Dec  2 20:36:51 sf kernel: [12966.634021]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.634028]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.634035]  [<ffffffff810632a6>] kthread+0x9=
6/0xa0
Dec  2 20:36:51 sf kernel: [12966.634043]  [<ffffffff814373d4>] kernel_thre=
ad_helper+0x4/0x10
Dec  2 20:36:51 sf kernel: [12966.634049]  [<ffffffff81063210>] ? kthread_w=
orker_fn+0x190/0x190
Dec  2 20:36:51 sf kernel: [12966.634056]  [<ffffffff814373d0>] ? gs_change=
+0xb/0xb
Dec  2 20:36:51 sf kernel: [12966.634060] ---[ end trace 7a713f1eaae715a8 ]=
---
Dec  2 20:36:51 sf kernel: [12966.737053] ------------[ cut here ]---------=
---
Dec  2 20:36:51 sf kernel: [12966.737098] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:930 assert_pipe+0x72/0x80 [i915]()
Dec  2 20:36:51 sf kernel: [12966.737104] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:36:51 sf kernel: [12966.737108] pipe B assertion failure (expecte=
d on, current off)
Dec  2 20:36:51 sf kernel: [12966.737112] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:36:51 sf kernel: [12966.737175] Pid: 10499, comm: kworker/u:29 Ta=
inted: G        W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:36:51 sf kernel: [12966.737180] Call Trace:
Dec  2 20:36:51 sf kernel: [12966.737195]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:36:51 sf kernel: [12966.737202]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:36:51 sf kernel: [12966.737224]  [<ffffffffa012a242>] assert_pipe=
+0x72/0x80 [i915]
Dec  2 20:36:51 sf kernel: [12966.737244]  [<ffffffffa012c1f8>] intel_enabl=
e_plane+0x38/0x90 [i915]
Dec  2 20:36:51 sf kernel: [12966.737264]  [<ffffffffa012f24d>] i9xx_crtc_m=
ode_set+0x73d/0xde0 [i915]
Dec  2 20:36:51 sf kernel: [12966.737274]  [<ffffffff8103ec2d>] ? sub_preem=
pt_count+0x9d/0xd0
Dec  2 20:36:51 sf kernel: [12966.737282]  [<ffffffff81435662>] ? _raw_spin=
_unlock_irqrestore+0x12/0x40
Dec  2 20:36:51 sf kernel: [12966.737289]  [<ffffffff8103ec2d>] ? sub_preem=
pt_count+0x9d/0xd0
Dec  2 20:36:51 sf kernel: [12966.737310]  [<ffffffffa012aaca>] intel_crtc_=
mode_set+0x6a/0xa0 [i915]
Dec  2 20:36:51 sf kernel: [12966.737322]  [<ffffffffa0103059>] drm_crtc_he=
lper_set_mode+0x359/0x4d0 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.737339]  [<ffffffffa0103243>] drm_helper_=
resume_force_mode+0x73/0x160 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.737367]  [<ffffffffa0084ed8>] ? drm_irq_i=
nstall+0x178/0x250 [drm]
Dec  2 20:36:51 sf kernel: [12966.737383]  [<ffffffffa010dda0>] i915_reset+=
0x360/0x4e0 [i915]
Dec  2 20:36:51 sf kernel: [12966.737399]  [<ffffffffa0112620>] ? i915_driv=
er_irq_postinstall+0x190/0x190 [i915]
Dec  2 20:36:51 sf kernel: [12966.737415]  [<ffffffffa01126f7>] i915_error_=
work_func+0xd7/0x130 [i915]
Dec  2 20:36:51 sf kernel: [12966.737426]  [<ffffffff8105c422>] process_one=
_work+0x112/0x390
Dec  2 20:36:51 sf kernel: [12966.737434]  [<ffffffff8105e711>] worker_thre=
ad+0x161/0x340
Dec  2 20:36:51 sf kernel: [12966.737440]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.737447]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.737456]  [<ffffffff810632a6>] kthread+0x9=
6/0xa0
Dec  2 20:36:51 sf kernel: [12966.737465]  [<ffffffff814373d4>] kernel_thre=
ad_helper+0x4/0x10
Dec  2 20:36:51 sf kernel: [12966.737472]  [<ffffffff81063210>] ? kthread_w=
orker_fn+0x190/0x190
Dec  2 20:36:51 sf kernel: [12966.737479]  [<ffffffff814373d0>] ? gs_change=
+0xb/0xb
Dec  2 20:36:51 sf kernel: [12966.737483] ---[ end trace 7a713f1eaae715a9 ]=
---
Dec  2 20:36:51 sf kernel: [12966.840513] ------------[ cut here ]---------=
---
Dec  2 20:36:51 sf kernel: [12966.840563] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:793 intel_enable_pipe+0x136/0x160 [i915]()
Dec  2 20:36:51 sf kernel: [12966.840571] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:36:51 sf kernel: [12966.840577] PLL state assertion failure (expe=
cted on, current off)
Dec  2 20:36:51 sf kernel: [12966.840583] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:36:51 sf kernel: [12966.840674] Pid: 10499, comm: kworker/u:29 Ta=
inted: G        W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:36:51 sf kernel: [12966.840681] Call Trace:
Dec  2 20:36:51 sf kernel: [12966.840698]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:36:51 sf kernel: [12966.840710]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:36:51 sf kernel: [12966.840723]  [<ffffffff8125b0a0>] ? delay_tsc=
+0x90/0xf0
Dec  2 20:36:51 sf kernel: [12966.840755]  [<ffffffffa012c196>] intel_enabl=
e_pipe+0x136/0x160 [i915]
Dec  2 20:36:51 sf kernel: [12966.840786]  [<ffffffffa012fa30>] i9xx_crtc_e=
nable+0x140/0x1a0 [i915]
Dec  2 20:36:51 sf kernel: [12966.840816]  [<ffffffffa012fa99>] i9xx_crtc_c=
ommit+0x9/0x10 [i915]
Dec  2 20:36:51 sf kernel: [12966.840833]  [<ffffffffa01030a5>] drm_crtc_he=
lper_set_mode+0x3a5/0x4d0 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.840854]  [<ffffffffa0103243>] drm_helper_=
resume_force_mode+0x73/0x160 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.840885]  [<ffffffffa0084ed8>] ? drm_irq_i=
nstall+0x178/0x250 [drm]
Dec  2 20:36:51 sf kernel: [12966.840909]  [<ffffffffa010dda0>] i915_reset+=
0x360/0x4e0 [i915]
Dec  2 20:36:51 sf kernel: [12966.840932]  [<ffffffffa0112620>] ? i915_driv=
er_irq_postinstall+0x190/0x190 [i915]
Dec  2 20:36:51 sf kernel: [12966.840956]  [<ffffffffa01126f7>] i915_error_=
work_func+0xd7/0x130 [i915]
Dec  2 20:36:51 sf kernel: [12966.840973]  [<ffffffff8105c422>] process_one=
_work+0x112/0x390
Dec  2 20:36:51 sf kernel: [12966.840984]  [<ffffffff8105e711>] worker_thre=
ad+0x161/0x340
Dec  2 20:36:51 sf kernel: [12966.840993]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.841029]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.841039]  [<ffffffff810632a6>] kthread+0x9=
6/0xa0
Dec  2 20:36:51 sf kernel: [12966.841052]  [<ffffffff814373d4>] kernel_thre=
ad_helper+0x4/0x10
Dec  2 20:36:51 sf kernel: [12966.841063]  [<ffffffff81063210>] ? kthread_w=
orker_fn+0x190/0x190
Dec  2 20:36:51 sf kernel: [12966.841073]  [<ffffffff814373d0>] ? gs_change=
+0xb/0xb
Dec  2 20:36:51 sf kernel: [12966.841080] ---[ end trace 7a713f1eaae715aa ]=
---
Dec  2 20:36:51 sf kernel: [12966.893040] ------------[ cut here ]---------=
---
Dec  2 20:36:51 sf kernel: [12966.893091] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:930 assert_pipe+0x72/0x80 [i915]()
Dec  2 20:36:51 sf kernel: [12966.893098] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:36:51 sf kernel: [12966.893105] pipe B assertion failure (expecte=
d on, current off)
Dec  2 20:36:51 sf kernel: [12966.893110] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:36:51 sf kernel: [12966.893201] Pid: 10499, comm: kworker/u:29 Ta=
inted: G        W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:36:51 sf kernel: [12966.893208] Call Trace:
Dec  2 20:36:51 sf kernel: [12966.893225]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:36:51 sf kernel: [12966.893236]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:36:51 sf kernel: [12966.893249]  [<ffffffff81433969>] ? schedule_=
timeout_uninterruptible+0x19/0x20
Dec  2 20:36:51 sf kernel: [12966.893279]  [<ffffffffa012a242>] assert_pipe=
+0x72/0x80 [i915]
Dec  2 20:36:51 sf kernel: [12966.893309]  [<ffffffffa012c1f8>] intel_enabl=
e_plane+0x38/0x90 [i915]
Dec  2 20:36:51 sf kernel: [12966.893339]  [<ffffffffa012fa3e>] i9xx_crtc_e=
nable+0x14e/0x1a0 [i915]
Dec  2 20:36:51 sf kernel: [12966.893369]  [<ffffffffa012fa99>] i9xx_crtc_c=
ommit+0x9/0x10 [i915]
Dec  2 20:36:51 sf kernel: [12966.893385]  [<ffffffffa01030a5>] drm_crtc_he=
lper_set_mode+0x3a5/0x4d0 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.893405]  [<ffffffffa0103243>] drm_helper_=
resume_force_mode+0x73/0x160 [drm_kms_helper]
Dec  2 20:36:51 sf kernel: [12966.893435]  [<ffffffffa0084ed8>] ? drm_irq_i=
nstall+0x178/0x250 [drm]
Dec  2 20:36:51 sf kernel: [12966.893458]  [<ffffffffa010dda0>] i915_reset+=
0x360/0x4e0 [i915]
Dec  2 20:36:51 sf kernel: [12966.893482]  [<ffffffffa0112620>] ? i915_driv=
er_irq_postinstall+0x190/0x190 [i915]
Dec  2 20:36:51 sf kernel: [12966.893506]  [<ffffffffa01126f7>] i915_error_=
work_func+0xd7/0x130 [i915]
Dec  2 20:36:51 sf kernel: [12966.893521]  [<ffffffff8105c422>] process_one=
_work+0x112/0x390
Dec  2 20:36:51 sf kernel: [12966.893532]  [<ffffffff8105e711>] worker_thre=
ad+0x161/0x340
Dec  2 20:36:51 sf kernel: [12966.893541]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.893551]  [<ffffffff8105e5b0>] ? manage_wo=
rkers.clone.24+0x240/0x240
Dec  2 20:36:51 sf kernel: [12966.893561]  [<ffffffff810632a6>] kthread+0x9=
6/0xa0
Dec  2 20:36:51 sf kernel: [12966.893572]  [<ffffffff814373d4>] kernel_thre=
ad_helper+0x4/0x10
Dec  2 20:36:51 sf kernel: [12966.893583]  [<ffffffff81063210>] ? kthread_w=
orker_fn+0x190/0x190
Dec  2 20:36:51 sf kernel: [12966.893593]  [<ffffffff814373d0>] ? gs_change=
+0xb/0xb
Dec  2 20:36:51 sf kernel: [12966.893599] ---[ end trace 7a713f1eaae715ab ]=
---
Dec  2 20:36:52 sf kernel: [12967.946052] [drm:intel_lvds_enable] *ERROR* t=
imed out waiting for panel to power on
Dec  2 20:38:04 sf kernel: [13037.887148] ------------[ cut here ]---------=
---
Dec  2 20:38:04 sf kernel: [13037.887185] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:793 intel_enable_pipe+0x136/0x160 [i915]()
Dec  2 20:38:04 sf kernel: [13037.887190] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:38:04 sf kernel: [13037.887193] PLL state assertion failure (expe=
cted on, current off)
Dec  2 20:38:04 sf kernel: [13037.887196] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:38:04 sf kernel: [13037.887238] Pid: 2107, comm: X Tainted: G    =
    W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:38:04 sf kernel: [13037.887241] Call Trace:
Dec  2 20:38:04 sf kernel: [13037.887252]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:38:04 sf kernel: [13037.887258]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:38:04 sf kernel: [13037.887266]  [<ffffffff8125b0a0>] ? delay_tsc=
+0x90/0xf0
Dec  2 20:38:04 sf kernel: [13037.887286]  [<ffffffffa012c196>] intel_enabl=
e_pipe+0x136/0x160 [i915]
Dec  2 20:38:04 sf kernel: [13037.887305]  [<ffffffffa012f217>] i9xx_crtc_m=
ode_set+0x707/0xde0 [i915]
Dec  2 20:38:04 sf kernel: [13037.887312]  [<ffffffff8103ec2d>] ? sub_preem=
pt_count+0x9d/0xd0
Dec  2 20:38:04 sf kernel: [13037.887319]  [<ffffffff81435662>] ? _raw_spin=
_unlock_irqrestore+0x12/0x40
Dec  2 20:38:04 sf kernel: [13037.887325]  [<ffffffff8103ec2d>] ? sub_preem=
pt_count+0x9d/0xd0
Dec  2 20:38:04 sf kernel: [13037.887344]  [<ffffffffa012aaca>] intel_crtc_=
mode_set+0x6a/0xa0 [i915]
Dec  2 20:38:04 sf kernel: [13037.887354]  [<ffffffffa0103059>] drm_crtc_he=
lper_set_mode+0x359/0x4d0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13037.887359]  [<ffffffff814356a0>] ? _raw_spin=
_unlock+0x10/0x40
Dec  2 20:38:04 sf kernel: [13037.887372]  [<ffffffffa0103ce9>] drm_crtc_he=
lper_set_config+0x9b9/0xa40 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13037.887381]  [<ffffffffa0101c03>] drm_fb_help=
er_set_par+0x73/0xe0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13037.887387]  [<ffffffff81281f4e>] fb_set_var+=
0x16e/0x380
Dec  2 20:38:04 sf kernel: [13037.887394]  [<ffffffff81038429>] ? finish_ta=
sk_switch+0x49/0xd0
Dec  2 20:38:04 sf kernel: [13037.887399]  [<ffffffff81432bfe>] ? __schedul=
e+0x46e/0xa90
Dec  2 20:38:04 sf kernel: [13037.887405]  [<ffffffff810395f2>] ? check_pre=
empt_wakeup+0x102/0x1d0
Dec  2 20:38:04 sf kernel: [13037.887411]  [<ffffffff8128f7bb>] fbcon_blank=
+0x1eb/0x2f0
Dec  2 20:38:04 sf kernel: [13037.887419]  [<ffffffff812e4351>] do_unblank_=
screen+0xb1/0x1f0
Dec  2 20:38:04 sf kernel: [13037.887426]  [<ffffffff812d9c20>] complete_ch=
ange_console+0x60/0x100
Dec  2 20:38:04 sf kernel: [13037.887431]  [<ffffffff812db82b>] vt_ioctl+0x=
1b6b/0x20d0
Dec  2 20:38:04 sf kernel: [13037.887437]  [<ffffffff810bc55c>] ? handle_pt=
e_fault+0x7c/0x7b0
Dec  2 20:38:04 sf kernel: [13037.887445]  [<ffffffff812d07d0>] tty_ioctl+0=
x2b0/0xcf0
Dec  2 20:38:04 sf kernel: [13037.887451]  [<ffffffff81025b1c>] ? do_page_f=
ault+0x1bc/0x440
Dec  2 20:38:04 sf kernel: [13037.887458]  [<ffffffff810f5407>] do_vfs_ioct=
l+0x97/0x5d0
Dec  2 20:38:04 sf kernel: [13037.887465]  [<ffffffff810e40a8>] ? vfs_write=
+0x158/0x180
Dec  2 20:38:04 sf kernel: [13037.887470]  [<ffffffff810f598a>] sys_ioctl+0=
x4a/0x80
Dec  2 20:38:04 sf kernel: [13037.887476]  [<ffffffff814362fb>] system_call=
_fastpath+0x16/0x1b
Dec  2 20:38:04 sf kernel: [13037.887480] ---[ end trace 7a713f1eaae715ac ]=
---
Dec  2 20:38:04 sf kernel: [13037.991056] ------------[ cut here ]---------=
---
Dec  2 20:38:04 sf kernel: [13037.991092] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:930 assert_pipe+0x72/0x80 [i915]()
Dec  2 20:38:04 sf kernel: [13037.991098] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:38:04 sf kernel: [13037.991103] pipe A assertion failure (expecte=
d on, current off)
Dec  2 20:38:04 sf kernel: [13037.991108] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:38:04 sf kernel: [13037.991166] Pid: 2107, comm: X Tainted: G    =
    W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:38:04 sf kernel: [13037.991171] Call Trace:
Dec  2 20:38:04 sf kernel: [13037.991184]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:38:04 sf kernel: [13037.991192]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:38:04 sf kernel: [13037.991222]  [<ffffffffa012a242>] assert_pipe=
+0x72/0x80 [i915]
Dec  2 20:38:04 sf kernel: [13037.991250]  [<ffffffffa012c1f8>] intel_enabl=
e_plane+0x38/0x90 [i915]
Dec  2 20:38:04 sf kernel: [13037.991278]  [<ffffffffa012f24d>] i9xx_crtc_m=
ode_set+0x73d/0xde0 [i915]
Dec  2 20:38:04 sf kernel: [13037.991289]  [<ffffffff8103ec2d>] ? sub_preem=
pt_count+0x9d/0xd0
Dec  2 20:38:04 sf kernel: [13037.991298]  [<ffffffff81435662>] ? _raw_spin=
_unlock_irqrestore+0x12/0x40
Dec  2 20:38:04 sf kernel: [13037.991307]  [<ffffffff8103ec2d>] ? sub_preem=
pt_count+0x9d/0xd0
Dec  2 20:38:04 sf kernel: [13037.991335]  [<ffffffffa012aaca>] intel_crtc_=
mode_set+0x6a/0xa0 [i915]
Dec  2 20:38:04 sf kernel: [13037.991349]  [<ffffffffa0103059>] drm_crtc_he=
lper_set_mode+0x359/0x4d0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13037.991357]  [<ffffffff814356a0>] ? _raw_spin=
_unlock+0x10/0x40
Dec  2 20:38:04 sf kernel: [13037.991376]  [<ffffffffa0103ce9>] drm_crtc_he=
lper_set_config+0x9b9/0xa40 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13037.991390]  [<ffffffffa0101c03>] drm_fb_help=
er_set_par+0x73/0xe0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13037.991399]  [<ffffffff81281f4e>] fb_set_var+=
0x16e/0x380
Dec  2 20:38:04 sf kernel: [13037.991408]  [<ffffffff81038429>] ? finish_ta=
sk_switch+0x49/0xd0
Dec  2 20:38:04 sf kernel: [13037.991416]  [<ffffffff81432bfe>] ? __schedul=
e+0x46e/0xa90
Dec  2 20:38:04 sf kernel: [13037.991424]  [<ffffffff810395f2>] ? check_pre=
empt_wakeup+0x102/0x1d0
Dec  2 20:38:04 sf kernel: [13037.991434]  [<ffffffff8128f7bb>] fbcon_blank=
+0x1eb/0x2f0
Dec  2 20:38:04 sf kernel: [13037.991444]  [<ffffffff812e4351>] do_unblank_=
screen+0xb1/0x1f0
Dec  2 20:38:04 sf kernel: [13037.991453]  [<ffffffff812d9c20>] complete_ch=
ange_console+0x60/0x100
Dec  2 20:38:04 sf kernel: [13037.991461]  [<ffffffff812db82b>] vt_ioctl+0x=
1b6b/0x20d0
Dec  2 20:38:04 sf kernel: [13037.991469]  [<ffffffff810bc55c>] ? handle_pt=
e_fault+0x7c/0x7b0
Dec  2 20:38:04 sf kernel: [13037.991479]  [<ffffffff812d07d0>] tty_ioctl+0=
x2b0/0xcf0
Dec  2 20:38:04 sf kernel: [13037.991487]  [<ffffffff81025b1c>] ? do_page_f=
ault+0x1bc/0x440
Dec  2 20:38:04 sf kernel: [13037.991497]  [<ffffffff810f5407>] do_vfs_ioct=
l+0x97/0x5d0
Dec  2 20:38:04 sf kernel: [13037.991506]  [<ffffffff810e40a8>] ? vfs_write=
+0x158/0x180
Dec  2 20:38:04 sf kernel: [13037.991514]  [<ffffffff810f598a>] sys_ioctl+0=
x4a/0x80
Dec  2 20:38:04 sf kernel: [13037.991522]  [<ffffffff814362fb>] system_call=
_fastpath+0x16/0x1b
Dec  2 20:38:04 sf kernel: [13037.991529] ---[ end trace 7a713f1eaae715ad ]=
---
Dec  2 20:38:04 sf kernel: [13038.095555] ------------[ cut here ]---------=
---
Dec  2 20:38:04 sf kernel: [13038.095587] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:793 intel_enable_pipe+0x136/0x160 [i915]()
Dec  2 20:38:04 sf kernel: [13038.095592] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:38:04 sf kernel: [13038.095597] PLL state assertion failure (expe=
cted on, current off)
Dec  2 20:38:04 sf kernel: [13038.095601] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:38:04 sf kernel: [13038.095660] Pid: 2107, comm: X Tainted: G    =
    W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:38:04 sf kernel: [13038.095665] Call Trace:
Dec  2 20:38:04 sf kernel: [13038.095676]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:38:04 sf kernel: [13038.095685]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:38:04 sf kernel: [13038.095695]  [<ffffffff8125b0a0>] ? delay_tsc=
+0x90/0xf0
Dec  2 20:38:04 sf kernel: [13038.095724]  [<ffffffffa012c196>] intel_enabl=
e_pipe+0x136/0x160 [i915]
Dec  2 20:38:04 sf kernel: [13038.095753]  [<ffffffffa012fa30>] i9xx_crtc_e=
nable+0x140/0x1a0 [i915]
Dec  2 20:38:04 sf kernel: [13038.095781]  [<ffffffffa012fa99>] i9xx_crtc_c=
ommit+0x9/0x10 [i915]
Dec  2 20:38:04 sf kernel: [13038.095794]  [<ffffffffa01030a5>] drm_crtc_he=
lper_set_mode+0x3a5/0x4d0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.095813]  [<ffffffffa0103ce9>] drm_crtc_he=
lper_set_config+0x9b9/0xa40 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.095827]  [<ffffffffa0101c03>] drm_fb_help=
er_set_par+0x73/0xe0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.095836]  [<ffffffff81281f4e>] fb_set_var+=
0x16e/0x380
Dec  2 20:38:04 sf kernel: [13038.095846]  [<ffffffff81038429>] ? finish_ta=
sk_switch+0x49/0xd0
Dec  2 20:38:04 sf kernel: [13038.095854]  [<ffffffff81432bfe>] ? __schedul=
e+0x46e/0xa90
Dec  2 20:38:04 sf kernel: [13038.095863]  [<ffffffff810395f2>] ? check_pre=
empt_wakeup+0x102/0x1d0
Dec  2 20:38:04 sf kernel: [13038.095872]  [<ffffffff8128f7bb>] fbcon_blank=
+0x1eb/0x2f0
Dec  2 20:38:04 sf kernel: [13038.095882]  [<ffffffff812e4351>] do_unblank_=
screen+0xb1/0x1f0
Dec  2 20:38:04 sf kernel: [13038.095891]  [<ffffffff812d9c20>] complete_ch=
ange_console+0x60/0x100
Dec  2 20:38:04 sf kernel: [13038.095899]  [<ffffffff812db82b>] vt_ioctl+0x=
1b6b/0x20d0
Dec  2 20:38:04 sf kernel: [13038.095907]  [<ffffffff810bc55c>] ? handle_pt=
e_fault+0x7c/0x7b0
Dec  2 20:38:04 sf kernel: [13038.095917]  [<ffffffff812d07d0>] tty_ioctl+0=
x2b0/0xcf0
Dec  2 20:38:04 sf kernel: [13038.095925]  [<ffffffff81025b1c>] ? do_page_f=
ault+0x1bc/0x440
Dec  2 20:38:04 sf kernel: [13038.095934]  [<ffffffff810f5407>] do_vfs_ioct=
l+0x97/0x5d0
Dec  2 20:38:04 sf kernel: [13038.095943]  [<ffffffff810e40a8>] ? vfs_write=
+0x158/0x180
Dec  2 20:38:04 sf kernel: [13038.095951]  [<ffffffff810f598a>] sys_ioctl+0=
x4a/0x80
Dec  2 20:38:04 sf kernel: [13038.095959]  [<ffffffff814362fb>] system_call=
_fastpath+0x16/0x1b
Dec  2 20:38:04 sf kernel: [13038.095966] ---[ end trace 7a713f1eaae715ae ]=
---
Dec  2 20:38:04 sf kernel: [13038.147095] ------------[ cut here ]---------=
---
Dec  2 20:38:04 sf kernel: [13038.147124] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:930 assert_pipe+0x72/0x80 [i915]()
Dec  2 20:38:04 sf kernel: [13038.147129] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:38:04 sf kernel: [13038.147134] pipe A assertion failure (expecte=
d on, current off)
Dec  2 20:38:04 sf kernel: [13038.147138] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:38:04 sf kernel: [13038.147195] Pid: 2107, comm: X Tainted: G    =
    W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:38:04 sf kernel: [13038.147200] Call Trace:
Dec  2 20:38:04 sf kernel: [13038.147210]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:38:04 sf kernel: [13038.147218]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:38:04 sf kernel: [13038.147228]  [<ffffffff81433969>] ? schedule_=
timeout_uninterruptible+0x19/0x20
Dec  2 20:38:04 sf kernel: [13038.147257]  [<ffffffffa012a242>] assert_pipe=
+0x72/0x80 [i915]
Dec  2 20:38:04 sf kernel: [13038.147284]  [<ffffffffa012c1f8>] intel_enabl=
e_plane+0x38/0x90 [i915]
Dec  2 20:38:04 sf kernel: [13038.147312]  [<ffffffffa012fa3e>] i9xx_crtc_e=
nable+0x14e/0x1a0 [i915]
Dec  2 20:38:04 sf kernel: [13038.147340]  [<ffffffffa012fa99>] i9xx_crtc_c=
ommit+0x9/0x10 [i915]
Dec  2 20:38:04 sf kernel: [13038.147353]  [<ffffffffa01030a5>] drm_crtc_he=
lper_set_mode+0x3a5/0x4d0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.147371]  [<ffffffffa0103ce9>] drm_crtc_he=
lper_set_config+0x9b9/0xa40 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.147385]  [<ffffffffa0101c03>] drm_fb_help=
er_set_par+0x73/0xe0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.147394]  [<ffffffff81281f4e>] fb_set_var+=
0x16e/0x380
Dec  2 20:38:04 sf kernel: [13038.147404]  [<ffffffff81038429>] ? finish_ta=
sk_switch+0x49/0xd0
Dec  2 20:38:04 sf kernel: [13038.147411]  [<ffffffff81432bfe>] ? __schedul=
e+0x46e/0xa90
Dec  2 20:38:04 sf kernel: [13038.147420]  [<ffffffff810395f2>] ? check_pre=
empt_wakeup+0x102/0x1d0
Dec  2 20:38:04 sf kernel: [13038.147429]  [<ffffffff8128f7bb>] fbcon_blank=
+0x1eb/0x2f0
Dec  2 20:38:04 sf kernel: [13038.147439]  [<ffffffff812e4351>] do_unblank_=
screen+0xb1/0x1f0
Dec  2 20:38:04 sf kernel: [13038.147448]  [<ffffffff812d9c20>] complete_ch=
ange_console+0x60/0x100
Dec  2 20:38:04 sf kernel: [13038.147456]  [<ffffffff812db82b>] vt_ioctl+0x=
1b6b/0x20d0
Dec  2 20:38:04 sf kernel: [13038.147464]  [<ffffffff810bc55c>] ? handle_pt=
e_fault+0x7c/0x7b0
Dec  2 20:38:04 sf kernel: [13038.147474]  [<ffffffff812d07d0>] tty_ioctl+0=
x2b0/0xcf0
Dec  2 20:38:04 sf kernel: [13038.147482]  [<ffffffff81025b1c>] ? do_page_f=
ault+0x1bc/0x440
Dec  2 20:38:04 sf kernel: [13038.147491]  [<ffffffff810f5407>] do_vfs_ioct=
l+0x97/0x5d0
Dec  2 20:38:04 sf kernel: [13038.147500]  [<ffffffff810e40a8>] ? vfs_write=
+0x158/0x180
Dec  2 20:38:04 sf kernel: [13038.147508]  [<ffffffff810f598a>] sys_ioctl+0=
x4a/0x80
Dec  2 20:38:04 sf kernel: [13038.147516]  [<ffffffff814362fb>] system_call=
_fastpath+0x16/0x1b
Dec  2 20:38:04 sf kernel: [13038.147523] ---[ end trace 7a713f1eaae715af ]=
---
Dec  2 20:38:04 sf kernel: [13038.251620] [drm] Changing LVDS panel from (+=
hsync, +vsync) to (-hsync, -vsync)
Dec  2 20:38:04 sf kernel: [13038.251780] ------------[ cut here ]---------=
---
Dec  2 20:38:04 sf kernel: [13038.251810] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:793 intel_enable_pipe+0x136/0x160 [i915]()
Dec  2 20:38:04 sf kernel: [13038.251816] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:38:04 sf kernel: [13038.251821] PLL state assertion failure (expe=
cted on, current off)
Dec  2 20:38:04 sf kernel: [13038.251825] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:38:04 sf kernel: [13038.251884] Pid: 2107, comm: X Tainted: G    =
    W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:38:04 sf kernel: [13038.251889] Call Trace:
Dec  2 20:38:04 sf kernel: [13038.251900]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:38:04 sf kernel: [13038.251908]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:38:04 sf kernel: [13038.251919]  [<ffffffff8125b0a0>] ? delay_tsc=
+0x90/0xf0
Dec  2 20:38:04 sf kernel: [13038.251948]  [<ffffffffa012c196>] intel_enabl=
e_pipe+0x136/0x160 [i915]
Dec  2 20:38:04 sf kernel: [13038.251977]  [<ffffffffa012f217>] i9xx_crtc_m=
ode_set+0x707/0xde0 [i915]
Dec  2 20:38:04 sf kernel: [13038.251987]  [<ffffffff8103ec2d>] ? sub_preem=
pt_count+0x9d/0xd0
Dec  2 20:38:04 sf kernel: [13038.251996]  [<ffffffff81435662>] ? _raw_spin=
_unlock_irqrestore+0x12/0x40
Dec  2 20:38:04 sf kernel: [13038.252042]  [<ffffffffa012aaca>] intel_crtc_=
mode_set+0x6a/0xa0 [i915]
Dec  2 20:38:04 sf kernel: [13038.252055]  [<ffffffffa0103059>] drm_crtc_he=
lper_set_mode+0x359/0x4d0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.252075]  [<ffffffffa0103ce9>] drm_crtc_he=
lper_set_config+0x9b9/0xa40 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.252089]  [<ffffffffa0101c03>] drm_fb_help=
er_set_par+0x73/0xe0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.252101]  [<ffffffffa0101dce>] drm_fb_help=
er_single_fb_probe+0x15e/0x2d0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.252113]  [<ffffffffa0101b52>] drm_fb_help=
er_hotplug_event+0x112/0x150 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.252126]  [<ffffffffa0101c47>] drm_fb_help=
er_set_par+0xb7/0xe0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.252134]  [<ffffffff81281f4e>] fb_set_var+=
0x16e/0x380
Dec  2 20:38:04 sf kernel: [13038.252144]  [<ffffffff81038429>] ? finish_ta=
sk_switch+0x49/0xd0
Dec  2 20:38:04 sf kernel: [13038.252152]  [<ffffffff81432bfe>] ? __schedul=
e+0x46e/0xa90
Dec  2 20:38:04 sf kernel: [13038.252160]  [<ffffffff810395f2>] ? check_pre=
empt_wakeup+0x102/0x1d0
Dec  2 20:38:04 sf kernel: [13038.252170]  [<ffffffff8128f7bb>] fbcon_blank=
+0x1eb/0x2f0
Dec  2 20:38:04 sf kernel: [13038.252180]  [<ffffffff812e4351>] do_unblank_=
screen+0xb1/0x1f0
Dec  2 20:38:04 sf kernel: [13038.252188]  [<ffffffff812d9c20>] complete_ch=
ange_console+0x60/0x100
Dec  2 20:38:04 sf kernel: [13038.252197]  [<ffffffff812db82b>] vt_ioctl+0x=
1b6b/0x20d0
Dec  2 20:38:04 sf kernel: [13038.252205]  [<ffffffff810bc55c>] ? handle_pt=
e_fault+0x7c/0x7b0
Dec  2 20:38:04 sf kernel: [13038.252215]  [<ffffffff812d07d0>] tty_ioctl+0=
x2b0/0xcf0
Dec  2 20:38:04 sf kernel: [13038.252222]  [<ffffffff81025b1c>] ? do_page_f=
ault+0x1bc/0x440
Dec  2 20:38:04 sf kernel: [13038.252232]  [<ffffffff810f5407>] do_vfs_ioct=
l+0x97/0x5d0
Dec  2 20:38:04 sf kernel: [13038.252240]  [<ffffffff810e40a8>] ? vfs_write=
+0x158/0x180
Dec  2 20:38:04 sf kernel: [13038.252248]  [<ffffffff810f598a>] sys_ioctl+0=
x4a/0x80
Dec  2 20:38:04 sf kernel: [13038.252257]  [<ffffffff814362fb>] system_call=
_fastpath+0x16/0x1b
Dec  2 20:38:04 sf kernel: [13038.252263] ---[ end trace 7a713f1eaae715b0 ]=
---
Dec  2 20:38:04 sf kernel: [13038.356094] ------------[ cut here ]---------=
---
Dec  2 20:38:04 sf kernel: [13038.356121] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:930 assert_pipe+0x72/0x80 [i915]()
Dec  2 20:38:04 sf kernel: [13038.356127] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:38:04 sf kernel: [13038.356132] pipe B assertion failure (expecte=
d on, current off)
Dec  2 20:38:04 sf kernel: [13038.356136] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:38:04 sf kernel: [13038.356193] Pid: 2107, comm: X Tainted: G    =
    W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:38:04 sf kernel: [13038.356198] Call Trace:
Dec  2 20:38:04 sf kernel: [13038.356207]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:38:04 sf kernel: [13038.356215]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:38:04 sf kernel: [13038.356244]  [<ffffffffa012a242>] assert_pipe=
+0x72/0x80 [i915]
Dec  2 20:38:04 sf kernel: [13038.356271]  [<ffffffffa012c1f8>] intel_enabl=
e_plane+0x38/0x90 [i915]
Dec  2 20:38:04 sf kernel: [13038.356298]  [<ffffffffa012f24d>] i9xx_crtc_m=
ode_set+0x73d/0xde0 [i915]
Dec  2 20:38:04 sf kernel: [13038.356308]  [<ffffffff8103ec2d>] ? sub_preem=
pt_count+0x9d/0xd0
Dec  2 20:38:04 sf kernel: [13038.356316]  [<ffffffff81435662>] ? _raw_spin=
_unlock_irqrestore+0x12/0x40
Dec  2 20:38:04 sf kernel: [13038.356345]  [<ffffffffa012aaca>] intel_crtc_=
mode_set+0x6a/0xa0 [i915]
Dec  2 20:38:04 sf kernel: [13038.356358]  [<ffffffffa0103059>] drm_crtc_he=
lper_set_mode+0x359/0x4d0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.356377]  [<ffffffffa0103ce9>] drm_crtc_he=
lper_set_config+0x9b9/0xa40 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.356391]  [<ffffffffa0101c03>] drm_fb_help=
er_set_par+0x73/0xe0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.356402]  [<ffffffffa0101dce>] drm_fb_help=
er_single_fb_probe+0x15e/0x2d0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.356415]  [<ffffffffa0101b52>] drm_fb_help=
er_hotplug_event+0x112/0x150 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.356427]  [<ffffffffa0101c47>] drm_fb_help=
er_set_par+0xb7/0xe0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.356435]  [<ffffffff81281f4e>] fb_set_var+=
0x16e/0x380
Dec  2 20:38:04 sf kernel: [13038.356445]  [<ffffffff81038429>] ? finish_ta=
sk_switch+0x49/0xd0
Dec  2 20:38:04 sf kernel: [13038.356452]  [<ffffffff81432bfe>] ? __schedul=
e+0x46e/0xa90
Dec  2 20:38:04 sf kernel: [13038.356461]  [<ffffffff810395f2>] ? check_pre=
empt_wakeup+0x102/0x1d0
Dec  2 20:38:04 sf kernel: [13038.356470]  [<ffffffff8128f7bb>] fbcon_blank=
+0x1eb/0x2f0
Dec  2 20:38:04 sf kernel: [13038.356479]  [<ffffffff812e4351>] do_unblank_=
screen+0xb1/0x1f0
Dec  2 20:38:04 sf kernel: [13038.356488]  [<ffffffff812d9c20>] complete_ch=
ange_console+0x60/0x100
Dec  2 20:38:04 sf kernel: [13038.356496]  [<ffffffff812db82b>] vt_ioctl+0x=
1b6b/0x20d0
Dec  2 20:38:04 sf kernel: [13038.356504]  [<ffffffff810bc55c>] ? handle_pt=
e_fault+0x7c/0x7b0
Dec  2 20:38:04 sf kernel: [13038.356514]  [<ffffffff812d07d0>] tty_ioctl+0=
x2b0/0xcf0
Dec  2 20:38:04 sf kernel: [13038.356521]  [<ffffffff81025b1c>] ? do_page_f=
ault+0x1bc/0x440
Dec  2 20:38:04 sf kernel: [13038.356530]  [<ffffffff810f5407>] do_vfs_ioct=
l+0x97/0x5d0
Dec  2 20:38:04 sf kernel: [13038.356539]  [<ffffffff810e40a8>] ? vfs_write=
+0x158/0x180
Dec  2 20:38:04 sf kernel: [13038.356547]  [<ffffffff810f598a>] sys_ioctl+0=
x4a/0x80
Dec  2 20:38:04 sf kernel: [13038.356555]  [<ffffffff814362fb>] system_call=
_fastpath+0x16/0x1b
Dec  2 20:38:04 sf kernel: [13038.356562] ---[ end trace 7a713f1eaae715b1 ]=
---
Dec  2 20:38:04 sf kernel: [13038.408519] ------------[ cut here ]---------=
---
Dec  2 20:38:04 sf kernel: [13038.408551] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:793 intel_enable_pipe+0x136/0x160 [i915]()
Dec  2 20:38:04 sf kernel: [13038.408557] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:38:04 sf kernel: [13038.408561] PLL state assertion failure (expe=
cted on, current off)
Dec  2 20:38:04 sf kernel: [13038.408565] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:38:04 sf kernel: [13038.408623] Pid: 2107, comm: X Tainted: G    =
    W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:38:04 sf kernel: [13038.408629] Call Trace:
Dec  2 20:38:04 sf kernel: [13038.408639]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:38:04 sf kernel: [13038.408648]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:38:04 sf kernel: [13038.408657]  [<ffffffff8125b0a0>] ? delay_tsc=
+0x90/0xf0
Dec  2 20:38:04 sf kernel: [13038.408687]  [<ffffffffa012c196>] intel_enabl=
e_pipe+0x136/0x160 [i915]
Dec  2 20:38:04 sf kernel: [13038.408715]  [<ffffffffa012fa30>] i9xx_crtc_e=
nable+0x140/0x1a0 [i915]
Dec  2 20:38:04 sf kernel: [13038.408743]  [<ffffffffa012fa99>] i9xx_crtc_c=
ommit+0x9/0x10 [i915]
Dec  2 20:38:04 sf kernel: [13038.408757]  [<ffffffffa01030a5>] drm_crtc_he=
lper_set_mode+0x3a5/0x4d0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.408775]  [<ffffffffa0103ce9>] drm_crtc_he=
lper_set_config+0x9b9/0xa40 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.408790]  [<ffffffffa0101c03>] drm_fb_help=
er_set_par+0x73/0xe0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.408802]  [<ffffffffa0101dce>] drm_fb_help=
er_single_fb_probe+0x15e/0x2d0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.408815]  [<ffffffffa0101b52>] drm_fb_help=
er_hotplug_event+0x112/0x150 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.408827]  [<ffffffffa0101c47>] drm_fb_help=
er_set_par+0xb7/0xe0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.408836]  [<ffffffff81281f4e>] fb_set_var+=
0x16e/0x380
Dec  2 20:38:04 sf kernel: [13038.408846]  [<ffffffff81038429>] ? finish_ta=
sk_switch+0x49/0xd0
Dec  2 20:38:04 sf kernel: [13038.408854]  [<ffffffff81432bfe>] ? __schedul=
e+0x46e/0xa90
Dec  2 20:38:04 sf kernel: [13038.408862]  [<ffffffff810395f2>] ? check_pre=
empt_wakeup+0x102/0x1d0
Dec  2 20:38:04 sf kernel: [13038.408871]  [<ffffffff8128f7bb>] fbcon_blank=
+0x1eb/0x2f0
Dec  2 20:38:04 sf kernel: [13038.408881]  [<ffffffff812e4351>] do_unblank_=
screen+0xb1/0x1f0
Dec  2 20:38:04 sf kernel: [13038.408890]  [<ffffffff812d9c20>] complete_ch=
ange_console+0x60/0x100
Dec  2 20:38:04 sf kernel: [13038.408898]  [<ffffffff812db82b>] vt_ioctl+0x=
1b6b/0x20d0
Dec  2 20:38:04 sf kernel: [13038.408906]  [<ffffffff810bc55c>] ? handle_pt=
e_fault+0x7c/0x7b0
Dec  2 20:38:04 sf kernel: [13038.408916]  [<ffffffff812d07d0>] tty_ioctl+0=
x2b0/0xcf0
Dec  2 20:38:04 sf kernel: [13038.408924]  [<ffffffff81025b1c>] ? do_page_f=
ault+0x1bc/0x440
Dec  2 20:38:04 sf kernel: [13038.408933]  [<ffffffff810f5407>] do_vfs_ioct=
l+0x97/0x5d0
Dec  2 20:38:04 sf kernel: [13038.408942]  [<ffffffff810e40a8>] ? vfs_write=
+0x158/0x180
Dec  2 20:38:04 sf kernel: [13038.408950]  [<ffffffff810f598a>] sys_ioctl+0=
x4a/0x80
Dec  2 20:38:04 sf kernel: [13038.408958]  [<ffffffff814362fb>] system_call=
_fastpath+0x16/0x1b
Dec  2 20:38:04 sf kernel: [13038.408964] ---[ end trace 7a713f1eaae715b2 ]=
---
Dec  2 20:38:04 sf kernel: [13038.460086] ------------[ cut here ]---------=
---
Dec  2 20:38:04 sf kernel: [13038.460117] WARNING: at drivers/gpu/drm/i915/=
intel_display.c:930 assert_pipe+0x72/0x80 [i915]()
Dec  2 20:38:04 sf kernel: [13038.460123] Hardware name: HP Compaq 2510p No=
tebook PC
Dec  2 20:38:04 sf kernel: [13038.460129] pipe B assertion failure (expecte=
d on, current off)
Dec  2 20:38:04 sf kernel: [13038.460133] Modules linked in: snd_seq_dummy =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer=
_oss ext2 loop kvm_intel kvm fuse scsi_wait_scan usb_storage tun snd_hda_co=
dec_analog snd_hda_intel snd_hda_codec iwl4965 snd_hwdep snd_pcm iwl_legacy=
 snd_timer snd yenta_socket soundcore e1000e pcmcia_core i915 drm_kms_helpe=
r mac80211 drm sdhci_pci sdhci cfg80211 rfkill mmc_core i2c_algo_bit pcmcia=
_rsrc snd_page_alloc
Dec  2 20:38:04 sf kernel: [13038.460190] Pid: 2107, comm: X Tainted: G    =
    W    3.2.0-rc3-00099-g883381d #163
Dec  2 20:38:04 sf kernel: [13038.460195] Call Trace:
Dec  2 20:38:04 sf kernel: [13038.460206]  [<ffffffff81046a2a>] warn_slowpa=
th_common+0x7a/0xb0
Dec  2 20:38:04 sf kernel: [13038.460214]  [<ffffffff81046b01>] warn_slowpa=
th_fmt+0x41/0x50
Dec  2 20:38:04 sf kernel: [13038.460224]  [<ffffffff81433969>] ? schedule_=
timeout_uninterruptible+0x19/0x20
Dec  2 20:38:04 sf kernel: [13038.460253]  [<ffffffffa012a242>] assert_pipe=
+0x72/0x80 [i915]
Dec  2 20:38:04 sf kernel: [13038.460281]  [<ffffffffa012c1f8>] intel_enabl=
e_plane+0x38/0x90 [i915]
Dec  2 20:38:04 sf kernel: [13038.460309]  [<ffffffffa012fa3e>] i9xx_crtc_e=
nable+0x14e/0x1a0 [i915]
Dec  2 20:38:04 sf kernel: [13038.460337]  [<ffffffffa012fa99>] i9xx_crtc_c=
ommit+0x9/0x10 [i915]
Dec  2 20:38:04 sf kernel: [13038.460350]  [<ffffffffa01030a5>] drm_crtc_he=
lper_set_mode+0x3a5/0x4d0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.460369]  [<ffffffffa0103ce9>] drm_crtc_he=
lper_set_config+0x9b9/0xa40 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.460384]  [<ffffffffa0101c03>] drm_fb_help=
er_set_par+0x73/0xe0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.460395]  [<ffffffffa0101dce>] drm_fb_help=
er_single_fb_probe+0x15e/0x2d0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.460408]  [<ffffffffa0101b52>] drm_fb_help=
er_hotplug_event+0x112/0x150 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.460420]  [<ffffffffa0101c47>] drm_fb_help=
er_set_par+0xb7/0xe0 [drm_kms_helper]
Dec  2 20:38:04 sf kernel: [13038.460428]  [<ffffffff81281f4e>] fb_set_var+=
0x16e/0x380
Dec  2 20:38:04 sf kernel: [13038.460438]  [<ffffffff81038429>] ? finish_ta=
sk_switch+0x49/0xd0
Dec  2 20:38:04 sf kernel: [13038.460446]  [<ffffffff81432bfe>] ? __schedul=
e+0x46e/0xa90
Dec  2 20:38:04 sf kernel: [13038.460454]  [<ffffffff810395f2>] ? check_pre=
empt_wakeup+0x102/0x1d0
Dec  2 20:38:04 sf kernel: [13038.460464]  [<ffffffff8128f7bb>] fbcon_blank=
+0x1eb/0x2f0
Dec  2 20:38:04 sf kernel: [13038.460473]  [<ffffffff812e4351>] do_unblank_=
screen+0xb1/0x1f0
Dec  2 20:38:04 sf kernel: [13038.460482]  [<ffffffff812d9c20>] complete_ch=
ange_console+0x60/0x100
Dec  2 20:38:04 sf kernel: [13038.460490]  [<ffffffff812db82b>] vt_ioctl+0x=
1b6b/0x20d0
Dec  2 20:38:04 sf kernel: [13038.460498]  [<ffffffff810bc55c>] ? handle_pt=
e_fault+0x7c/0x7b0
Dec  2 20:38:04 sf kernel: [13038.460508]  [<ffffffff812d07d0>] tty_ioctl+0=
x2b0/0xcf0
Dec  2 20:38:04 sf kernel: [13038.460516]  [<ffffffff81025b1c>] ? do_page_f=
ault+0x1bc/0x440
Dec  2 20:38:04 sf kernel: [13038.460525]  [<ffffffff810f5407>] do_vfs_ioct=
l+0x97/0x5d0
Dec  2 20:38:04 sf kernel: [13038.460533]  [<ffffffff810e40a8>] ? vfs_write=
+0x158/0x180
Dec  2 20:38:04 sf kernel: [13038.460542]  [<ffffffff810f598a>] sys_ioctl+0=
x4a/0x80
Dec  2 20:38:04 sf kernel: [13038.460550]  [<ffffffff814362fb>] system_call=
_fastpath+0x16/0x1b
Dec  2 20:38:04 sf kernel: [13038.460556] ---[ end trace 7a713f1eaae715b3 ]=
---
Dec  2 20:38:04 sf kernel: [13039.514097] [drm:intel_lvds_enable] *ERROR* t=
imed out waiting for panel to power on
Dec  2 20:38:18 sf kernel: [13053.657417] e1000e 0000:00:19.0: irq 44 for M=
SI/MSI-X
Dec  2 20:38:18 sf kernel: [13053.708196] e1000e 0000:00:19.0: irq 44 for M=
SI/MSI-X
Dec  2 20:38:20 sf kernel: [13055.080923] e1000e: eth0 NIC Link is Up 100 M=
bps Full Duplex, Flow Control: Rx/Tx
Dec  2 20:38:20 sf kernel: [13055.080934] e1000e 0000:00:19.0: eth0: 10/100=
 speed: disabling TSO

--MP_/7P+D6MDvabUSe5j7xKYK4Ba--

--Sig_/hxDncaSLdo+5RCmM+HMDyma
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk7ZETQACgkQcaHudmEf86rGOACdEdfLOyiKbfcHWGAWJjvJVdbS
5XgAnjEwAbSoxcymrLZiM/7soqzyZrXM
=FgWv
-----END PGP SIGNATURE-----

--Sig_/hxDncaSLdo+5RCmM+HMDyma--
