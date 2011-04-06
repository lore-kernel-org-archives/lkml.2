Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1DFGoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 02:44:18 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:33620 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481Ab1DFGoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 02:44:17 -0400
Message-ID: <4D9C0BAA.40602@ti.com>
Date: Wed, 06 Apr 2011 12:13:54 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: david@lang.hm, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        linux-arm-kernel@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Detlef Vollmann <dv@vollmann.ch>,
        David Brown <davidb@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>	<201104031726.37420.arnd@arndb.de>	<20110403160324.GA8050@n2100.arm.linux.org.uk>	<201104040259.26601.arnd@arndb.de>	<1301915022.15819.28.camel@e102109-lin.cambridge.arm.com>	<20110404112104.GB19854@n2100.arm.linux.org.uk>	<1301923457.417.34.camel@e102391-lin.cambridge.arm.com>	<20110404133104.GA23266@n2100.arm.linux.org.uk>	<1301925445.417.54.camel@e102391-lin.cambridge.arm.com>	<BANLkTi=d-rQpinSW9YPsZbkh9tDK5FLS+w@mail.gmail.com>	<4D9AB958.5010304@ti.com> <BANLkTinZ+3PqkbbJp3fFs_Z8JBHQdPYM_g@mail.gmail.com>
In-Reply-To: <BANLkTinZ+3PqkbbJp3fFs_Z8JBHQdPYM_g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/2011 3:46 AM, Linus Walleij wrote:
> 2011/4/5 Santosh Shilimkar<santosh.shilimkar@ti.com>:
>> [Me]
>>> (And third it will also eventually need to hook into the timer-based
>>> delay framework that I think Nokia is working on to be really
>>> useful, else all delays become unpredictable.)
>>>
>> Do you mean udelay()/mdelay() here ?
>
> Yes. Stephen Boyd from Qualcomm has floated patches to fix it for the
> ARM architecture, I just pushed him again. We use it in our
> ST-Ericsson products.
>
I remember the post.

> Ideally you'd want that to go along with the A15 timer stuff so that this
> monotonic high-precision timer is also used for udelay()/mdelay().
>
The A15 counter which is always available and running can be used
to emulate this.

Regards
Santosh
