Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935249Ab1JESAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 14:00:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45070 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab1JESAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 14:00:18 -0400
Date: Wed, 5 Oct 2011 12:00:13 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH 1/6 v2] gpio-pch: Delete invalid "restore" code in
 suspend()
Message-ID: <20111005180013.GD4205@ponder.secretlab.ca>
References: <1311207599-2553-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311207599-2553-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied all 6, thanks.

g.

On Thu, Jul 21, 2011 at 09:19:54AM +0900, Tomoya MORINAGA wrote:
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/gpio/gpio-pch.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
> index 36919e7..ca9c7b0 100644
> --- a/drivers/gpio/gpio-pch.c
> +++ b/drivers/gpio/gpio-pch.c
> @@ -241,7 +241,6 @@ static int pch_gpio_suspend(struct pci_dev *pdev, pm_message_t state)
>  	struct pch_gpio *chip = pci_get_drvdata(pdev);
>  
>  	pch_gpio_save_reg_conf(chip);
> -	pch_gpio_restore_reg_conf(chip);
>  
>  	ret = pci_save_state(pdev);
>  	if (ret) {
> -- 
> 1.7.4.4
> 
