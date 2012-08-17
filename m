Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774Ab2HQJVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:21:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56151 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756543Ab2HQJVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:21:44 -0400
Date: Fri, 17 Aug 2012 10:21:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 04/31] arm64: MMU definitions
Message-ID: <20120817092106.GA24389@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-5-git-send-email-catalin.marinas@arm.com>
 <20120817090451.GP11011@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817090451.GP11011@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 10:04:52AM +0100, Tony Lindgren wrote:
> * Catalin Marinas <catalin.marinas@arm.com> [120814 10:57]:
> > The virtual memory layout is described in
> > Documentation/arm64/memory.txt. This patch adds the MMU definitions for
> > the 4KB and 64KB translation table configurations. The SECTION_SIZE is
> > 2MB with 4KB page and 512MB with 64KB page configuration.
> > 
> > PHYS_OFFSET is calculated at run-time and stored in a variable (no
> > run-time code patching at this stage).
> 
> Care to clarify this part a bit? Is the memory standardized somehow
> now and not needed? Or do we still need to add that for various SoCs
> later on?

The memory is not standardised but we have FDT to fully specify it. The
PHYS_OFFSET does not need to be defined, it is automatically detected at
boo-time based on the kernel load address and stored in a variable to be
used later.

> Other than that:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

Thanks.

-- 
Catalin
