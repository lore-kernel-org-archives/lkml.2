Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab2GMKE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:04:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53017 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab2GMKEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:04:53 -0400
MIME-Version: 1.0
In-Reply-To: <4FFFE2B3.3040306@arm.com>
References: <1342166974-4490-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1342166974-4490-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=k6MDt5arZfPgrn8_tPu_zgPsD2e5y0-JyUkrx71Z6BNQ@mail.gmail.com>
	<CAHp75VfiyLJKdSogHRDqU1TC-3icKAhCXa0hWbfnWEcNmJosTQ@mail.gmail.com>
	<4FFFE2B3.3040306@arm.com>
Date: Fri, 13 Jul 2012 13:04:51 +0300
Message-ID: <CAHp75Vde==tJU9DrKwvWv1OezdO+YiEUAZAbiuvs0wAgUwwmYQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] dw_dmac: set default alignment
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: viresh kumar <viresh.kumar2@arm.com>
Cc: viresh kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 11:56 AM, viresh kumar <viresh.kumar2@arm.com> wrote:
> I wanted to ask, will normal memcpy for anybody will work with unaligned addresses
> with this patch? I believe they will.
Hmm... I just rechecked and it seems it works without this patch. I
didn't remember why this patch still in my pool.

-- 
With Best Regards,
Andy Shevchenko
