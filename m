Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2FUMM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 08:12:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:14178 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756842Ab2FUMM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 08:12:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="156613423"
Message-ID: <1340280986.13910.207.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 0/4] hfsplus: stop using write_supers and s_dirt
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Thu, 21 Jun 2012 15:16:26 +0300
In-Reply-To: <1339587471-2713-1-git-send-email-dedekind1@gmail.com>
References: <1339587471-2713-1-git-send-email-dedekind1@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-zjJjlPYIzBeBZqTfGQd9"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zjJjlPYIzBeBZqTfGQd9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-06-13 at 14:37 +0300, Artem Bityutskiy wrote:
> This patch-set makes HFSPLUS file-system stop using the VFS '->write_supe=
rs()'
> call-back and the '->s_dirt' superblock field because I plan to remove th=
em
> once all users are gone.

Hi, Al or Andrew, would you please consider picking this patch-set?

--=20
Best Regards,
Artem Bityutskiy

--=-zjJjlPYIzBeBZqTfGQd9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP4xCaAAoJECmIfjd9wqK0KyoQAK81qzhv2WgRUQPqjMmCSpwa
B7oxT5jfb13qeoeH9tkU7edu2s7kTLMaC7Bwd0w1tel1aMJ3oId9kOzw15xC2qjr
Cw18DceVLLPIe6LR3GITFWdKXLyh3KMbXW/92/mcJlZfszAdQK1GETO1A63x3iAw
HiYK0g9lofarCDkaAsFBH06w/rbyKqHamz6jcW9XzN9B76zfvqSKwTLr7XBEwR27
H4E+xa2fnOKbkJa0UewC73et2tDruEmbZiDeXQ/NeuiJUMl79QAUJb0Mn5r1Y58B
Ree5+jCTj+cJEXb6KNhlanK88GgapFAeQ7zr+MVwWGONTgssaC5uJHy0PtgpJmZ6
X87ingpPYgzxuAAM7J9FUNcIxSxeNuZpEDcFeZ/GOZDhkBpc0B9RLdYGXnRYMqZB
jce4hPeGr2khobC8oAWiUN1ysOs3jCoAZx/ATVvs8OkaWd19PmvFAxWg3E2BiKFC
48Jhjv3goTozqdwzlpS0X91tMDqo2kyCxZh0TYbSzPn+NeoyfgA7vwEMsIwsFxuk
M+n+d+uZKWjEKT1MR/dUlHMD/xeGgqQdVRUzAC0noW5f3DVGTGsAtVa3k53WYP4S
+S7eRRMs8kf1TSddacbQuByOXtqVfUQXqvMk3VCrXkUcD/j3aVmqs4PUSd1cl8eT
p7NEgvpCjlF35VrF2tVG
=xquD
-----END PGP SIGNATURE-----

--=-zjJjlPYIzBeBZqTfGQd9--

