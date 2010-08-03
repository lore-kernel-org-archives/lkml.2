Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab0HCCCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 22:02:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61354 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab0HCCCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 22:02:14 -0400
Date: Tue, 03 Aug 2010 11:02:12 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH v2 3/3] rtc: Add MAX8998 rtc driver
In-reply-to: <20100803020847.58795fbd@linux.lan.towertech.it>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        akpm@linux-foundation.org, p_gortmaker@yahoo.com,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com
Message-id: <4C5778A4.80002@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
References: <1280734507-8398-1-git-send-email-jy0922.shim@samsung.com>
 <1280734507-8398-3-git-send-email-jy0922.shim@samsung.com>
 <20100803020847.58795fbd@linux.lan.towertech.it>
X-OriginalArrivalTime: 03 Aug 2010 02:02:12.0622 (UTC)
 FILETIME=[E369D2E0:01CB32AF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/3/2010 9:08 AM, Alessandro Zummo wrote:
> On Mon, 02 Aug 2010 16:35:07 +0900
> Joonyoung Shim <jy0922.shim@samsung.com> wrote:
> 
>> This adds support for the RTC provided by the Maxim 8998 chip. This
>> driver was tested on a GONI board by using the rtc-test application from
>> the Documentation/rtc.txt.
>>
>> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> 
>  Seems nice. I'd add rtc_valid_tm where appropriate.
>  And maybe free that irq you requested ;)
> 

Right, i missed.

>  pending those changes, you have my 
> 
>   Acked-by: Alessandro Zummo <a.zummo@towertech.it>
> 
> 

Thanks.
