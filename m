Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab2CCByI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 20:54:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34626 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2CCByG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 20:54:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of shijie8@gmail.com designates 10.101.175.14 as permitted sender) smtp.mail=shijie8@gmail.com; dkim=pass header.i=shijie8@gmail.com
MIME-Version: 1.0
In-Reply-To: <m2mx7yn2we.fsf@bob.laptop.org>
References: <1329373053-19494-1-git-send-email-b32955@freescale.com>
	<4F4D9725.3090100@freescale.com>
	<1330502098.3545.78.camel@sauron.fi.intel.com>
	<4F4DE0E5.8070808@freescale.com>
	<1330516974.3545.104.camel@sauron.fi.intel.com>
	<CAMiH66HmV+58w36DGCt+e=ihTrYUwXf1Cur+678YX2GKcB1-jA@mail.gmail.com>
	<m2mx7yn2we.fsf@bob.laptop.org>
Date: Sat, 3 Mar 2012 09:54:05 +0800
Message-ID: <CAMiH66G54BCoMrSTqnXyJy=C8w4RqVkv_qvQosUHWj4qd+Xh=Q@mail.gmail.com>
Subject: Re: [PATCH v6 0/2] patch set about the MXS-DMA
From: Huang Shijie <shijie8@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>,
        Huang Shijie <b32955@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Sat, Mar 3, 2012 at 4:50 AM, Chris Ball <cjb@laptop.org> wrote:
> Hi,
>
> On Wed, Feb 29 2012, Huang Shijie wrote:
>>> Pushed both to l2-mtd.git tree, thanks. I am worried that it touches
>>> other subsystems like dma, sound, and mmc and there are no acks for
>>> those. Would be nice to get them somehow.
>>
>> I ever thought Vinod could accept this patch set.
>>
>> To Vinod & Chris:
>>       Could you give the ack to the first patch?
>
> Yes -- for the first patch:
>
> Acked-by: Chris Ball <cjb@laptop.org>
>

thanks a lot.

Huang Shijie


> (I think Shawn's ACK is sufficient for the second patch.)
>
> Thanks,
>
> - Chris.
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
