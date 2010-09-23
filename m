Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab0IWWiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:38:09 -0400
Received: from mail.perches.com ([173.55.12.10]:2313 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab0IWWiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:38:08 -0400
Subject: Re: [PATCH 1/1] Rename camel case variables in channel.c  (updated)
From: Joe Perches <joe@perches.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "'gregkh@suse.de'" <gregkh@suse.de>
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7289ED89CF@TK5EX14MBXC130.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7289ED89CF@TK5EX14MBXC130.redmond.corp.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 15:38:06 -0700
Message-ID: <1285281486.25928.31.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 22:04 +0000, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Rename camel case variables in channel.c
[]
> -static int VmbusChannelCreateGpadlHeader(void *Kbuffer, u32 Size,
> -					 struct vmbus_channel_msginfo **MsgInfo,
> -					 u32 *MessageCount)
> +static int VmbusChannelCreateGpadlHeader(void *kbuffer, u32 size,
> +					 struct vmbus_channel_msginfo **msginfo,
> +					 u32 *messagecount)
>  {
>  	int i;
> -	int pageCount;
> +	int pagecount;
>  	unsigned long long pfn;
> -	struct vmbus_channel_gpadl_header *gpaHeader;
> -	struct vmbus_channel_gpadl_body *gpadlBody;
> -	struct vmbus_channel_msginfo *msgHeader;
> -	struct vmbus_channel_msginfo *msgBody = NULL;
> -	u32 msgSize;
> +	struct vmbus_channel_gpadl_header *gpal_header;
> +	struct vmbus_channel_gpadl_body *gpadl_body;
> +	struct vmbus_channel_msginfo *msgheader;
> +	struct vmbus_channel_msginfo *msgbody = NULL;
> +	u32 msgsize;

Why gpal_header and not gpadl_header?

I didn't read farther.

