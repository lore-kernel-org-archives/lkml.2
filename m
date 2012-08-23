Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2HWBx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 21:53:28 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61803 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2HWBxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 21:53:25 -0400
Date: Wed, 22 Aug 2012 18:51:01 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/14] drivers/power/ab8500_btemp.c: fix error return code
Message-ID: <20120823015100.GA24471@lizard>
References: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
 <1345365870-29831-7-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1345365870-29831-7-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 10:44:22AM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
[...]
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

2,3,4,5,6 applied, thanks!

> ---
>  drivers/power/ab8500_btemp.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
> index bba3cca..2b76943 100644
> --- a/drivers/power/ab8500_btemp.c
> +++ b/drivers/power/ab8500_btemp.c
> @@ -1014,6 +1014,7 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
>  		create_singlethread_workqueue("ab8500_btemp_wq");
>  	if (di->btemp_wq == NULL) {
>  		dev_err(di->dev, "failed to create work queue\n");
> +		ret = -ENOMEM;
>  		goto free_device_info;
>  	}
>  
