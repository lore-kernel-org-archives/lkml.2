Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab0DVVw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 17:52:56 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:54013 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab0DVVwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 17:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=n6ZSdaCKxiExL+0e8EqHfYWL2E9XNzQdSKQFUMQhfKHRZT2Td7wD4n35r/dy1wytHl
         +/DKv1uqQoUHNNu7e0X+luOErKupVurb92Q6j8nSqrDqKySqxYdM2KX+gcN2cSXeec5P
         +GkAnmpKnjlmWuWnbIDsFZFKdAFCLlhl28GvA=
Message-ID: <4BD0C531.9050104@lwfinger.net>
Date: Thu, 22 Apr 2010 16:52:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.7 Thunderbird/3.0.4
MIME-Version: 1.0
To: Roel Van Nyen <roel.vannyen@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       "Bartlomiej Zolnierkiewicz devel@driverdev.osuosl.org" 
	<bzolnier@gmail.com>,
       Bernhard Schiffner <bernhard@schiffner-limbach.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: fix coding style errors of r8180_rtl8225z2.c
References: <4BD0C19F.3030809@gmail.com>
In-Reply-To: <4BD0C19F.3030809@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2010 04:37 PM, Roel Van Nyen wrote:
> Fix coding style errors
> 
> Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>
> 
> ---
> 
>  drivers/staging/rtl8187se/r8180_rtl8225z2.c |   58 ++++++++++++++-------------
> 
>  1 files changed, 30 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/staging/rtl8187se/r8180_rtl8225z2.c b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
> 
> index 6edf5a4..9c38b3a 100644
> 
> --- a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
> 
> +++ b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
> 
> @@ -225,7 +225,7 @@ static void rtl8225_SetTXPowerLevel(struct net_device *dev, short ch)
> 
>  }
> 
>  
> 
>  static const u8 rtl8225z2_threshold[] = {
>     <========================= HERE
> -        0x8d, 0x8d, 0x8d, 0x8d, 0x9d, 0xad, 0xbd,
> 
> +    0x8d, 0x8d, 0x8d, 0x8d, 0x9d, 0xad, 0xbd,
> 
>  };

NACK: This patch is badly broken. All of the blank lines like the one I
marked above fail.

Larry

