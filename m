Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab1KHTfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:35:18 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:37314 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab1KHTfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:35:17 -0500
Date: Tue, 8 Nov 2011 22:35:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        wlanfae <wlanfae@realtek.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192e: Use kzalloc rather than kmalloc
Message-ID: <20111108193537.GB4682@mwanda>
References: <1320779160.8062.139.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9MdG657QzbOEWl1C"
Content-Disposition: inline
In-Reply-To: <1320779160.8062.139.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4EB98459.009C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9MdG657QzbOEWl1C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08, 2011 at 08:05:53PM +0100, Thomas Meyer wrote:
> From: Thomas Meyer <thomas@m3y3r.de>
>=20
>  Use kzalloc rather than kmalloc followed by memset with 0
>=20
>  This considers some simple cases that are common and easy to validate
>  Note in particular that there are no ...s in the rule, so all of the
>  matched code has to be contiguous
>=20
>  The semantic patch that makes this change is available
>  in scripts/coccinelle/api/alloc/kzalloc-simple.cocci.
>=20
>  More information about semantic patching is available at
>  http://coccinelle.lip6.fr/
>=20
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

All the patches with the subject "[PATCH] staging: rtl8192e: Use
kzalloc rather than kmalloc" should be combined into a single patch.

Don't do the funny thing where the changelog is indented one space.

regards,
dan carpenter


--9MdG657QzbOEWl1C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuYSIAAoJEOnZkXI/YHqR2CsP/1E1a+bpLhfG0FLHSl3rCAMh
YBaq73Evies81xLtLZKVoHyUpEWLB073wHIzZdKkMkV5cMCfeTJ4EOrLh/X7glC9
nI/alIDyKfMvETSgFne1owXUJXt/S19yoTiVRfdVKJDKgTEALfiKpK2bolAuFzpG
zale1nkSyKHrEanlQCclTjsS79r88Sy1VJzT4YDFCOWmA+3y1nyU0FWPwbCMrFYx
dUJeEA0RqDPleVsoJUjCGm+XW6kFy04NpTagrmj/BuI6qaZxXkqddqYB9DKGcN0f
ZlawE241O7SUefOtGB07E6jW2hcUhPxbEdirzVmgB8c7T8++jRktIeyEDtMI2PXe
0Oc9UkVdczdJ5M2r3QmqWZXe/4X/Gp4+D+OKUMnnmn0WOtMpbHJDrhjrgf0q0tnS
ugtVThyeArJuq/MZLyKokpBd+UmDhA9tNuBjtx+HjnwShskawu/elQ6Ts5oPVFx6
4nWwfhSRVdlrIkZmJP3EYadMEY7ipF8HxUe9veFZ+vRjp9rCnehl0RIBICs0Vp4T
/wVlrQxYR6MGBzbIRNJkkIsFDNyHYC7RxbibJ9D3o5XGCUpFAk00E7O4lhGwcpNp
mmJ7nUamlFqriHgYFwv3eDzAxQPDxI+pOB12W82XwFzRMukfBcxu/+hkrSu/B0y5
SLEjPtequfrdaPUVK718
=J2iW
-----END PGP SIGNATURE-----

--9MdG657QzbOEWl1C--
