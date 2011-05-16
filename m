Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab1EPHjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 03:39:40 -0400
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:55294 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1EPHji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 03:39:38 -0400
X-Greylist: delayed 2808 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 May 2011 03:39:38 EDT
Date: Mon, 16 May 2011 09:49:49 +0300
From: Apollon Oikonomopoulos <apoikos@gmail.com>
To: Faidon Liambotis <paravoid@debian.org>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        seto.hidetoshi@jp.fujitsu.com,
        =?utf-8?B?SGVydsOp?= Commowick <hcommowick@exosec.fr>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg KH <greg@kroah.com>,
        Ben Hutchings <ben@decadent.org.uk>, chronidev@gmail.com
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-ID: <20110516064949.GA6000@noc.grnet.gr>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
 <20110428183434.GG30645@1wt.eu>
 <20110429100200.GB23293@pcnci.linuxbox.cz>
 <20110430093605.GA10529@1wt.eu>
 <20110430173905.GA25641@tty.gr>
 <20110430201436.GF10529@1wt.eu>
 <20110514190423.GA2264@nik-comp.lan>
 <20110515225653.GA17342@tty.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Disposition: inline
In-Reply-To: <20110515225653.GA17342@tty.gr>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (ulysses.noc.ntua.gr [IPv6:2001:648:2000:de::230]); Mon, 16 May 2011 09:49:56 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On 01:56 Mon 16 May     , Faidon Liambotis wrote:
> > and Peter Zijlstra asked there, whether reporters systems were running
> > some RT tasks. Then I realised that all of my four crashed boxes were
> > pacemaker/corosync clusters and pacemaker uses lots of RT priority
> > tasks. So I believe this is important, and might be reason why other
> > machines seem to be running rock solid - they are not running any RT
> > tasks.  It also might help with hunting this bug. Is somebody of You
> > also running some RT priority tasks on inflicted systems, or problem
> > also occured without it?
> 
> No, no RT tasks here. The boxes in my case were just running a lot of
> kvm processes.

Actually we are running multipathd, which is an RT process and heavily loaded
on these particular systems.

Regards,
Apollon
