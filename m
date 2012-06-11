Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2FKLGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:06:32 -0400
Received: from bar.sig21.net ([80.81.252.164]:37391 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab2FKLGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:06:30 -0400
Date: Mon, 11 Jun 2012 13:05:57 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Boszormenyi Zoltan <zboszor@pr.hu>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: AMD FX CPU bug, not fixed by latest microcode?
Message-ID: <20120611110557.GA4599@sig21.net>
References: <4FD4F45D.5050103@pr.hu>
 <20120611084318.GA1685@liondog.tnic>
 <20120611094905.GA10349@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611094905.GA10349@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 11:49:05AM +0200, Borislav Petkov wrote:
> On Mon, Jun 11, 2012 at 10:43:18AM +0200, Borislav Petkov wrote:
> > On Sun, Jun 10, 2012 at 09:24:13PM +0200, Boszormenyi Zoltan wrote:
> > > I have an AMD FX-8120 boxed CPU in an ASUS M5A99X-EVO mainboard
> > > with 32GB DDR3/1600 memory, running Fedora 17, upgraded from 16.
> > > memtest86+ show no problems.
> 
> Ohe other thing: if there's an option in the BIOS to disable the IOMMU,
> can you do that and try reproducing the issue with IOMMU disabled?

Maybe not related, but I had bad memory in my Intel Core-i5
based system some months ago which resulted in rare crashes,
usually manifested itself as g++ ICEs when compiling a
mid-sized  C++ project -- compiling a kernel with make -p4 showed
no problem.  Also memtest86+ didn't show the issue,
so I tried memtest86-4.0a which claims to find more errors
due to SMP support.  An overnight run left me with a screen
full of garbage and a crashed memtest86-4.0.  I replaced
the RAM anyway and the box was stable since then.

memtest86-4.0a is at
http://memtest86.com/

The page claims:
  With a single CPU it is not possible to drive multi-channel memory
  controllers at full speed making it impossible to detect some types of errors

Maybe someone knowledgable could comment if this is true.


Johannes
