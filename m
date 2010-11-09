Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0KIA6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 19:58:07 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61270 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab0KIA6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 19:58:04 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/JTKJ9RSiQhztqwGALUZGS
Date: Mon, 8 Nov 2010 16:57:54 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: Re: [GIT PULL] fixes for tidspbridge 2.6.37-rc1
Message-ID: <20101109005754.GX9264@atomide.com>
References: <AANLkTinZF-47WQyF5k1Nv64NjfMNSQ-+oE0eGycR24NM@mail.gmail.com>
 <AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikB0zhN13u5OtRwviOv-rFDW-vFTmq0t7ALuO7N@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Contreras <felipe.contreras@gmail.com> [101108 14:51]:
> On Sun, Nov 7, 2010 at 11:36 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
> > The situation of tidspbridge driver on staging has been pretty sad,
> > basically, it has never worked. This is a step backwards from the
> > previous situation where it was clear which branch to use to get it
> > working. Unfortunately, the ARM and OMAP trees haven't made it easy,
> > as changes in those trees have broken it even further.

Hmm to me it looks like these reverts you are suggesting are
for drivers/staging/tidspbridge, not for arch/arm/* :)
 
> Here's another try, this one has only one patch that needs omap
> maintainers to ack.

Acked that memblock patch it in this thread.

Tony
