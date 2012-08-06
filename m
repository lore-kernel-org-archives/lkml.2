Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab2HFMmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:42:35 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57109 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab2HFMmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:42:33 -0400
Message-id: <501FBBB4.6000109@samsung.com>
Date: Mon, 06 Aug 2012 14:42:28 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Rob Clark <rob.clark@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, patches@linaro.org,
        linux@arm.linux.org.uk, arnd@arndb.de, jesse.barker@linaro.org,
        m.szyprowski@samsung.com, daniel@ffwll.ch, sumit.semwal@ti.com,
        maarten.lankhorst@canonical.com, Rob Clark <rob@ti.com>
Subject: Re: [PATCH 2/2] dma-buf: add helpers for attacher dma-parms
References: <1342715014-5316-1-git-send-email-rob.clark@linaro.org>
 <1342715014-5316-3-git-send-email-rob.clark@linaro.org>
 <501F9C8E.4080002@samsung.com> <xa1tobmoxmdz.fsf@mina86.com>
In-reply-to: <xa1tobmoxmdz.fsf@mina86.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 01:58 PM, Michal Nazarewicz wrote:
> 
> Tomasz Stanislawski <t.stanislaws@samsung.com> writes:
>> I recommend to change the semantics for unlimited number of segments
>> from 'value 0' to:
>>
>> #define DMA_SEGMENTS_COUNT_UNLIMITED ((unsigned long)INT_MAX)

Sorry. It should be:
#define DMA_SEGMENTS_COUNT_UNLIMITED ((unsigned int)INT_MAX)

>>
>> Using INT_MAX will allow using safe conversions between signed and
>> unsigned integers.
> 
> LONG_MAX seems cleaner regardless.
> 
> 
> 

