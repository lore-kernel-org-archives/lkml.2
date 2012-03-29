Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab2C2Kl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 06:41:29 -0400
Received: from narfation.org ([79.140.41.39]:33870 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab2C2KlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 06:41:24 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, simon.wunderlich@s2003.tu-chemnitz.de,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: Re: Using nested locking for spin_lock_bh
Date: Thu, 29 Mar 2012 12:41 +0200
Message-ID: <2191191.ipEiEk2XX9@bentobox>
User-Agent: KMail/4.7.4 (Linux/3.2.0-2-amd64; KDE/4.7.4; x86_64; ; )
In-Reply-To: <20120329031136.GA2062@zhy>
References: <2108147.Aqyix6xDmB@bentobox> <20120329031136.GA2062@zhy>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1925874.T97UG4ExHP"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1925874.T97UG4ExHP
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday, March 29, 2012 11:11:37 AM Yong Zhang wrote:
> On Wed, Mar 28, 2012 at 06:36:39PM +0200, Sven Eckelmann wrote:
> > Hi,
> > 
> > I started to run some experimental batman-adv code inside some virtual
> > machines with different debugging functions enabled. One of them was
> > lockdep. There we noticed a false positive for a lock class that is
> > actually used in two different data structures.
> 
> Hmm, I think you can initialize the lock class in the two differnent data
> structures with differnt lock_class_key.

Thanks. I think I understand the problem now a little bit better and could 
resolve it using lockdep_set_class.

Kind regards,
	Sven
--nextPart1925874.T97UG4ExHP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJPdDw8AAoJEF2HCgfBJntGTvMP/3NVWjoEJqWsPvo2Xy8O1Nyn
XipMS2TZEMB84RiNxCre+VCwpPTLJ0BqlFJ+CDj9n/qGj7Qd6R5+Wz0AdJtIZkrQ
Y7wUuqwIMnauUwpktNlqRl+N0E5jKqldkWV8pCWi2ogEkqcoou2loICsEnKNDxCD
Qy7R56Q2udQAWlzOQpxlvowu3aHdcjmNEDVhEmynLnZ/Bel2fnGPgwgFw1dQPil4
xR6jkK8ZO+eQmOMfInWg7chamL2uXWMeD8/v7em+ZPGgIvBsRnV6ARRPqbiFxigC
GXhq9YImXmAwtwqEpWcWtts8tL1VnXTl7Ojjg84InugT8DMLjmL03dQtWp+B9sST
ngmn04BTibhUZLZpgCHjeDRr3NitVZ7hmETVK+7wyExn9SMMGv+RHOVjVj407H+K
uKygOJYAdDC607kQXkgUBbEx/s0z3VbSSy1m40PddsOsM6x984Dkr5bErFSO3XX2
mvxwn/LLLfa0scMdN3vOADtBglq2fnVc7e5lDYe77fphQ+w6GoC9PcHYtvOLB8HF
NhNs7IzPXDbVMYGOfwe4woqcfsk4CCq1Z/Rocu5f2uvelL9l4+VCI+BNRW2oOaSg
+lzz6whplqyeGj6HImY5q0LijzzSsmOJUOHXidRW1iLUAKAuRQa/d6BLuLHQ+pNX
+QnpeFXe7u3QleuCXBJx
=oUBS
-----END PGP SIGNATURE-----

--nextPart1925874.T97UG4ExHP--

