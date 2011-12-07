Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab1LGTbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:31:46 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:13137 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab1LGTbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:31:45 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Z+n9WJcs/mvGJhSOJFS7i
Date: Wed, 7 Dec 2011 11:31:42 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Heikki Krogerus <krohei@gmail.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH 2/2] Revert "ARM: RX-51: Enable isp1704 power on/off"
Message-ID: <20111207193141.GG31337@atomide.com>
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
 <1323105820-25946-3-git-send-email-felipe.contreras@nokia.com>
 <20111207130517.GA22946@xps8300>
 <CAMP44s2FV=Dtquq+HuhB7+0fTi9YwiY-4YcSf1XdB=OwDHYULA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP44s2FV=Dtquq+HuhB7+0fTi9YwiY-4YcSf1XdB=OwDHYULA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Contreras <felipe.contreras@gmail.com> [111207 10:12]:
> On Wed, Dec 7, 2011 at 3:05 PM, Heikki Krogerus <krohei@gmail.com> wrote:
> > On Mon, Dec 05, 2011 at 07:23:40PM +0200, Felipe Contreras wrote:
> >> From: Felipe Contreras <felipe.contreras@gmail.com>
> >>
> >> This reverts commit 10299e2e4e3ed3b16503d4e04edd48b33083f4e2.
> >>
> >> This seems to break USB networking stuff.
> >>
> >> Cc: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
> >> Cc: Heikki Krogerus <heikki.krogerus@nokia.com>
> >> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> >> Cc: Tony Lindgren <tony@atomide.com>
> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> >> ---
> >>  arch/arm/mach-omap2/board-rx51-peripherals.c |   27 +------------------------
> >>  1 files changed, 2 insertions(+), 25 deletions(-)
> >
> > <snip>
> >
> >> -static void __init rx51_charger_init(void)
> >> -{
> >> -     WARN_ON(gpio_request_one(RX51_USB_TRANSCEIVER_RST_GPIO,
> >> -             GPIOF_OUT_INIT_LOW, "isp1704_reset"));
> >
> > How about simply GPIOF_OUT_INIT_HIGH here. Is that not enough to fix
> > your problem? Revering the whole thing does not make any sense to me.
> 
> Yes, that fixes it :)

Got an updated patch for this one? Please also Cc linux-omap and
linux-arm-kernel lists for arch/arm/*omap*/ touching patches.

Regards,

Tony
