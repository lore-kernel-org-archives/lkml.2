Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1HCAwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 20:52:33 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:43615 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab1HCAw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 20:52:28 -0400
Date: Tue, 2 Aug 2011 20:52:24 -0400 (EDT)
From: Donald Zickus II <dzickus@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Francis Moreau <francis.moro@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <1747228315.594236.1312332744394.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4E386588.8060503@gmail.com>
Subject: Re: v3.0: Weird kernel log message when resuming avout NMI received
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> On 08/02/2011 09:48 PM, Don Zickus wrote:
> > On Sun, Jul 31, 2011 at 01:19:29PM +0200, Jiri Slaby wrote:
> >> On 07/31/2011 01:06 PM, Cyrill Gorcunov wrote:
> >>> On Sun, Jul 31, 2011 at 08:56:30AM +0200, Francis Moreau wrote:
> >>>> Hello,
> >>>>
> >>>> I'm seeing those kernel message when resuming:
> >>>>
> >>>> [ 524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
> >>>> [ 524.973288] Do you have a strange power saving mode enabled?
> >>>> [ 524.973289] Dazed and confused, but trying to continue
> >>>>
> >>>> I don't know if it's important or not because the system seems to
> >>>> work
> >>>> after but maybe it worths to report
> >>>>
> >>>
> >>> Hi Francis, cpu please?
> >>
> >> Hi, I'm seeing those too. For a longer time though. Please see
> >> https://bugzilla.novell.com/show_bug.cgi?id=678882#c16
> >
> > That is with 2.6.37. Lots of watchdog/perf nmi fixes have been added
> > since then (though dmesg suggests the watchdog is disabled due to a
> > broken
> > PMU).
> 
> No, comment 16 (the link above) is about 3.0.

Hi Jiri,

My apologies.  I see a bugzilla and just scroll to the top, habit I guess.  It seems like Peter has a fix already.  Hopefully it works.

Cheers,
Don
