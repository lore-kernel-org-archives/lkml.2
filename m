Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1G3PuK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 11:50:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48816 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1G3PuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 11:50:06 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1107282213000.31246@ionos>
References: <alpine.LFD.2.02.1107282213000.31246@ionos>
Date: Sat, 30 Jul 2011 17:49:32 +0200
X-Google-Sender-Auth: J3RkkQ02T3Lgbd8RJptx3hiw4no
Message-ID: <CANqCtQ+VhmfpNZ8Oh_0MR+bZfAeBuowBsK9TyC5iA4B2oLpXfg@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.0-rt6
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/7/28 Thomas Gleixner <tglx@linutronix.de>:
> Dear RT Folks,
>
> I'm pleased to announce the 3.0-rt6 release.
>
> Changes versus 3.0-rt4 (I pushed out a rt5 w/o announce)
>
>  * pin_cpu fix (Yong Zhang)
>
>  * Various compile fixes (Yong Zhang & myself)
>
>  * Serial fix for omap
>
>  * Clocksource lockless watchdog reset
>
>  * Reenabled CONFIG_RCU_BOOST (problem is unreproducible and maybe
>    related to NO_HZ, which is still disabled. Paul is working on it!)
>
>  * KGDB work^Whackaround (Jason Wessel)
>
>    The kgdb workaround is really a hack and wants to be replaced by a
>    proper overhaul for the console/tty maze.
>    See: kgb-serial-hackaround.patch
>
> As I said yesterday, I'm preparing for vanishing from the net.
>
> Please keep on testing and sending patches. Peter Zijlstra kindly
> volunteered to cover for me. He'll pick up stuff and eventually push
> out releases when a reasonable number of sane patches hits his inbox.

I got rt5 booting yesterday on a ARM core (Atmel AT91):
* LCD driver broken, booting stops during initialising driver (seems
to be broken in mainstream too)
* Strange issue with finding files in a directory. (currently checking
if it is RT-patch related.)
* Furthermore, the board feels slow... Can be perception only, need to
check it out...
* The patch (http://www.spinics.net/lists/arm-kernel/msg45022.html)
that solved the problem at https://lkml.org/lkml/2007/11/26/73 is no
longer part of the RT-patch. I Need to test if it is still needed...

Kind regards,

Remy
