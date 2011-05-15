Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1EOW5E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 18:57:04 -0400
Received: from solitude.tty.gr ([95.154.208.37]:36905 "EHLO mx.tty.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab1EOW5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 18:57:03 -0400
Date: Mon, 16 May 2011 01:56:54 +0300
From: Faidon Liambotis <paravoid@debian.org>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org, stable@kernel.org,
        seto.hidetoshi@jp.fujitsu.com,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg KH <greg@kroah.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Apollon Oikonomopoulos <apoikos@gmail.com>, chronidev@gmail.com
Subject: Re: 2.6.32.21 - uptime related crashes?
Message-ID: <20110515225653.GA17342@tty.gr>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
 <20110428183434.GG30645@1wt.eu>
 <20110429100200.GB23293@pcnci.linuxbox.cz>
 <20110430093605.GA10529@1wt.eu>
 <20110430173905.GA25641@tty.gr>
 <20110430201436.GF10529@1wt.eu>
 <20110514190423.GA2264@nik-comp.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110514190423.GA2264@nik-comp.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 09:04:23PM +0200, Nikola Ciprich wrote:
> Nicolas, thanks for further report, it contradicts my theory that
> problem occured somewhere during 2.6.32.16.  Now I think I know why
> several of my other machines running 2.6.32.x for long time didn't
> crashed:
> 
> I checked bugzilla entry for (I believe the same) problem here:
> https://bugzilla.kernel.org/show_bug.cgi?id=16991

I don't think that that bug is related, I for one haven't seen any
backtrace that is similar to the above or relevant to divide by zero.

> and Peter Zijlstra asked there, whether reporters systems were running
> some RT tasks. Then I realised that all of my four crashed boxes were
> pacemaker/corosync clusters and pacemaker uses lots of RT priority
> tasks. So I believe this is important, and might be reason why other
> machines seem to be running rock solid - they are not running any RT
> tasks.  It also might help with hunting this bug. Is somebody of You
> also running some RT priority tasks on inflicted systems, or problem
> also occured without it?

No, no RT tasks here. The boxes in my case were just running a lot of
kvm processes.

Regards,
Faidon
