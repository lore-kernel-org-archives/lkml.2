Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab2JWUXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:23:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933443Ab2JWUXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:23:31 -0400
Date: Wed, 24 Oct 2012 07:23:47 +1100
From: NeilBrown <neilb@suse.de>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 061/193] drivers/md: remove CONFIG_EXPERIMENTAL
Message-ID: <20121024072347.65f3e930@notabene.brown>
In-Reply-To: <1351022666-6960-62-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-62-git-send-email-keescook@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+uj.rfX8jUq7=5K06Bq+KYn"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+uj.rfX8jUq7=5K06Bq+KYn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Oct 2012 13:02:14 -0700 Kees Cook <keescook@chromium.org> wrote:

> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
>=20
> CC: Neil Brown <neilb@suse.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/md/Kconfig |   25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 91a02ee..f583e96 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -155,10 +155,9 @@ config MD_RAID456
>  	  If unsure, say Y.
> =20
>  config MULTICORE_RAID456
> -	bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
> +	bool "RAID-4/RAID-5/RAID-6 Multicore processing"
>  	depends on MD_RAID456
>  	depends on SMP
> -	depends on EXPERIMENTAL
>  	---help---
>  	  Enable the raid456 module to dispatch per-stripe raid operations to a
>  	  thread pool.

I'm happy to remove the "depends on EXPERIMENTAL".
I'm not so happy to remove the "(EXPERIMENTAL)" text.  That code really
shouldn't be used in production - just for experiments.

Thanks,
NeilBrown

--Sig_/+uj.rfX8jUq7=5K06Bq+KYn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIb80znsnt1WYoG5AQJ9TxAAgYlGt3UPVkpq96t9yIE6i+uXQxJjdO9q
3WlRXQFYmX23eHIBavR55i+JuEGnJZZAy3OxUzqODAMkqjJzp+UbLkYASPKMByML
vGaIG+NdhxRUvueQDLYs8Uhln9TLJZ6TQ9GOjVDvBZVCSYxxIOxK6rkkiqoLTPoT
uj/hm3rSYe+5hUvV1INzDkM/dopNxc8eEh1wH1A3V+jDxo/AjO+Z0nkOz57KSVnN
0NjEni90UPwq/FmwrigMwy8JykQsV7KePk3dEH7YM2SAND0W/gtmYs/Gd8d+s5rW
+qR0LC9a/c6GUhsU54ChAhUwIY43sFic8cTyeUgzvpT4Lu8xRDdRVaIB3ZzbJJiE
O64zT2KPWcyDALnOT2NTz1OEss4eNlL1pAD6lxWDMLXw0kGn2nAIq2z9ZDkStuKl
MuEiig6JzpnbO47nGm6hNr6DTnLxyTL1LPhOHa2HFccizFi9/QYx4dtSrS6SlrDT
OC+Wwre3AgbjnD3yepNph3mTYbyV8jhZsCOTwIG9jkDhvsV+8zzCgYMazdgma4Ey
x11rAiQF4uZ+iUPDO69HHmqc06WLSmx+XdUlj+f6DKwcwFCmkmGJ2tjw1o20pbNi
qyezvx17HkaixFffu2bbeH0NWQeUoFgTE2mtFTQ+CdeFeE9T/6FH+K7RX/8V/3pw
IUTN7juxTto=
=1t7E
-----END PGP SIGNATURE-----

--Sig_/+uj.rfX8jUq7=5K06Bq+KYn--
