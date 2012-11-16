Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab2KPNtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:49:14 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50146 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab2KPNtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:49:12 -0500
Date: Fri, 16 Nov 2012 15:42:48 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: dwc3: core: move dwc3_cache_hwparams before
 dwc3_alloc_event_buffers
Message-ID: <20121116134248.GC18527@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1353069901-19217-1-git-send-email-kishon@ti.com>
 <50A63A5E.50409@mvista.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8NvZYKFJsRX2Djef"
Content-Disposition: inline
In-Reply-To: <50A63A5E.50409@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8NvZYKFJsRX2Djef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 16, 2012 at 05:06:38PM +0400, Sergei Shtylyov wrote:
> Hello.
>=20
> On 16-11-2012 16:45, Kishon Vijay Abraham I wrote:
>=20
> >commit 392142 (moved event buffer allocation out of dwc3_core_init()). B=
ut
>=20
>    The actual summary is "usb: dwc3: core: move event buffer
> allocation out of dwc3_core_init()".

too late for that. Already on Greg's tree. Let's just hope this won'
repeat on upcoming patches ;-)

--=20
balbi

--8NvZYKFJsRX2Djef
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQpkLYAAoJEIaOsuA1yqREm2YP/2A58nvctBdtRrSXwS4isAjL
hTjoYR9fa/ZTtND68UU9bAD6c4ud0InyUfcGVtLOGbcaYLo9FIjPfPhz8Tr3/PsF
BV7jkYJhou6UP+OO5cEFzIpp2IkGRK91Enk4uSS7sG3y7oUK0m5xYf7UpbKZa8Xu
qv+bLyWzfzgHHS71Twr1zZ4q6lu59O5A8P8PV9dbaL80RXPusQXYbEIUckAyeRsw
oWw38UfxfhLF2oOJhna2H9XN3jB5dmV08yTMu17EzD1iWO9EZX51UTkpsmuWnFlQ
Ngrs+AwQxvppqcdCWxuq4T91lsbdw2IL+QC4m+CLGVXu1hcS9oVOHSurjVFaFZOQ
0GdZG8j4/B2AEuc0FrUCmhnFYlh4XcP/6xKBCbmAQrK5HcamjZbS1/s5Ur9Srt2K
BHnJe/3i96i0WlrBWvgzhxO8LhnQV9VLih43MvFQSIZznjWPaYT6xfNLdLDq9ZXz
rBOujRVLZZBFXvSvYWUQwrKuvQMr5MBq/vwePOyHkWHTao8eAqCkIijzT2brHlFR
5Xu2+yiA5yM4GosIJiHaV/tZ1kCle5IrCO9V1VkFhyMAeJ3n1rlFR2LuAPsvtmbe
Gc2yY9J0XR8o0G58bNRjmkNwFbyQH4G4Z59r24DO3Ro+BYCZo7vms0e6JcLf3M+9
CxbEKge5vBiBkQTgMEUB
=QNNZ
-----END PGP SIGNATURE-----

--8NvZYKFJsRX2Djef--
