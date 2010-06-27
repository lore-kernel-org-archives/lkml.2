Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab0F0GuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 02:50:19 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56349 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab0F0GuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 02:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H/MfAYp4v/2bBSaPwss+CVffrwLAFLXO7oDVV7G5LBtPZvrNfQTxO/hN7Ewhnria15
         PtU6maOTQd9s7xqgyaVbpkSB/BaDDePQrbgLFpq2LrGKIDgq7n2hL+mvRAYuLQPe/WoM
         /FglCxbxnbxOJt3UHtsi4pHyW88QxsBj4LLJw=
Date: Sun, 27 Jun 2010 03:50:07 -0300
From: "Gustavo F. Padovan" <gustavo@padovan.org>
To: Cody Rester <codyrester@gmail.com>
Cc: marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: bluetooth: bluecard_cs.c: Fixed include
 error, changed to linux/io.h
Message-ID: <20100627065006.GA32318@vigoh>
References: <1277619142-10751-1-git-send-email-codyrester@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277619142-10751-1-git-send-email-codyrester@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Cody Rester <codyrester@gmail.com> [2010-06-27 02:12:22 -0400]:

> Fixed include error, changed to linux/io.h
> 
> Signed-off-by: Cody Rester <codyrester@gmail.com>
> ---
>  drivers/bluetooth/bluecard_cs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
> index d9bf87c..89a4455 100644
> --- a/drivers/bluetooth/bluecard_cs.c
> +++ b/drivers/bluetooth/bluecard_cs.c
> @@ -37,7 +37,7 @@
>  #include <linux/wait.h>
>  
>  #include <linux/skbuff.h>
> -#include <asm/io.h>
> +#include <linux/io.h>
>  
>  #include <pcmcia/cs_types.h>
>  #include <pcmcia/cs.h>
> -- 
> 1.7.0.4

Acked-by: Gustavo F. Padovan <padovan@profusion.mobi>

-- 
Gustavo F. Padovan
http://padovan.org
