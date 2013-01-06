Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3AFO6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 09:58:45 -0500
Received: from mail-gg0-f182.google.com ([209.85.161.182]:43126 "EHLO
	mail-gg0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab3AFO6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 09:58:44 -0500
Message-ID: <50E99120.7080608@gmail.com>
Date: Sun, 06 Jan 2013 08:58:40 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Denis Efremov <yefremov.denis@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: remove exported function from __init section
References: <1357482103-14116-1-git-send-email-yefremov.denis@gmail.com>
In-Reply-To: <1357482103-14116-1-git-send-email-yefremov.denis@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2013 08:21 AM, Denis Efremov wrote:
> The symbol of_fixed_clk_setup is exported and annotated __init.
> This looks like section mismatch.
> Fix this by removing the __init annotation of of_fixed_clk_setup.
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>

Mike should take this.

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
>  drivers/clk/clk-fixed-rate.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
> index af78ed6..a53b53b 100644
> --- a/drivers/clk/clk-fixed-rate.c
> +++ b/drivers/clk/clk-fixed-rate.c
> @@ -85,7 +85,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
>  /**
>   * of_fixed_clk_setup() - Setup function for simple fixed rate clock
>   */
> -void __init of_fixed_clk_setup(struct device_node *node)
> +void of_fixed_clk_setup(struct device_node *node)
>  {
>  	struct clk *clk;
>  	const char *clk_name = node->name;
> 
