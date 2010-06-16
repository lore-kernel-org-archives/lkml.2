Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab0FPG2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 02:28:15 -0400
Received: from verein.lst.de ([213.95.11.210]:49514 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791Ab0FPG2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 02:28:14 -0400
Date: Wed, 16 Jun 2010 08:27:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@lst.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86-32: always use irq stacks
Message-ID: <20100616062748.GA29543@lst.de>
References: <20100526110923.GA28414@lst.de> <20100616051629.GA26012@lst.de> <20100616055609.GC17936@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616055609.GC17936@elte.hu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 07:56:09AM +0200, Ingo Molnar wrote:
> 
> * Christoph Hellwig <hch@lst.de> wrote:
> 
> > ping?  This just came up again as a side-issue in the direct reclaim thread.  
> > x86-32 really is the only one out there still having this compared to the 
> > other common architetures like x86-64, powerpc and s390.
> 
> We should also make 8K stacks the default on 32-bit. I.e. remove all the 
> Kconfig distinctions and make the stack model similar on 32-bit and 64-bit 
> x86.

Sounds fine to me.  Do you want an additional patch for that or a respin
to include it in one patch?

