Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965867Ab2ERRSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:18:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:57064 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965701Ab2ERRSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:18:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144942486"
Date: Fri, 18 May 2012 13:19:01 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NVM Mapping API
Message-ID: <20120518171901.GT22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
 <1337161920.2985.32.camel@dabdike.int.hansenpartnership.com>
 <20120516173523.GK22985@linux.intel.com>
 <1337248478.30498.24.camel@dabdike.int.hansenpartnership.com>
 <20120517185944.GP22985@linux.intel.com>
 <1337331833.2938.22.camel@dabdike.int.hansenpartnership.com>
 <20120518144922.GS22985@linux.intel.com>
 <1337355068.2938.41.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337355068.2938.41.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 04:31:08PM +0100, James Bottomley wrote:
> On Fri, 2012-05-18 at 10:49 -0400, Matthew Wilcox wrote:
> > You're downplaying the complexity of your own solution while overstating
> > the complexity of mine.  Let's compare, using your suggestion of the
> > dmesg buffer.
> 
> I'll give you that one when you tell me how you use your vfs interface
> simply from within the kernel.  Both are always about the same
> complexity in user space ...
> 
> To be honest, I'm not hugely concerned whether the key management API is
> u32 or a string.  What bothers me the most is that there will be
> in-kernel users for whom trying to mmap a file through the vfs will be
> hugely more complex than a simple give me a pointer to this persistent
> region.

Huh?  You snipped the example where I showed exactly that.  The user
calls nvm_map() and gets back a pointer to a kernel mapping for the
persistent region.
