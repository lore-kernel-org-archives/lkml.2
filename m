Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2DBOyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:54:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:57548 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab2DBOyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:54:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="136616916"
Message-ID: <1333378674.22146.18.camel@sauron.fi.intel.com>
Subject: Re: [patch] UBIFS: Add cryptographic functionality when a key is
 passed to the compress / decompress functions
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date: Mon, 02 Apr 2012 17:57:54 +0300
In-Reply-To: <alpine.DEB.2.00.1204021645070.29393@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	      <alpine.DEB.2.00.1202202112220.21022@eristoteles.iwoars.net>
	     <1330531826.3545.128.camel@sauron.fi.intel.com>
	     <alpine.DEB.2.00.1203191635030.22256@eristoteles.iwoars.net>
	  <1332511796.18717.72.camel@sauron.fi.intel.com>
	    <alpine.DEB.2.00.1203231739330.22944@eristoteles.iwoars.net>
	   <1332521515.22278.2.camel@sauron.fi.intel.com>
	   <alpine.DEB.2.00.1203252302310.5527@eristoteles.iwoars.net>
	   <alpine.DEB.2.00.1203252325100.5527@eristoteles.iwoars.net>
	  <1332837188.31549.14.camel@sauron.fi.intel.com>
	  <alpine.DEB.2.00.1203291639200.912@eristoteles.iwoars.net>
	 <1333377383.22146.14.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1204021645070.29393@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-acqWhqSzj0UQWawQILGr"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-acqWhqSzj0UQWawQILGr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-04-02 at 16:48 +0200, Joel Reardon wrote:
> >
> > You support only one length - please, kill ivlen parameter.
> >
> > Also, should ubifs_aes_crypt be static? I do not see any users outside
> > of compress.c. In this case remove the "ubifs_" prefix. But a
> > non-written convention, in UBIFS we _tend_ to prefix only non-static
> > functions with "ubifs_" and avoid having it for static functions.
> >
>=20
> Should length for key remain, and the IV is just the same? Or should the
> global #define just be used inside the aes function.

I guess I was a little confused WRT iv vs cryptokey. Anyway, I thought
you just use UBIFS_CRYPTO_KEYSIZE for all of this, why not to just use
the constant in this function? Why passing the length as an argument?

--=20
Best Regards,
Artem Bityutskiy

--=-acqWhqSzj0UQWawQILGr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPeb5yAAoJECmIfjd9wqK0Rt4QAKUUNE01BMt4AMnSLskOc9TL
dkCmmG3AjoyuWks+NJ3V1fNq3ajNq+Rn+C4GgUmv0UhPoI4/ih54sO4JXuD2NMBs
lqSZD/KTKUukEOiwxopw7W9yYn2gFiW0inoK0QdNMHqn70XMsFRrOGSFs/qNgnAH
4jdC4wLQD5H28VAV5qPHtx4xXF5lu4z4KoIBMqBVxI8zjD5bs9OqmbOMZKhisA/z
W5nwJA4QUdafa4s3CqKphaMUbUj4+dPrISCWg/cjGTwbmKlzKAh3Pu8o1v8IoXBx
reghqG1fnatxPDqdL7L17Ye3z7YQIwnWozZkmEsd/lerEQ6jFN80ThY6fZaWnewn
bxoEndvEerQA8eOMs6USzqQsI2wted5xCTcKO6dA3ID7S8XDL+akRYKijjDRq1Bt
QkHZaZBRHax1i5ygcPSNZ0fqTyeOFuVdzPWgr01qGXJPo4Pxx//l9pKIZJX6hRCD
/jBve+ZN2COhD5NxDGekkzqeRIA/QRrfvbr86x49M4x/MYc4zliM2GMBzVfdt1u1
za0P42CWMBMqxzjoX5IgujsMH06YCngMv99PKMI04Etlzm2z8ZxD55UBms1/lb4y
C/HrNgxrp3Ttnh17Ya8AqXu8r0wfLnUUJqzoFiMTemv7ef63McjJnrqwaR6oRiAP
HLeKR6TejCAelXmdcf1X
=/my3
-----END PGP SIGNATURE-----

--=-acqWhqSzj0UQWawQILGr--

