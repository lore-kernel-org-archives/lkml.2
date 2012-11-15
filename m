Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768154Ab2KOO6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:58:45 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51119 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768126Ab2KOO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:58:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAOh2x=nQ+y+_+mikxQUvWj1zBFf1qrrFgmqHFLZyHm9WY3=jAQ@mail.gmail.com>
References: <1352989248-28913-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=nQ+y+_+mikxQUvWj1zBFf1qrrFgmqHFLZyHm9WY3=jAQ@mail.gmail.com>
Date: Thu, 15 Nov 2012 20:28:42 +0530
X-Google-Sender-Auth: OEONveH358RY734F1Y6pVUM1i3M
Message-ID: <CAOh2x=kxxKgMQQW8zvg+Y9F94YoPc5yK9gPY3_+FE2QMhpq6Ug@mail.gmail.com>
Subject: Re: [PATCH 1/2] dw_dmac: check direction properly in dw_dma_cyclic_prep
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 8:05 PM, viresh kumar <viresh.kumar@linaro.org> wrote:
> On Thu, Nov 15, 2012 at 7:50 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>
>> +static inline bool is_slave_direction(enum dma_transfer_direction direction)
>> +{
>> +       return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
>> +}
>
> I would add this in dmaengine.h and will also include check for DMA_DEV_TO_DEV.

Also, what about is_slave_xfer() name?
