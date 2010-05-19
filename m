Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab0ESCA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 22:00:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42749 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab0ESCA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 22:00:57 -0400
Date: Wed, 19 May 2010 11:00:54 +0900
From: InKi Dae <inki.dae@samsung.com>
Subject: Re: [PATCH] s3c-fb:  enable fimd driver for s5pv210.
In-reply-to: <20100519014959.GD4720@trinity.fluff.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: akpm@linux-foundation.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
Message-id: <4BF34656.5040100@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ko; rv:1.9.1.9)
 Gecko/20100317 Thunderbird/3.0.4
References: <4BF29B5C.2050202@samsung.com>
 <20100519014959.GD4720@trinity.fluff.org>
X-OriginalArrivalTime: 19 May 2010 02:00:55.0485 (UTC)
 FILETIME=[1E0AA6D0:01CAF6F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-05-19 오전 10:50, Ben Dooks 쓴 글:
> On Tue, May 18, 2010 at 10:51:24PM +0900, InKi Dae wrote:
>    
>> I'm sorry for being late.
>>
>> this patch is for s5pv210.
>> to support s5pv210, CH_ENABLE bit of SHADOW register should be enabled to enable window layer on s5pv210.
>>      
> I'd like to hold this until the chnages for multi-hardware
> support and header file cleanup are done.
>
>    
Ok,

and please review two other patches also.

thank you.
