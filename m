Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1KALH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 07:07:57 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:44193 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab1KALH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 07:07:56 -0400
Subject: Re: [PATCH] Stageing: bcm: fixed spacing coding style in
 led_control.c
From: Paul Bolle <pebolle@tiscali.nl>
To: Ciaran McCormick <ciaranmccormick@gmail.com>
Cc: gregkh@suse.de, shemminger@vyatta.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1320144259-22339-1-git-send-email-ciaranmccormick@gmail.com>
References: <1320144259-22339-1-git-send-email-ciaranmccormick@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 12:07:45 +0100
Message-ID: <1320145665.14409.149.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stageing? And you might as well drop the filename from the summary. By
the way, are the other files (if any) of this driver any better (I
haven't checked)?

On Tue, 2011-11-01 at 10:44 +0000, Ciaran McCormick wrote:
> ---
>  drivers/staging/bcm/led_control.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/bcm/led_control.c b/drivers/staging/bcm/led_control.c
> index 16e939f..28c3382 100644
> --- a/drivers/staging/bcm/led_control.c
> +++ b/drivers/staging/bcm/led_control.c
> @@ -5,8 +5,8 @@
>  
>  static B_UINT16 CFG_CalculateChecksum(B_UINT8 *pu8Buffer, B_UINT32 u32Size)
>  {
> -	B_UINT16 	u16CheckSum=0;
> -	while(u32Size--) {
> +	B_UINT16	u16CheckSum = 0;
> +	while (u32Size--) {
>  		u16CheckSum += (B_UINT8)~(*pu8Buffer);

I'd say this line might need a space after the cast.

>  	    pu8Buffer++;
>  	}
> @@ -16,7 +16,7 @@ BOOLEAN IsReqGpioIsLedInNVM(PMINI_ADAPTER Adapter, UINT gpios)
>  {
>  	INT Status ;
>  	Status = (Adapter->gpioBitMap & gpios) ^ gpios ;

You missed the space before the semicolons here.

> -	if(Status)
> +	if (Status)
>  		return FALSE;
>  	else
>  		return TRUE;

But, more importantly, why only do whitespace related stuff? Almost
every second word apparently needs to be restyled here. Is doing just
whitespace related stuff worthwhile? (This is not a rhetorical question.
I'm actually wondering what Greg prefers).


Paul Bolle

