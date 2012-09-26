Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab2IZOsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:48:04 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33755 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2IZOsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:48:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAOh2x==ZCozF-Q1rjKapSYKK+x6HdyHs8N2ZJ96iSxoYZKPRXQ@mail.gmail.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-5-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==ZCozF-Q1rjKapSYKK+x6HdyHs8N2ZJ96iSxoYZKPRXQ@mail.gmail.com>
Date: Wed, 26 Sep 2012 20:18:02 +0530
X-Google-Sender-Auth: EojxLjPwY38_ZGjZm5B0iyZY5uw
Message-ID: <CAOh2x==ytZvZ9haAkfzeMua=kw54-3OpzMGuf_wPYkSesLbpEw@mail.gmail.com>
Subject: Re: [PATCHv2 4/4] MAINTAINERS: add recently created files to dw_dmac section
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 8:15 PM, viresh kumar <viresh.kumar@linaro.org> wrote:
>>  SYNOPSYS DESIGNWARE DMAC DRIVER
>>  M:     Viresh Kumar <viresh.linux@gmail.com>
>> +M:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>  S:     Maintained
>>  F:     include/linux/dw_dmac.h
>> -F:     drivers/dma/dw_dmac_regs.h
>> -F:     drivers/dma/dw_dmac.c
>> +F:     drivers/dma/dw/
>
> I can't see this change...

Sorry didn't saw your 3rd patch... :(

I don't know why, but when i get patches from you... they appear in
the older threads..
i.e. v2 comes as reply to v1, v3 as reply to v2... so becomes
difficult to track them..

You simply do git send-email *.patch?
