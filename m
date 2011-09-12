Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1ILH2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 03:28:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44380 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab1ILH2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 03:28:20 -0400
Date: Mon, 12 Sep 2011 09:28:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 0/4] Support for the TS-5500 platform
Message-ID: <20110912072810.GA1574@ucw.cz>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  Documentation/ABI/testing/sysfs-platform-ts5500 |   46 +++
>  MAINTAINERS                                     |   12 +
>  arch/x86/Kconfig                                |    2 +
>  arch/x86/platform/Makefile                      |    1 +
>  arch/x86/platform/ts5500/Kconfig                |   28 ++
>  arch/x86/platform/ts5500/Makefile               |    4 +
>  arch/x86/platform/ts5500/ts5500.c               |  471 +++++++++++++++++++++++
>  arch/x86/platform/ts5500/ts5500_adc.c           |  326 ++++++++++++++++
>  arch/x86/platform/ts5500/ts5500_adc.h           |   62 +++
>  arch/x86/platform/ts5500/ts5500_gpio.c          |  421 ++++++++++++++++++++
>  arch/x86/platform/ts5500/ts5500_gpio.h          |   60 +++
>  arch/x86/platform/ts5500/ts5500_leds.c          |  133 +++++++


Few lines of documentation/README file would be nice.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
