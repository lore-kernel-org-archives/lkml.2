Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab2IUHem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:34:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59791 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab2IUHek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:34:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAMPhdO-+7myDOLNxRs8Pi78for3g8+-npsY+EbOa+sxoW=2C1w@mail.gmail.com>
References: <CAPgLHd8ZQr2-1B2QcwO83gJNBrzw-WY1WWgWQJJCQYxirVAC2Q@mail.gmail.com>
	<CAMPhdO-+7myDOLNxRs8Pi78for3g8+-npsY+EbOa+sxoW=2C1w@mail.gmail.com>
Date: Fri, 21 Sep 2012 15:34:39 +0800
Message-ID: <CAN1soZz2wuTR6QkKkr74QN3=BZVKRjQSGvh5cKpqY9bHivxvcQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa: fix return value check in pxa2xx_drv_pcmcia_probe()
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, linux@arm.linux.org.uk,
        yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 3:30 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Fri, Sep 21, 2012 at 3:19 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> In case of error, the function clk_get() returns ERR_PTR()
>> and never returns NULL pointer. The NULL test in the error
>> handling should be replaced with IS_ERR().
>>
>> dpatch engine is used to auto generated this patch.
>> (https://github.com/weiyj/dpatch)
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Ack
>
Applied

Thanks
Haojian
