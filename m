Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab2I0OAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:00:04 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50623 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2I0OAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:00:01 -0400
MIME-Version: 1.0
In-Reply-To: <1348740388.1648.27.camel@vkoul-udesk3>
References: <CAOh2x=n4ZCsQ1ccqobZF6fz-Kuj_VE-ua5PftAHQkTobA=p+pw@mail.gmail.com>
	<1348573156-5032-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348740388.1648.27.camel@vkoul-udesk3>
Date: Thu, 27 Sep 2012 17:00:00 +0300
Message-ID: <CAHp75VfCYWqic9MbBZrTO-dM+Yfn6P8q33Fb_LMwmg4rYS5N=w@mail.gmail.com>
Subject: Re: [PATCHv3] dw_dmac: autoconfigure data_width or get it via
 platform data
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        viresh.kumar@linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 1:06 PM, Vinod Koul <vinod.koul@linux.intel.com> wrote:
> On Tue, 2012-09-25 at 14:39 +0300, Andy Shevchenko wrote:
>> Not all of the controllers support the 64 bit data width. Make it configurable
>> via platform data. The driver will try to get a value from the component
>> parameters, otherwise it will use the platform data.
>>
> What was this gen against, I can apply this.
Just rebased to recent linux-next, no conflicts.
...
Applying: dw_dmac: mark dwc_dump_chan_regs as inline
Applying: dw_dmac: fill optional encoded parameters in register structure
Applying: dw_dmac: get number of channels from hardware if possible
Applying: dw_dmac: autoconfigure block_size or use platform data
Applying: dw_dmac: autoconfigure data_width or get it via platform data
Applying: dw_dmac: introduce software emulation of LLP transfers
...

Have you kept the order of the patches?



-- 
With Best Regards,
Andy Shevchenko
