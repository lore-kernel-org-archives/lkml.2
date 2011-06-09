Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab1FIWEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:04:15 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17333 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab1FIWEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:04:12 -0400
Date: Thu, 9 Jun 2011 23:55:54 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Alexander Stein <alexander.stein@systec-electronic.com>
cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] pch_uart: add missing comment about OKI ML7223
In-Reply-To: <1307604631-10168-1-git-send-email-alexander.stein@systec-electronic.com>
Message-ID: <alpine.LNX.2.00.1106092353490.17868@swampdragon.chaosbits.net>
References: <1307604631-10168-1-git-send-email-alexander.stein@systec-electronic.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011, Alexander Stein wrote:

> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
> ---
>  drivers/tty/serial/pch_uart.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
> index 4652109..e3e6d6b 100644
> --- a/drivers/tty/serial/pch_uart.c
> +++ b/drivers/tty/serial/pch_uart.c
> @@ -44,6 +44,7 @@ enum {
>  /* Set the max number of UART port
>   * Intel EG20T PCH: 4 port
>   * OKI SEMICONDUCTOR ML7213 IOH: 3 port
> + * OKI SEMICONDUCTOR ML7223 IOH: 2 port
>  */
>  #define PCH_UART_NR	4
>  

Looks right to me - the driver does claim to support that device.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

