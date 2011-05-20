Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935315Ab1ETFOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:14:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46640 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935215Ab1ETFOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:14:36 -0400
Date: Fri, 20 May 2011 15:14:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build warning after merge of the final tree
 (tip/powerpc tree related)
Message-Id: <20110520151431.465d11f4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__20_May_2011_15_14_31_+1000_5U+o0j1aFoqgAidv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_May_2011_15_14_31_+1000_5U+o0j1aFoqgAidv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc allnoconfig)
produced these warnings:

kernel/time/clocksource.c: In function '__clocksource_updatefreq_scale':
kernel/time/clocksource.c:655: warning: comparison of distinct pointer type=
s lacks a cast
kernel/time/clocksource.c:655: warning: right shift count >=3D width of type
kernel/time/clocksource.c:655: warning: passing argument 1 of '__div64_32' =
from incompatible pointer type
include/asm-generic/div64.h:35: note: expected 'uint64_t *' but argument is=
 of type 'long unsigned int *'
kernel/time/clocksource.c:656: warning: comparison of distinct pointer type=
s lacks a cast
kernel/time/clocksource.c:656: warning: right shift count >=3D width of type
kernel/time/clocksource.c:656: warning: passing argument 1 of '__div64_32' =
from incompatible pointer type
include/asm-generic/div64.h:35: note: expected 'uint64_t *' but argument is=
 of type 'long unsigned int *'
kernel/time/clockevents.c: In function 'clockevents_config':
kernel/time/clockevents.c:211: warning: comparison of distinct pointer type=
s lacks a cast
kernel/time/clockevents.c:211: warning: right shift count >=3D width of type
kernel/time/clockevents.c:211: warning: passing argument 1 of '__div64_32' =
from incompatible pointer type
include/asm-generic/div64.h:35: note: expected 'uint64_t *' but argument is=
 of type 'long unsigned int *'

This is a 32 bit build.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__20_May_2011_15_14_31_+1000_5U+o0j1aFoqgAidv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN1fi3AAoJEDMEi1NhKgbsP48IAJaR84HEt22QdHsKL+BwcG1t
+yhK+RrrVIesHQfUZl8UzuLRaBFQxp7FtO8HJ9wK0hPkqi96BAzU3MKFN0E6uI1n
bGUEnOwLDpwO3491ecoJwoR+pjtyyrJeO/h7ehT4OpY66CcCFBvoPOiA0uNx7Vxy
5rHGOAl773T6o2KBXai63MbC2aeI6bxaucWLH3rhhX9Iyw5Q0MvSUtUbpYNleINX
Fs0/dNnojbkVHI/jpzNFyu1+CCQGnvM4C+L5F506PEnxwB1Bz5AOtVWVu6chfIEt
zsv0+0DJ0BsvklhaSGa+d8zTT8h4ai/yzHKORhE9uIY91h1jZpSKlNUBmaMR8Uw=
=03S+
-----END PGP SIGNATURE-----

--Signature=_Fri__20_May_2011_15_14_31_+1000_5U+o0j1aFoqgAidv--
