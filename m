Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965507Ab0GPM6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:58:47 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50951 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965374Ab0GPM6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:58:45 -0400
X-Sasl-enc: Y/Mj/FxM90kitTkoF2TqYpUSc6DXxi+5E2asgvL6vknc 1279285124
Date: Fri, 16 Jul 2010 09:58:41 -0300
From: Henrique de Moraes Holschuh <hmh@debian.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, "Theodore Ts'o" <tytso@mit.edu>,
        Michael Biebl <biebl@debian.org>, 587665@bugs.debian.org,
        linux-kernel@vger.kernel.org, Petter Reinholdtsen <pere@hungry.com>
Subject: Re: [Pkg-sysvinit-devel] Bug#587665: Safety of early boot init of
 /dev/random seed
Message-ID: <20100716125841.GA21384@khazad-dum.debian.net>
References: <20100701141022.GA3811@login1.uio.no>
 <20100701171357.GE4789@khazad-dum.debian.net>
 <20100702064415.GE3811@login1.uio.no>
 <20100702232919.GA14437@login2.uio.no>
 <20100703012833.GA20929@khazad-dum.debian.net>
 <20100703151636.GB23648@khazad-dum.debian.net>
 <20100703160819.GA12343@khazad-dum.debian.net>
 <1278355233.9937.21.camel@calx>
 <20100715233305.GF27512@khazad-dum.debian.net>
 <1279248082.936.250.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279248082.936.250.camel@calx>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010, Matt Mackall wrote:
> > > Don't bother fiddling with the pool size.
> > 
> > We don't, but local admins often do, probably in an attempt to better handle
> > bursts of entropy drainage.  So, we do want to properly support non-standard
> > pool sizes in Debian if we can.
> 
> Unless they're manually patching their kernel, they probably aren't
> succeeding. The pool resize ioctl was disabled ages ago. But there's
> really nothing to support here: even the largest polynomial in the
> source is only 2048 bits, or 256 bytes.

Well,

cat /proc/sys/kernel/random/poolsize 
4096

And that is stock mainline 2.6.32.16 on amd64, AFAIK...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
