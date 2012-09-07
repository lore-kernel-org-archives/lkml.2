Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245Ab2IGNtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:49:24 -0400
Received: from bitmer.com ([213.157.87.50]:46224 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2IGNtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:49:22 -0400
X-Greylist: delayed 1094 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Sep 2012 09:49:22 EDT
Date: Fri, 7 Sep 2012 16:31:07 +0300
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-watchdog@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: omap_wdt: convert to new watchdog core
Message-ID: <20120907133107.GA14585@bitmer.com>
References: <1346769684-25543-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346769684-25543-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Sep 04, 2012 at 05:41:24PM +0300, Aaro Koskinen wrote:
> Convert omap_wdt to new watchdog core. On OMAP boards, there are usually
> multiple watchdogs. Since the new watchdog core supports multiple
> watchdogs, all watchdog drivers used on OMAP should be converted.
> 
> The legacy watchdog device node is still created, so this should not
> break existing users.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> ---
>  drivers/watchdog/Kconfig    |    1 +
>  drivers/watchdog/omap_wdt.c |  268 ++++++++++++++++++-------------------------
>  2 files changed, 115 insertions(+), 154 deletions(-)
> 
Am I missing some extra patch but this causes a crash on top of v3.6-rc4
commit eeea3ac?

Crash happens in omap_wdt.c:99 on Nokia N9.

-- 
Jarkko
