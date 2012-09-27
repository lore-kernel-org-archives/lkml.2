Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab2I0IQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:16:20 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55571 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab2I0IQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:16:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120927074039.GH12592@arwen.pp.htv.fi>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348731121-2515-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<20120927074039.GH12592@arwen.pp.htv.fi>
Date: Thu, 27 Sep 2012 13:46:17 +0530
X-Google-Sender-Auth: CtvTCj8c3bptt99rjz-BRXx5huo
Message-ID: <CAOh2x==i26PjSWzFYE+qzAThUL1fiFy8D17NtQGZqznGzRVApw@mail.gmail.com>
Subject: Re: [PATCHv3 1/7] dmaengine: dw_dmac: use helper macro module_platform_driver()
From: viresh kumar <viresh.kumar@linaro.org>
To: balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 1:10 PM, Felipe Balbi <balbi@ti.com> wrote:
>> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c

>> @@ -1700,6 +1700,7 @@ MODULE_DEVICE_TABLE(of, dw_dma_id_table);
>>  #endif
>>
>>  static struct platform_driver dw_driver = {
>> +     .probe          = dw_probe,
>
> probe's in __init section. This is wrong. You need to change probe
> __devinit.

Good one. How can i miss it. :(

@Andy: Please add my Acked-by: after this change.
