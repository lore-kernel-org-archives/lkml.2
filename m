Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2I0ISA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:18:00 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56089 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab2I0IR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:17:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120927074236.GI12592@arwen.pp.htv.fi>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348731121-2515-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<20120927074236.GI12592@arwen.pp.htv.fi>
Date: Thu, 27 Sep 2012 13:47:58 +0530
X-Google-Sender-Auth: vXPDGLrloLPICohFRrMP3A4FYks
Message-ID: <CAOh2x=nBZs-pPrFQ-bsaCsH7gB2y-Y-4RoCnmSCmCtn9JQy8sw@mail.gmail.com>
Subject: Re: [PATCHv3 3/7] dmaengine: dw_dmac: remove CLK dependency
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

On Thu, Sep 27, 2012 at 1:12 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Thu, Sep 27, 2012 at 10:31:57AM +0300, Andy Shevchenko wrote:
>> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>
>> This driver could be used on different platforms. Thus, the HAVE_CLK dependency
>> is dropped away.
>>
>> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> ---
>>  drivers/dma/Kconfig |    1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
>> index 677cd6e..df32537 100644
>> --- a/drivers/dma/Kconfig
>> +++ b/drivers/dma/Kconfig
>> @@ -83,7 +83,6 @@ config INTEL_IOP_ADMA
>>
>>  config DW_DMAC
>>       tristate "Synopsys DesignWare AHB DMA support"
>> -     depends on HAVE_CLK
>
> as is, this will break compilation of any arch which doesn't set
> HAVE_CLK.

No, it will not due to following commit id:

commit 93abe8e4b13ae9a0428ce940a8a03ac72a7626f1
Author: Viresh Kumar <viresh.kumar@st.com>
Date:   Mon Jul 30 14:39:27 2012 -0700

    clk: add non CONFIG_HAVE_CLK routines


@Andy:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
