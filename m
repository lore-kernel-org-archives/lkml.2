Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750916Ab1DBEiU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 00:38:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56790 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1DBEiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 00:38:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DOYnWuZB1wXcb0nNylFEZ9u9H5KVKHaTfUnp8jYF7KPuuvVU0x7n1hsNhS6vrOfoxP
         nwWsaUbM2sTCppvPxS45fi+69AbrdEk4DGnZCqnlpdjasOOgNHnRsV/fSOTqjUqAXgCi
         v1sYP/AWQUz0ZwmH4yuiMTL2eZOi00EG5GY1k=
Date: Sat, 2 Apr 2011 06:38:04 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@elte.hu>, david@lang.hm,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110402043804.GB3989@riccoc20.at.omicron.at>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
 <201104011554.07924.arnd@arndb.de>
 <1301671655.28467.52.camel@e102144-lin.cambridge.arm.com>
 <201104011755.57412.arnd@arndb.de>
 <alpine.LFD.2.00.1104011557080.28032@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1104011557080.28032@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 04:19:31PM -0400, Nicolas Pitre wrote:
> 
> In a perfect world the bootloader would be bug free and always up to 
> date with the best DT data.  In practice I'm very skeptical this will 
> always be the case and painless.  At least the above makes it very 
> simple to have a self contained kernel when (not if) need be.

Yes, my experience with DT on powerpc teaches me that, although DT
sounds wonderful in theory, in practice kernel/dtb/uboot form a love
triangle (or perhaps a hate triangle) where all three points must be
exactly up to date with each other. If one part is even just a month
or two too old/new, then your kernel might not boot.

Richard
