Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab0EVHRn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 03:17:43 -0400
Received: from mx3.wp.pl ([212.77.101.7]:14838 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab0EVHRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 03:17:42 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 May 2010 03:17:42 EDT
Date: Sat, 22 May 2010 09:13:40 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: bkl: Pushdowns for sound/oss ?
Message-Id: <20100522091340.9524d962.krzysztof.h1@wp.pl>
In-Reply-To: <4BF6A7A6.9080807@ladisch.de>
References: <alpine.LFD.2.00.1005211536330.25348@localhost.localdomain>
	<20100521144055.GB13174@linux-mips.org>
	<4BF6A7A6.9080807@ladisch.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [IWM0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 17:32:54 +0200
Clemens Ladisch <clemens@ladisch.de> wrote:

> Ralf Baechle wrote:
> > On Fri, May 21, 2010 at 03:45:04PM +0200, John Kacur wrote:
> > > sound/oss/msnd_pinnacle.c
> > 
> > Random weirdo ISA sound card.  Probably only ever tested on x86 and will
> > have the chances
> 
> This has since been replaced with an ALSA driver, so we can basically
> just kill the OSS driver off at this point.  Krzystof?
> 

I have tested/developed the ALSA driver on the Pinnacle card - I have such a card so
I can retest and fix the ALSA driver at any moment.

The driver is supposed to handle the Classic model as well but I am not aware anybody tested
the ALSA driver on this model.

IMO, we can remove the OSS driver - one can look into the git to find the old source if needed.

I am looking to people who have the old ISA cards for OSS drivers not converted 
into the ALSA. I can convert these drivers if these people are willing to test or donate the
hardware.

Regards,
Krzysztof
