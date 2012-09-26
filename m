Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab2IZRuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:50:35 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58616 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab2IZRue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:50:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAOh2x=kPAKXXo7C6meHvy4g0Vpwsx98dMbA6568pmt978eVq6w@mail.gmail.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-4-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=kPAKXXo7C6meHvy4g0Vpwsx98dMbA6568pmt978eVq6w@mail.gmail.com>
Date: Wed, 26 Sep 2012 20:50:32 +0300
Message-ID: <CAHp75VfT0R21X6x3_MMpsBBy+_C2OwiBgRaV8-O4rNPH1ZhXoA@mail.gmail.com>
Subject: Re: [PATCHv2 3/4] dma: move dw_dmac driver to an own directory
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 5:53 PM, viresh kumar <viresh.kumar@linaro.org> wrote:
> On Wed, Sep 26, 2012 at 6:10 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> The dw_dmac driver contains multiple files. To make a managment of them more
>> convenient move it to an own directory.
>
> git format-patch has a option -C or -M or both... that makes such
> changes easier to review.
> If you create patches with these options, we will not get such long
> patches for renames....
> instead a single line will tell "foo.c file is renamed as dw/foo.c"

> So this patch will have only few lines after that.
It's never late to learn something new. Thanks!

> Please resend with that... as its impossible to review it currently.
Will be in v3.


-- 
With Best Regards,
Andy Shevchenko
