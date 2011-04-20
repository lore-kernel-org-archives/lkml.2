Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab1DTMCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:02:18 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:49122 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab1DTMCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:02:17 -0400
X-IronPort-AV: E=Sophos;i="4.64,246,1301875200"; 
   d="scan'208";a="5393100"
Date: Wed, 20 Apr 2011 13:02:46 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc-cmos: do not call rtc_update_irq when cmos->rtc is
 uninitialized
In-Reply-To: <20110419183909.GA7273@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1104201302170.10886@kaball-desktop>
References: <alpine.DEB.2.00.1104191707440.10886@kaball-desktop> <20110419183909.GA7273@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 19, 2011 at 06:14:48PM +0100, Stefano Stabellini wrote:
> > Hi all,
> > I have a 32 bit kernel compiled with:
> > 
> > CONFIG_HPET_TIMER
> > CONFIG_HPET_EMULATE_RTC
> > CONFIG_RTC_DRV_CMOS
> > 
> > that crashes reliably on boot on xen with the following stack trace:
> 
> The commit f6d5b33125c4fa63c16f7f54c533338c9695d82c
> Author: John Stultz <john.stultz@linaro.org>
> Date:   Tue Mar 29 18:00:27 2011 -0700
> 
>     RTC: Fix early irqs caused by calling rtc_set_alarm too early
>     
> 
> doesn't fix it for you? (it is in 2.6.39-rc4)
> 

Yes, it does! I was working on 2.6.39-rc3...
Thanks,

Stefano
