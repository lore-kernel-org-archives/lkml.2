Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab2CTWA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:00:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34616 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab2CTWAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:00:55 -0400
Date: Wed, 21 Mar 2012 09:00:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-Id: <20120321090038.06c65f50bd0329df8705f2cd@canb.auug.org.au>
In-Reply-To: <20120308180048.GC26516@kroah.com>
References: <20120308152110.12c805f59c45251d79bcb24b@canb.auug.org.au>
	<20120308180048.GC26516@kroah.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Mar_2012_09_00_38_+1100_7v7Jho74cPLZ/qBH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Mar_2012_09_00_38_+1100_7v7Jho74cPLZ/qBH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 8 Mar 2012 10:00:48 -0800 Greg KH <greg@kroah.com> wrote:
>
> On Thu, Mar 08, 2012 at 03:21:10PM +1100, Stephen Rothwell wrote:
> >=20
> > After merging the tip tree, today's linux-next build (x86_64 allmodconf=
ig)
> > failed like this:
> >=20
> > drivers/staging/sep/sep_driver.c:55:32: fatal error: linux/rar_register=
.h: No such file or directory
> >=20
> > Caused by commit 33e9970add94 ("x86/mid: Kill off Moorestown").
> >=20
> > Following previous instructions, I have disabled the staging tree driver
> > using this patch (pending a fix in the tip tree):
>=20
> Looks good to me.  Alan, care to send me an update that fixes this
> driver for real?

Was this ever fixed?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__21_Mar_2012_09_00_38_+1100_7v7Jho74cPLZ/qBH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPaP4GAAoJEECxmPOUX5FEspsP/0vamxq9HO1wZG1yu7KSiWwJ
NP5PAq6Tz8mBtNsQCki8k1/uFD9/grkxmMiPlTEwwbfktycUix6rQQYvn7pi1Q23
av6ae4/M2SbcxIRYdo3OyvSEZ4iIlecsVKJZdj59LiL2Ewtdr4aCr14XGDwRHbb9
/Jl82uK8AFTarknfnG2DqhyfFAJ2VjUvIvV91J5xNN5mwnFqj6lU3HVFUFgNeCrk
FF8onZNODsIblWKDRknT0OmtpJ4t7YyT7Gg3WLjt7deRY5MXaj7WjHo9alhaZpFf
GPzRXStY/bB+SW79UD80sRzPTntIg73k489MB91VfIzCDj2ntJEOnldRx9MryRsq
1DbpybIAlclGHNz2LGYzJ8A/JyfnD7zIBXAkF0RKfyfEyCKdmPutDhCEnT0UeWDI
Qi7eXfMdVs3BqbAgWssZN0z9d6v7LorKHEFhf7OCUaGrhJf7f74tLFKh8eEAwtYw
VDAXdmzD+bhjxFKqKinn5aoCLCRE6qsyAJGcRqAqPzn9BeVr+VBHyjLt7ECEjfwt
OxWe2qUyeOHHm+0T8KJO9mQcddZcqb6kHmAEaQCERgrLM/Jg7PWeb3U8Gm1De0Sf
j09HHJca+lsP+IxudBLjH3cYYrrHH6Uictc5E9EQzdKs8e9YZVNND+IB58pxPr7n
jFA4BavxOKmDMwHFtYhR
=qw8a
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Mar_2012_09_00_38_+1100_7v7Jho74cPLZ/qBH--
