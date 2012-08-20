Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab2HTEyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:54:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53968 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab2HTEyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:54:17 -0400
Date: Mon, 20 Aug 2012 14:54:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Namhyung Kim <namhyung@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-Id: <20120820145404.f12977568303f4982ce89e8e@canb.auug.org.au>
In-Reply-To: <20120817115019.GJ2438@linux.vnet.ibm.com>
References: <20120816131236.13013e1ec18b1f1074f6dc92@canb.auug.org.au>
	<20120816194651.GK2445@linux.vnet.ibm.com>
	<20120817105633.0aba80ddf7eb9523e04c264d@canb.auug.org.au>
	<20120817115019.GJ2438@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__20_Aug_2012_14_54_04_+1000_LYzqDb00YNwulCj1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Aug_2012_14_54_04_+1000_LYzqDb00YNwulCj1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Fri, 17 Aug 2012 04:50:19 -0700 "Paul E. McKenney" <paulmck@linux.vnet.i=
bm.com> wrote:
>
> Does the following help?

Yes, that fixes the warnings.  Please submit those two patches to the tip
folks ASAP as I can't build the tip tree without them.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__20_Aug_2012_14_54_04_+1000_LYzqDb00YNwulCj1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQMcLsAAoJEECxmPOUX5FEnSIQAIpxM6xgI9r1rUFlNvdGo2cv
chKkoneW6AGFr+3nCo1CVgkf8XIsPOU+sTHS7QlWVUp0IyZP4iHzYQ05p6FTOFGT
cJ2Ju8N4L+nG/WW86PmnEmc/r4pOvKNvqjMMbGfgLSXSXLSkbMgibnttLuz0SWhK
WOpxShHoZXIOHRUDwId58ppm8I/WvJrgLC9k0ithaG5nvytiRBcwckBL8fb483r3
WpJEF3W5+Ig4o6Xv7QXwbQeBhX93eP2znz4CLUUduTax+ZDEKUK+BMayFsiAJWFX
oGE6erz8UyegI5uRh8uPoxOvtCrduWwRF0JfDJ2R7eir71ck8C3c8SzCniyJg6Xc
9QmFghN10d5/Ztf92rQoE2KwrUv3355Zvtc1dEkfMdWPCZTQJ92j7rshzgkFopEi
1ilV2AuVDJBTwDGFjpr+AfWJGHD2MGwsPhaEo2FWERcAtv7+JoCfk6X/a5Wm3Umo
JXrapPyi05fOJqtDYE/Pc9x8v44vHJ7nc/cqTv1XNoERnB29oMaI/wu0iGtr4Xno
L51Cj6BeYODhvFc3gwiEJewMiBa/azudO3C4m6eXGhM0T7P4tG/WLqbpE/pahpoj
8cQ9PrikHqIUVtixz0SdHe6KrPEVff96zTEYVHr31a/7samzxRm+8etF65jmgXag
RyGEMyNV7u8JjIX8KNVs
=hd/O
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Aug_2012_14_54_04_+1000_LYzqDb00YNwulCj1--
