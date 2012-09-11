Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab2IKGFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:05:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab2IKGFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:05:33 -0400
Date: Tue, 11 Sep 2012 16:05:23 +1000
From: NeilBrown <neilb@suse.de>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <linux-kernel@vger.kernel.org>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        <herbert@gondor.hengli.com.au>, <james.t.kukunas@linux.intel.com>
Subject: Re: [PATCH] add further __init annotations to crypto/xor.c
Message-ID: <20120911160523.3d5284f8@notabene.brown>
In-Reply-To: <504DF52C020000780009A301@nat28.tlf.novell.com>
References: <504DF52C020000780009A301@nat28.tlf.novell.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Wp+txC0jReUAIVBp_HbZiy/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Wp+txC0jReUAIVBp_HbZiy/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Sep 2012 13:11:56 +0100 "Jan Beulich" <JBeulich@suse.com> wrote:

> Allow particularly do_xor_speed() to be discarded post-init.
>=20
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>=20
> ---
>  crypto/xor.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> --- 3.6-rc5/crypto/xor.c
> +++ 3.6-rc5-sections-xor/crypto/xor.c
> @@ -56,11 +56,11 @@ xor_blocks(unsigned int src_count, unsig
>  EXPORT_SYMBOL(xor_blocks);
> =20
>  /* Set of all registered templates.  */
> -static struct xor_block_template *template_list;
> +static struct xor_block_template *__initdata template_list;
> =20
>  #define BENCH_SIZE (PAGE_SIZE)
> =20
> -static void
> +static void __init
>  do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
>  {
>  	int speed;
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

applied, thanks.
NeilBrown

--Sig_/Wp+txC0jReUAIVBp_HbZiy/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE7Uoznsnt1WYoG5AQJvxQ/9GEmHjS24Yzv9TQ85ibgReOcDKeesM2UV
7waXC1KstKmHAz2o4WdEOKLsoqYWGGVB6YNYxtSM9ZHCfjwJf77JeLlxFHBKdPs0
b3MkI9qG+WB8O84YQqJ34oBNhlXJEom9NbidmEsBHMQoe9/aoUsbRglCscxIkYBe
BD7DteAUtIYF/IZ8FcvyXZuumiXjPmahvuY/wi4DJyBZubdQ3tQWEyPVkpGvkDd4
l4l0gfbct41CDCX+etKpc4Gb4VxgvFPxVPPpZf5pNeTQoh+hkgXnlP74N1pamrzt
nhuLyrq/KOmzCAyLI+YcPsr7lHXBWDmUTxiSekK2VL7MYpK3Y97D18m67crkuaI2
dTjGbegfCUUKMs3Gvr4gQScRth4pfDQUvL228hYB/ZlxBHbiWd1ttpEWj49x4Bff
evE/j80ZJ8ZEhAyUlSdHwdqEHkiZp5fZn3MMgBKrqiBxjv+i4Jn5zSNT+rp8c4sI
zpNwZ8uFq7cXAg+VBLHgCYQflkJfn15/JjoJlIk8auRRuGcythRmRFIBcQD6/RXS
wY48G2ZLi29WRU5TPMqBIy2olJPhxyvviA3ZxKEVKpmXOoM8KU50Is9ewZreolYJ
cFeucW+KP7lJHBlnVRz8AKSDvtEn4WGpKEWblxMKJoik46p5VZxpXKWEfbbXEMep
xxfJVqsVL0M=
=czHH
-----END PGP SIGNATURE-----

--Sig_/Wp+txC0jReUAIVBp_HbZiy/--
