Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab1GJWby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 18:31:54 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19884 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab1GJWbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 18:31:51 -0400
Date: Mon, 11 Jul 2011 00:31:50 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Edwin van Vliet <edwin@cheatah.nl>
cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/input/tablet/aiptek: removed double define
In-Reply-To: <1310336441-26893-1-git-send-email-edwin@cheatah.nl>
Message-ID: <alpine.LNX.2.00.1107110031220.2818@swampdragon.chaosbits.net>
References: <1310336441-26893-1-git-send-email-edwin@cheatah.nl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Edwin van Vliet wrote:

> Constant AIPTEK_TOOL_BUTTON_PEN_MODE was diefined twice
> 
> Signed-off-by: Edwin van Vliet <edwin@cheatah.nl>
> ---
>  drivers/input/tablet/aiptek.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
> index 0a619c5..6d89fd1 100644
> --- a/drivers/input/tablet/aiptek.c
> +++ b/drivers/input/tablet/aiptek.c
> @@ -225,7 +225,6 @@
>  	/* toolMode codes
>  	 */
>  #define AIPTEK_TOOL_BUTTON_PEN_MODE			BTN_TOOL_PEN
> -#define AIPTEK_TOOL_BUTTON_PEN_MODE			BTN_TOOL_PEN
>  #define AIPTEK_TOOL_BUTTON_PENCIL_MODE			BTN_TOOL_PENCIL
>  #define AIPTEK_TOOL_BUTTON_BRUSH_MODE			BTN_TOOL_BRUSH
>  #define AIPTEK_TOOL_BUTTON_AIRBRUSH_MODE		BTN_TOOL_AIRBRUSH
> 
Reviewed-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

