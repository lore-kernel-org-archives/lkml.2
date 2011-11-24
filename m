Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab1KXKaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:30:35 -0500
Received: from vm1.sequanux.org ([188.165.36.56]:37980 "EHLO vm1.sequanux.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785Ab1KXKad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:30:33 -0500
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Nov 2011 05:30:33 EST
Date: Thu, 24 Nov 2011 11:29:49 +0100
From: Simon Guinot <simon@sequanux.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <trivial@kernel.org>, Simon Guinot <sguinot@lacie.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] [RESEND] leds: Kconfig: Fix typo 'D2NET_V2'
Message-ID: <20111124102949.GA18490@kw.sim.vm.gnt>
References: <1322129317.25125.13.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <1322129317.25125.13.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Thu, Nov 24, 2011 at 11:08:37AM +0100, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) This corrects an obvious typo. That typo was added in commit
> 84712e9aa4 ("[ARM] Kirkwood: add LaCie d2 Network v2 support") which
> added support for 'MACH_D2NET_V2'.
>=20
> 1) I sent this yesterday to trivial@kernel.org only. However, this
> allows people using a "LaCie d2 Network v2 NAS Board" to enable "LED
> support for Network Space v2 GPIO LEDs" and thus lets them run code that
> they can't run now. So, to be really safe, this time I've also CC'd the

They can run this code because more likely the same binary kernel
supports all the Kirkwood machines, including MACH_NETSPACE_V2, etc...

And that's why I missed this typo :)

> people involved in that commit to (perhaps test this and) ACK or NAK
> this.

Acked-by: Simon Guinot <sguinot@lacie.com>

Thanks for the patch.

Simon

>=20
>  drivers/leds/Kconfig |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index ff203a4..1b75a56 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -347,7 +347,8 @@ config LEDS_MC13783
>  config LEDS_NS2
>  	tristate "LED support for Network Space v2 GPIO LEDs"
>  	depends on LEDS_CLASS
> -	depends on MACH_NETSPACE_V2 || MACH_INETSPACE_V2 || MACH_NETSPACE_MAX_V=
2 || D2NET_V2
> +	depends on MACH_NETSPACE_V2 || MACH_INETSPACE_V2 || \
> +		   MACH_NETSPACE_MAX_V2 || MACH_D2NET_V2
>  	default y
>  	help
>  	  This option enable support for the dual-GPIO LED found on the
> --=20
> 1.7.7.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7OHJ0ACgkQgtp0PDeOcDoZ+gCgoPIMcwXc6svBWcry009lsjyZ
F0cAn0BUKMCkarcgbm9P3sJsxY5IPipb
=7pWE
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
