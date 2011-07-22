Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab1GVVby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:31:54 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:36877 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932200Ab1GVVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:31:51 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAIvrKU5tgwKe/2dsb2JhbABTp0t4iHwCu3EOhjEEo08
Date: Fri, 22 Jul 2011 23:31:49 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 0/11 v3] Generic Watchdog Timer Driver
Message-ID: <20110722213149.GV3834@infomag.iguana.be>
References: <20110711135056.GT29245@infomag.iguana.be> <CACqU3MUbStZ0M8g_AE1WppY5tpxfqDVdvJpj+U7KWJ3V9TBW-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqU3MUbStZ0M8g_AE1WppY5tpxfqDVdvJpj+U7KWJ3V9TBW-w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaud,

> I had the occasion to have a look to the code in -next this week, so
> my comment will be based on this.
> 
> One thing which looked too constrained to me, is that the framework
> only supports a for a single watchdog. While this is fine for most
> board, I have an x86 based device which has 2 watchdog. This might be
> silly, but that's what the hardware provide. The current wartchdog
> framework would fail to adapt to this board. Moreover, one might think
> to provide interface to fail-to-wire NICs device on top of the
> watchdog framework. So at the end, it might be needed to be able to
> register an infinite amount of watchdog. Though, I am not sure how it
> would presented to userland, maybe something ala /dev/watchdog/[0-N].

This is what I said allready in the past:
1) we need the framework to get rid of the existing common code first.
2) next step is to extend the framework to support multiple watchdogs.
(via a sysfs like interface).

And we are seeing other interesting functionality that might also be added
to the framework. So still a lot of work to do :-).

PS: this comment was removed as a cleanup from Beta code to code that
is ready to be included in mainline:
+       /* The future version will have to manage a list of all
+        * registered watchdog devices. To start we will only
+        * support 1 watchdog device via the /dev/watchdog interface */

Kind regards,
Wim.

