Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162668Ab1FAIq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:46:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40429 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161492Ab1FAIqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:46:18 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110601080304.051730779@blue.kroah.org>
References: <20110601080304.051730779@blue.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-ICQUvSn14QYocu/OUyzl"
Date: Wed, 01 Jun 2011 09:46:13 +0100
Message-ID: <1306917973.22348.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [040/146] [PARISC] wire up syncfs syscall
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ICQUvSn14QYocu/OUyzl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-06-01 at 16:59 +0900, Greg KH wrote:
> 2.6.38-stable review patch.  If anyone has any objections, please let us =
know.

Also added in 2.6.39, not 2.6.38.

Ben.

> ------------------
>=20
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
>=20
> commit 2e7bad5f34b5beed47542490c760ed26574e38ba upstream.
>=20
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> ---
>  arch/parisc/include/asm/unistd.h   |    3 ++-
>  arch/parisc/kernel/syscall_table.S |    1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
>=20
> --- a/arch/parisc/include/asm/unistd.h
> +++ b/arch/parisc/include/asm/unistd.h
> @@ -819,8 +819,9 @@
>  #define __NR_clock_adjtime	(__NR_Linux + 324)
>  #define __NR_name_to_handle_at	(__NR_Linux + 325)
>  #define __NR_open_by_handle_at	(__NR_Linux + 326)
> +#define __NR_syncfs		(__NR_Linux + 327)
> =20
> -#define __NR_Linux_syscalls	(__NR_open_by_handle_at + 1)
> +#define __NR_Linux_syscalls	(__NR_syncfs + 1)
> =20
>=20
>  #define __IGNORE_select		/* newselect */
> --- a/arch/parisc/kernel/syscall_table.S
> +++ b/arch/parisc/kernel/syscall_table.S
> @@ -425,6 +425,7 @@
>  	ENTRY_COMP(clock_adjtime)
>  	ENTRY_SAME(name_to_handle_at)	/* 325 */
>  	ENTRY_COMP(open_by_handle_at)
> +	ENTRY_SAME(syncfs)
> =20
>  	/* Nothing yet */
> =20
>=20
>=20
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review
>=20

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-ICQUvSn14QYocu/OUyzl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATeX8VOe/yOyVhhEJAQqPJg//VYWN0ep6RTM9DMcu58oXec2eDeC35nlp
fBOZTaoMadFJKEjj3dKUyUcIFU4kOnN4MkyiUa4B/Drzy23ZMDVLvFAjdbvaafmv
WwBnrR/Xc1ISfZrrmoQ15U3pIXg4AhXRA2YQNtPxDUsU/t9zMsZtYgfAkInjUtmP
TB+zu1wPVi11fhAN8j5q4DmkFP7a6JoUpXUewMoD2WmVsf2yqcTmyIZl+6IrRrHj
95hBCWTlXXxbr2mPD2EVx/09IwVlIirKfBggcW2bgfQHXwfcMtgExUOytN3jWMKj
ZIDo1XXcGhUZljeV0MuklbD+ajjA5cCEw6/wKMoEZhmfJRItl5ixtEWExolDDviT
tzb92UQFea3hv+7HtiowFvA8vDyLiDhqCS9GUM4LPMOdqzPyNadvhQk5lChBWPg1
Mw+Yz2zDkiBFhmKJGZSitqciDVNZ6OROwBpPWswWzZIdWjR7enqtTCgoCyu47M4/
/GmAcj8HzaUo8KJ9qXwUFVx6llEzCFRKHv+ErROdPDN34sMrw8Jp2oGT8HMCu121
m6p5O7Hqfwi6vxGTo4Ih3VlFhtsSqvpVzGWgVKe7qlZn2jzzxQYljpCQhiSNyQt+
Na4OUH3R/+AZ/JK68/ga5Rvmigz76hawDLMXYMOEHjYpgXweKM3dou6hUPh9DgZR
qtnJsrUR2IA=
=OJZF
-----END PGP SIGNATURE-----

--=-ICQUvSn14QYocu/OUyzl--
