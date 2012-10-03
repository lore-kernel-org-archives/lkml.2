Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab2JCXIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:08:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36958 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab2JCXIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:08:15 -0400
Date: Thu, 4 Oct 2012 09:08:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH -next] asymmetric keys: fix printk format warning
Message-Id: <20121004090806.70274213735de74211f4334d@canb.auug.org.au>
In-Reply-To: <506CC48E.2020303@xenotime.net>
References: <20121003173007.c322d79c31676b9494a6bfd5@canb.auug.org.au>
	<506CC48E.2020303@xenotime.net>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Oct_2012_09_08_06_+1000_HbjgVEvsKnic/mrA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Oct_2012_09_08_06_+1000_HbjgVEvsKnic/mrA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Lets also cc Rusty who committed the patch ...]

On Wed, 03 Oct 2012 16:04:46 -0700 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> From: Randy Dunlap <rdunlap@xenotime.net>
>=20
> Fix printk format warning in x509_cert_parser.c:
>=20
> crypto/asymmetric_keys/x509_cert_parser.c: In function 'x509_note_OID':
> crypto/asymmetric_keys/x509_cert_parser.c:113:3: warning: format '%zu' ex=
pects type 'size_t', but argument 2 has type 'long unsigned int'
>=20
> Builds cleanly on i386 and x86_64.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> ---
>  crypto/asymmetric_keys/x509_cert_parser.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- linux-next-20121003.orig/crypto/asymmetric_keys/x509_cert_parser.c
> +++ linux-next-20121003/crypto/asymmetric_keys/x509_cert_parser.c
> @@ -110,7 +110,7 @@ int x509_note_OID(void *context, size_t
>  	if (ctx->last_oid =3D=3D OID__NR) {
>  		char buffer[50];
>  		sprint_oid(value, vlen, buffer, sizeof(buffer));
> -		pr_debug("Unknown OID: [%zu] %s\n",
> +		pr_debug("Unknown OID: [%lu] %s\n",
>  			 (unsigned long)value - ctx->data, buffer);
>  	}
>  	return 0;
>=20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Oct_2012_09_08_06_+1000_HbjgVEvsKnic/mrA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQbMVWAAoJEECxmPOUX5FEfMYQAIOtycJymW1cUHVtns7qmTWe
GTsQtKy3G/WiM0kjwC0bYTGj9RpSxEvj0+7K1y71soc3qrFbsuEWqcwC3hJ9iqQ4
Mwh7BEpOzCnlKJ6KTYPWreEOK3X0yjgWaS8AzG0nGn60Luep2c78hba3ZOsGd9IP
/go+U28LJM6FhnpSJZ6haMw1H2NRyXkThJehjMvNZNLSrT1QAMnDJjw6VS1eMgYf
XDD1HP5GAMWrY5KzBRqwgk1yYJ682y+OWro8cq8E65D+E2tjgEs9iAAPTfJie46H
Dcl6GmOEBElP68z1uQliEuSaDnuxOM6yoQJQKQF44gNdOW5hcIYLCOc/Un10Edhz
NK3ruiFPWw5M/2rPcYVunsqD1HooUqzVpp87hFPdVCIJRKPXpzTXWbKvlvKiHjfk
ymvVxObZpU/99xEvNK2PQMUvAVc1sFf7351SDYuI7kAZ4j/rsX/OHOnxYhDo5n0A
uPUWv0AKgMO/azRWSSf/BkuuWti3MztFKE0ex6Ko4dDtrLBho/4WpaT18x9LekmQ
nk08n8SSaQ9nNcxtjnbyx/tii9MpO1uTPEbFm4r9JI4MJqKAiVmi/qvKUe6O4iOE
A0Qb7cedH353ylR85GCro9tkDf9/HUrH7c217WF023UzVWoRS5Pt+e8dCfQc/Y8t
oTjROrdDkrc7u88C0eAJ
=ggiV
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Oct_2012_09_08_06_+1000_HbjgVEvsKnic/mrA--
