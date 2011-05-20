Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934299Ab1ETSJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:09:23 -0400
Received: from relais.videotron.ca ([24.201.245.36]:61027 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251Ab1ETSJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:09:22 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 20 May 2011 14:09:20 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v5 15/19] ARM: LPAE: Add support for
 cpu_v7_do_(suspend|resume)
In-reply-to: <1305897667.2788.98.camel@e102109-lin.cambridge.arm.com>
Message-id: <alpine.LFD.2.00.1105201407480.14430@xanadu.home>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
 <1304859098-10760-16-git-send-email-catalin.marinas@arm.com>
 <20110518072737.GC6815@atomide.com>
 <1305897667.2788.98.camel@e102109-lin.cambridge.arm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011, Catalin Marinas wrote:
> On Wed, 2011-05-18 at 08:27 +0100, Tony Lindgren wrote:
> > Do we really need all this ifdef else throughout this series?
> > 
> > I think we already have things in place to do this dynamically
> > like we already do for thumb, smp_on_up, v6 vs v7 and so on.
> 
> By dynamically, do you mean at run-time? We won't be able to compile
> both classic and LPAE in the same kernel, there is just too much
> difference between them (2 vs 3 levels of page tables - LPAE is an
> entirely new format).
> 
> If you mean some simpler macros like what we have for ARM/THUMB to
> reduce the number of lines, I'm fine with it though we don't always have
> a 1:1 mapping between LPAE and non-LPAE instructions.
> 
> Alternatively, I'm happy to create a separate proc-v7lpae.S file.

That would probably be the best option.


Nicolas
