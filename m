Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab0IARgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:36:01 -0400
Received: from smtpauth23.prod.mesa1.secureserver.net ([64.202.165.47]:50082
	"HELO smtpauth23.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755699Ab0IARgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:36:00 -0400
Message-ID: <4C7D601B.3060708@sailtheuniverse.com>
Date: Tue, 31 Aug 2010 13:03:39 -0700
From: Hank Janssen <hjanssen@sailtheuniverse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 2/5] staging: hv: Fixed lockup problem with bounce_buffer
 scatter list - RESEND
References: <4C7D4667.5040102@sailtheuniverse.com> <1283359091.1797.179.camel@Joe-Laptop>
In-Reply-To: <1283359091.1797.179.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2010 09:38 AM, Joe Perches wrote:
> On Tue, 2010-08-31 at 11:13 -0700, Hank Janssen wrote:
> 
>> diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
> []
>> -			request->DataBuffer.PfnArray[i] =
>> -					page_to_pfn(sg_page((&sgl[i])));
>> +			request->DataBuffer.PfnArray[i] = 
>> +				page_to_pfn(sg_page((&sgl[i])));
> 
> I did a bit of a doubletake reading this last change.
> 
> This isn't actually a part of your fix and it introduces
> a whitespace error.
> 

I will resubmit this patch and clean up the whitespace error.

When change the code I normally also change the indentation to the
correct format for that area of the code. That is how the whitespace
snuck in there.

Thanks,

Hank.

