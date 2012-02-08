Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2BHLF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:05:28 -0500
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:50916 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756994Ab2BHLF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:05:26 -0500
Message-ID: <1328699121.20197.52.camel@cumari>
Subject: Re: [PATCH 3.3] OMAP4: PRM: fix build breakage when CONFIG_OF is
 not defined
From: Luciano Coelho <coelho@ti.com>
To: balbi@ti.com
Cc: tony@atomide.com, linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>
Date: Wed, 08 Feb 2012 13:05:21 +0200
In-Reply-To: <20120208110318.GC16334@legolas.emea.dhcp.ti.com>
References: <1328698752-18756-1-git-send-email-coelho@ti.com>
	 <20120208110318.GC16334@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-08 at 13:03 +0200, Felipe Balbi wrote: 
> On Wed, Feb 08, 2012 at 12:59:12PM +0200, Luciano Coelho wrote:
> > Since 3.3-rc1, prm44xx.c build breaks if CONFIG_OF is not set:
> > 
> > arch/arm/mach-omap2/prm44xx.c:41: error: 'OMAP44XX_IRQ_PRCM' undeclared here (not in a function)
> > make[1]: *** [arch/arm/mach-omap2/prm44xx.o] Error 1
> > 
> > This is because of a missing include, which is added indirectly if
> > CONFIG_OF is defined.  This problem was introduced in commit
> > 2f31b51659c2d8315ea2888ba5b93076febe672b
> 
> same as previous patch. Abbreviated commit and commit subject.

Okay, I'll send v2 in a sec.

> > Cc: Tero Kristo <t-kristo@ti.com>
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> 
> Reviewed-by: Felipe Balbi <balbi@ti.com>

Thanks!

-- 
Cheers,
Luca.

