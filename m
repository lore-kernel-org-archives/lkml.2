Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab2IKLW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:22:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61427 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758868Ab2IKLWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:22:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rajanikanth HV <rajanikanth.hv@stericsson.com>
Subject: Re: mfd: Implement devicetree support for AB8500 Btemp
Date: Tue, 11 Sep 2012 11:22:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Rajanikanth HV <rajanikanth.hv@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "STEricsson_nomadik_linux" <STEricsson_nomadik_linux@list.st.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>
References: <CAB4BAktQz5MY_AHHWUAhRp7HtEzC3v8uFbP0enx1b7ibJLoZ4Q@mail.gmail.com> <201209101401.06859.arnd@arndb.de> <504EFA0F.2090102@stericsson.com>
In-Reply-To: <504EFA0F.2090102@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209111122.08713.arnd@arndb.de>
X-Provags-ID: V02:K0:vnTL0VyoaGY4RXrhPUveHkl5hel/hifot23iiuDZfct
 HhA/cgb5iiibwRBf2URD8/ispM8WJktYvsRbvHfzvQzhY0ZqOw
 s1FeAypVzr4LxI6bnCOdC96XRjCfWA3ZfSZMJkvNsixy22cpob
 JLZYX2gBFLtCfJ5vqqb5BYWECRkqLUQTBWuExhINbjw9rizRL8
 K/aWnRw0XNwgpWLNyhwZwNUDOVg8/S00vDE+ug8JE9CwgSbDcA
 l9ZUCyXgi0pjQGxD4lSusWUXK9vnV6dfWtoSCUowbaNsG8XbL9
 RpKSLDtIo+z5rW5Y4Bmi3izmarFyJZmxLaDnqYraLA99HbZRLb
 3i/rRmF/p9bkInm3BfQ0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2012, Rajanikanth HV wrote:
> >> +Supplied-to:
> >> +     This shall be power supply class dependency where in the
> runtime battery
> >> +     properties will be shared across fuel guage and charging
> algorithm driver.
> >
> > I probably don't understand enough of this, but shouldn't the other
> devices
> > that are supplied by this have a reference to this node rather than doing
> > it this way around? Why use strings here instead of phandles?
> 
> This is a logical binding w.r.t power supply event change
> across energy-management-module drivers where in runtime battery
> properties are shared along with uevent notification.
> ref: di->btemp_psy.external_power_
> changed =
>      ab8500_btemp_external_power_changed;
>      ref: ab8500_btemp.c
> 
> Need for this property:
>  btemp, fg and charger updates power-supply properties
>  based on the events listed above.
>  Event handler invokes power supply change notifier
>  which in-turn invokes registered power supply class call-back
>  based on the 'supplied_to' string.
>  ref:
>    power_supply_changed_work(..) ./drivers/power/power_supply_core.c
> 
> In this case how to approach through phandle?
> ============================
> 

Sorry, I really tried, but I cannot make sense of what you wrote
there. Can you try again and describe in full English sentences
how the hardware blocks are connected and what their purpose is?

	Arnd
