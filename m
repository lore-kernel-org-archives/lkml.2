Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1KCKqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 06:46:06 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:55238 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab1KCKqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 06:46:01 -0400
Date: Thu, 3 Nov 2011 21:45:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: Changed location for arm-lpae/for-next
Message-Id: <20111103214537.87f44ff9a80db78fe163b368@canb.auug.org.au>
In-Reply-To: <CAHkRjk4ow5EZyqj3j6yDocsX5BPjDQvrqX1enPfyDt5kp=qxaQ@mail.gmail.com>
References: <20111004132614.GA13865@e102109-lin.cambridge.arm.com>
	<20111005120621.46c24fe4b8f83ac78944b777@canb.auug.org.au>
	<CAHkRjk7YBJJO9HW3JC0AUT2-JTyMwj=4=zd==dSG=pfBvCiFNg@mail.gmail.com>
	<20111006095625.c4814b818efdc61842451625@canb.auug.org.au>
	<CAHkRjk4ow5EZyqj3j6yDocsX5BPjDQvrqX1enPfyDt5kp=qxaQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Nov_2011_21_45_37_+1100_jZJNbCUFD2juxQnx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Nov_2011_21_45_37_+1100_jZJNbCUFD2juxQnx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

On Thu, 3 Nov 2011 10:29:24 +0000 Catalin Marinas <catalin.marinas@arm.com>=
 wrote:
>
> I now got my kernel.org account back and I plan to remove the github
> tree. You can get the above branches from:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux.git for-next
> git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux.git kmemleak

OK, I have switched back to these.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Nov_2011_21_45_37_+1100_jZJNbCUFD2juxQnx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsnDRAAoJEECxmPOUX5FEhLwP/RKheyOegWiSS4cDxGpb8VKD
fOw8MYNp4xaIlthqGLIJGsuJEy22S83s4vkJW15XiKTHphio8iMd5+58MbGvGLxS
t8wrTs+mdnAIhwRa7WNttIs9CSrDLIxX/OxYsGoaPjORgDcDbHtVlslh6l2a+kH4
tvG7Sc6iEZCU35rDy5bJoMqO9yeWWVK4SfM1a7q9MFAV6l1pUicyzptQc0+BrtSo
ebhcXOj0LYrSuSn1difiVxIy3CLQhcfxOpZURQkInMw9bG9N4PkC5tIYPf/HFLlF
X5leqpjYJv1tePM3QwQ4WseLA9VyQHdO5TeNnfSyMHTPY/Pnbee9rnK/8ipnw6Nj
Q8g4KEbHoX/1Vtx8knmo2oXe17edqafE8QjVS2t0aFU5ff8H1C9D2nKFkDiacegN
JvsswYWPogX0S3pddK6/VNaD5/1fmniJoYcEEc+REXbrEgOkgvmGXolW8hKUDHEE
FVaCO5Jdzp/xjTQTHx+riFqDC7KaWlainS7Mx+VwvVZA2nRC+SgSQ128uTPDkCxw
h13Wxuo1J1+fCala9KWp3cNYXJl+wdji7oPM93urbZQrTeN78KT3izWuB0UT6DoF
vretyc87+EgAAT/R4RpXfvCUr0IZAQyxGTlrGq6gp5AZ3D1sC+stz59WvgECoBTA
v81hm6bQQSkNf4aPs3NE
=j/hL
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Nov_2011_21_45_37_+1100_jZJNbCUFD2juxQnx--
