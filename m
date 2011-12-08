Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab1LHP1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 10:27:23 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:47394 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab1LHP1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 10:27:20 -0500
Date: Thu, 8 Dec 2011 10:27:19 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Avi Kivity <avi@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5 V5] Add generic stubs for kvm stop check functions
Message-ID: <20111208152719.GD6301@mgebm.net>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <1323116344-17911-5-git-send-email-emunson@mgebm.net>
 <4EDF79DF.6050209@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
Content-Disposition: inline
In-Reply-To: <4EDF79DF.6050209@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 07 Dec 2011, Avi Kivity wrote:

> On 12/05/2011 10:19 PM, Eric B Munson wrote:
> >
> > diff --git a/include/asm-generic/kvm_para.h b/include/asm-generic/kvm_p=
ara.h
> > new file mode 100644
> > index 0000000..177e1eb
> > --- /dev/null
> > +++ b/include/asm-generic/kvm_para.h
> > @@ -0,0 +1,14 @@
> > +#ifndef _ASM_GENERIC_KVM_PARA_H
> > +#define _ASM_GENERIC_KVM_PARA_H
> > +
> > +
> > +/*
> > + * This function is used by architectures that support kvm to avoid is=
suing
> > + * false soft lockup messages.
> > + */
> > +static inline bool kvm_check_and_clear_guest_paused(int cpu)
> > +{
> > +	return false;
> > +}
> > +
> > +#endif
>=20
> Please fold into patch 2.

Will do for V6.

>=20
> What about arch/{ia64,s390,powerpc}/include/asm/kvm_para.h?
>=20

I will add the above to those as well.

> --=20
> error compiling committee.c: too many arguments to function
>=20

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO4NdXAAoJEKhG9nGc1bpJ+j4P/jaPyA9IkUJxCxXzhBRYAZ65
DHoOmp2yOP0Y70Fu382BqWu5O43fcW68D7s/vRU8qoHA1HelYSG2SGhIeUezIvks
3ZcSFg4VphIbdWx/eDmG/d3e4ZQKguAmXIPmS66nbNGRkuwrtyHAR1Q3DU0/rrnz
FMysPTMtUOtY/5qrYNX7wpNX2QHRkOFM5QxLOaWlPu9ESIwe1juJbJ42JwqA8Ben
0L7o6+RqU0TCTNtvGBdYB0yNBTJAm9rSoPhqwG6VJ7uYOx9nB+SA8nyOcg+PYJbr
RvxmKXWJPeIZW/uM87Akzn7BE3rN4cCIwF+qIwTuFm2QG7hd8zABMdaQnePJa6OB
4JZykWWIqPH+i6Op/LohYL1OQWlzHV2zu+qJgtWPkk1islfPUKxlAR2dBq7u7Iba
OWesTOJKtDCNqIt519cOAwPpvlFh3u3hPygFtPEU2x08B4ipPcxnVBA083oeyL+N
RmjQNMSwOZ3ztgZN8qSNorcIL3ZB4ivergcRgvfu9q2u9IycSkKERGHb52Jwzv9Z
ZVYlBQrQVh3B/lH3dZvspea+PaRcPVwQfFz+3VAqy7Waom8L1Z1PTUdoe1N2GrXB
ExEDeMkrNmeXdd6BZ7GCawaRoH0LJ4kNUUWEP7XFecFB7xaMD1hARD0uBVPzqiG/
HYU44+8A3dFIw3w/odWq
=bZNe
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
