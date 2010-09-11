Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab0IKNTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 09:19:53 -0400
Received: from ch-zrh-72-201.trenka.ch ([93.188.72.201]:39517 "EHLO
	mail.o2s.ch" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751898Ab0IKNTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 09:19:52 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Sep 2010 09:19:52 EDT
From: David =?iso-8859-1?q?Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>
Organization: OpenSourceSupport GmbH
To: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Importing RPC server bundle
Date: Sat, 11 Sep 2010 15:16:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-gentoo-r7; KDE/4.4.5; x86_64; ; )
X-Face: a023Y#Om+E(<|Tkz7Ae>YeJ\rvY,eXDn^g66`NiaNQ"#xRJ=gr'!V}V#{MN6!YO{s{{)
 =?utf-8?q?=3Bh=0A=09=3Ds?=@Vv%T)fi>gJrAHvijw^ZG9{b1rtf~mn$V^b`:3m>yH=o$Eo')
 =?utf-8?q?Ul8f=7DF=251vdg9=7C52W=3DXs=0A=09rR=5E/E/SPo=5E=7B-R22=5Ba?=
 =?utf-8?q?=7Dc=3F?=@tgfp<I#oOW7r}0We&3g5"2>N5r/Vu|>kWs"|J'XppA;*0A,6>
 =?utf-8?q?=0A=09*GY?=(0=H@>@^vEy]!m\)I42Lu@k~_=:U@/kf8{AO4'F7:Hy_*"5Xf9Vvkqr4E(
 =?utf-8?q?32pVlT=3A=3D=26=0A=09i4l=5B3=25=3FZ?=<zzP~wGSke?1VJj\cd~Z(,Upc;nOR|pqK@<j(`EYFSn,jN)A(~`YwM2nIv,
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7005810.E5IQ2uPSJs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009111516.34263.david.lanzendoerfer@o2s.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7005810.E5IQ2uPSJs
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi
I made finally USB gadget working by import the rpc server bundle from our
fork[1] of the android kernel release 2.6.32.
But GNUtoo asked me, why I imported such an old version, also of AMSS.
So my question now to you folks:
I can import it and make it work with a new version again,
but I need to know, what source and place I shall take it from.

Thx in advance
	leviathan

[1] http://gitorious.org/htc-msm-2-6-32/leviathan-incoming/commits/msm-gnuconform

--nextPart7005810.E5IQ2uPSJs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkyLgTIACgkQAeZw77btGjqeqQCgsJTH3daVAIxc/+zob+dik/DK
KZkAoKtJ6ds1OxFG4l2g4RCjxFbPh6cz
=BkOH
-----END PGP SIGNATURE-----

--nextPart7005810.E5IQ2uPSJs--
