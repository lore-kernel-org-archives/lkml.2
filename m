Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab1DEWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 18:16:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38420 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab1DEWQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 18:16:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Kp426MK7O7sy+2nEhMwPcTch51+Fl+X8LqN4pJ8WCzX0PirzDEDoSmHvPkif3gbj8l
         TDlzboOaIw/lQugcHbF6Ug5MInywgAhMURrw5GCf4JECfOUwGEyc3SXyH0k9O/Rh2lyl
         lA4/T4/iuXGmnkqZRRIqMwufwmsLEQeWWe2ck=
MIME-Version: 1.0
In-Reply-To: <4D9AB958.5010304@ti.com>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
	<201104031726.37420.arnd@arndb.de>
	<20110403160324.GA8050@n2100.arm.linux.org.uk>
	<201104040259.26601.arnd@arndb.de>
	<1301915022.15819.28.camel@e102109-lin.cambridge.arm.com>
	<20110404112104.GB19854@n2100.arm.linux.org.uk>
	<1301923457.417.34.camel@e102391-lin.cambridge.arm.com>
	<20110404133104.GA23266@n2100.arm.linux.org.uk>
	<1301925445.417.54.camel@e102391-lin.cambridge.arm.com>
	<BANLkTi=d-rQpinSW9YPsZbkh9tDK5FLS+w@mail.gmail.com>
	<4D9AB958.5010304@ti.com>
Date: Wed, 6 Apr 2011 00:16:22 +0200
X-Google-Sender-Auth: cpwD4eThM8RbsSt6diw-wC3W3tE
Message-ID: <BANLkTinZ+3PqkbbJp3fFs_Z8JBHQdPYM_g@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
From: Linus Walleij <linus.walleij@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: david@lang.hm, Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/5 Santosh Shilimkar <santosh.shilimkar@ti.com>:
> [Me]
>> (And third it will also eventually need to hook into the timer-based
>> delay framework that I think Nokia is working on to be really
>> useful, else all delays become unpredictable.)
>>
> Do you mean udelay()/mdelay() here ?

Yes. Stephen Boyd from Qualcomm has floated patches to fix it for the
ARM architecture, I just pushed him again. We use it in our
ST-Ericsson products.

Ideally you'd want that to go along with the A15 timer stuff so that this
monotonic high-precision timer is also used for udelay()/mdelay().

Yours,
Linus Walleij
