Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768609Ab2KOR6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 12:58:44 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57573 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768575Ab2KOR6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:58:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpokPEuHy_rmjamLWZRu32f56W29Wo06EbWr4C2iqNqzvXQ@mail.gmail.com>
References: <1352989248-28913-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1352989248-28913-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=mpzinz4xr4poNtX0Mom65kfptGM047-hu+XDLTS7m2rw@mail.gmail.com>
	<1352992898.11158.338.camel@smile>
	<CAKohpo=F1SmD0qCn9ybOOQ9VXWFQ-BY=udPgrWYPa23M2PuU_g@mail.gmail.com>
	<1352993269.11158.340.camel@smile>
	<CAKohpokPEuHy_rmjamLWZRu32f56W29Wo06EbWr4C2iqNqzvXQ@mail.gmail.com>
Date: Thu, 15 Nov 2012 19:58:41 +0200
Message-ID: <CAHp75VdDD7GwUUqp50YhbMEgX1kixV=3jmN7-QxV6paHcfWq0Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] dw_dmac: make usage of dw_dma_slave optional
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        spear-devel <spear-devel@list.st.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 5:38 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 15 November 2012 20:57, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> Well, the prep_* should assign the value due to changes of check in the
>> dwc_descriptor_complete. Otherwise we will potentially skip some
>> important piece of code.
>
> What i meant to say was, set_runtime_config() must have already done this part.

On one hand it is true. On the other - *_prep* functions use
explicitly passed parameter. I doubt there is a consistency between
value in slave config passed via dwc_control and value passed as
explicit function parameter.

-- 
With Best Regards,
Andy Shevchenko
