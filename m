Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab0IPH1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:27:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47482 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab0IPH1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:27:39 -0400
Date: Thu, 16 Sep 2010 17:27:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
Message-Id: <20100916172732.ce21cd1b.sfr@canb.auug.org.au>
In-Reply-To: <4C91C544.5050907@kernel.org>
References: <20100914002932.850d02f3.sfr@canb.auug.org.au>
	<20100916163218.e09be473.sfr@canb.auug.org.au>
	<20100916063922.GA17596@elte.hu>
	<20100916170939.22e38e4c.sfr@canb.auug.org.au>
	<4C91C544.5050907@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Sep_2010_17_27_32_+1000_4fYV7em_/zyE5GWy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Sep_2010_17_27_32_+1000_4fYV7em_/zyE5GWy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yinghai,

On Thu, 16 Sep 2010 00:20:36 -0700 Yinghai Lu <yinghai@kernel.org> wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>

I did not write this patch ...

> @@ -249,9 +249,8 @@ static void arm_memory_present(void)
>  static void arm_memory_present(void)
>  {
>  	struct memblock_region *reg;
> -	int i;
> =20
> -	for_each_memblock(memory, reg) {
> +	for_each_memblock(memory, reg)
>  		memory_present(0, memblock_region_base_pfn(reg),
>  			       memblock_region_end_pfn(reg));
>  }

That looks good (but I have not tested it).  Thanks

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Sep_2010_17_27_32_+1000_4fYV7em_/zyE5GWy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkcbkAAoJEDMEi1NhKgbsEHoH/A8//9pRCoeXtc12WKOUaOFv
818QxPw0tiIX3n4yzYg2KcFSdjyttZDHyWQDynW3On3DS/9qqxUnGQxKjDIHOMgE
WOh5gIZhbCIHynTrzoQuDvt4v05n8zoRgIXk6Uy5Ihl+mVrAWJ5mlqrgO+uQR8B9
wrfLYZytPnIEdu3P/a79n/XTdui8wetaIfE05XAa6laSrXdyqZMUktLyhM2/l3DN
8V/G+BkbjFGepcfZmIuQRffZmROFG5TdgNk4w9dxEMC8ZaC9N6KH/7Ac73GSkRzM
esKmtevSBKOgkaAvLFriM4gbb3oxepVKE+bpOD5KwQfdyuzX3mEAX82Sw7wdj8w=
=CKY5
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Sep_2010_17_27_32_+1000_4fYV7em_/zyE5GWy--
