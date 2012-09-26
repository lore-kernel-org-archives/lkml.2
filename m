Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab2IZRtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:49:14 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52672 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab2IZRtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:49:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAOh2x==ytZvZ9haAkfzeMua=kw54-3OpzMGuf_wPYkSesLbpEw@mail.gmail.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-5-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==ZCozF-Q1rjKapSYKK+x6HdyHs8N2ZJ96iSxoYZKPRXQ@mail.gmail.com>
	<CAOh2x==ytZvZ9haAkfzeMua=kw54-3OpzMGuf_wPYkSesLbpEw@mail.gmail.com>
Date: Wed, 26 Sep 2012 20:49:12 +0300
Message-ID: <CAHp75VcHS9Q1vwje5FLo1XkiZjaxNdrgi78zAE44_98NU-hgjQ@mail.gmail.com>
Subject: Re: [PATCHv2 4/4] MAINTAINERS: add recently created files to dw_dmac section
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 5:48 PM, viresh kumar <viresh.kumar@linaro.org> wrote:
> On Wed, Sep 26, 2012 at 8:15 PM, viresh kumar <viresh.kumar@linaro.org> wrote:
>>>  SYNOPSYS DESIGNWARE DMAC DRIVER
>>>  M:     Viresh Kumar <viresh.linux@gmail.com>
>>> +M:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>>  S:     Maintained
>>>  F:     include/linux/dw_dmac.h
>>> -F:     drivers/dma/dw_dmac_regs.h
>>> -F:     drivers/dma/dw_dmac.c
>>> +F:     drivers/dma/dw/
>>
>> I can't see this change...
>
> Sorry didn't saw your 3rd patch... :(
>
> I don't know why, but when i get patches from you... they appear in
> the older threads..
> i.e. v2 comes as reply to v1, v3 as reply to v2... so becomes
> difficult to track them..
>
> You simply do git send-email *.patch?
Okay, I will send v3 as separate thread. (Usually I remove old
messages and don't see all of thread content)


-- 
With Best Regards,
Andy Shevchenko
