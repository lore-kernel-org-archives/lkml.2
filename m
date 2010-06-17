Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab0FQOc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 10:32:58 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41435 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760106Ab0FQOc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 10:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=fZmlayMk9O1Tz24WSUAgjGwhgWXGogsE7CqE4mDJY2+o+9PieLFwEJLwiFbe0QKe+l
         EEizVVCYQfx+RC6H0ORPCDTjB1oEHp4Fv9b/cjSVphBMGC0eFxOrcvDZHPwAXznxnxXH
         GkhtNGXgSUNrnJjXirDoHJtJywrgsywwZa5hI=
Subject: Re: [PATCH] Drivers: Staging: Moved one brace to its proper place.
From: Ben Collins <bcollins@bluecherry.net>
To: Matti Lammi <mattij.lammi@gmail.com>
Cc: gregkh@suse.de, mithlesh@linsyssoft.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1276764228-14657-1-git-send-email-mattij.lammi@gmail.com>
References: <1276764228-14657-1-git-send-email-mattij.lammi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Bluecherry, LLC
Date: Thu, 17 Jun 2010 10:32:50 -0400
Message-ID: <1276785170.2705.13.camel@maclara>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-17 at 11:43 +0300, Matti Lammi wrote:
> Another small fix.
> 
> Signed-off-by: Matti Lammi <mattij.lammi@gmail.com>
> ---
>  drivers/staging/otus/athr_common.h |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/otus/athr_common.h b/drivers/staging/otus/athr_common.h
> index 3e32f5b..c58ffee 100644
> --- a/drivers/staging/otus/athr_common.h
> +++ b/drivers/staging/otus/athr_common.h
> @@ -128,2 +128,2 @@ struct athr_wapi_param {
>  	} u;
>  };
> 
> -struct athr_wapi_sta_info
> -{
> +struct athr_wapi_sta_info{
>  	u16	msg_type;
>  	u16	datalen;
>  	u8	sta_mac[ETH_ALEN];

If you're going to move it, might I suggest:

+struct athr_wapi_sta_info {

Note the space between info and {

> --
> 1.6.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Bluecherry: http://www.bluecherrydvr.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/

