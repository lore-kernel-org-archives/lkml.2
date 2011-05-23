Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1EWBZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 21:25:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33412 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1EWBZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 21:25:34 -0400
Date: Mon, 23 May 2011 11:25:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: linux-next: build warnings in Linus' tree
Message-Id: <20110523112529.c2dbc445.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__23_May_2011_11_25_29_+1000_vWpmPjks0r5+0H5t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_May_2011_11_25_29_+1000_vWpmPjks0r5+0H5t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the origin tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

arch/x86/kernel/ftrace.c: In function 'ftrace_make_nop':
arch/x86/kernel/ftrace.c:308: warning: assignment discards qualifiers from =
pointer target type
arch/x86/kernel/ftrace.c: In function 'ftrace_make_call':
arch/x86/kernel/ftrace.c:318: warning: assignment discards qualifiers from =
pointer target type

Introduced by commit dc326fca2b64 ("x86, cpu: Clean up and unify the NOP
selection infrastructure").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__23_May_2011_11_25_29_+1000_vWpmPjks0r5+0H5t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEbBAEBAgAGBQJN2beJAAoJEDMEi1NhKgbsAjAH9iW670Q4h5jQx0sQNd/KTjh5
gijK3F932F4SvaxFWRrw81lCYCNeOsBGndnqXRgMib6Afr9i9A4fZ4xcbrCa2Bg3
kOClKDUdjmopQH80tbVM+TBV+sUU/oZEg53FQ2qLh/Up1YIe+dwvR/mT5PTXMmkc
qLsHQzJQ8BzenW63Ee5a3MWGfCoyBg2QBTqke9jaLgSfEpPDBo1OTQ6tuX/W+/eh
TXBsURsYReZVRWTLta1vFpQlpRt+FJtJzC9ioS30CcSz46QP7PL6NB8guUYE0193
a4UynFmZs5KkOYS+5VZqUGBdGxkj1e2MD3kQU6QMkujn0hcfNguS2/iZBWuLiQ==
=9x5g
-----END PGP SIGNATURE-----

--Signature=_Mon__23_May_2011_11_25_29_+1000_vWpmPjks0r5+0H5t--
