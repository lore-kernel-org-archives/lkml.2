Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935387Ab2JaMzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 08:55:38 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64299 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab2JaMze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:55:34 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Randy Dunlap <rdunlap@xenotime.net>, Felipe Balbi <balbi@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb/gadget: let file storage gadget select libcomposite
In-Reply-To: <20121031123749.GE10998@arwen.pp.htv.fi>
Organization: http://mina86.com/
References: <20121018144614.b61961cfae2274d52d340882@canb.auug.org.au> <50809624.30601@xenotime.net> <20121024144435.GF4368@breakpoint.cc> <xa1thapjlqv1.fsf@mina86.com> <20121024174508.GA6014@breakpoint.cc> <xa1tehknlnbr.fsf@mina86.com> <20121031123749.GE10998@arwen.pp.htv.fi>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Wed, 31 Oct 2012 13:55:03 +0100
Message-ID: <xa1tfw4ug5so.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 31 2012, Felipe Balbi <balbi@ti.com> wrote:
> nevertheless, I should be receiving a patch right about now removing
> that file. Alan, care to send a patch for that ?

I have some other stuff to remove as well, so I can take care of it, so
Alan can spend his time on something more important.

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
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQkR+oAAoJECBgQBJQdR/0SN0P/jcPq110A7uPgB53vnC8vf50
ERixs2ZrBHGeJl1SBOpZzWkI8QeMRne5DD1saInQCC6pC+RY/UT5gG68O5GdPeFM
qG/uVxiJmrMnYnPoUIcWbQPOrtU0JzHgWxr2QqQt/BcB9Uoq66xaSJNpOQBW6qQn
1ORwX4OxIur2GuzOHXZcCu0c66T7AyfEUWg5uu80qjDi1rF1xNesU23o+HLqSe8Q
lGcW8LeOLio3keWPzB3b6emDaw/f4Cmu3y5xe2E6LYDOHA0eOhjCIVMJRkymtdqj
Y7CDMiFfd/BOTt7+/y9YmBLzTfB9qvKt86AyfAhnbsaaPavMGgNk6vWjHLQ45xdS
EVW1BWpy9PUmkCy4owapvVj4WAJE4pTmrbpfcCKvg7LmMlBBAyghUCcg0GG4LoLq
0N/0WuMz81SNK8QGzUppmQi5+H8JQXDIB3/3O1/Gp3W40YNLhgkYqtAl7EGPQ80H
tUtLrI1gDQRQZKiv45wlhw3+els67IegN2axQBwpfxJ5DKH8g8BHVTLRkDZaYmPo
OGu2aLJ7Lrq+crg+gcTQBX9njgxu+4N3YYyB92LKgAOwaEVQ5Y10kLh6JvuV8JCJ
8FPG/58hVpk/WR19FkdCsWAkIBxoLmZ0vbhOP6IarMWyN2U8D7xG/j0ev6CTXZqV
Hp6uo9OYTpx+2+L2phl5
=zL/m
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
