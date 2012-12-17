Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2LQPMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:12:06 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:38868 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2LQPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:12:04 -0500
MIME-Version: 1.0
In-Reply-To: <1355753223-3705-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355753223-3705-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1355753223-3705-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 17 Dec 2012 20:42:03 +0530
Message-ID: <CAKohpom-C-VYnyHHu8hVVpvDWrkLUAFVs9f9Qu+74XtiFVRZvg@mail.gmail.com>
Subject: Re: [PATCH 2/2] dma: dw_dmac: clear suspend during termination
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 December 2012 19:37, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>
> Clear DWC_CFGL_CH_SUSP bit during termination if the channel
> was paused.
>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Insufficient commit log :(
You don't have to say here, what you are doing, but why you are doing it.

Please mention the reason here first, then repost the series after getting my
comments

--
viresh
