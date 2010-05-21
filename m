Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab0EUOGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:06:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37731 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab0EUOGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:06:15 -0400
Date: Fri, 21 May 2010 10:06:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: bkl: Pushdowns for sound/oss ?
Message-ID: <20100521140613.GA15070@infradead.org>
References: <alpine.LFD.2.00.1005211536330.25348@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005211536330.25348@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 03:45:04PM +0200, John Kacur wrote:
> Hi Ralf
> 
> I was looking at doing some of that last remaining ioctl bkl-pushdowns, in 
> particular in:
> sound/oss/swarm_cs4297a.c
> sound/oss/msnd_pinnacle.c
> sound/oss/sh_dac_audio.c
> sound/oss/vwsnd.c
> sound/oss/dmasound/dmasound_core.c
> sound/oss/dmasound/dmasound_core.c
> 
> when I noticed they were including asm files from mips. I went so far as 
> to compile my own mips tool chain, but I wasn't able to compile the above.
> Being oss sound, I was wondering if these are still maintained or are 
> marked for removal some time in the future.
> 
> If there is merely a problem with my toolchain, then that can be fixed, 
> but there is no point in wasting time with these if no-one uses them.

Can we just drop OSS?  It's beend deprecated and mostly dead for years.
