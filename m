Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2KLOAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:00:38 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61709 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2KLOAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:00:37 -0500
MIME-Version: 1.0
In-Reply-To: <1352728712.11158.291.camel@smile>
References: <1352719406-26405-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=m9TyMOhh=nCD0nznEBy6jN7eUddp7hLT7TnCf0xM07dA@mail.gmail.com>
	<1352728712.11158.291.camel@smile>
Date: Mon, 12 Nov 2012 19:30:36 +0530
Message-ID: <CAKohpom1FxvxakLbEok4OPUdd5nu-Axth6bGrFZ+DpDoKA=biQ@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: absence of pdata isn't critical when autocfg is set
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2012 19:28, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Mon, 2012-11-12 at 19:24 +0530, viresh kumar wrote:

>> Allocate it dynamically to support multiple controllers with different
>> configuration
>> in a SoC.
>
> Like you did for device tree? No problem, but here is the question: what
> the default values should be and where we can get them?

Yes. Fill with the values you mentioned in your static definition :)

--
viresh
