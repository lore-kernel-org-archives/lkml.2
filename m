Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab1DFFcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 01:32:20 -0400
Received: from nm3-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.154]:26285 "HELO
	nm3-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751335Ab1DFFcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 01:32:18 -0400
X-Yahoo-Newman-Id: 586982.47246.bm@omp1001.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=DKIM-Signature:Message-ID:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Reply-To:From:To:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE;
  b=pY4PjdW9pQSUlTlhaG3iphbqT47Nwo6/R8lTg/7YDNRM0Md68EZipH11z0UOsO5tI0VfcfxNpTBQ62p0fwk0c7tqqhddig9xySaJ4w0AO15eJIfaT54R5HzYridCLS52QF3iqYyYjbMsNcmTdlNb/z5gx2RpSYp3KssPZDNksLE=  ;
Message-ID: <432042.74224.qm@smtp107.sbc.mail.bf1.yahoo.com>
X-Yahoo-SMTP: 0ZppkVOswBDyrb4Liqg66opdPJvf5xVRybHKqkZnjdMxhstq
X-YMail-OSG: V0KuIPIVM1mmarmoOU6m2.BvAcEy2h9yjKWWMS6FKspJtS2
 y3dwthNi.5kaIjU1BinBe680qNHmCni4ISTG2HWAr5s7dRoVp8r1ZpRwoK73
 0NlX9Vjl0dY3qxreUXSzwdTktc_LxLPZHTLNqubcIJsBmSfbUNy.3F.5_oy3
 nM06DtneJXpXFSdkCrzX9XYWC4blQv2SO3qHOyQ3vc8kySu06cVSXuD9ajoJ
 Q3uJvYg00OKRbDE31xBv40xhG1qmF3ONhQgjCSDLaGrDVFc_4nt2w1tC2U_J
 mQlJhcJt5XohsY40kjXHmbZrJl9EQQk4.nvwmM_jPNXxIOQZJUNCsALbORKz
 9bitSL69e.lfIcDKlpa6PsGeETreW0Jzxcr7T2P42tz4PwkBORVd3hc2qDYS
 yRxzLTBr.RwCACgbGPdwad2qQ_zgAhiIJrP8ojXz0y5taEnWKKP6dw3g1E8U
 MgzLMh4bMBjOsRoze8Vqg8TQQtwTKUw.FU5hxuYtk8giBKz0ZP9KHiBTCsvP
 Mm5xaMhsR38.OtWj0WIQkof8lCne9zntyASfcCTajos_HrBf8olgLnDsUsYy
 LdJZ1V1dQc4RfGD.ArUgE6dVOPsUvoPdtI8yI23mRkJNqYPLkxlk8TAyJaBi
 _b_3Omg_mJEkHBk9HVoRD_q0Sl2SFa3scu8RIvV48s2NBgfv33WJSCjAkONZ
 MgR_B2R_NnmFJP13.6iETJqmuX0G0JOY8F9XxDDU6gDmPw25_W5_6EMZeQVz
 ELwVUu6h2kodNMHe9QF2WXY_z7d06noUKKc2FTYDdz2FqB5kOjBNOPmHSu0E
 yZBBfsijjrvbxU9fZAw2bfZbO7uOsswNOz0v.FnbY4cCgDEJpbe2CXSS3CFZ
 I60Gr9KrcdK8fTgEuMSKFV24ZPqowhKpP3zA.dryNXlccRnv87Gf4aHwYLk0
 eiIYIoszTVaxNm1MX6BbHaMuOuPmABmlrNy7bwHlxZXVM_W5MU0aGPBJAfE5
 i0x1R9NISEJ5o8MkcnBdiLD971_.2U2c0ZONmRQ6j.bjg3xU5Er7Q2fN5X3c
 fTx1ihQYv5REzxsCl2us5knBtM5dxdXglXoWCv6mXdM1hsNWtBTYyMvstJGY
 lSUV8my6WQy8yJJ2nVNBQ71O3dX22unP4qdGSlFDRG7Lvhp4TEIXonGCtSJw
 lT5UcNNYZ6iNwTRUXxZ8k4iOMDmxJkt72xN88i7WnR5mKcMHKMGtTVqu62m9
 AHJYqq3lEfROsmgpxJhYn2wdG_nldDthaFOGGpimSxxgtneWg3q_Q.FbZmfe
 Svafyw_oRaRfSJJI7tIzr4Tll9DmxhcQIBQL.abK.YDVgm6GfrYpCR6FyehA
 d2D8JgzCez39guM5VHT_E13qFgW8WAyFzSt9Gu9qWKxce0LTDuBjsF170QUq
 oFLvJ3Ukeuf68YoU8T0LkDXvlPxQQtR3JfOXdPJI.XgGkXxrGFbzu.8ZInLJ
 YESAsBOLLWHLzMgIEoobm85TtBXCpChsuMUPx63Yte15xVznW3O4.irsKixY
 COgWZiQzuNnldO2NiwFTd7JRC5qOZ7MAip0MOTmLk5UqfcQHnSBBZdsMoQTm
 L3FV2VYxVUAO0cge87f3nqw3MkdWJLF1kfbhLHyEjEzBCwgf1ryHf_a4.X32
 Cx2drttxa3c3Kn_3XaMJZpPf.dcF3a86kwq.iXui75yc8Wn6KtSsPA3jBAFl
 LS_UOXtPlp1l31R1teOAOHtLREvd7d0hfPnd1vFxxCvCwB6cld9PXRWrZiS7
 R5nszwjitH14R9yh2bgfWxycKVHj74ZI15dO5QGkSgmR50u.hb2.xvHYXqaS
 MtrBigx8zmiHymSBPtM2qDfDmswk3wguXNplRHx9.9dq8W6FgB4u0isBqevs
 V5R9efBtOzvXuOol15WBkjV1hkrI19Tt9TjZjDWfhdcUCL2UZPWwqFXJTcTR
 LOeHBR_dRtYt1d1RIBPnEy4whKYFQXW0bKXcob.QYDPR6EvFOVOKJ63rNu5U
 6tcBsS3wCZYn35qiCL9A0.sKs0rVt4LH.P.oZi.zzDwQOYWQulBNX1pADMK0
 Ra.FgJvh2ZllYABpjVrBfU5wnsKSoVzG8uvH.0u_c9IYniBr21xJ7XWfZnkA
 Dd_46TI.q0.9fwdYz9tNFjHmVByvxDHHl7_ztRdePRx067xze.1Qkl4SASTa
 gGwhVY8WxOKlIsfPqJyI659LyUcJ6h_DYHVQIWCEa3km8eqJ4QpkReKxp6Ky
 Rv0WSmR619Uj10yBme7VInQf0LWM.4N3HcBZDcuub.yKxG9Aye0oZDwDTCwz
 Tr_k9_zDdL91msak.FGR3SzT.3U.ss.JmjIeeAWMWrKEYJKMMwL3yo.7Xb7m
 UhJUBrY23_hH34nwbDpJ22jq9vVhQfOS2VhBaUa03u3TZvkUBNVCdLGkbPY2
 pgeVBeLp1O2GzvoZ3W2vB6jsgdtztiyeAwtK_kKbfyrPkgFkA.y5ht_C_gA4
 22qbs4FF2L21m3OBm2.buEsASFDK8LhgZ3QpNT6wrDre2P4akt1D4OzqLpoe
 hU5Of_jEoxL_Tr69awcevzvrC_utHJYFwjd0ZqVPDVSQhdZ2oyYO2sLDCKvr
 dMtJjoOqKLZhK_onnE3kS0SPR37IgkWiCS6CeFAVidSt4qjfIDFsQ3v6AYJW
 EV81sik3PuMHucJ5bkCs5obJqxreyk42lI.etgIbxR56SKPWFTR33k42BKYi
 kNOJTTnHrQY1QSqcfxIiruwVmVY07NtDDq8rzgB8Xqe_ikehhSvxqAdh_3VL
 ZqaPTI.0I_28.fZYF.CPtEHAo6Mb56AavgQbN4lXlauWi1LKryzzAgEiJH4Y
 rOVGEah4lMoKxzEZINmLp_k_r2y1z31Xo96vVS4ZuzEEWRabJ1Niitoo2K6Q
 Qgq5EKqBFixtFMxv2nAM.SpnwnHAw7mSlgpMlSjlF72RY83QSe8k0tU481JA
 yUl1GcK514eg8FJDl0dJboM1mh8xuX82M8y0uOvrW11oZszZNwqP7g6sCMSU
 vNwghCZ32sK4miqXZE0ewaVVC7gROiWrFNdY8acej5RHqROioAi0KR3uEhDh
 SUhH6Pq67q1RyhKw2.0vBowcm4my2p6JKY4GkgcvLrwzY5hgVitXhkN2P6Lm
 Q2XGMWrIuE5vxPJb5OUVx8bfzJbUZebc4yGSwBlce2u9sxSPSkgJ4sIfSScQ
 oMfHHEb1IxDpMRiSdL5Hrbu8gokCUWUet4lgIP7lZDolIKvbu7H4RLoSSxpb
 f5udHmQLZ_FQtZNpj0XEk49lSGerB6w2T51V0UxwJ.kaCKuwkpT5QWh1Sjad
 XHUCAcc818FUBEV24Ug--
X-Yahoo-Newman-Property: ymail-3
Reply-To: <barr.chenshulin@mail.mn>
From: "Barr Chen Shulin" <lake-folk@sbcglobal.net>
To: info@lawfirm.net
Subject: GET BACK TO ME ASAP
Date: Wed, 6 Apr 2011 13:32:21 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1251"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2600.0000
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2600.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am highly compelled upon strict recommendation, to write you this very 
urgent and confidential letter. I do hope my letter will not embarrass you since 
I had no previous correspondence with you.
 
I am Chen Shulin,an attorney at law a deceased client of mine that shares 
the same last name as yours died in a heart-related condition in 2005,due to 
Sumatra Indonesia earthquake 2004 that took all the family members.
http://en.wikipedia.org/wiki/2004_Indian_Ocean_earthquake
i need you to assist me in distributing (uS$17,500,000.00 Million)left by my client

Get back to me for more details.

Best regards,
Barr Chen Shulin,
Attorney at Law.
