Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2BCFo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 00:44:28 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39585 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab2BCFo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 00:44:26 -0500
Message-ID: <1328247987.6750.26.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Fix error handling in ubi_scan()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Date: Fri, 03 Feb 2012 07:46:27 +0200
In-Reply-To: <1327944013-18944-1-git-send-email-richard@nod.at>
References: <1327944013-18944-1-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-7NUeA9OvA8h2fMipaowD"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7NUeA9OvA8h2fMipaowD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-01-30 at 18:20 +0100, Richard Weinberger wrote:
> Two bad things can happen in ubi_scan():
> 1. If kmem_cache_create() fails we jump to out_si and call
>    ubi_scan_destroy_si() which calls kmem_cache_destroy().
>    But si->scan_leb_slab is NULL.
> 2. If process_eb() fails we jump to out_vidh, call
>    kmem_cache_destroy() and ubi_scan_destroy_si() which calls
>    again kmem_cache_destroy().

Pushed to ubi-2.6.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-7NUeA9OvA8h2fMipaowD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPK3SzAAoJECmIfjd9wqK0F24QAJslkZfl6bN53eqzOCWwrlDI
UC51xgiMJrAgnbBh2HD3VPH0VDpNEfqfg1etMbnJ6vZ/tPvHre2cCSi6rebKQN+c
MJkWGWRXQ+jgO3KEPha5zoO5L8n3aGhAmO1myrvtkU8l5tTeXXAYIiLsUmfMLfyj
LrGsd2dX7VbO8E+2fSMPRZaYoc7Llfgannf8S3TLDwIR/YJzCkTWBRZ0Zb1UXkFB
d5xKwPYAYCY6w18NNoCigyoUl3od4hw4xZ8fllrZ8+EjyxauDpuYZwQLUq0O7D8N
cqHRdS38wrJp7kUD8d75uiXCSFTJ3IHZVLZkPyhB1Kvs+GvFrE21PJ7guHk+1J1J
OwtiKQ2UsO3XmqbN1Ss0QYgHmmbXuUrSiZiTDSFgqZ1E2bGVlBmOlXAWF1mM6j5w
uNa9f+qF7ctPif6jlI+imDO8NChoUuo9ntv7QZttT8lVSuwmtfHg4aYV3xhmcccA
9t0IBzIg/3L1xC3EdulX1YorOnX5HBwTSUAv+K3UjqY8XR3OHB2DCnHHLm3PQ+11
Zkp/JGizK9OC1RUw7bmnfxyB+o/Ld71/Ee2c/yV4AbBTLEDnihe5yQS5FVG/Ds0Z
dpfYZpxiT9R48roLeLIntWAQ+eyo3dh7zf8720C9njfPNm48fqIrPz6AuHrJJYZs
enVRxT8/NNTCeUpccF9J
=4E7b
-----END PGP SIGNATURE-----

--=-7NUeA9OvA8h2fMipaowD--

