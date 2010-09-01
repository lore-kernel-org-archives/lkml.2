Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0IAQiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:38:15 -0400
Received: from mail.perches.com ([173.55.12.10]:1197 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab0IAQiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:38:14 -0400
Subject: Re: [PATCH 2/5] staging: hv: Fixed lockup problem with
 bounce_buffer scatter list - RESEND
From: Joe Perches <joe@perches.com>
To: Hank Janssen <hjanssen@sailtheuniverse.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
In-Reply-To: <4C7D4667.5040102@sailtheuniverse.com>
References: <4C7D4667.5040102@sailtheuniverse.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 09:38:11 -0700
Message-ID: <1283359091.1797.179.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 11:13 -0700, Hank Janssen wrote:

> diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
[]
> -			request->DataBuffer.PfnArray[i] =
> -					page_to_pfn(sg_page((&sgl[i])));
> +			request->DataBuffer.PfnArray[i] = 
> +				page_to_pfn(sg_page((&sgl[i])));

I did a bit of a doubletake reading this last change.

This isn't actually a part of your fix and it introduces
a whitespace error.



