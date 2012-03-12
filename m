Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2CLBHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 21:07:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53447 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754016Ab2CLBHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 21:07:36 -0400
Message-ID: <1331514446.3022.140.camel@deadeye>
Subject: Re: [ 02/12] Remove COMPAT_IA32 support
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 12 Mar 2012 01:07:26 +0000
In-Reply-To: <20120312002046.041448832@1wt.eu>
References: <20120312002046.041448832@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-nZK4uO5dEQLskjifPF0h"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nZK4uO5dEQLskjifPF0h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-03-12 at 01:20 +0100, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.

The subject/first line should include '[IA64]', as in the original
commit.  It looks like this has been automatically stripped.

Ben.

> ------------------
>=20
> From: Ben Hutchings <ben@decadent.org.uk>
>=20
> commit 32974ad4907cdde6c9de612cd1b2ee0568fb9409 upstream
>=20
> This just changes Kconfig rather than touching all the other files the
> original commit did.
>=20
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  arch/ia64/Kconfig |   17 -----------------
>  1 files changed, 0 insertions(+), 17 deletions(-)
>=20
> diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
> index 1ee596c..20fc9c5 100644
> --- a/arch/ia64/Kconfig
> +++ b/arch/ia64/Kconfig
> @@ -502,23 +502,6 @@ config ARCH_PROC_KCORE_TEXT
>  	def_bool y
>  	depends on PROC_KCORE
> =20
> -config IA32_SUPPORT
> -	bool "Support for Linux/x86 binaries"
> -	help
> -	  IA-64 processors can execute IA-32 (X86) instructions.  By
> -	  saying Y here, the kernel will include IA-32 system call
> -	  emulation support which makes it possible to transparently
> -	  run IA-32 Linux binaries on an IA-64 Linux system.
> -	  If in doubt, say Y.
> -
> -config COMPAT
> -	bool
> -	depends on IA32_SUPPORT
> -	default y
> -
> -config COMPAT_FOR_U64_ALIGNMENT
> -	def_bool COMPAT
> -
>  config IA64_MCA_RECOVERY
>  	tristate "MCA recovery from errors other than TLB."
> =20

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-nZK4uO5dEQLskjifPF0h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT11MTue/yOyVhhEJAQrKcBAAn9Q61emBImJh0SyudQ1MoP7ueWuWgib8
zhEvgQiKtNlzCx5KYmGxXP1VLRHEVlWK5lKkyeWSfa6rUEEAr1FOA2jhEnlSCCst
Pcl+q/eDQo+WtC50uBs9TBoxikFYTohLEFIEGHkOu6iFCOl1WrnJd6KXICA+r+Wy
t9eZjetfuni7VPpnaEQaKg5ZwzMb0arUfhLJ5iVElSRem6X2B6/YSrYnMIGqH01v
a4Mu2ok+9wr9bmbRepDYfCj4rvKe0ONDKG0muvaMP1sVRC7BccAUtJmoKtKcjehm
rVyd8rl0JfqX4hMFBoIIUKD6F8qT8zR+FiDb6nuRctnuXq7tl3Mq9xJ6AtFyT4x1
lsvzPjeIUQfUsaTRiCJ6n0hWQZfPwMTDKWufjdrakwXav8Nf+siBKgQb3YstRyvC
Pnwgy2geYRG2Bactl4MKSU/1Et3gf0IoTfNDZ3YQ7Ab227nWwix3IWpbwRyvNjj4
OCthxX6RfUrpePLp5jI9yuWeXh1ard168JCwx1Se9NUk6XKJdyvByHTZrzXbOdDG
yrdNm/sIgvxUtm0TuDf6PF2YUP2Fr8mH3dhPmioV4o9NygMuvXT9dg50P9/8E4Mc
LwQYXKfnJ1kzivAA/uSir1rvqeRg1iRl0grMED7duA6JYd5ORBtE+CJhiqPgstoC
fjAGeevQDiU=
=i3PJ
-----END PGP SIGNATURE-----

--=-nZK4uO5dEQLskjifPF0h--
