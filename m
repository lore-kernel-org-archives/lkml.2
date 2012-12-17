Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab2LQP1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:27:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:39427 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab2LQP1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:27:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,302,1355126400"; 
   d="scan'208";a="265483437"
Message-ID: <1355758017.31620.110.camel@smile>
Subject: Re: [PATCH 2/2] dma: dw_dmac: clear suspend during termination
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Mon, 17 Dec 2012 17:26:57 +0200
In-Reply-To: <CAKohpom-C-VYnyHHu8hVVpvDWrkLUAFVs9f9Qu+74XtiFVRZvg@mail.gmail.com>
References: <1355753223-3705-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1355753223-3705-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAKohpom-C-VYnyHHu8hVVpvDWrkLUAFVs9f9Qu+74XtiFVRZvg@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-17 at 20:42 +0530, Viresh Kumar wrote: 
> On 17 December 2012 19:37, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> >
> > Clear DWC_CFGL_CH_SUSP bit during termination if the channel
> > was paused.
> >
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Insufficient commit log :(
> You don't have to say here, what you are doing, but why you are doing it.

Fighting against bug. The workflow in our case is to a) pause the dma,
b) do something in the slave driver, c) terminate all transfers, d)
submit new transfer. But d) doesn't happen because the channel is still
paused.

> Please mention the reason here first, then repost the series after getting my
> comments

Okay.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
