Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab1JGWCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 18:02:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:44586 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1JGWCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 18:02:16 -0400
Date: Sat, 8 Oct 2011 00:02:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0.6-rt17
In-Reply-To: <4E8F58ED.9060702@localhost>
Message-ID: <alpine.LFD.2.02.1110080000400.3240@ionos>
References: <alpine.LFD.2.02.1110070046270.3240@ionos> <4E8F3605.6060104@localhost> <4E8F58ED.9060702@localhost>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Oct 2011, Fernando Lopez-Lezcano wrote:
> On 10/07/2011 10:25 AM, Fernando Lopez-Lezcano wrote:
> > On 10/06/2011 06:15 PM, Thomas Gleixner wrote:
> > > Dear RT Folks,
> > > 
> > > I'm pleased to announce the 3.0.6-rt17 release.
> > 
> > Hi and thanks again. So far this one is not hanging which is very good
> > news. But I still see the hrtimer_fixup_activate warnings I reported for
> > rt16...
> 
> I tried rt17 on my workstation and it froze after a few minutes (quad core
> intel based desktop). Reset button freeze. Then I set up my serial console and
> tried it out. I could not get it to freeze permanently but I got _many_
> hrtimer_fixup_activate warnings and while the console is sending those the
> gnome interface freezes (this is on fc14). So it is not very usable for
> debugging...
> 
> Just tried again after another reboot (@ 115200 baud) and it worked for a
> while. Then it started spewing messages again and it is again unusable. I'm
> attaching a trace of what was sent to the serial console while the machine
> froze temporarily.

Does adding nohz=off to the kernel commandline solve it?

You probably posted your .config before, but could you please send it
again (private mail is fine).

Thanks,

	tglx
