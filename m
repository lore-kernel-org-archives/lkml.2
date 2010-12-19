Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab0LSDVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 22:21:47 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:55751 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab0LSDVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 22:21:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oiqq6BegjFd8zjPbwZgOW6EioSONnLFFukGdO77ydty7SD3VBPRpUO5vusRK+jCxL8
         p3O/8qk31eOTxO2O5RMN522uSSFqpUfl++M2FSLj1y4LYdD/jaI0S99raPkjRSVg63qq
         gx2D6w2FjEuajpnkuwpmnupUw0DEjbKe5rPKE=
Message-ID: <4D0D7A46.9090704@acm.org>
Date: Sat, 18 Dec 2010 21:21:42 -0600
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: dann frazier <dann.frazier@canonical.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add missing space in start_now parameter description
References: <1292629107-26337-1-git-send-email-dann.frazier@canonical.com>
In-Reply-To: <1292629107-26337-1-git-send-email-dann.frazier@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Acked-by: Corey Minyard <cminyard@mvista.com>

On 12/17/2010 05:38 PM, dann frazier wrote:
> Signed-off-by: dann frazier<dann.frazier@canonical.com>
> ---
>   drivers/char/ipmi/ipmi_watchdog.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
> index f4d334f..9b12da5 100644
> --- a/drivers/char/ipmi/ipmi_watchdog.c
> +++ b/drivers/char/ipmi/ipmi_watchdog.c
> @@ -314,7 +314,7 @@ MODULE_PARM_DESC(preop, "Pretimeout driver operation.  One of: "
>   		 "preop_none, preop_panic, preop_give_data.");
>
>   module_param(start_now, int, 0444);
> -MODULE_PARM_DESC(start_now, "Set to 1 to start the watchdog as"
> +MODULE_PARM_DESC(start_now, "Set to 1 to start the watchdog as "
>   		 "soon as the driver is loaded.");
>
>   module_param(nowayout, int, 0644);

