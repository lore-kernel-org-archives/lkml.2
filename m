Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab1EXSln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:41:43 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:32768 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853Ab1EXShz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:37:55 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Greg KH <greg@kroah.com>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [stable] PA-RISC: compile error in include/net/dst.h
Date: Tue, 24 May 2011 20:37:49 +0200
Message-ID: <2522442.xP32cQyJEX@donald.sf-tec.de>
User-Agent: KMail/4.6 beta5 (Linux/2.6.37-12-desktop; KDE/4.6.3; i686; ; )
In-Reply-To: <2254093.9oQvKLogfV@donald.sf-tec.de>
References: <2612811.b2htuyZy9x@donald.sf-tec.de> <20110522143222.GB14556@kroah.com> <2254093.9oQvKLogfV@donald.sf-tec.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3541033.Jq7cWPDluZ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3541033.Jq7cWPDluZ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

I wrote:
> Am Sonntag, 22. Mai 2011, 07:32:22 schrieb Greg KH:
> > On Sun, May 22, 2011 at 10:15:19AM +0200, Rolf Eike Beer wrote:
> > >                  from include/net/ipv6.h:16,
> > >                  from
> > >                  include/linux/sunrpc/clnt.h:25,
> > >                  from include/linux/nfs_fs.h:50,
> > > 
> > >                  from init/do_mounts.c:20:
> > > include/net/dst.h: In function 'dst_hold':
> > > include/net/dst.h:238:2: error: size of unnamed array is negative
> > > In file included from include/linux/nfs_fs.h:59:0,
> > > 
> > >                  from init/do_mounts.c:20:
> > > include/linux/mempool.h: In function 'mempool_create_kmalloc_pool':
> > > include/linux/mempool.h:58:10: warning: cast to pointer from integer
> > > of
> > > different size
> > > 
> > > This is both in 2.6.38.6 and 2.6.39, but is not in 2.6.38.4 when
> > > compiling for my C8000.
> > 
> > Could you bisect it down to the patch that causes the problem in
> > 2.6.38.6?
> 
> I will try if I find time in the next days. Until now I can only confirm
> that 2.6.38.5 builds fine.

As 2.6.38.6 does if I use the correct .config. So it is an older issue which is 
not related to recent changes but likely some general HPPA breakage. We'll 
discuss the rest on linux-parisc.

Eike
--nextPart3541033.Jq7cWPDluZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk3b+v0ACgkQXKSJPmm5/E5JtwCfXbn0WubfIblCw+/NIb7z23oB
OpUAniuTRy4AShlOK718waVyBsje/CYi
=vhmF
-----END PGP SIGNATURE-----

--nextPart3541033.Jq7cWPDluZ--

