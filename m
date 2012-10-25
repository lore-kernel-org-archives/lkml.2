Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992614Ab2JYTCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:02:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50008 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992550Ab2JYTCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:02:05 -0400
Date: Thu, 25 Oct 2012 12:02:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: devel@driverdev.osuosl.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dgrp: remove unused including <linux/version.h>
Message-ID: <20121025190201.GA25086@kroah.com>
References: <CAPgLHd95Tv12n=yaSoM-nKtOd0NGiRq-LYe1H_NcFwQUS8U0YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd95Tv12n=yaSoM-nKtOd0NGiRq-LYe1H_NcFwQUS8U0YQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 09:23:47PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove including <linux/version.h> that don't need it.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/staging/dgrp/dgrp_sysfs.c | 1 -
>  1 file changed, 1 deletion(-)

Someone else already beat you to this change, sorry.

greg k-h
