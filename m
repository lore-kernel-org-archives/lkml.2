Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab2B2NNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 08:13:17 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34844 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610Ab2B2NNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 08:13:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of shijie8@gmail.com designates 10.236.184.167 as permitted sender) smtp.mail=shijie8@gmail.com; dkim=pass header.i=shijie8@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330516974.3545.104.camel@sauron.fi.intel.com>
References: <1329373053-19494-1-git-send-email-b32955@freescale.com>
	<4F4D9725.3090100@freescale.com>
	<1330502098.3545.78.camel@sauron.fi.intel.com>
	<4F4DE0E5.8070808@freescale.com>
	<1330516974.3545.104.camel@sauron.fi.intel.com>
Date: Wed, 29 Feb 2012 08:13:15 -0500
Message-ID: <CAMiH66HmV+58w36DGCt+e=ihTrYUwXf1Cur+678YX2GKcB1-jA@mail.gmail.com>
Subject: Re: [PATCH v6 0/2] patch set about the MXS-DMA
From: Huang Shijie <shijie8@gmail.com>
To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Cc: Huang Shijie <b32955@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem:

On Wed, Feb 29, 2012 at 7:00 AM, Bityutskiy, Artem
<artem.bityutskiy@intel.com> wrote:
> On Wed, 2012-02-29 at 16:25 +0800, Huang Shijie wrote:
>> Hi Artem:
>> > On Wed, 2012-02-29 at 11:10 +0800, Huang Shijie wrote:
>> >> Hi:
>> >>
>> >> ping.
>> > Is this patch-set independent or requires something like gpma patches?
>> >
>> This patch set is independent, and it does not depend upon any other
>> patches.
>
> Pushed both to l2-mtd.git tree, thanks. I am worried that it touches
> other subsystems like dma, sound, and mmc and there are no acks for
> those. Would be nice to get them somehow.
>

I ever thought Vinod could accept this patch set.

To Vinod & Chris:
      Could you give the ack to the first patch?

Does the second patch need  extra acks beside Shawn's?

BR
Huang Shijie
