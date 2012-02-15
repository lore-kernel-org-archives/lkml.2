Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab2BOHUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 02:20:12 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:36423 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295Ab2BOHUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 02:20:08 -0500
Message-ID: <1329290402.19569.24.camel@cumari>
Subject: Re: [PATCH 3.3 v2] OMAP4: PRM: fix build breakage when CONFIG_OF is
 not defined
From: Luciano Coelho <coelho@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>
Date: Wed, 15 Feb 2012 09:20:02 +0200
In-Reply-To: <20120214203801.GU1426@atomide.com>
References: <1328699683-19357-1-git-send-email-coelho@ti.com>
	 <20120214203801.GU1426@atomide.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Tue, 2012-02-14 at 12:38 -0800, Tony Lindgren wrote: 
> * Luciano Coelho <coelho@ti.com> [120208 02:43]:
> > Since 3.3-rc1, prm44xx.c build breaks if CONFIG_OF is not set:
> > 
> > arch/arm/mach-omap2/prm44xx.c:41: error: 'OMAP44XX_IRQ_PRCM' undeclared here (not in a function)
> > make[1]: *** [arch/arm/mach-omap2/prm44xx.o] Error 1
> > 
> > This is because of a missing include, which is added indirectly if
> > CONFIG_OF is defined.  This problem was introduced in commit
> > 2f31b51 (ARM: OMAP4: PRM: use PRCM interrupt handler).
> > 
> > Cc: Tero Kristo <t-kristo@ti.com>
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > Reviewed-by: Felipe Balbi <balbi@ti.com>
> 
> A similar patch should be already in mainline kernel queued by Russell.

Right, someone pointed this out to me after I sent the two patches.
Sorry for the trouble, I should have looked more carefully before
jumping in to fix this stuff. ;)

-- 
Cheers,
Luca.

