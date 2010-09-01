Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab0IAMgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 08:36:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35876 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab0IAMgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 08:36:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JFuHIXJo6sYtYDqEQJuGIuTCcvtc6NEou66DkDQWke0vgycBQ8VIUTGqaoqP3ALRMo
         MZJm6NJMWP6cyAfIgWi0Tzj5rfKT/eoz8EdmB/5BAd0BvNs+ZvvTU0LPK6znny+XQFXS
         wHdG1BrJoEQeGXjGsJOCsgHvhQRtwj06Ex13M=
Message-ID: <4C7E48C0.8000007@gmail.com>
Date: Wed, 01 Sep 2010 14:36:16 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: "Prashant P. Shah" <pshah.mumbai@gmail.com>
CC: gregkh@suse.de, randy.dunlap@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, apatard@mandriva.com
Subject: Re: [PATCH] Staging: xgifb: fixed many style issue in vb_ext.c
References: <1283334498-7490-1-git-send-email-pshah.mumbai@gmail.com>
In-Reply-To: <1283334498-7490-1-git-send-email-pshah.mumbai@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/09/2010 11:48, Prashant P. Shah ha scritto:
> This is a patch to the vb_ext.c file that fixes many style
> issues found by the checkpatch.pl tool.
> - extra spaces
> - invalid code indent
> - extra braces
> - invalid comment style
 >
> Signed-off-by: Prashant P. Shah<pshah.mumbai@gmail.com>
> ---
>   drivers/staging/xgifb/vb_ext.c | 1816 +++++++++++++++++++---------------------
>   1 files changed, 846 insertions(+), 970 deletions(-)
>
> -/* ------------------------------------------------------ */
> -/* Function : XGINew_SenseHiTV */
> -/* Input : */
> -/* Output : */
> -/* Description : */
> -/* ------------------------------------------------------ */
> +/* ----------------------------------------------------------------------------
> + * Function : XGINew_SenseHiTV
> + * Input :
> + * Output :
> + * Description :
> + * ----------------------------------------------------------------------------
> + */

I think you can remove all the banners without meaningful content 
instead of making checkpatch happy about them.

thanks,
riccardo
