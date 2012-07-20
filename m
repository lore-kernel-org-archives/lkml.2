Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2GTN0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:26:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57769 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab2GTN0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:26:45 -0400
Message-ID: <50095C6F.2020106@ti.com>
Date: Fri, 20 Jul 2012 18:56:07 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Mike Turquette <mturquette@linaro.org>, Kevin Hilman <khilman@ti.com>,
        <linux-kernel@vger.kernel.org>, <shawn.guo@linaro.org>,
        <rob.herring@calxeda.com>, <pdeschrijver@nvidia.com>,
        <pgaikwad@nvidia.com>, <viresh.kumar@linaro.org>, <rnayak@ti.com>,
        <paul@pwsan.com>, <broonie@opensource.wolfsonmicro.com>,
        <tglx@linutronix.de>, <ccross@android.com>,
        <linux-arm-kernel@lists.infradead.org>,
        "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH 2/2] [RFC] cpufreq: omap: scale regulator from clk notifier
References: <1342225001-22962-1-git-send-email-mturquette@linaro.org> <1342225001-22962-3-git-send-email-mturquette@linaro.org> <CACRpkda7g2qMErwf-nebKSOW=044=YadEzEoKWM1dT=29yueeA@mail.gmail.com>
In-Reply-To: <CACRpkda7g2qMErwf-nebKSOW=044=YadEzEoKWM1dT=29yueeA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 7/17/2012 3:58 AM, Linus Walleij wrote:
> On Sat, Jul 14, 2012 at 2:16 AM, Mike Turquette <mturquette@linaro.org> wrote:
> '
>> This patch moves direct control of the MPU voltage regulator out of the
>> cpufreq driver .target callback and instead puts that logic into a clock
>> rate change notifier callback.
> 
> That's heavy stuff.
> 
> I was hoping that the first example of using clk notifiers would be
> something like mach-davinci replacing it's legacy clock framework
> with drivers/clk and then go in and change the horrid cpufreq hack
> that is currently in drivers/mmc/host/davinci_mmc.c to use a
> clock notifier instead of cpufreq.
> 
> Sekhar/Kevin, any chance to have DaVinci converted to Mikes new
> clock framework? It doesn't look super-complex and would be a
> good example for others I think.

Murali (CCed) from TI is planning to work on it and should be posting
patches in 3rd/4th week of August. Once he is done, will work on
migrating the drivers to clock notifiers.

Thanks,
Sekhar
