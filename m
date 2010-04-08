Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab0DHT6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:58:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40892 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933150Ab0DHT6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:58:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [Bug #15624] [BUG] percpu misaligned allocation
Date: Thu, 8 Apr 2010 22:02:06 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera> <JVS2s9dmTsP.A.mnH.stPvLB@chimera> <20100407215926.GA10002@nowhere>
In-Reply-To: <20100407215926.GA10002@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004082202.06306.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 April 2010, Frederic Weisbecker wrote:
> On Wed, Apr 07, 2010 at 11:13:49PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.33.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15624
> > Subject		: [BUG] percpu misaligned allocation
> > Submitter	: Frederic Weisbecker <fweisbec@gmail.com>
> > Date		: 2010-03-18 4:49 (21 days old)
> > Message-ID	: <20100318044930.GC5045@nowhere>
> > References	: http://marc.info/?l=linux-kernel&m=126888780031992&w=2
> 
> 
> This has been fixed with "eb1e79611cc9bfe21978230e3521e77ea2d7874a"
> (perf: Correctly align perf event tracing buffer).
> 
> The ticket can be closed, thanks!

Thanks, closing.

Rafael
