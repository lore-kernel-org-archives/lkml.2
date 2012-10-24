Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935478Ab2JXSsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:48:16 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48872 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935265Ab2JXSsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:48:14 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Felipe Balbi <balbi@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb/gadget: let file storage gadget select libcomposite
In-Reply-To: <20121024174508.GA6014@breakpoint.cc>
Organization: http://mina86.com/
References: <20121018144614.b61961cfae2274d52d340882@canb.auug.org.au> <50809624.30601@xenotime.net> <20121024144435.GF4368@breakpoint.cc> <xa1thapjlqv1.fsf@mina86.com> <20121024174508.GA6014@breakpoint.cc>
User-Agent: Notmuch/0.14+22~g8bdc16b (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Wed, 24 Oct 2012 20:47:04 +0200
Message-ID: <xa1tehknlnbr.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On Wed, Oct 24, 2012 at 07:30:42PM +0200, Michal Nazarewicz wrote:
>> At first it looks strange as FSG does not use composite, but yeah:

On Wed, Oct 24 2012, Sebastian Andrzej Siewior wrote:
> Yeah. However, it should be removed in v3.8 anyway :)

Yep, that's what feature-removal-schedule.txt says. :]

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJQiDeoAAoJECBgQBJQdR/00W4P/01kbM2iZKHwCbNCqERqpTyI
c6+sflvLSS02m9FwHS7jrHjiPnnObC3TsMM0EMDVhptQqQgBI49h/ZsWOp+ZsEtY
ZLXVZVXz2odt2uSZOrhUzdMhE9BTddy93sXdf0BPN5OP2WGNY2NGNXAtWYa4rSoW
OKJrAeQOcmpVvSPC4D736upQsZ7t/7w2mZ2Ikbgg2PG7HaFB3CBF30JzWn3e6NuJ
DGunBE9rMmO1KsILImhQvywbv7UL3LIGqmVDoNu16iHuTpkbk6Q9/jpeaH0jjTb8
Bs4aSapNCYuAzkHuWbys/yousIKY8a7Qnf6AU13G5b1ysOcrZ3bpYgjdaei5MLl1
AJUH3RL/2JY+zM08JLnmr8WRpY75RQqmOkeWNpyZ6QM+6RtayTZF6s2tQS75jeTf
adWm0v7UuoIzbUW2ZxF/oNgtP6FbQesCQbW0m+ZSUA2nID1rNCV7yrDSuLPS8X0l
Y5CB2/WbY/+umcAcrGJZacO27KqyLC5qFceL6C1VGy664iDe3fBiUno0sH/ZdSBG
+oYuLLlgTHaixAn54Cs9ljbKDUMhnjrqVTzYGN2xMvkMILDYHHmpgYIzDxIFUQrC
7LXUYd/VwG1gqW5yG33cFj/hHWlwVXFi9qphI45ZcaB9Nz/s9g4B1wPxYL1kZhaO
K3ZLr+JjL0qkRmkATOf3
=pf8B
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
