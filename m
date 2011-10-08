Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1JHKDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 06:03:36 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:33689 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156Ab1JHKDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 06:03:33 -0400
Date: Sat, 8 Oct 2011 13:03:28 +0300
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] usb gadget: fix langwell_udc.c build error
Message-ID: <20111008100326.GA24633@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
 <4E8F67C6.5020603@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <4E8F67C6.5020603@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 07, 2011 at 01:57:42PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>=20
> Move function to fix langwell_udc.c build error:
>=20
> drivers/usb/gadget/langwell_udc.c: In function 'show_langwell_udc':
> drivers/usb/gadget/langwell_udc.c:1693:3: error: implicit declaration of =
function 'lpm_device_speed'
> drivers/usb/gadget/langwell_udc.c: At top level:
> drivers/usb/gadget/langwell_udc.c:2637:37: error: conflicting types for '=
lpm_device_speed'
> drivers/usb/gadget/langwell_udc.c:1693:20: note: previous implicit declar=
ation of 'lpm_device_speed' was here

I don't have this compile error on my branch, did something go in
without me noticing ?

Can you blame a comit which introduced this ?

btw, all I have is a warning.

--=20
balbi

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOkB/uAAoJEAv8Txj19kN1ACgH/2VwYOJkUVEjj030UzZOSXtc
Cmx/Aea0lmXqJGMHnmaiv03ijci2jhHmOjwYF7vrhhNHLDUfLyUqn86YTv7mnDEj
QRuNDCKUW8YgSVxNGBhcbGO/Yf71cMUVw0SuxkLSeIDJc8U4XLbnrNUvq0qM2Jqc
u7h9e8a0yWnDd53kTIhLUGuE/JAB2KuLa5s89Q37CXN9tJw1d6JF+x/rsV8QjoUi
Eak9EEUZSo1YwlwTYLXV+aojszpsAowbEfQ9UFjd0Ko3GbZQojb8Lf4IGEOXeQn0
rGSWE7yowVBPzY7HiThvfnSLD4O4JXq21beebdgqTnNDMk92aAQjZAGVJRw5j44=
=i/g8
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
