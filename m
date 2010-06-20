Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0FTVfP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:35:15 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:32276 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778Ab0FTVfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:35:12 -0400
Message-ID: <4C1E898D.8010902@bluewatersys.com>
Date: Mon, 21 Jun 2010 09:35:09 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: mike@compulab.co.il, linux-kernel@vger.kernel.org, vilensky@compulab.co.il,
       mike.rapoport@gmail.com
Subject: Re: [PATCH] ds2782: Fix ds2782_get_capacity return value
References: <1276562699-4933-1-git-send-email-ryan@bluewatersys.com>
In-Reply-To: <1276562699-4933-1-git-send-email-ryan@bluewatersys.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 12:44 PM, Ryan Mallon wrote:
> The ds2782_get_capacity function should return 0 on success, not the
> capacity value.
> 
> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
> ---
>  drivers/power/ds2782_battery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
> index d762a0c..2afbeec 100644
> --- a/drivers/power/ds2782_battery.c
> +++ b/drivers/power/ds2782_battery.c
> @@ -163,7 +163,7 @@ static int ds2782_get_capacity(struct ds278x_info *info, int *capacity)
>  	if (err)
>  		return err;
>  	*capacity = raw;
> -	return raw;
> +	return 0;
>  }
>  
>  static int ds2786_get_current(struct ds278x_info *info, int *current_uA)

Ping, Anton?

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
