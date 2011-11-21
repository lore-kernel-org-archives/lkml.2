Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab1KUVKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:10:12 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59939 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1KUVKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:10:09 -0500
Date: Tue, 22 Nov 2011 08:09:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        herbert@gondor.hengli.com.au
Subject: Re: [PATCH v2.2 1/7] crypto: GnuPG based MPI lib - source files
 (part 1)
Message-Id: <20111122080958.1104b58698ed93803b48c22c@canb.auug.org.au>
In-Reply-To: <CALLzPKa9dAKTWTsFJg5SUDM0LkywDMOc0AYpYvv_tfsYF2wHDA@mail.gmail.com>
References: <cover.1319025009.git.dmitry.kasatkin@intel.com>
	<fad5214d102c09d2a2bf971483efb6e0dbee3937.1319025009.git.dmitry.kasatkin@intel.com>
	<20111119143337.cd84cfc59a78e0378dbd4089@canb.auug.org.au>
	<CALLzPKZ70YWb45k+8Z6ApH5MuN7HwBBTWbLcu-UtRkFU07cwmg@mail.gmail.com>
	<alpine.LRH.2.00.1111212227130.20158@tundra.namei.org>
	<CALLzPKa9dAKTWTsFJg5SUDM0LkywDMOc0AYpYvv_tfsYF2wHDA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Nov_2011_08_09_58_+1100_GzX+MaJJUMZGMzCw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Nov_2011_08_09_58_+1100_GzX+MaJJUMZGMzCw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

On Mon, 21 Nov 2011 17:32:54 +0200 "Kasatkin, Dmitry" <dmitry.kasatkin@inte=
l.com> wrote:
>
> In fact it does not break bisect, because compilation is enabled in
> the 3rd patch.

Ah. sorry, I missed that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Nov_2011_08_09_58_+1100_GzX+MaJJUMZGMzCw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOyr4mAAoJEECxmPOUX5FEWDoP/0QdPpNJmx9hqaAx0JSTawWd
rMRdprhi03tTUGDiRzDMF2AaPs47n8+bKNtPJys7Cy0mp+v2u1boHHsAsKK7D0pj
hvLT4lC1UTwEheiK82ZruyxqMigdXWAzEgE8mL3va7Qr4Jovvpl4ZgaAX9hejWJF
MCRv9EulTURXVfT47JElLXdU8s67wH+Cpnl0EbPKqOaxKtkHFt7cJVA/Lm7YsZrj
0YPO2mcWjVxd0Aadjj4eYrQU/qAJLHwPbng6SOUX87TMQ+dwpTtxU+hzTMJTRof3
or6aY9doGdpq0Qe3E6v8VCqSetRu82NNeQvKd2pfRiXDa4JGzkULr06SPN1/fjZD
7e71k+Q6tu1iKeOiZ7bHjFANPE1OMssbZjNjR5bYnqYkQtEfRknKMoV0TvUR/RJI
n6X1BpMdG4rDtSOR48rm7OmRvYzxkm2gGmEMdIh6sEK3Wgh0gyPs8fq+FcIGC2o5
Jm6juAUrS1W8UpVtKC1/DvpexIrqEUxG4lo0W5srSTxoGZk2XSMlKZXZLaKyUz/j
eSULaxDbOy8lwQG/Uh8N0yqUYkGRqIzvt4hJXMFciiFB1GpVf8NoT4D+CmB/xbKA
ue2LKof0NQFDRK7rjUn3SD6rYBEvlT0xPFzP9cgj17D4jK/eRE11PCBXa3BjKaE0
zlgzDl9sifSxyOmbqCAH
=A/+B
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Nov_2011_08_09_58_+1100_GzX+MaJJUMZGMzCw--
