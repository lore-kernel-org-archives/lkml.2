Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab0ITVEC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:04:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52321 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160Ab0ITVEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:04:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Bug #17752] 2.6.36-rc3: inconsistent lock state (iprune_sem, shrink_icache_memory)
Date: Mon, 20 Sep 2010 23:03:04 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <1fwtoy8sG5H.A.veG.9D7lMB@chimera> <Wn2eLj_6KZG.A._MH.jE7lMB@chimera> <4C97C7EC.5070907@s5r6.in-berlin.de>
In-Reply-To: <4C97C7EC.5070907@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009202303.04793.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 20, 2010, Stefan Richter wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.35.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17752
> > Subject		: 2.6.36-rc3: inconsistent lock state (iprune_sem, shrink_icache_memory)
> > Submitter	: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > Date		: 2010-09-01 6:37 (20 days old)
> > Message-ID	: <tkrat.ed8eda6bc8ffe64e@s5r6.in-berlin.de>
> > References	: http://marc.info/?l=linux-kernel&m=128332308528119&w=2
> 
> I think this should not be marked as a regression.  See the older reports of
> very similar issues (in my LKML mail from September 3, logged in bugzilla in
> comment #1)
> 	http://lkml.org/lkml/2010/1/15/76	(2.6.33-rc, xfs involved)
> 	http://lkml.org/lkml/2010/1/18/108	(2.6.32.y, ntfs involved)
> and hch's analysis in the first of these two threads
> 	http://lkml.org/lkml/2010/1/19/267	(several filesystems and
> 						 other code paths)
> So, unless my trace was a code path that only newly acquired that oldproblem
> of other code paths, this is an older issue.  Alas this is not obvious to me
> at least from the log that I got.
> 
> I did not have lockdep enabled on the machine which delivered the log during
> the last few months or so; I just remembered to re-enable it at the occasion
> of switching to 2.6.36-rc.

Thanks a lot for the info, I've dropped this bug from the list of recent regressions.

Rafael
