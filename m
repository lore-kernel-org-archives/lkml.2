Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1FGPQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:16:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:56934 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab1FGPQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:16:10 -0400
Date: Tue, 7 Jun 2011 17:15:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Remy Bohmer <linux@bohmer.net>, Armin Steinhoff <armin@steinhoff.de>,
        Johannes Bauer <hannes_bauer@aon.at>,
        Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Changing Kernel thread priorities
In-Reply-To: <1307456080.2322.264.camel@twins>
Message-ID: <alpine.LFD.2.02.1106071713570.11814@ionos>
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at>  <alpine.LFD.2.02.1106071033350.11814@ionos> <4DEDF1F2.2080204@steinhoff.de>  <1307439469.2322.235.camel@twins>  <BANLkTi=KPyds_BWYpXHeUkAg000FGSuJOQ@mail.gmail.com>
 <1307456080.2322.264.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011, Peter Zijlstra wrote:
> On Tue, 2011-06-07 at 13:02 +0200, Remy Bohmer wrote:
> > Well, I 100% agree that it must be under full userspace control to be
> > able to set the priorities. But, the kernel default assumption of
> > starting everything at 50 is wrong as well.
> > Imagine the following situation:
> > * Realtime application is running and has threads active in the range
> > of prios 20 - 90.
> > * Now bring up a network device, it immediately starts spamming the
> > system at prio 50 _before_ you have the chance to set it below 20 by
> > means of chrt.
> > * RT behaviour is gone!
> 
> Good point I guess, Thomas should we default to 1 for everything?

No objections.
