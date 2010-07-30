Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab0G3RJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:09:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20420 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0G3RJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:09:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6059"; a="49214215"
Subject: Re: [PATCH 2/3] arm: mm: do not set missing flags on ScorpionMP
From: Daniel Walker <dwalker@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Steve Muckle <smuckle@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
In-Reply-To: <20100730071910.GC29746@n2100.arm.linux.org.uk>
References: <1279911483-7039-1-git-send-email-johlstei@codeaurora.org>
	 <1279911483-7039-3-git-send-email-johlstei@codeaurora.org>
	 <20100724082334.GB15571@n2100.arm.linux.org.uk>
	 <1280354280.21185.10.camel@c-dwalke-linux.qualcomm.com>
	 <20100728223603.GB6729@n2100.arm.linux.org.uk>
	 <1280357495.21185.26.camel@c-dwalke-linux.qualcomm.com>
	 <20100729071818.GC6729@n2100.arm.linux.org.uk>
	 <1280443366.27035.14.camel@c-dwalke-linux.qualcomm.com>
	 <20100730071910.GC29746@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 10:09:37 -0700
Message-ID: <1280509777.4142.3.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-30 at 08:19 +0100, Russell King - ARM Linux wrote:
> On Thu, Jul 29, 2010 at 03:42:46PM -0700, Daniel Walker wrote:
> > On Thu, 2010-07-29 at 08:18 +0100, Russell King - ARM Linux wrote:
> > > On Wed, Jul 28, 2010 at 03:51:35PM -0700, Daniel Walker wrote:
> > > > @@ -326,6 +327,29 @@ cpu_elf_name:
> > > >  
> > > >  	.section ".proc.info.init", #alloc, #execinstr
> > > >  
> > > > +	.type   __v7_msm_proc_info, #object
> > > > +__v7_msm_proc_info:
> > > > +	.long	0x000f0000		@ Required ID value
> > > > +	.long	0x000f0000		@ Mask for ID
> > > 
> > > Almost - is there no more specific ID value for your CPU?
> > 
> > Here's one with a more specific cpu id. Would you be willing to take
> > this for 2.6.36 or are you pretty much done taking pull requests?
> 
> Yes, but if its just for this patch, is there much point to a pull
> request?

I've got some other stuff too .. Jeff Ohlstein sent several patches (one
of which started this discussion), which are needed for an SMP board
we've been working on.

Daniel

