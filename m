Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab1ENUqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 16:46:52 -0400
Received: from 1wt.eu ([62.212.114.60]:36209 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab1ENUqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 16:46:51 -0400
Date: Sat, 14 May 2011 22:45:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg KH <greg@kroah.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Apollon Oikonomopoulos <apoikos@gmail.com>, chronidev@gmail.com
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-ID: <20110514204536.GA16496@1wt.eu>
References: <20110428082625.GA23293@pcnci.linuxbox.cz> <20110428183434.GG30645@1wt.eu> <20110429100200.GB23293@pcnci.linuxbox.cz> <20110430093605.GA10529@1wt.eu> <20110430173905.GA25641@tty.gr> <20110430201436.GF10529@1wt.eu> <20110514190423.GA2264@nik-comp.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110514190423.GA2264@nik-comp.lan>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, May 14, 2011 at 09:04:23PM +0200, Nikola Ciprich wrote:
> Hello gentlemans,
> Nicolas, thanks for further report, it contradicts my theory that problem occured somewhere during 2.6.32.16.

Well, I'd like to be sure what kernel we're talking about. Nicolas said
"2.6.32.8 Debian Kernel", but I suspect it's "2.6.32-8something" instead.
Nicolas, could you please report the exact version as indicated by "uname -a" ?

> Now I think I know why several of my other machines running 2.6.32.x for long time didn't crashed:
> 
> I checked bugzilla entry for (I believe the same) problem here:
> https://bugzilla.kernel.org/show_bug.cgi?id=16991
> and Peter Zijlstra asked there, whether reporters systems were running some RT tasks. Then I realised that all of my four crashed boxes were pacemaker/corosync clusters and pacemaker uses lots of RT priority tasks. So I believe this is important, and might be reason why other machines seem to be running rock solid - they are not running any RT tasks.
> It also might help with hunting this bug. Is somebody of You also running some RT priority tasks on inflicted systems, or problem also occured without it?

No, our customer who had two of these boxes crash at the same time was
not running any RT task to the best of my knowledge.

Cheers,
Willy

