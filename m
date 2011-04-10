Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab1DJICQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 04:02:16 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33236 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752510Ab1DJICM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 04:02:12 -0400
Date: Sun, 10 Apr 2011 10:01:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Michael B?sch <mb@bu3sch.de>, Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Rafa? Mi?ecki <zajec5@gmail.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
Message-ID: <20110410080159.GB2798@ucw.cz>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
 <op.vtisojsk3ri7v4@arend-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.vtisojsk3ri7v4@arend-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> >@@ -0,0 +1,30 @@
> >+config BCMAI_POSSIBLE
> >+       bool
> >+       depends on HAS_IOMEM && HAS_DMA
> >+       default y
> >+
> >+menu "Broadcom's AI"
> >+       depends on BCMAI_POSSIBLE
> >+
> >+config BCMAI
> >+       tristate "AI support"
> >+       depends on BCMAI_POSSIBLE
> >+
> >+config BCMAI_HOST_PCI_POSSIBLE
> >+       bool
> >+       depends on BCMAI && PCI = y
> >+       default y
> >+
> >+config BCMAI_HOST_PCI
> >+       bool "Support for AI on PCI-host bus"
> >+       depends on BCMAI_HOST_PCI_POSSIBLE
> >+
> >+config BCMAI_DEBUG
> >+       bool "BCMAI debugging"
> >+       depends on BCMAI
> >+       help
> >+         This turns on additional debugging messages.
> >+
> >+         If unsure, say N

Totally useless  :-(. It should really explain what AI means in this context.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
