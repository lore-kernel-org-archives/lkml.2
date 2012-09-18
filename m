Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab2IRHSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:18:46 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43854 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245Ab2IRHSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:18:42 -0400
MIME-Version: 1.0
In-Reply-To: <50581084.2050007@yahoo.es>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<50581084.2050007@yahoo.es>
Date: Tue, 18 Sep 2012 12:48:41 +0530
X-Google-Sender-Auth: RYir3mXGUnsim75jGohp20RQFHE
Message-ID: <CAOh2x=kL=pB2Hk4qHNUR1zTJUeJRPNihcH4dVP3EKzC3ETF52A@mail.gmail.com>
Subject: Re: [PATCH 0/7] dw_dmac: introduce autoconfiguration
From: viresh kumar <viresh.kumar@linaro.org>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 11:41 AM, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> The (embedded) dw dma on the AP7000 indeed does not support auto
> configuration (the register reads as zero) and so it needs the
> platform data.
>
> I tested the driver on AVR32 with the atmel-mci driver and it all
> worked well.
>
> I also tested the new software emulation of LLP mode by setting
> nollp for each channel to true. That also worked as expected.
>
>
> Tested-by: Hein Tibosch <hein_tibosch@yahoo.es>

Great. :)
