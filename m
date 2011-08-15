Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab1HOQMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 12:12:43 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:55706 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751620Ab1HOQMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 12:12:42 -0400
Date: Mon, 15 Aug 2011 09:12:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Marcos Paulo Souza <marcos.mage@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: platform.c: Fix warning on make htmldocs
Message-Id: <20110815091241.78672ff5.rdunlap@xenotime.net>
In-Reply-To: <alpine.DEB.2.02.1108151258310.4595@odin>
References: <alpine.DEB.2.02.1108151258310.4595@odin>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011 13:02:11 -0300 (BRT) Marcos Paulo Souza wrote:

> 
> The function arch_setup_pdev_archdata has a parameter called pdev, but the 
> documentation of the function documents a dev parameter. By changing the 
> documentation parameter to pdev fix this warning.
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
> 
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
> -- 

This is already fixed in linux-next.  It's probably a good idea to
check linux-next for fixes etc.

Thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
