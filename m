Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab1EJT5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 15:57:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39783 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab1EJT5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 15:57:18 -0400
Subject: Re: [PATCH] regulator: Remove some unused variables from wm831x
 DCDCs
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
In-Reply-To: <1305035577-27184-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1305035577-27184-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 20:57:14 +0100
Message-ID: <1305057434.3206.44.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 15:52 +0200, Mark Brown wrote:
> These became unused with the IRQ removal patch, I'm fairly sure that a
> patch was sent earlier by someone else but it doesn't seem to have been
> applied and I don't have a copy sitting around any more.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/wm831x-dcdc.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
> index e93453b..a0982e8 100644
> --- a/drivers/regulator/wm831x-dcdc.c
> +++ b/drivers/regulator/wm831x-dcdc.c
> @@ -600,7 +600,6 @@ err:
>  static __devexit int wm831x_buckv_remove(struct platform_device *pdev)
>  {
>  	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
> -	struct wm831x *wm831x = dcdc->wm831x;
>  
>  	platform_set_drvdata(pdev, NULL);
>  
> @@ -776,7 +775,6 @@ err:
>  static __devexit int wm831x_buckp_remove(struct platform_device *pdev)
>  {
>  	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
> -	struct wm831x *wm831x = dcdc->wm831x;
>  
>  	platform_set_drvdata(pdev, NULL);
>  

Applied.

Thanks

Liam

