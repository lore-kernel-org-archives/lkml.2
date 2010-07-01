Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549Ab0GAWZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:25:44 -0400
Received: from shutemov.name ([188.40.19.243]:53832 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab0GAWZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:25:42 -0400
Date: Fri, 2 Jul 2010 01:25:41 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Anfei Zhou <anfei.zhou@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [patch 071/149] ARM: 6166/1: Proper prefetch abort handling on
 pre-ARMv6
Message-ID: <20100701222541.GB10481@shutemov.name>
References: <20100701175144.GA2116@kroah.com>
 <20100701173212.785441106@clark.site>
 <20100701221420.GA10481@shutemov.name>
 <20100701221728.GA12187@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701221728.GA12187@suse.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 03:17:28PM -0700, Greg KH wrote:
> On Fri, Jul 02, 2010 at 01:14:20AM +0300, Kirill A. Shutemov wrote:
> > On Thu, Jul 01, 2010 at 10:31:37AM -0700, Greg KH wrote:
> > > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> > > 
> > > ------------------
> > > 
> > > From: Anfei <anfei.zhou@gmail.com>
> > > 
> > > commit 5e27fb78df95e027723af2c90ecc9b4527ae59e9 upstream.
> > > 
> > > Instruction faults on pre-ARMv6 CPUs are interpreted as
> > > a 'translation fault', but do_translation_fault doesn't
> > > handle well if user mode trying to run instruction above
> > > TASK_SIZE, and result in the infinite retry of that
> > > instruction.
> >  
> > Actually, this patch helps also on ARMv6+. Probably, better to correct
> > commit message for stable.
> 
> We (well, I) like to keep the commit log identical to what is upstream
> just to make things easier all around.  Otherwise people start asking
> for spelling fixes, clarifications, and all sorts of other stuff (like
> this.)

Ok, fair enough.

I asked for it because I was confused by this commit message while
investigate (the same) problem on ARMv7 CPU.

-- 
 Kirill A. Shutemov
