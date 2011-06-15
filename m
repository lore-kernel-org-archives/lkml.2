Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1FOM3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 08:29:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45741 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab1FOM3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 08:29:44 -0400
Date: Wed, 15 Jun 2011 22:29:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.0-rc3
Message-Id: <20110615222932.05a863fc.sfr@canb.auug.org.au>
In-Reply-To: <1308138281.4112.3.camel@Tux>
References: <1308138281.4112.3.camel@Tux>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Jun_2011_22_29_32_+1000_ZRcosJOo/Tj7C/XG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Jun_2011_22_29_32_+1000_ZRcosJOo/Tj7C/XG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Jun 2011 19:44:41 +0800 Wanlong Gao <wanlong.gao@gmail.com> wrot=
e:
>
> <snip>
> I see that some mips fixes in ralf's tree but not been pulled. almost
> for about one month.

Well, the mips tree in linux-next is
git://git.linux-mips.org/pub/scm/upstream-sfr.git#mips-for-linux-next and
I fetch it every day.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Jun_2011_22_29_32_+1000_ZRcosJOo/Tj7C/XG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+KWsAAoJEDMEi1NhKgbsGTAH/14CwQWtKSViDwvgCtUDInS1
rs4EvYTT6/B28U3M5l+BNEDH5aTUVM6rKxZYpS+xDMb5nD6fQq4OW66C/ilAqWfw
oRMbv1AmikJf2KXyTDTI3oghe6aDfZusWhSPIo+/gHeOCRXTAuiIOLFuASgjD+G7
8CEKIRFDSLBDXUitjXFOUy7DjcwqSsy66yL/kUaSQa6SZpJPqZ9xytaokhiC8Frw
Z5Ih4awd1VX3+hAaXcjFLyfIGe6ZymPuRmg1IwBB4QHDLdKUOX+Dgd2s/NZVg2JS
TsF9Z84xQXu2sGMo1MyK0XAyL9hx++3IB58RSVIyKrXLhe2nj+75y9ogxZNkg9Y=
=oewP
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Jun_2011_22_29_32_+1000_ZRcosJOo/Tj7C/XG--
