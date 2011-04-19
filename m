Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1DSSjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 14:39:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59249 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1DSSjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 14:39:47 -0400
Date: Tue, 19 Apr 2011 14:39:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc-cmos: do not call rtc_update_irq when cmos->rtc is
 uninitialized
Message-ID: <20110419183909.GA7273@dumpdata.com>
References: <alpine.DEB.2.00.1104191707440.10886@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104191707440.10886@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 06:14:48PM +0100, Stefano Stabellini wrote:
> Hi all,
> I have a 32 bit kernel compiled with:
> 
> CONFIG_HPET_TIMER
> CONFIG_HPET_EMULATE_RTC
> CONFIG_RTC_DRV_CMOS
> 
> that crashes reliably on boot on xen with the following stack trace:

The commit f6d5b33125c4fa63c16f7f54c533338c9695d82c
Author: John Stultz <john.stultz@linaro.org>
Date:   Tue Mar 29 18:00:27 2011 -0700

    RTC: Fix early irqs caused by calling rtc_set_alarm too early
    

doesn't fix it for you? (it is in 2.6.39-rc4)
