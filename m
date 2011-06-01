Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162730Ab1FAIpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:45:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40414 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162668Ab1FAIp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:45:29 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110601080303.433532961@blue.kroah.org>
References: <20110601080303.433532961@blue.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-dqBGBhahCq0/WCTFpGJ+"
Date: Wed, 01 Jun 2011 09:45:21 +0100
Message-ID: <1306917921.22348.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [039/146] [PARISC] wire up the fhandle syscalls
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dqBGBhahCq0/WCTFpGJ+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-06-01 at 16:59 +0900, Greg KH wrote:
> 2.6.38-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------

These syscalls were added in 2.6.39!

Ben.

> From: James Bottomley <James.Bottomley@HansenPartnership.com>
>=20
> commit a71aae4cec120ee85cf32608fca40a4605461214 upstream.
>=20
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> ---
>  arch/parisc/include/asm/unistd.h   |    4 +++-
>  arch/parisc/kernel/syscall_table.S |    2 ++
>  2 files changed, 5 insertions(+), 1 deletion(-)
>=20
> --- a/arch/parisc/include/asm/unistd.h
> +++ b/arch/parisc/include/asm/unistd.h
> @@ -817,8 +817,10 @@
>  #define __NR_fanotify_init	(__NR_Linux + 322)
>  #define __NR_fanotify_mark	(__NR_Linux + 323)
>  #define __NR_clock_adjtime	(__NR_Linux + 324)
> +#define __NR_name_to_handle_at	(__NR_Linux + 325)
> +#define __NR_open_by_handle_at	(__NR_Linux + 326)
> =20
> -#define __NR_Linux_syscalls	(__NR_clock_adjtime + 1)
> +#define __NR_Linux_syscalls	(__NR_open_by_handle_at + 1)
> =20
>=20
>  #define __IGNORE_select		/* newselect */
> --- a/arch/parisc/kernel/syscall_table.S
> +++ b/arch/parisc/kernel/syscall_table.S
> @@ -423,6 +423,8 @@
>  	ENTRY_SAME(fanotify_init)
>  	ENTRY_COMP(fanotify_mark)
>  	ENTRY_COMP(clock_adjtime)
> +	ENTRY_SAME(name_to_handle_at)	/* 325 */
> +	ENTRY_COMP(open_by_handle_at)
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

--=-dqBGBhahCq0/WCTFpGJ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATeX8IOe/yOyVhhEJAQoTtxAAw40jCxyNlmp5RtE9gsFBpn9QD6Lirx19
cDf+byMp10yDdk4ES5edD5dOavwDQ/Z2qIbMnXHs979oPdmeq7plXmKV6ePBaXCW
wjH7reiaPbD2n02f6BLVA5sTVOq/AehJlWXp/iz3gI60s+FCWEmagBlYpk9M4fjc
/qrCKbsjHiQeYnGeBEjtmmaj+3DiIdBCE0CqOGhKgJt2YgWHxsMv5XCsfdL/GWeF
XfXwhmlXOpAZ37sJY2gOtV9SaM6T3yl9/VlKcqJviHbsmPq35jkf/qDJuYMWm2dQ
s5xF5t/AgFi0Z5Cu+sTBgzDpSzh4MkebznYjG+3MgPocP6Op/jQ2Hg0LCtpYEHL9
/4DO98ScpSv4coBWwyT7IcVZVROWZVypb40p8IMFUhRbtpmBMRj2Z0TAaG4roxV3
MXfA6YCT7wJSthydYx2dLQnO5FFZKedb/1KZpdcNrFoKyuc7+aC0o5ivILpVru0L
bgaqVBL7tNiqlmqcYYmcfnQHPj15MDLslQJspvfKXgAiq1LrN5P2L2qe3hSzn7H3
mK9rAR0+lBvf7WraEZEBCKUu1/F0rl3pRoWQm2NQaFkXdtJPQKN+Y42uqAdFRV1l
6UD31edu1h+axKkfxks1nvrynSsbNCN559SnBFLsmligZliR6O3YQkhLTOiQscIx
1NMydVMTXwo=
=xzxV
-----END PGP SIGNATURE-----

--=-dqBGBhahCq0/WCTFpGJ+--
