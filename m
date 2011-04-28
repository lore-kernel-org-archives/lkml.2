Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655Ab1D1QDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:03:08 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47289 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757715Ab1D1QDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:03:04 -0400
Subject: Re: [PATCH 2/3] make new alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Timur Tabi <timur@freescale.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <4DB88DAF.2010504@freescale.com>
References: <20110414200139.ABD98551@kernel>
	 <20110414200140.CDE09A20@kernel> <4DB88AF0.1050501@freescale.com>
	 <1303940249.9516.366.camel@nimitz>  <4DB88DAF.2010504@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 28 Apr 2011 09:02:57 -0700
Message-ID: <1304006577.9516.2578.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 16:42 -0500, Timur Tabi wrote:
> Dave Hansen wrote:
> >> Is there an easy way to verify that alloc_pages_exact(5MB) really does allocate
> >> > only 5MB and not 8MB?
> 
> > I'm not sure why you're asking.  How do we know that the _normal_
> > allocator only gives us 4k when we ask for 4k?  Well, that's just how it
> > works.  If alloc_pages_exact() returns success, you know it's got the
> > amount of memory that you asked for, and only that plus a bit of masking
> > for page alignment.
> > 
> > Have you seen alloc_pages_exact() behaving in some other way?
> 
> I've never tested this part of alloc_pages_exact(), even when I wrote (the first
> version of) it.  I just took it on faith that it actually did what it was
> supposed to do.

I did actually go add a bunch of printks to it at one point.  It did
seem to be working just fine and freeing the right amount of memory.

-- Dave

