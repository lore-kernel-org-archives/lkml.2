Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2GERfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:35:04 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57312 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752032Ab2GERfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:35:02 -0400
Message-ID: <1341509701.21263.7.camel@joe2Laptop>
Subject: Re: [PATCH 01/19] Staging: xgifb: Comment cleaning.
From: Joe Perches <joe@perches.com>
To: Miguel =?ISO-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Jul 2012 10:35:01 -0700
In-Reply-To: <c43dc4d9658a520bc62592d51ec9b7b2a3d81fd7.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
	 <c43dc4d9658a520bc62592d51ec9b7b2a3d81fd7.1341498465.git.magomez@igalia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 16:45 +0200, Miguel Gómez wrote:
> Remove commented code and useless comments. Leave only those with relevant
> hints to the code.

[]

> diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
[]
> @@ -1,9 +1,3 @@
> -/*
> - * XG20, XG21, XG40, XG42 frame buffer device
> - * for Linux kernels  2.5.x, 2.6.x
> - * Base on TW's sis fbdev code.
> - */

Maybe the comment removal is a bit aggressive.
Perhaps two of these are relevant comments.

> diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
[]
> @@ -79,7 +79,4 @@ struct xgi_hw_device_info {
>  	unsigned long ulCRT2LCDType; /* defined in the data structure type */
>  };
>  
> -/* Additional IOCTL for communication xgifb <> X driver        */
> -/* If changing this, xgifb.h must also be changed (for xgifb) */
>  #endif
> -

Maybe this too.

>From a quick glance, the rest of the patches look like
nice cleanups.

btw: most kernel code uses logical line continuations
at the end of the line not at the beginning of the next
line.

ie:
	if (foo &&
	    bar)
not
	if (foo
	    && bar)

cheers, Joe

