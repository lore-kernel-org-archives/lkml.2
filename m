Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab1GTSwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:52:02 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63689 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab1GTSwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:52:00 -0400
Date: Wed, 20 Jul 2011 12:51:59 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH 1/6] pch_gpio: Delete invalid "restore" code in suspend()
Message-ID: <20110720185159.GH4642@ponder.secretlab.ca>
References: <1311156662-3044-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311156662-3044-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 07:10:57PM +0900, Tomoya MORINAGA wrote:
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Hi Tomoya,

I'm deferring this series to v3.2.  You'll need to rebase it against
gpio/next or linux-next before I can apply it because there has been a
reorganization of the drivers/gpio tree.

g.

> ---
>  drivers/gpio/pch_gpio.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
> index 36919e7..ca9c7b0 100644
> --- a/drivers/gpio/pch_gpio.c
> +++ b/drivers/gpio/pch_gpio.c
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
