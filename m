Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2FKO1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:27:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40446 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2FKO07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:26:59 -0400
Message-ID: <4FD60030.8090700@gmail.com>
Date: Mon, 11 Jun 2012 09:26:56 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: export of_platform_populate()
References: <1339113456-27089-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1339113456-27089-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 06:57 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Without this, modules can't use this API, leading to build failures.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---

Applied for 3.5.

Rob

> This is useful in 3.5.
> 
>  drivers/of/platform.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 343ad29..3132ea0 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -462,4 +462,5 @@ int of_platform_populate(struct device_node *root,
>  	of_node_put(root);
>  	return rc;
>  }
> +EXPORT_SYMBOL_GPL(of_platform_populate);
>  #endif /* CONFIG_OF_ADDRESS */
