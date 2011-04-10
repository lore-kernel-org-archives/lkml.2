Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab1DJIYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 04:24:35 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49093 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753022Ab1DJIYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 04:24:33 -0400
Date: Sun, 10 Apr 2011 08:24:21 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Rafa? Mi?ecki <zajec5@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Michael B?sch <mb@bu3sch.de>, Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
Message-ID: <20110410082420.GA1460@localhost.ucw.cz>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com> <op.vtisojsk3ri7v4@arend-laptop> <20110410080159.GB2798@ucw.cz> <BANLkTikL+GvaKN6nT-9WjpPjaJz0dR51KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikL+GvaKN6nT-9WjpPjaJz0dR51KQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >+config BCMAI_HOST_PCI_POSSIBLE
> >> >+       bool
> >> >+       depends on BCMAI && PCI = y
> >> >+       default y
> >> >+
> >> >+config BCMAI_HOST_PCI
> >> >+       bool "Support for AI on PCI-host bus"
> >> >+       depends on BCMAI_HOST_PCI_POSSIBLE
> >> >+
> >> >+config BCMAI_DEBUG
> >> >+       bool "BCMAI debugging"
> >> >+       depends on BCMAI
> >> >+       help
> >> >+         This turns on additional debugging messages.
> >> >+
> >> >+         If unsure, say N
> >
> > Totally useless  :-(. It should really explain what AI means in this context.
> 
> Feel free to propose sth.

AFAICT AI means "artifical inteligence". So _you_ really need to fix your kconfig.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
