Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab0JZK3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:29:01 -0400
Received: from smtp.nokia.com ([192.100.122.230]:29970 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab0JZK27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:28:59 -0400
Subject: Re: [PATCH] wireless/wl1271: remove redundant if-statement v2
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Nicolas Kaiser <nikai@nikai.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101025153003.3aa7c168@absol.kitzblitz>
References: <20101025000744.17f7086e@absol.kitzblitz>
	 <4CC4B210.2010608@lwfinger.net>	<1288012245.21130.24.camel@chilepepper>
	 <20101025153003.3aa7c168@absol.kitzblitz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 13:27:44 +0300
Message-ID: <1288088864.27698.1.camel@chilepepper>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2010 10:27:48.0482 (UTC) FILETIME=[6FB1B620:01CB74F8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 15:30 +0200, ext Nicolas Kaiser wrote:
> wl1271_ps_elp_sleep() is void and cannot return a value.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
> Sorry for the poor wording of the initial description.
> 
>  drivers/net/wireless/wl12xx/wl1271_event.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
> index 7b3f503..38ccef7 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_event.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_event.c
> @@ -134,8 +134,6 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
>  
>  		/* go to extremely low power mode */
>  		wl1271_ps_elp_sleep(wl);
> -		if (ret < 0)
> -			break;
>  		break;
>  	case EVENT_EXIT_POWER_SAVE_FAIL:
>  		wl1271_debug(DEBUG_PSM, "PSM exit failed");

Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>

Thanks! Applied to the wl12xx tree.

-- 
Cheers,
Luca.

