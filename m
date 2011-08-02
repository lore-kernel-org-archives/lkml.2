Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab1HBTtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 15:49:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986Ab1HBTs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 15:48:58 -0400
Date: Tue, 2 Aug 2011 15:48:55 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Francis Moreau <francis.moro@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v3.0: Weird kernel log message when resuming avout NMI received
Message-ID: <20110802194855.GA3593@redhat.com>
References: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com>
 <20110731110641.GG2209@sun>
 <4E353A41.2010405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E353A41.2010405@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 01:19:29PM +0200, Jiri Slaby wrote:
> On 07/31/2011 01:06 PM, Cyrill Gorcunov wrote:
> > On Sun, Jul 31, 2011 at 08:56:30AM +0200, Francis Moreau wrote:
> >> Hello,
> >>
> >> I'm seeing those kernel message when resuming:
> >>
> >> [  524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
> >> [  524.973288] Do you have a strange power saving mode enabled?
> >> [  524.973289] Dazed and confused, but trying to continue
> >>
> >> I don't know if it's important or not because the system seems to work
> >> after but maybe it worths to report
> >>
> > 
> > Hi Francis, cpu please?
> 
> Hi, I'm seeing those too. For a longer time though. Please see
> https://bugzilla.novell.com/show_bug.cgi?id=678882#c16

That is with 2.6.37.  Lots of watchdog/perf nmi fixes have been added
since then (though dmesg suggests the watchdog is disabled due to a broken
PMU).

I think for the Core iX family, 2.6.39 and higher have been stable.

Cheers,
Don
