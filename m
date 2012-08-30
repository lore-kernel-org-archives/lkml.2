Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab2H3RTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 13:19:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53789 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076Ab2H3RTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 13:19:22 -0400
Date: Thu, 30 Aug 2012 10:19:19 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] clk: Make the generic clock API available by default
Message-ID: <20120830171918.GE4356@opensource.wolfsonmicro.com>
References: <1346186104-4083-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <503E8E6E.1010101@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503E8E6E.1010101@wwwdotorg.org>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 02:49:34PM -0700, Stephen Warren wrote:
> On 08/28/12 13:35, Mark Brown wrote:

> >@@ -674,6 +676,7 @@ config ARCH_TEGRA
> >  	select GENERIC_CLOCKEVENTS
> >  	select GENERIC_GPIO
> >  	select HAVE_CLK
> >+	select HAVE_CUSTOM_CLK

> For 3.7, Tegra will switch to the common clock framework. I think
> this patch would then disable that. How should we resolve this -
> rebase the Tegra common-clk tree on top of any branch containing
> this patch in order to remove that select statement?

I'd expect this to be applied on a separate branch so you should be able
to rebase your conversion on top of it or merge it into your branch
which should deal with things well enough I think?
