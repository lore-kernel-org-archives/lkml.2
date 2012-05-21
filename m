Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab2EUQIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:08:45 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:15261 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab2EUQIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:08:43 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19O+TnMUtO0+P9yKuBV2aK5
Date: Mon, 21 May 2012 09:08:40 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lauri Leukkunen <lauri.leukkunen@nokia.com>,
        Sebastian Reichel <sre@debian.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Ameya Palande <ameya.palande@nokia.com>
Subject: Re: rx51: support for lis3lv02d accelerometer
Message-ID: <20120521160840.GK17852@atomide.com>
References: <1621273.5PNGJFOirm@pali>
 <20120509000734.GZ5088@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120509000734.GZ5088@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pali,

* Tony Lindgren <tony@atomide.com> [120508 17:12]:
> * Pali Rohár <pali.rohar@gmail.com> [120504 08:41]:
> > Hi!
> > 
> > Upstream linux kernel has already driver for lis3lv02d accelerometer
> > in drivers/misc/lis3lv02d. So now can be added also platform support
> > for nokia rx51. Patch exists for long time in meego obs repository:
> > https://build.pub.meego.com/package/view_file?file=linux-2.6-omap-rx51-Platform-support-for-lis3lv02d-acceleromet.patch&package=kernel-adaptation-n900&project=CE%3AAdaptation%3AN900
> > 
> > It is possible to include this patch to upstream kernel?
> 
> Thanks, applying into board branch with From: Ameya as in the
> link above.

Just noticed that this one is still using OMAP_GPIO_IRQ that
won't work any longer. Can you please send a fix on top of this
patch against linux next to fix it?

The fix is to use gpio_to_irq() in the related init function
instead of static OMAP_GPIO_IRQ in the data structure.

Regards,

Tony
