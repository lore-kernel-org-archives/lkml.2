Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab1CIPil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:38:41 -0500
Received: from 64.mail-out.ovh.net ([91.121.185.65]:46328 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753175Ab1CIPik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:38:40 -0500
Date: Wed, 9 Mar 2011 16:33:20 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: John Stultz <john.stultz@linaro.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] rtc/at91sam9: fix typo .alarm_irq_enabled instead of
 .alarm_irq_enable
Message-ID: <20110309153320.GE9351@game.jcrosoft.org>
References: <1299601173-26252-1-git-send-email-plagnioj@jcrosoft.com>
 <1299603953.28285.215.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299603953.28285.215.camel@work-vm>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 11456313028473891791
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:05 Tue 08 Mar     , John Stultz wrote:
> On Tue, 2011-03-08 at 17:19 +0100, Jean-Christophe PLAGNIOL-VILLARD
> wrote:
> > in struct rtc_class_ops at91_rtc_ops
> > 
> > introduce in commit 16380c153a6
> > RTC: Convert rtc drivers to use the alarm_irq_enable method
> 
> I believe this fix is already upstream:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d40358509ee862d7e4049187bc05eba1911a2959
ok some of my tree are new update to date enough

Best Regards,
J.
