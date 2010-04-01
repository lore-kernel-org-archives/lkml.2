Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0DAJao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 05:30:44 -0400
Received: from outgoing.selfhost.de ([82.98.87.70]:59878 "EHLO
	outgoing.selfhost.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab0DAJah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 05:30:37 -0400
Message-ID: <4BB467AD.7070001@afaics.de>
Date: Thu, 01 Apr 2010 11:30:21 +0200
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Thunderbird/3.0.4
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.1 regression: sound splutters
References: <4BB1E34B.5030207@darkharri.de> <s5hhbnx1xen.wl%tiwai@suse.de>
In-Reply-To: <s5hhbnx1xen.wl%tiwai@suse.de>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig18081BB84EE1F92BB9194838"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig18081BB84EE1F92BB9194838
Content-Type: multipart/mixed;
 boundary="------------020101010604090806020303"

This is a multi-part message in MIME format.
--------------020101010604090806020303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/30/10 20:23, Takashi Iwai wrote:
> At Tue, 30 Mar 2010 13:40:59 +0200,
> Harald Dunkel wrote:
>>
>> With 2.6.33.1 and 2.6.34-rc2 sound splutters for my PC. Moving
>> back to 2.6.29.8 makes the problem go away.
>=20
> Hm, it's a bit old to bisect.  What about 2.6.32.*?
>=20

Sorry, that was a typo. The good version is 2.6.32.8.

>=20
> First try the freshly released 2.6.34-rc3.  If the problem persists,
> run alsa-info.sh with --no-upload option, and attach the generated file=

> for further analysis.

Same problem with rc3. See attachment.


Regards

Harri

--------------020101010604090806020303
Content-Type: application/x-tar;
 name="alsa-info.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="alsa-info.txt.gz"

H4sICE9mtEsAA2Fsc2EtaW5mby50eHQA7T1rd+LGkp9Hv6Jzc3Y9kzW4WwKMOet7LgN4ho2x
vcYzSdbXhyOkButar0jCj+zJ/vat6paEAImHDZnJOBqPUL+q69VVpUdJE9/2dPM4Cib830Mj
sPxIHht6YFruyDtWvvvu+xUbdGme9pukC/0DR48szyV9AYvcE1qulKtH60CBPvGoQHeJ5zbI
1e2ENP2AEEboUUOtNDRKPl21iEoZVbD/qeVOHknbCqPAGk5wYqgsLWyK0uZDC4B+OPt0IMeE
v044/40fhJZJ/umSf9oCXrvXzVKxCExRero7GelGNAl40CByUy4Cz5wYETnTHZ5WIsAfeeBy
ezlMATbuGHCb66GEoZZrZa1SCgxNOfd5AKPdMek/hRF3oD0lRWkGxq0VcYFSPLlVq9cQKYOH
oZeiScjEvXO9B1fp9y5Ix9WHNjeTxl94KDAWkvzMg3ARV2BjYN3zgNzLZjmUlWlZVctMObWG
gR48zbTKRuVTZNlWZPEw0xg3CTGCCnKTiKkd4KQNuOSxCTAIXXNwa+oDy424lFnfm7gm6fMA
QYPakOjWCkko+JQPJQPuzCOhGB/G40dYKk8B4zoIQSyGN3atEJAcPgk8V0AG0ISS6y5imXKf
3DTIx3azJGtLeEzEsUJyt7Sd6BGhj2ZFq1DYiBX8Slhd4HjR6pIMnpYbRroNUoUj4ANfjw1Z
rCltsGGZkubEtDxi8nvLAKWSWLS8wPcCub7rap2yk/cHJ+97ByeXByc/wf4n8rbb+lgjJ7pj
2U/vyEdrfEvafGS5lhgjYbY8Nwo8QDIgbwMOBqLyTqFag1KYtTexI8vhpqWTe8vkHjHSzhIJ
WCSPEYBw/ABUG4F2XYNYV59brEbetn5WtQqrvSO9i86HkgoqbnhmOg97JxXcvNddQ7Boaq5K
BDn5mbumFxy0BdUH/Uk4lPwj3fZegUZuyFZaAVJJndZrDbVWq0858KY/iSdrEJ3qtEGrh1UF
hr65CPiIR8YtrlbicMeDJTbktxYo7TCwzDGIh8ZbharitzSt0Ea4AXjQYNfE5QkaEk3CBqnV
eh9/K4Gwwui9+h4YoAedICiRdudzv3N6PIJ68ver5tALohL5z/Sglxz0O5eX8HOBP4KxPc/0
A2/IiecjT0PyVi5NsGl6xM13azBQrO8SiMR69EtgCZAbQCh/PC6pokks+/ojna+/t/S6+viY
O8Y3Qn+uarczZEyaNC7SpiV8WcqHmJHQvUFmbd2boWkPfC8c6Oa/SIOw/dIO/5Q3XLgHmOiX
/Rf9SyANnNACaAgaXG6DvHUntv1u/1v9ASpRHQTFO5YUaqT9GjgKyi8cyWBkIWPp/ov+ATy0
VgNHD+/+CDHJ2TzXfoLZzvZf9E95E0IwCIvKcHAtnQmTMw0tWqARRta/LTe94GbAKQSRAY5W
90OOVkiAaJBLrtsRv4OQp1WvU6Vpmuh3G0RVTiauIVxnF0JI+sgU6TyTIuUGxRGpW4sb0Lfh
plyCkw0z4ymtQy3EYz00sCQF/yHwJr4MyyCKH+kQIYCv7jVEzATBCMSU1/SxWqMQXFUqAIZU
6hgkHdVwz47QI4q+QysSXTl0hGBBpUStiAbJJdHGoA2ApxM1HR9YSgzgCnD5oDnTcD6JMi0f
Lrrn4AO8Y3WfeMd0n1i4m7ihZ1sGhOfmMdsnD/odP0Z0uufXiLA0jdjRtAL8kR32wUlbxt2T
aNAjPYWUjGXPG3sGrAVeU5Vcy1gMSPAn0Q15QDqgpcJYg/QhzOIeTNSOoz8XzmqO/yZVgDRd
3fbGf9sn0ZOPtQgHSjJSFPhBgAehdIQhG5yXcd1BFCB+ceEER3TYufhgCu8B4j4MdTjIh7Qp
aTPSVklbSxoBOR7hKdVxG9DDEzrdhsOUR9p6PPo2iK3sjFiWT+wXobL6KqisFVGpTqkkbWts
wZmipBbPsJJV3u20jqp1cmHrT0PduMNm0gMPCUtcxrd0fq0vG30ReC8YHRvb5w3uP1hw0rTR
2Ix7WRNOroWMeZuayP5Fu3syNZFsHRWLYTSmh+BqIj6Gkz/0ls/XQpZVQ6KpRZqYaNNhok1d
d0aZYI4qG6b6JB1lDmdxFF6hCAy+nixauo8XsjaSXzLms2dPnKJ5nunNZkIAbxQeA1MAsAsx
jY8FVUOPC8fWbxzboOhMIinmeOy9buNavsaRyFN6s63jdVSp3+6W+tzmRgSa82y9qSVqswvT
JahwuQj4GuRQXg4D0PUfcH+EOx13Q9wZuKvgrppqaX0HWsqeoaVrjZnTUvZSLVX/0tI/h5Ye
7UBL1Wdo6Vpj5rRU/fMYxVerkoyu1kk6nCom7mq4O0xVVC9WUe1o/fDxOU58bujy4G9ngde8
0L94IEbIp+k1hAaJ9PExLjV59m8eL+hAqgKjVKjDRKg965EHmRMCShldbXd6ljENh5eGWOlQ
ANUAtobHmrw60XVhgCm6C2uxYpKlavOCSU4CKJMt0sM2meplVBVPdWq5fFsEqWvO8jJaimdp
tbdFSWWtOV5GR2aOHI+ITjD1iBW2gUeso5eqS4+16bGu4VVWrbDPnL2oT11GURRj5oQyxjKT
MpozKcnV0qJV8kKJA+T1Fv72tXdVHETprNTppnFQ3G96qVlOUslOUqH5qkUzg6ezqCg/lc/r
gZroAVWFy0glbW5H0v1JEIh7obsX9uJUX6e8C1bnluU9G/HmyFublTffjrxbHJ/WeLa02drS
Pj3pPHsWde1Z5snZUKPY2l42S82Gk6ivSm0rs2o72pKZsswXx1LrmKiZaf4yT0vkXJ2RM6OJ
nOVJmpcRtYainruRkwKspACNH6RbE7YONSeFzXYIW90hbG2HsCvk+sJyxRN3Nn/M3DIDwHVz
Zl3JBZWnHxspYaF+AB4AVBRx02BVd8/I+acr8vGCtDk+AUuuAms8BkPddfw+d0Muh6V3dmAs
sKMCuwa5/i9YezdEnNfgnHpEOo8RPvEQJMvOJceEHdT34dj2Aih8CDh3RStAbIahZ1jy+cFj
5NU+CODXCXcNLspUTl4yIiQGWdZAbJ99Rk+NVCrVb1AqtQpTnyeV80B3x3xdsajbFouZiqX2
DYqFiZvjzxHLexvGrCsVtm2p8FQqh9+gVNQKqzzbhD2tK5TKtoUy9Sv1LyyUTEQzIxSmrSsU
Qj4HfBTj87H7P6RKSZ3mSEtnR4Y2dTh4TXAdQQGYwtWjrXA1akXQ8PmyczIQOD3zGnL6VAk7
ejXyUlFelVx5ictIzxJY5Q8SGEsFpr8agbE606g256TgVGY9HzUpDBzmF9m8i1LpVGaA3vOF
pqZCG74aoakQhhtqcRi+fKktjcPVVWttW3LTUrkZxXKjM6dfcwGARGWBO0dHmsaYhuHwifXI
zRvSaiNjum5EmlfNi26WMaJizahrXqXlaXbPCg0onp0PLi47/c5ZqzPHMUobKanmMlKBnJ7n
rk8oxJawjVANzg6aN6Tvc/0OFOrF4eUoRwc2JJQXE6olhGZuhM8RzNJQad5aVZBoniq+uEm9
LHq7bDWfGVPz9YkuCthqKTtGxexQV7OjQP6UGVWNVekcN4qN97kfWYZur2fAqy9WApWS6ziv
QeQxcpP8hCl3mScjRiLNbqr3MukWU3WlDRxy1xq7eFHPNTw+Gh1PgyqVAXRxiZH86HrDBdD4
zEB9Clp2LWHXBjG5LZ/tl4a+VhEXBUGAWAcG/VitbmrYqFIqAa3ZLJAkH1g+bkFcwDs3fU1R
jOChBH+w/QdhJPA80GdxTYqx2j45StK44VwSzscOTH5/ELrmQZze2aIrxtcLxvuG06JtaqwY
fpgdXl8Y7q8YXls6O1s1e3X58FWzV5YOV1fNrhUMD/mvK0aqBSMxQzdQlLQ8fCr5enTbUCIP
H4+hihk8PAYl/AMYAqrYkRqdhVjO9tQyPVV1vmdZsbGr+EtQlUDZHJq+YYn010aSclv6OwzP
aFqq1FA1ssaTOKF5ZBVmnaeJmbpI58RxpTF3MSUfDIIEI8Yryvcyid2OU+EXpyCO7upjmUc+
BfeWvSsr38PoXvPsU/OUtD42zz50+uTqnFx97PbJSfe0Q37qnp6S9x1y/rlz+dNl9+qqc/ad
HKS7E3wu6RYvg4Uk8kTq9xJEwltvYgMKnFhozR28uWUCIMCJm5Z4zwBC+L+DskQxMATuYMKA
4zOdrFC0lJXvTGnUwzLoZRmz0WOjoaQNYF/zG3CEvOOBypOtDSfDuKHEpOB8W386aGI+PgDy
RIbDwlsKmhenzV8U5QfYIK4MI4iLCVa9b7Z+JB8BgwddPGCGgEOC3RSBF00S3a/TzPub5F4M
Ns48jUuuZ4oYMvcTbMHsswOWrSHfw/gwU1pjRpbOmDx5dj1b3nhOpXnZaZ1ftud402peXH26
7Lxq1qyeU92MSvVAXT7jTCObaWRC1R28k5mv48IaxYfihmfyogR8gQUUBDHx6yduFKWF5duH
BiV7omrvYG/5uyX2FCJvpIr7lW8aZG82EXRPhA6O77lgOkJsB3iNJOlzP0ny3Mc4GPM6Zf8Y
Q7E1iIZPUPeFASJGFGADyOlIiaucLFlkr6dDoBPs7YugRff1YfxCkQbx72UIFf+W/uWJOM0P
xV3V5Det5u7EwTgtufkaP/wZpmHWqeVYERTTHuBCSA0vhWKHTH2tQq6BvH/DO6RlSs33cOC5
NwUEXLR6S7Evxks+vHTKRxEgIguX1vg2KsJVrVYTZOF3OjrTDbrM4552FbBX9M0nUYxfSmQi
k+0ROxVMEa2VGrk+VBH7Eqtn5VREcOGAJVTjVcI/mvKVUgYLIKRW0qopGaNRMeFF/fPpTh6z
+uoEnpJRq2xG9lz/fLLlk0BflSHajIDTk86fGHt8cuaVaRxeGn1ltqXVfmUEvz73IdN9conO
NzlGXG1saomSjKKFhjlDJLBNe6/GPZsvvgEdqxFewKsw9oiRzZvdiFXHmFOdRW6soTnJIFQc
rTqnMNPG68VgeE5ZlvZdQSN7BTSq3y6N2fTVXIWNCetG3IGiMInZ6Dp2hMI5xN1o3G2tGXPU
Z8cz5gjzBTOKawJ2qBuRXXhRYPFFTiKrtCzP9P9XeRNjWmZYgJKD1/7KuoH3LMhewHWTPARW
xPcyrZhMSbpnV50PnctMtQHBf0TUTI14DI/syZgpC8EcOpZLINqhdLZWfyRYY410g5Ne92cx
AV5ySJgy9yg2Ar3X7QkvUzhNSwtMFH6fkqduSt778/PTTvMsl7w1sJNPcGexw5foZvCTxQyG
2lcvgKKMnSyVNEMinaGvsmsJFGX5ZNEb6XaYlUJczqBZ3ZYY2K7EkJ9Ik1I5x/baV09PTr5O
ETGH29IhtiZv5zQoR1/qu0YpJwFoGT5HX78ZycmoWc+EMLpzG5KThrOZ/WA7d6TVHAFo1RwB
aJQWySAn431NEezckeZkyG8ogZ170m1IoPDNA2vKYefutPB9BRtKY2sOdZfSyHtjwpqC2NjB
biqIvPcsbCiDjf3ml5DB4pse1pTA1lxwkQQW3w+xIf83dsobYzjzep1NTjvUnfvURdzki7DZ
Jlhu7FW3haW6CZYbO8cN15mWs85y1li1eI3NvMtrvfWl7tqf7oCqRQ1bQt/GrvRroU9dj76N
PXDn7FOvc9m86rQXSMyeBcJQBz/RYRnzlSx7CWu+URWP9s/XaqTVLiB/5hpaQqacNkvmxo74
KydzTocXCd7Yq/8pCFaLCc519EjvwgIVt2NyicxFpOAVx1Nl26Oj0Yj+te1s25uVdG7AtANJ
J6+jnpH0l+bFt73NSlrbOPx8ocTjW7RZgVe+NEu+7W1O4FuL5NeV+OprptrWLmqtwGnJ++Sn
+C3eGdo4AH8megVnkXkcy42Zt2eg5975+tdq/cO2udX69d8Ok8+BF99BqlVmKdra9boiFZ5H
aPX6XhXIk0nIg5eeharVmdPQyL6Hermx+LeOXwbkBouXGMuTTZVtIJsZO7d4zQGfS5+etYrS
78rv+UmHtk3iL+j1lnwPVFFkq2IdsapiBs7gzgkHt9z2eYBFRXxEUomflnBHoanYnnFn4uFA
N2xFn0S3g8A3xmGohBMXjhT+6HtBNIKy4SnyA4tKGPmKbRvK0OW+EoyQG4qtGjqm7hmspgyB
pMjzoltovLNsAdcbhRVFN3xrYPiTUYDZdvJ34OMbvUP9nqc1+JBGmJZQ/KEP7E1rQHXw+6R6
ZMGgiYUnUsoIuikBt6ABkDWdgRE8+REeOJ6ZfiYVv39pDAKZvKFEE5cHg1A8uhIXULdC5cGp
Hx5W5z6uGpn6Ub1+OAsLa+vqEZXDRZtvOAMPGQjH4nkYUTIe1Wq9QpMe4jcEWsyJ4zylpWQc
HjuWaSnWfXSvWKox0O2xNxhakWgO9AfRmu064PegkjiPVmGPyn3FVgcoGc+VYjf5PVYyrPT1
SLGCpDmGIn5lMmOKnMxMg6LsHnCBi1WnTAkiY2A4XqjU1Sod+K6vxOl70Cm659wPPEd2whpf
x2+lRkC64oeOh8LCcQp+KvIuEFBFPxxgW8Okv8LvEW/BNH3MgQugsArI2PKQCeJIt+Mpku/7
gs5GquIMDd245YqD31DFhExlEg5BtbxARxUeK2EgVcMUP4aJ+EI/fYBaqkxuDWtwa5iKBwdM
OwLlhSbfsh4VoQ4DfewrPOlkcc5lp7E/1gHv8O5JVYaTKAL+Aj0wFqeXzLnlgaPbykh30+TL
A8w/Mh0OaOUv7GtCCKNlqtFDenhDhLYRVqK0xvAtiFb8STjyD0IfDZW8Rb0hwFViyk8Uf0/f
pTBqh1q9epP5nC6auyQ/tCG+/ArWlTQxVfTUcu+uT89+bN5g6UO/CxDIWxt0zd4ntvfwDqu7
l/+NL9ufwq9orBi+TKkSiVm9fvcA/pd+zo6t0uKx8Wv/CX5B1TWeiFBXzPAEP5eAODzSVAAh
17DgEX5MYo5H4AhzeQS8FnBYmak1yuo3JF64AlCl0iAjK3AwK7ABAd+vEx4KfGBhleKO5dGD
BKEBKrBQABWwFvI7qg2i//Y4GPMITFDooxUTFHj4hkz5PKNII/WID/YfD/Fblg2gNoyI4ZjH
4v2deIbOkimYqrFaTUwhDVKSldcg77vnfYKWt4SfWgRoZTmoWq7Xq4eI1zxptnQxs8SkBJO3
rKbVVTJ8iniI3w7+f0czJc8sfQAA
--------------020101010604090806020303--

--------------enig18081BB84EE1F92BB9194838
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAku0Z7gACgkQUTlbRTxpHjcuMACdHLRfu2vpHT4Nhxuv2P/pOI6W
OG8An132HJw5ZmPhtIgqVkb0NCUZ8xt6
=O06B
-----END PGP SIGNATURE-----

--------------enig18081BB84EE1F92BB9194838--
