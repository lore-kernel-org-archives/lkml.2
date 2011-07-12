Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1GLCuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 22:50:00 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:42891 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab1GLCt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 22:49:59 -0400
To: john stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Willy Tarreau <w@1wt.eu>, Rand@jasper.es
Subject: Re: 2.6.32.21 - uptime related crashes?
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
	<20110428183434.GG30645@1wt.eu>
	<20110429100200.GB23293@pcnci.linuxbox.cz>
	<20110430093605.GA10529@1wt.eu> <20110430173905.GA25641@tty.gr>
	<BANLkTi=22QFrJ4vO7-3VuHU=9Cg39bxJ4Q@mail.gmail.com>
	<20110705231515.95bc758f.akpm@linux-foundation.org>
	<kk5d3hgi9eh.fsf@brer.local.valinux.co.jp>
	<1310434819.30337.21.camel@work-vm>
From: =?iso-2022-jp?B?TUlOT1VSQSBNYWtvdG8gLyAbJEJMJzE6GyhCIBskQj8/GyhC?= 
	<minoura@valinux.co.jp>
Date: Tue, 12 Jul 2011 11:49:57 +0900
In-Reply-To: <1310434819.30337.21.camel@work-vm> (john stultz's message of "Mon\, 11 Jul 2011 18\:40\:19 -0700")
Message-ID: <kk5aack8b6y.fsf@brer.local.valinux.co.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


|> In <1310434819.30337.21.camel@work-vm>
|>  john stultz <johnstul@us.ibm.com> wrote:

> I'm working on a debug patch that will hopefully trip sched_clock
> overflows very early to see if we can't shake these issues out.

Thanks. I hope that'll help.

-- 
Minoura Makoto <minoura@valinux.co.jp>
