Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1GZTuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 15:50:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:56195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab1GZTt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 15:49:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,270,1309762800"; 
   d="scan'208";a="30375145"
Date: Tue, 26 Jul 2011 12:49:56 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Bob Zhang <zhanglinbao@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hayfeng Lee <omycle@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Bob Zhang <2004.zhang@gmail.com>
Subject: Re: x86_64 virtual memory map
Message-ID: <20110726194956.GA4117@tassilo.jf.intel.com>
References: <5f6c52c61003241920i6b3eaaf7k946f67d1a6f9e384@mail.gmail.com>
 <m1r5n7ln0l.fsf@fess.ebiederm.org>
 <CAKdQVUZMC0eaeqev=tAbS2myHJOA1KJt4r8TVMz6=yQeDpUpZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKdQVUZMC0eaeqev=tAbS2myHJOA1KJt4r8TVMz6=yQeDpUpZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> and in the end of mm.txt , it says :
> >>Current X86-64 implementations only support 40 bits of address space,
>  >> 27but we support up to 46 bits. This expands into MBZ space in the
> >>page tables.
> so this 40bit(1TB) is responding to virtual memory map(1TB) ?

The 1TB limit was dropped a long time ago.
Your googling found an old file.

> 3,  if I installed 64TB physical memory (RAM) , but linux kernel only

What system is that out of curiosity? Are you sure it's not
a cluster?

> support 1TB address space , what should I do next ?

There's no known 1TB limit currently.

However at least for Intel Xeons there is no CPU which supports
more than 16TB physical address space.

Are you sure you have your units correct?

The theoretical x86 kernel limits are higher and it should upto support
64TB. However since that's untested territory and there 
have been bugs in large memory support in the past
you may run into problems.

Other architectures like IA64 will support more (but you
may be also in untested territory)

I believe 4+TB x86 systems have been tested.

-Andi

