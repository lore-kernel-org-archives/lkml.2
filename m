Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1EGGaV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:30:21 -0400
Received: from zmta01.irigo.dk ([193.200.44.52]:44999 "EHLO zmta01.irigo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab1EGGaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:30:18 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 May 2011 02:30:17 EDT
Subject: Re: mmotm 2011-05-06-16-39 uploaded (leds)
From: Esben Haabendal <eha@doredevelopment.dk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: akpm@linux-foundation.org, Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110506182341.d2cd8a19.rdunlap@xenotime.net>
References: <201105070015.p470FlAR013200@imap1.linux-foundation.org>
	 <20110506182341.d2cd8a19.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Organization: DoreDevelopment ApS
Date: Sat, 07 May 2011 08:23:53 +0200
Message-ID: <1304749433.3530.3.camel@eha.ulstruplund.dk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 18:23 -0700, Randy Dunlap wrote:
> On Fri, 06 May 2011 16:39:31 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2011-05-06-16-39 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > It contains the following patches against 2.6.39-rc6:
> 
> 
> As reported on April 15 of 2011 in
> Subject: Re: mmotm 2011-04-14-15-08 uploaded (leds)
> 
> 
> from leds-support-automatic-start-of-blinking-with-ledtrig-timer.patch:
> 
> This build error happened several times when
> CONFIG_LEDS_TRIGGERS is not enabled:
> 
> drivers/leds/led-class.c:134: error: 'struct led_classdev' has no member named 'trigger_data'

Hmm...  This is in led_set_software_blink() which is only used if
CONFIG_LEDS_TRIGGERS is enabled.  It might make sense to leave out all
the blink related functions when CONFIG_LEDS_TRIGGERS is not enabled.

I am just leaving for some weekend activities, but I will happy to write
a patch for it sunday or perhaps monday.

/Esben

