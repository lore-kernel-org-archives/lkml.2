Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab2ENNPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:15:55 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:41399 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756141Ab2ENNPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:15:54 -0400
Date: Mon, 14 May 2012 15:15:50 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] watchdog: fix ie6xx_wdt.c printk format warning
Message-ID: <20120514131550.GH3074@spo001.leaseweb.com>
References: <20120511162738.1d65b6efe099a54841be6313@canb.auug.org.au> <4FADBDEB.402@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FADBDEB.402@xenotime.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Randy,

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix printk format warning; use cast to u64 since resource_size_t can
> be either u32 or u64.
> 
> drivers/watchdog/ie6xx_wdt.c:261:4: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'resource_size_t'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Fix added to linux-watchdog-next.

Thanks,
Wim.

