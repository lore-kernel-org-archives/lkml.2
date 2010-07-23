Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab0GWT5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 15:57:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53687 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258Ab0GWT5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:57:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug #16348] kswapd continuously active when doing IO
Date: Fri, 23 Jul 2010 21:55:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Marius Tolzmann <tolzmann@molgen.mpg.de>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera> <PRbv8sgxY6G.A.NWF.-UYSMB@chimera> <20100723134525.GC7362@dastard>
In-Reply-To: <20100723134525.GC7362@dastard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007232155.55588.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 23, 2010, Dave Chinner wrote:
> On Fri, Jul 23, 2010 at 02:15:54PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.33 and 2.6.34.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16348
> > Subject		: kswapd continuously active when doing IO
> > Submitter	: Marius Tolzmann <tolzmann@molgen.mpg.de>
> > Date		: 2010-07-07 10:58 (17 days old)
> 
> The fix for this is already in 2.6.36-rc6.

Thanks, closing.

Rafael
