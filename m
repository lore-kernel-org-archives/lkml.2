Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab1ANOja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:39:30 -0500
Received: from void.printf.net ([89.145.121.20]:39488 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab1ANOjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:39:23 -0500
Date: Fri, 14 Jan 2011 14:39:22 +0000
From: Chris Ball <cjb@laptop.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: sdhci-of does not build on x86
Message-ID: <20110114143922.GA29486@void.printf.net>
References: <1295008191-1596-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295008191-1596-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Fri, Jan 14, 2011 at 01:29:51PM +0100, Michal Marek wrote:
> After commit c10d1e2, CONFIG_OLPC selects CONFIG_OF, which enables to
> select CONFIG_MMC_SDHCI_OF, which does not build on x86:
> 
> drivers/mmc/host/sdhci-of-core.c:24:25: fatal error: asm/machdep.h: No
> such file or directory
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
> 
> I don't know if the driver could possibly work on some OLPC hardware,
> but it wasn't used on x86 before, so this patch won't make things any worse.

Thanks very much for the patch, but Grant Likely already has a different
one queued that he's going to push to Linus, so we'll use that.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
