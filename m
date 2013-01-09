Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab3AIO6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:58:07 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:41776 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab3AIO6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:58:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpokJGXKZ9jonGtYvTnPNLVr=wjhQ0DN_e=PF=U3nvusp-A@mail.gmail.com>
References: <20130108155423.GJ19691@intel.com>
	<1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1357719435-29955-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130109135006.GO19691@intel.com>
	<CAKohpokJGXKZ9jonGtYvTnPNLVr=wjhQ0DN_e=PF=U3nvusp-A@mail.gmail.com>
Date: Wed, 9 Jan 2013 16:58:02 +0200
Message-ID: <CAHp75VdWWy7V=PQ2EfXrixX2==yDiakga=tA=jV9bzRrqqzZhw@mail.gmail.com>
Subject: Re: [resend][PATCH 03/16] dmaengine: introduce is_slave_xfer function
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 4:19 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> n 9 January 2013 19:20, Vinod Koul <vinod.koul@intel.com> wrote:
>>> +static inline bool is_slave_xfer(enum dma_transfer_direction direction)
>>> +{
>>> +     return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
>>> +}
>> After reading the subsequent patch I understand what is intent here. Perhaps
>> is_slave_dirn() would have been a beter one...
>
> dirn isn't readable, it took me some time to understand the intent...
> Either have xfer or direction :)

Agree with Viresh. I might rename it to is_slave_direction if you want to.

-- 
With Best Regards,
Andy Shevchenko
