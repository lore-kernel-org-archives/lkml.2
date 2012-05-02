Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2EBPeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:34:36 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:56252 "EHLO
	tservice.net.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752806Ab2EBPef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:34:35 -0400
Date: Wed, 2 May 2012 19:34:32 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Paul Walmsley <paul@pwsan.com>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] W1: OMAP HDQ1W: allow driver to be built on all OMAP2+
Message-ID: <20120502153432.GA15534@ioremap.net>
References: <alpine.DEB.2.00.1205020206020.19695@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205020206020.19695@utopia.booyaka.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 02:08:36AM -0600, Paul Walmsley (paul@pwsan.com) wrote:
> 
> Allow the OMAP HDQ1W driver to be built for all OMAP2+ SoCs by
> adjusting KConfig dependencies.  The previous dependency required
> either SOC_OMAP2430 or ARCH_OMAP3 to be set, but the HDQ IP block is
> present on OMAP2420 and OMAP44xx SoCs.  The driver was still
> selectable on multi-OMAP kernel configurations, however; so the
> previous prohibition was rather pointless.
> 
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Cc: Evgeniy Polyakov <zbr@ioremap.net>

Well, looks good, although I know nothing about build deps for OMAP platform :)

-- 
	Evgeniy Polyakov
