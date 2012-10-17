Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab2JQQ6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:58:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60052 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756469Ab2JQQ6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:58:34 -0400
Message-ID: <1350493112.3072.49.camel@joe-AO722>
Subject: Re: [PATCH 5/5] Thermal: Add ST-Ericsson db8500 thermal dirver.
From: Joe Perches <joe@perches.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "hongbo.zhang" <hongbo.zhang@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Date: Wed, 17 Oct 2012 09:58:32 -0700
In-Reply-To: <CAKohpo=Vfq=z8NK6w4_QpwwLniYiwcfGfzWZsoG_zBPYPXrcUw@mail.gmail.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	 <1350387889-15324-6-git-send-email-hongbo.zhang@linaro.com>
	 <CAKohpo=Vfq=z8NK6w4_QpwwLniYiwcfGfzWZsoG_zBPYPXrcUw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 20:53 +0530, Viresh Kumar wrote:
> On 16 October 2012 17:14, hongbo.zhang <hongbo.zhang@linaro.org> wrote:
[]
> > diff --git a/drivers/thermal/db8500_cpufreq_cooling.c b/drivers/thermal/db8500_cpufreq_cooling.c
[]
> > +#include <linux/slab.h>
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/cpufreq.h>
> > +#include <linux/cpu_cooling.h>
> > +#include <linux/err.h>
> 
> should be in alphabetical order

There's no agreed kernel convention here.
Some prefer christmas tree (shortest to longest length)


