Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab2JQRCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:02:40 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64547 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab2JQRCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:02:38 -0400
MIME-Version: 1.0
In-Reply-To: <1350493112.3072.49.camel@joe-AO722>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1350387889-15324-6-git-send-email-hongbo.zhang@linaro.com>
	<CAKohpo=Vfq=z8NK6w4_QpwwLniYiwcfGfzWZsoG_zBPYPXrcUw@mail.gmail.com>
	<1350493112.3072.49.camel@joe-AO722>
Date: Wed, 17 Oct 2012 22:32:37 +0530
Message-ID: <CAKohponsXAKYiqeZTYE-5yv=C+BKmMRCUPVb56-nTRp=S8TU_Q@mail.gmail.com>
Subject: Re: [PATCH 5/5] Thermal: Add ST-Ericsson db8500 thermal dirver.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: "hongbo.zhang" <hongbo.zhang@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2012 22:28, Joe Perches <joe@perches.com> wrote:
>> > +#include <linux/slab.h>
>> > +#include <linux/module.h>
>> > +#include <linux/platform_device.h>
>> > +#include <linux/cpufreq.h>
>> > +#include <linux/cpu_cooling.h>
>> > +#include <linux/err.h>
>>
>> should be in alphabetical order
>
> There's no agreed kernel convention here.
> Some prefer christmas tree (shortest to longest length)

:)

I have seen a number of times this happening, because the list
isn't in alphabetical order people aren't able to easily read if an
#include ... is already there or not.

And so one header file is included multiple times. Because git diff
only shows few lines above and below a change, even people can't
catch it in reviews. That's why they must always be in alphabetical order.

--
viresh
