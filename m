Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422811Ab2JaNAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:00:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56825 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422737Ab2JaNAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:00:23 -0400
Date: Wed, 31 Oct 2012 14:54:12 +0200
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb/gadget: let file storage gadget select libcomposite
Message-ID: <20121031125412.GK10998@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20121018144614.b61961cfae2274d52d340882@canb.auug.org.au>
 <50809624.30601@xenotime.net>
 <20121024144435.GF4368@breakpoint.cc>
 <xa1thapjlqv1.fsf@mina86.com>
 <20121024174508.GA6014@breakpoint.cc>
 <xa1tehknlnbr.fsf@mina86.com>
 <20121031123749.GE10998@arwen.pp.htv.fi>
 <xa1tfw4ug5so.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sU4rRG038CsJurvk"
Content-Disposition: inline
In-Reply-To: <xa1tfw4ug5so.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sU4rRG038CsJurvk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 31, 2012 at 01:55:03PM +0100, Michal Nazarewicz wrote:
> On Wed, Oct 31 2012, Felipe Balbi <balbi@ti.com> wrote:
> > nevertheless, I should be receiving a patch right about now removing
> > that file. Alan, care to send a patch for that ?
>=20
> I have some other stuff to remove as well, so I can take care of it, so
> Alan can spend his time on something more important.

that's up to you guys, I just need the patch removing what we committed
to remove ;-) Either way is fine by me :-)

cheers

ps: thanks for volunteering :-)

--=20
balbi

--sU4rRG038CsJurvk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkR90AAoJEIaOsuA1yqRE+ZUP/1J5GD/GOgFOGZOrnSNF95u3
4mRI7FiTyqB8+CqkElgAJscQ92GXZ1LRRJ4iG+93Sw4K4skNybP5i50oia27HbS+
02cbFMHyTPYxME9kgQKAg4uxwagBeo844k46SqWGheHZyWt4uYXbeUYKcfT7pvWD
RAPpGg+/QHb8jmcd8lhfRTgufpJXyLu0864f6v35NCZzrk/fMhEsR81XvtSFAI63
wpWn/dqIAY2Q/9tGj6D2CD6YaYIch/64SvrPUBD04wITIKvRT9sCalM68ejo+0JH
SF0fR+dM26A4jsn422SDmRMqAXSyy+In8Wv7dDpuY28M9oKJp7Pi+dmU+a7Qe4rw
Oa/cLH6jduIobEDaShJU56+x3C411MvlJtoP54wIgIdf8C+Xu12gKSebdEfH3N9I
sOxfm3qa27YvNVdSDpUxdN8O/luGqU4DIAyZmizhBANpG54Ad5bMKMMWdmWVtADJ
WntgKlSg36noEKqwnB5C3HSJg8xT8vgu1U1+pLOXP4Z97El10qwKRk2CapDD3mZw
Knw+NlFeI1Bfqci5Da7cU/zN4Y0Iz+uJ0OjX2fOxlXXW4pVBCJSDcme6Xn5ufsIa
TkueQhzsEcpPvPB5Up0UO4pZg9rOsxYe4D4Mn5K7lJ1vu1wncukzyjhOTR8yaa/q
XA3/ku31yvurfVb+GnxU
=M6TZ
-----END PGP SIGNATURE-----

--sU4rRG038CsJurvk--
