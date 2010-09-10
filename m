Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0IJHrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 03:47:25 -0400
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:53560 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752099Ab0IJHrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 03:47:25 -0400
Date: Fri, 10 Sep 2010 09:47:22 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Nix <nix@esperi.org.uk>
Cc: Artur Skawina <art.08.09@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>,
        John Drescher <drescherjm@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown
 to unusability (HPET)
Message-ID: <20100910074722.GA17716@brouette>
References: <87zkvx2ese.fsf@spindle.srvr.nix>
 <20100906053255.GA23340@brouette>
 <87iq2gyllg.fsf@spindle.srvr.nix>
 <87wrqu8s1u.fsf_-_@spindle.srvr.nix>
 <4C8982EF.8030705@gmail.com>
 <87eid282pj.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eid282pj.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (hm, odd.
> 
> spindle:~# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> tsc
> 
> spindle:~# grep -i tsc /proc/timer_list
> spindle:~# grep -i hpet /proc/timer_list
> Clock Event Device: hpet
>  set_next_event: hpet_legacy_next_event
>  set_mode:       hpet_legacy_set_mode
> 
> I suspect current_clocksource doesn't do what we think it does, or the
> clocksource and 'clock event device' are not the same.)

Yes, same here. When saying I was using tsc in my previous mail, I had
run the first command only, but when running the other two, I get the
same results than you, so HPET seems to be used too.

-- 
Damien Wyart
