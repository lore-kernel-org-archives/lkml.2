Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab0ITGHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 02:07:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58981 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab0ITGHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 02:07:37 -0400
Date: Mon, 20 Sep 2010 16:07:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sage Weil <sage@newdream.net>, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        linux-fsdevel@vger.kernel.org, gregf@hq.newdream.net
Subject: Re: [PATCH] fs/locks.c: prepare for BKL removal
Message-Id: <20100920160729.96872d12.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.1009192009260.9243@cobra.newdream.net>
References: <1284815371-5843-1-git-send-email-arnd@arndb.de>
	<Pine.LNX.4.64.1009192009260.9243@cobra.newdream.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__20_Sep_2010_16_07_29_+1000_90kEm8H+xeX9wDMj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Sep_2010_16_07_29_+1000_90kEm8H+xeX9wDMj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Sep 2010 20:59:01 -0700 (PDT) Sage Weil <sage@newdream.net> wrot=
e:
>
> I suspect the easiest thing is to leave Ceph out of this stage of your=20
> series, I'll switch lock_kernel() to lock_flocks() once that exists=20
> upstream.  Unless there is a better way?=20

Maybe someone could write a trivial implementation of lock_flocks() (i.e.
one that does not make any changes to behaviour) and ask Linus to take it
now in preparation for the next merge window (he has done that before).
That way, more of this could be put into individual other trees and avoid
more conflicts ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__20_Sep_2010_16_07_29_+1000_90kEm8H+xeX9wDMj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMlvohAAoJEDMEi1NhKgbsVigH/1DN/pFolovLzYlT2dVt4i+D
JydiJLZk9S09GeTRtwozhBaMXU09uLBYQELZcGwgxGsFsNQ/RP8HxhEzkTpe2Vuo
hCosua17dnk23ytQzK+PZokVq546p2hcP6mWo3ESticgiTUiWrhgTYnevvT1i0ii
PkEkXoOTuV4MroqR/BVRIXatfxnHkOd4B8WR5VnvJxXnPcE94zGc3fwNd84bN8Dw
4s08ZhiwzpqvijsRvlklZnkiv3LlCR1EEGG4ANqgtbajdgGeNvB3ln4auLDs29ws
FDNleAJJmSAkmm/xLdSWpIxyAddge8v1k+fGPHR8bbrcKIDTg4N1qUVRsTF2vBI=
=7mkO
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Sep_2010_16_07_29_+1000_90kEm8H+xeX9wDMj--
