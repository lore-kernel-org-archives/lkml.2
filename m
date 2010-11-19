Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab0KSUZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 15:25:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38091 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797Ab0KSUZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 15:25:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [Bug #21332] Regression in single stepping over hardware breakpoint (Wine)
Date: Fri, 19 Nov 2010 21:24:52 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Michael Stefaniuc <mstefani@redhat.com>
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera> <t78YtCSuOqN.A.gEG.I4b5MB@chimera> <20101119145651.GB5558@nowhere>
In-Reply-To: <20101119145651.GB5558@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011192124.52423.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 19, 2010, Frederic Weisbecker wrote:
> On Fri, Nov 19, 2010 at 12:53:38AM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.35 and 2.6.36.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=21332
> > Subject		: Regression in single stepping over hardware breakpoint (Wine)
> > Submitter	: Michael Stefaniuc <mstefani@redhat.com>
> > Date		: 2010-10-27 23:41 (23 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/0c4519e825c9e2b6a8310deff8582f8c35bfbba9
> 
> 
> The fix is in:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> 	perf/urgent
> 
> 6c0aca288e726405b01dacb12cac556454d34b2a
> ("x86: Ignore trap bits on single step exceptions")
> 
> And should reach mainline soon.

OK, status updated.

Thanks,
Rafael
