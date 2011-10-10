Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab1JJFKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 01:10:08 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:51335 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab1JJFKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 01:10:07 -0400
Date: Mon, 10 Oct 2011 08:10:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: balbi@ti.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH -next] usb gadget: fix langwell_udc.c build error
Message-ID: <20111010050959.GA30935@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
 <4E8F67C6.5020603@xenotime.net>
 <20111008100326.GA24633@legolas.emea.dhcp.ti.com>
 <4E91DF00.8060107@xenotime.net>
 <20111009223638.GA29776@legolas.emea.dhcp.ti.com>
 <4E9228CA.1060904@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <4E9228CA.1060904@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Oct 09, 2011 at 04:05:46PM -0700, Randy Dunlap wrote:
> On 10/09/11 15:36, Felipe Balbi wrote:
> > git log --pretty=3Doneline -S'lpm_device_speed' HEAD --	\
> > 	drivers/usb/gadget/langwell_udc.c
>=20
> e538dfdae85244fd2c4231725d82cc1f1bc4942c usb: Provide usb_speed_string() =
function

Aha, now I know why, that went straight througth Greg.

Greg, can you pick this patch ? It's clearly needed. Meanwhile, I'll
cherry-pick that commit from your tree and apply Randy's fix too.

Here's my ack for $SUBJECT:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOkn4nAAoJEAv8Txj19kN1NpMH/1N4iNiL/LLh+qBIwemM9kqC
0uga5Hd609oxBkD6qCSLBj6QDJ+ekvCNIFvRC/10izJCeoTQ7ioIlDJpMJFMRNFD
Y6ncYkUPTSBQc8Y+SEYJuMIVozPglKQpBp4POO5hwe1j5edsW4gPkL37g9rsSvs8
dn0u7DuPupReeHC+P8X4T39EiwJr9jssFe+zvuOLfM3nWvVA45SR5AfqpuCuZTco
4cPD/KSUFjXK6rFSjUlPNFFltOkxq1GSy3LLz+Z6y0oUh8q+lqZAFNG4tmIW4fxu
rBw7TEHHBTpOZ5hffMFI0/H/QePEcQDmILyM2zSC+gClwgns1D7kR+QT6o++KB8=
=e5UV
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
