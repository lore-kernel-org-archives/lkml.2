Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab2CEEm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 23:42:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:23067 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab2CEEm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 23:42:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="73525436"
Subject: Re: [PATCH v6 0/2] patch set about the MXS-DMA
From: Vinod Koul <vinod.koul@intel.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>,
        Huang Shijie <b32955@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "LW@KARO-electronics.de" <LW@karo-electronics.de>
In-Reply-To: <CAMiH66HmV+58w36DGCt+e=ihTrYUwXf1Cur+678YX2GKcB1-jA@mail.gmail.com>
References: <1329373053-19494-1-git-send-email-b32955@freescale.com>
	 <4F4D9725.3090100@freescale.com>
	 <1330502098.3545.78.camel@sauron.fi.intel.com>
	 <4F4DE0E5.8070808@freescale.com>
	 <1330516974.3545.104.camel@sauron.fi.intel.com>
	 <CAMiH66HmV+58w36DGCt+e=ihTrYUwXf1Cur+678YX2GKcB1-jA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Mar 2012 10:17:10 +0530
Message-ID: <1330922830.24656.137.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 08:13 -0500, Huang Shijie wrote:
> Hi Artem:
> 
> On Wed, Feb 29, 2012 at 7:00 AM, Bityutskiy, Artem
> <artem.bityutskiy@intel.com> wrote:
> > On Wed, 2012-02-29 at 16:25 +0800, Huang Shijie wrote:
> >> Hi Artem:
> >> > On Wed, 2012-02-29 at 11:10 +0800, Huang Shijie wrote:
> >> >> Hi:
> >> >>
> >> >> ping.
> >> > Is this patch-set independent or requires something like gpma patches?
> >> >
> >> This patch set is independent, and it does not depend upon any other
> >> patches.
> >
> > Pushed both to l2-mtd.git tree, thanks. I am worried that it touches
> > other subsystems like dma, sound, and mmc and there are no acks for
> > those. Would be nice to get them somehow.
> >
> 
> I ever thought Vinod could accept this patch set.
> 
> To Vinod & Chris:
>       Could you give the ack to the first patch?
Both,
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>
Although the second patch overloads the dmaengine flags but for lack of
any other suitable alternative, this looks okay...
> 
> Does the second patch need  extra acks beside Shawn's?
> 
> BR
> Huang Shijie
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod

