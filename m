Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab1GLEV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 00:21:58 -0400
Received: from 1wt.eu ([62.212.114.60]:37524 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab1GLEV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 00:21:58 -0400
Date: Tue, 12 Jul 2011 06:19:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: "MINOURA Makoto / ?$BL'1: ?$B??" <minoura@valinux.co.jp>
Cc: john stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-ID: <20110712041938.GO27254@1wt.eu>
References: <20110428082625.GA23293@pcnci.linuxbox.cz> <20110428183434.GG30645@1wt.eu> <20110429100200.GB23293@pcnci.linuxbox.cz> <20110430093605.GA10529@1wt.eu> <20110430173905.GA25641@tty.gr> <BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com> <20110705231515.95bc758f.akpm@linux-foundation.org> <kk5d3hgi9eh.fsf@brer.local.valinux.co.jp> <1310434819.30337.21.camel@work-vm> <kk5aack8b6y.fsf@brer.local.valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kk5aack8b6y.fsf@brer.local.valinux.co.jp>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 11:49:57AM +0900, MINOURA Makoto / ?$BL'1: ?$B?? wrote:
> 
> |> In <1310434819.30337.21.camel@work-vm>
> |>  john stultz <johnstul@us.ibm.com> wrote:
> 
> > I'm working on a debug patch that will hopefully trip sched_clock
> > overflows very early to see if we can't shake these issues out.
> 
> Thanks. I hope that'll help.

That certainly will. What currently makes this bug hard to fix is that
it takes around 7 months to test a possible fix. We don't even know if
more recent kernels are affected, it's possible that 2.6.32-stable is
the only one that people don't reboot for an update in 7 months :-/

We need to make this bug more visible, so John's patch will be very
welcome !

Regards,
Willy

