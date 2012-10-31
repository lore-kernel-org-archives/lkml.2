Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422767Ab2JaMwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 08:52:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53676 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756872Ab2JaMwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:52:42 -0400
Date: Wed, 31 Oct 2012 14:46:11 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Masanari Iida <standby24x7@gmail.com>, <trivial@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [PATCH] [trivial] usb: Fix typo in drivers/usb
Message-ID: <20121031124611.GH10998@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351262599-15461-1-git-send-email-standby24x7@gmail.com>
 <20121030193059.GA8810@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YrlhzR9YrZtruaFS"
Content-Disposition: inline
In-Reply-To: <20121030193059.GA8810@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YrlhzR9YrZtruaFS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 30, 2012 at 12:30:59PM -0700, Greg KH wrote:
> On Fri, Oct 26, 2012 at 11:43:19PM +0900, Masanari Iida wrote:
> > Correct spelling typo in debug message within drivers/usb.
> >=20
> > Signed-off-by: Masanari Iida <standby24x7@gmail.com>
>=20
> This no longer applies, please redo it against the latest linux-next
> tree.

When doing so, you can add my Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--YrlhzR9YrZtruaFS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkR2TAAoJEIaOsuA1yqREPjgQAJIKDqB8YTc/lddjCTAVj7Ef
eQ+lYFtY3xdjy+WmIu+NM9568wJyov8aNSJMC9scfLW8VnBDCg64IYvuxbKpYw8d
ElLmdUNQ/oVi4MMjExNFJC21qxJrk64SIk1QeKmmyMmM4OVoSVfcQhGRiF0NXBA3
/9fxQw7eAmThVB2rCT9NL2uyDgSuZjFTk+9/JqrLkSSnzx3CqPSKibAe3O9dkBdw
ijRjcgb0BzdPCH1WqxmUxtv6kCGycxpoLvRNn5tVQycymQ0kMCRwubJdDCsI+CN2
u/z2jcdp6deUVpEPxFDNcDrf14Dx40R3LlvAykYZq0eM/V19RXq0xYAMGVO00pwG
hRjE7RX69M0fwvMlQDrbBaO5CoFgl90JC307mVpdWooiMwArX19oCwzaxt1XIu80
nWzQLp5SpYpixgyFnDwEAaO6k8aiNZfPxmJaKVT56NkQ1JEAcmezqsynW4KJr7k9
e/g7mEjt4BdlNFLCsSW9ydKMvC6VQ7+lxNnxjoSQ8PqpK2ARoFPsqDe/RBCvqO/s
qSAiaB3vCuVfS709GQso2QZvaN9OqESdls002tPN55Oqg89OQ/1uj28Te2G58eQO
5GjAIeh0GlbMf+fVReh7mdNMO8fiU9VVMGfY8yq71Rp1GPfxJZLl6tZF4OSH9yXy
V04273qfSObei7RarRBS
=0CFT
-----END PGP SIGNATURE-----

--YrlhzR9YrZtruaFS--
