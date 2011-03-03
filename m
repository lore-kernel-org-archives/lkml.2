Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab1CCCFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:05:46 -0500
Received: from ozlabs.org ([203.10.76.45]:46297 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab1CCCFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:05:45 -0500
Date: Thu, 3 Mar 2011 13:05:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-03-02-16-52 uploaded
Message-Id: <20110303130538.3e99f952.sfr@canb.auug.org.au>
In-Reply-To: <201103030127.p231ReNl012841@imap1.linux-foundation.org>
References: <201103030127.p231ReNl012841@imap1.linux-foundation.org>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Mar_2011_13_05_38_+1100_HKT7vQaDy4Tl0xod"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Mar_2011_13_05_38_+1100_HKT7vQaDy4Tl0xod
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 02 Mar 2011 16:52:55 -0800 akpm@linux-foundation.org wrote:
>
> The mm-of-the-moment snapshot 2011-03-02-16-52 has been uploaded to
>=20
>    http://userweb.kernel.org/~akpm/mmotm/

If you create your linux-next.patch using kapm-start..kapm-end in the
linux-next tree, you will save about 8000+ lines of patch and you won't
need "next-remove-localversion.patch" any more.  I am keeping those
references up to date each day.

BTW, To keep "git am" happy:

diff --git a/broken-out/memcg-keep-only-one-charge-cancelling-function-fix.=
patch
index e081c43..42c45fc 100644
--- a/broken-out/memcg-keep-only-one-charge-cancelling-function-fix.patch
+++ b/broken-out/memcg-keep-only-one-charge-cancelling-function-fix.patch
@@ -1,3 +1,4 @@
+From: Johannes Weiner <hannes@cmpxchg.org>
=20
 Keep the underscore-version of the charge cancelling function which took a
 page count, rather than silently changing the semantics of the

Cheers,
Stephen Rothwell

--Signature=_Thu__3_Mar_2011_13_05_38_+1100_HKT7vQaDy4Tl0xod
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNbvdyAAoJEDMEi1NhKgbsJk0H/j24InuPjfO0oNfA+YKrcEzf
7oFKURktGEYMc4muf6y7hmEvxl8q0CODb6X+uChRfrUFB0GTVgOpHUqtePUTNNNf
5boLVW6utxeueNTYWPpf3Mo4LAdpkqlmmQ1i1tc8RMtkWKJRdKYejFV0f1LPPQzJ
iq9qfOOZs0aI4rxh4cRhYCPmipVA2fY2G+POq4FYPdx00mi9PahmpFtGocHXQWS+
ghqybanFtgVeMI/iKHha74tldAXs5AcNay3xS/VKvBF551TrOQr3BxrISiGjIyK4
9sBAYk2/5xwLOxt39FHpO7PbdtYjB6Uuppq+yGhIdN4+71xfDxKiXvtO80+04tw=
=gUrx
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Mar_2011_13_05_38_+1100_HKT7vQaDy4Tl0xod--
