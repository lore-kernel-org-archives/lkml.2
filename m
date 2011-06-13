Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1FMO2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:28:16 -0400
Received: from mta11.charter.net ([216.33.127.80]:49612 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab1FMO2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:28:15 -0400
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=p9YancsnzTcA:10 a=Sy5Z6_G6oKoA:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=YAB0o5rrCPvY04roRcsA:9 a=wPNLvfGTeEIA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DF61E7E.908@cuw.edu>
Date: Mon, 13 Jun 2011 09:28:14 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: sgruszka@redhat.com, linville@tuxdriver.com
CC: Greg Dietsche <Gregory.Dietsche@cuw.edu>, kernel-janitors@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] iwlegacy: remove unreachable code
References: <1307066770-27309-1-git-send-email-Gregory.Dietsche@cuw.edu>
In-Reply-To: <1307066770-27309-1-git-send-email-Gregory.Dietsche@cuw.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2011 09:06 PM, Greg Dietsche wrote:
> return; at the end of the function is unecessary.
>
> Signed-off-by: Greg Dietsche<Gregory.Dietsche@cuw.edu>
> ---
>   drivers/net/wireless/iwlegacy/iwl-eeprom.c |    1 -
>   1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
> index cb346d1..5bf3f49 100644
> --- a/drivers/net/wireless/iwlegacy/iwl-eeprom.c
> +++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
> @@ -316,7 +316,6 @@ static void iwl_legacy_init_band_reference(const struct iwl_priv *priv,
>   		break;
>   	default:
>   		BUG();
> -		return;
>   	}
>   }
>
>    

any comments/reviews/acks on this patch series?

thanks,
Greg

