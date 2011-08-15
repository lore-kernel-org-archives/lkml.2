Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab1HODyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 23:54:52 -0400
Received: from void.printf.net ([89.145.121.20]:55901 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab1HODyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 23:54:51 -0400
From: Chris Ball <cjb@laptop.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, patches@linaro.org
Subject: Re: [PATCH] mmc: sdhci-esdhc-imx: add missing inclusion of linux/module.h
References: <1313375298-18546-1-git-send-email-shawn.guo@linaro.org>
Date: Sun, 14 Aug 2011 23:54:36 -0400
In-Reply-To: <1313375298-18546-1-git-send-email-shawn.guo@linaro.org> (Shawn
	Guo's message of "Mon, 15 Aug 2011 10:28:18 +0800")
Message-ID: <m2mxfbmirn.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

On Sun, Aug 14 2011, Shawn Guo wrote:
> There are following warning and error when compiling the driver.
> The patch adds the missing inclusion of linux/module.h to fix them.
>
> drivers/mmc/host/sdhci-esdhc-imx.c:87:1: warning: data definition has
> no type or storage class

Pushed to mmc-next for 3.1.  I don't see these on my imx build with
CONFIG_MMC_SDHCI_ESDHC_IMX=m, so it'd be useful to see your .config
so that I'm able to reproduce in future.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
