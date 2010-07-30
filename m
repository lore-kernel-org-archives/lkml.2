Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab0G3HTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 03:19:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54450 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab0G3HTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 03:19:32 -0400
Date: Fri, 30 Jul 2010 08:19:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Steve Muckle <smuckle@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 2/3] arm: mm: do not set missing flags on ScorpionMP
Message-ID: <20100730071910.GC29746@n2100.arm.linux.org.uk>
References: <1279911483-7039-1-git-send-email-johlstei@codeaurora.org> <1279911483-7039-3-git-send-email-johlstei@codeaurora.org> <20100724082334.GB15571@n2100.arm.linux.org.uk> <1280354280.21185.10.camel@c-dwalke-linux.qualcomm.com> <20100728223603.GB6729@n2100.arm.linux.org.uk> <1280357495.21185.26.camel@c-dwalke-linux.qualcomm.com> <20100729071818.GC6729@n2100.arm.linux.org.uk> <1280443366.27035.14.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280443366.27035.14.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 03:42:46PM -0700, Daniel Walker wrote:
> On Thu, 2010-07-29 at 08:18 +0100, Russell King - ARM Linux wrote:
> > On Wed, Jul 28, 2010 at 03:51:35PM -0700, Daniel Walker wrote:
> > > @@ -326,6 +327,29 @@ cpu_elf_name:
> > >  
> > >  	.section ".proc.info.init", #alloc, #execinstr
> > >  
> > > +	.type   __v7_msm_proc_info, #object
> > > +__v7_msm_proc_info:
> > > +	.long	0x000f0000		@ Required ID value
> > > +	.long	0x000f0000		@ Mask for ID
> > 
> > Almost - is there no more specific ID value for your CPU?
> 
> Here's one with a more specific cpu id. Would you be willing to take
> this for 2.6.36 or are you pretty much done taking pull requests?

Yes, but if its just for this patch, is there much point to a pull
request?
