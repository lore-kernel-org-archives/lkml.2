Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab1DJQOt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 12:14:49 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:44947 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab1DJQOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 12:14:47 -0400
X-MDAV-Processed: mail.academy.zt.ua, Sun, 10 Apr 2011 19:14:45 +0300
X-Spam-Processed: mail.academy.zt.ua, Sun, 10 Apr 2011 19:14:44 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-Return-Path: george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: George Kashperko <george@znau.edu.ua>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Michael B?sch <mb@bu3sch.de>, Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <op.vtpt6v173ri7v4@arend-laptop>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	 <op.vtisojsk3ri7v4@arend-laptop> <20110410080159.GB2798@ucw.cz>
	 <BANLkTikL+GvaKN6nT-9WjpPjaJz0dR51KQ@mail.gmail.com>
	 <20110410082420.GA1460@localhost.ucw.cz>
	 <BANLkTim9JTpZGib+_C_vTFFhP5azbGwMjg@mail.gmail.com>
	 <op.vtpt6v173ri7v4@arend-laptop>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 10 Apr 2011 19:11:57 +0300
Message-Id: <1302451917.14558.13.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Sun, 10 Apr 2011 10:30:53 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:
> 
> > 2011/4/10 Pavel Machek <pavel@ucw.cz>:
> >>> >> >+config BCMAI_HOST_PCI_POSSIBLE
> >>> >> >+       bool
> >>> >> >+       depends on BCMAI && PCI = y
> >>> >> >+       default y
> >>> >> >+
> >>> >> >+config BCMAI_HOST_PCI
> >>> >> >+       bool "Support for AI on PCI-host bus"
> >>> >> >+       depends on BCMAI_HOST_PCI_POSSIBLE
> >>> >> >+
> 
> Hi Rafał,
> 
> Could use term AMBA AXI instead which gives enough hits on Google to hint  
> interested people to more in depth information.
> 
> FYI: AXI = Advanced eXtensible Interface
> 	High-speed interconnect for chip cores ( provides higher bursts/transfers  
> than predecessor AHB = Advanced High-performance Bus (AHB)).
> 
> Gr. AvS

Not sure if AXI will be relevant bus name to manage newer Broadcom IP
cores. Yes, AMBA AXI is underlying interconnect used for communications,
but those communications are made in regard of communication ports
(those thingys referenced at Broadcom code as wrappers and which are
actually master ports intermediately bound to the backplane itself).
Pretty much sure your original bcmb is much more relevant for managing
Broadcom hardware extensions over AXI than just axi, especially
considering that techniques we use to identify, enumerate and control
AXI slave ports are completely Broadcom-specific.

Have nice day,
George


