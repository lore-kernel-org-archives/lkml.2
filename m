Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab0DFVAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:00:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756438Ab0DFVAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:00:41 -0400
Date: Tue, 6 Apr 2010 13:56:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <20100406204655.GG14054@uio.no>
Message-ID: <alpine.LFD.2.00.1004061348110.3487@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org> <1270571019.1814.163.camel@barrios-desktop> <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org> <1270572327.1711.3.camel@barrios-desktop> <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
 <4BBB69A9.5090906@redhat.com> <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org> <20100406120315.53ad7390.akpm@linux-foundation.org> <20100406194238.GB20357@a1.tnic> <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
 <20100406204655.GG14054@uio.no>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Apr 2010, Steinar H. Gunderson wrote:

> On Tue, Apr 06, 2010 at 01:02:35PM -0700, Linus Torvalds wrote:
> >    I haven't looked at the kernel config files: do they perhaps share the 
> >    same (odd?) SLUB/SLAB/SLOB config?
> 
> http://storage.sesse.net/config-crashing-2.6.34-rc2

Ok, CONFIG_SLUB, which is the common case. Not likely to be buggy.

> >    Did people have KSM enabled?
> 
> No KSM for me.

Ok, not anything odd there either, and you're not using any odd RCU setup 
either. Nothing odd at all strikes me about your config, in fact. Lots and 
lots of modules, but I guess it comes from some distro default config..

		Linus
