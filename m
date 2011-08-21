Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1HUOdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 10:33:50 -0400
Received: from lo.gmane.org ([80.91.229.12]:48755 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab1HUOdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 10:33:46 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Wanlong Gao <wanlong.gao@gmail.com>
Subject: Re: [Doc] =?utf-8?b?YXJjaF9zZXR1cF9wZGV2X2FyY2hkYXRhOg==?= fix documentation for parameter "pdev"
Date: Sun, 21 Aug 2011 14:33:30 +0000 (UTC)
Message-ID: <loom.20110821T163206-452@post.gmane.org>
References: <201108211255.44032.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 112.80.209.86 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.835.94 Safari/535.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rolf Eike Beer <eike-kernel <at> sf-tec.de> writes:

> 
> Signed-off-by: Rolf Eike Beer <eike-kernel <at> sf-tec.de>
> ---
>  drivers/base/platform.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 0cad9c7..99a5272 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -33,7 +33,7 @@ EXPORT_SYMBOL_GPL(platform_bus);
> 
>  /**
>   * arch_setup_pdev_archdata - Allow manipulation of archdata before its used
> - * @dev: platform device
> + * @pdev: platform device
>   *
>   * This is called before platform_device_add() such that any pdev_archdata may
>   * be setup before the platform_notifier is called.  So if a user needs to
Already queue. See:

http://git.kernel.org/?p=linux/kernel/git/next/linux-
next.git;a=commitdiff;h=7de636fa25c19fc4187f85f8325c50b1b21a6d8b

Thanks
-Wanlong Gao

