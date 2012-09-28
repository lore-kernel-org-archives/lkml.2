Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2I1CS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 22:18:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51186 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2I1CSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 22:18:55 -0400
Date: Thu, 27 Sep 2012 19:16:01 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 49/57] power: Cancelling status charging notification.
Message-ID: <20120928021601.GH5040@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-50-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-50-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:46AM -0600, mathieu.poirier@linaro.org wrote:
> From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>

No reasoning behind the change?

> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
>  drivers/power/abx500_chargalg.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
> index ce58f20..4db0ef0 100644
> --- a/drivers/power/abx500_chargalg.c
> +++ b/drivers/power/abx500_chargalg.c
> @@ -641,10 +641,8 @@ static void abx500_chargalg_hold_charging(struct abx500_chargalg *di)
>  	abx500_chargalg_usb_en(di, false, 0, 0);
>  	abx500_chargalg_stop_safety_timer(di);
>  	abx500_chargalg_stop_maintenance_timer(di);
> -	di->charge_status = POWER_SUPPLY_STATUS_CHARGING;
>  	di->maintenance_chg = false;
>  	cancel_delayed_work(&di->chargalg_wd_work);
> -	power_supply_changed(&di->chargalg_psy);
>  }
>  
>  /**
> -- 
> 1.7.5.4
> 
> 
