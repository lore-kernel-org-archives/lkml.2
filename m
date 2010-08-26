Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0HZPhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 11:37:05 -0400
Received: from xenotime.net ([72.52.115.56]:57711 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752658Ab0HZPhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 11:37:04 -0400
Date: Thu, 26 Aug 2010 08:36:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: piotr@hosowicz.com
Cc: Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
        Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Which kernel.org WWW is the master server?
Message-Id: <20100826083655.ebb019bd.rdunlap@xenotime.net>
In-Reply-To: <4C76862D.5050703@example.com>
References: <4C6D4864.2040002@example.com>
	<alpine.LRH.2.00.1008261536290.2372@twin.jikos.cz>
	<4C7683D3.5090500@nets.rwth-aachen.de>
	<4C76862D.5050703@example.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 17:20:13 +0200 Piotr Hosowicz wrote:

> On 26.08.2010 17:10, Arnd Hannemann wrote:
> > Am 26.08.2010 15:37, schrieb Jiri Kosina:
> >> On Thu, 19 Aug 2010, Piotr Hosowicz wrote:
> >>
> >>
> >>> I wrote a simple python script that tells me that a new kernel version
> >>> appeared. The problem is that it is based exactly on this what appears on the
> >>> webpage so sometimes it resolves the server IP that the version has changed,
> >>> despite the fact that it is not true. Which server is the master server?
> >>>
> >> I guess that simply running
> >>
> >> 	finger @kernel.org
> >>
> >> will give you exactly the information you are looking for which much less
> >> pain of connecting to www server, parsing html, etc.
> >>
> >
> > Not sure if this is still accurate:
> >
> >> Aug 21, 2003: Please don't use *finger.kernel.org* for any sort of
> >> automatic monitoring. The number of automatic bots hitting this port
> >> is causing the finger daemon to shut down more often than not. The
> >> same information is available from
> >> http://www.kernel.org/kdist/finger_banner
> >> <http://kernel.org/kdist/finger_banner>.
> 
> Moreover it is written as the above.

I have a script that reads finger_banner then adds mmotm & its base kernel tree,
& linux-next & its base kernel tree to the finger_banner.  (It was written
before finger_banner included linux-next info.)

Output today is:

The latest linux-next version of the Linux kernel is:         next-20100826
The latest snapshot 2.6 version of the Linux kernel is:       2.6.36-rc2-git4
The latest mainline 2.6 version of the Linux kernel is:       2.6.36-rc2
The latest stable 2.6.35 version of the Linux kernel is:      2.6.35.3  
The latest stable 2.6.34 version of the Linux kernel is:      2.6.34.5  
The latest stable 2.6.33 version of the Linux kernel is:      2.6.33.7  
The latest stable 2.6.32 version of the Linux kernel is:      2.6.32.20 
The latest stable 2.6.31 version of the Linux kernel is:      2.6.31.14 
The latest stable 2.6.27 version of the Linux kernel is:      2.6.27.52 
mmotm-2010-0811-1610 ... applies to: 2.6.35
next-20100826 ... applies to: v2.6.36-rc2


http://www.xenotime.net/linux/scripts/kcurrent

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
