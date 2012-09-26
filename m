Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab2IZDjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 23:39:52 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38962 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2IZDjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 23:39:51 -0400
MIME-Version: 1.0
In-Reply-To: <1348580274.13371.127.camel@smile>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348575190-11761-7-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348579169.2476.1.camel@joe-AO722>
	<1348580274.13371.127.camel@smile>
Date: Wed, 26 Sep 2012 09:09:50 +0530
X-Google-Sender-Auth: sPHJjo-RhORo56pXwEDtwkM8GZE
Message-ID: <CAOh2x=k8ZV+YQWmsj3w7gqVNFq8Czrc70ca0UUg0gDX-MkM7mg@mail.gmail.com>
Subject: Re: [PATCHv1 6/6] MAINTAINERS: add recently created files to dw_dmac section
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Joe Perches <joe@perches.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 7:07 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Tue, 2012-09-25 at 06:19 -0700, Joe Perches wrote:
>> On Tue, 2012-09-25 at 15:13 +0300, Andy Shevchenko wrote:
>> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>
>> You also added yourself as a maintainer.
>> Congrats/sympathies, etc...
> Actually I prefer to be just a supporter, because I introduce few
> additional files. But if I understood correctly, there is no way to
> distinguish person statuses in one section.

Then probably you just need to mark your entries in driver files?

>> > diff --git a/MAINTAINERS b/MAINTAINERS
>> []
>> > @@ -6007,10 +6007,13 @@ F:  drivers/tty/serial
>> >
>> >  SYNOPSYS DESIGNWARE DMAC DRIVER
>> >  M: Viresh Kumar <viresh.linux@gmail.com>
>> > +M: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> >  S: Maintained
>> >  F: include/linux/dw_dmac.h
>> >  F: drivers/dma/dw_dmac_regs.h
>> >  F: drivers/dma/dw_dmac.c
>> > +F: drivers/dma/dw_dmac_at32.c
>> > +F: drivers/dma/dw_dmac_pci.c
>>
>> Perhaps these F: lines instead
>>
>> F:    include/linux/dw_dmac.h
>> F:    drivers/dma/dw_dmac*
> Might be. There is another idea to move them under drivers/dma/dw/
> folder. So, Viresh, what do you think is better?

Yes. Can be done.

--
viresh
