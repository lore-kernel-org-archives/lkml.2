Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030311Ab2GMKes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:34:48 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40234 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030206Ab2GMKeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:34:46 -0400
MIME-Version: 1.0
In-Reply-To: <4FFFF8E1.20408@arm.com>
References: <1342166974-4490-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1342166974-4490-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=k6MDt5arZfPgrn8_tPu_zgPsD2e5y0-JyUkrx71Z6BNQ@mail.gmail.com>
	<CAHp75VfiyLJKdSogHRDqU1TC-3icKAhCXa0hWbfnWEcNmJosTQ@mail.gmail.com>
	<4FFFE2B3.3040306@arm.com>
	<CAHp75Vde==tJU9DrKwvWv1OezdO+YiEUAZAbiuvs0wAgUwwmYQ@mail.gmail.com>
	<4FFFF8E1.20408@arm.com>
Date: Fri, 13 Jul 2012 13:34:45 +0300
Message-ID: <CAHp75Vfq9z5PyK_eRH6yjXQ1O8n5ErenYPkxe33vKr7M4f4=gw@mail.gmail.com>
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

On Fri, Jul 13, 2012 at 1:30 PM, viresh kumar <viresh.kumar2@arm.com> wrote:
> Sorry, got confused now. What works without this patch? And what doesn't work without it?
It seems this patch is redundant.

-- 
With Best Regards,
Andy Shevchenko
