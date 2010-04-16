Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441Ab0DPONN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:13:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757729Ab0DPONK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:13:10 -0400
Date: Fri, 16 Apr 2010 10:12:49 -0400
From: Don Zickus <dzickus@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, peterz@infradead.org,
       gorcunov@gmail.com, aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100416141249.GD15159@redhat.com>
References: <1271366710-17468-1-git-send-email-dzickus@redhat.com>
 <20100415153251.590c91ca.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415153251.590c91ca.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 03:32:51PM -0700, Randy Dunlap wrote:
> On Thu, 15 Apr 2010 17:25:10 -0400 Don Zickus wrote:
> 
> >  arch/x86/kernel/apic/hw_nmi.c |    2 +-
> >  include/linux/sched.h         |    6 +
> >  init/Kconfig                  |    1 +
> >  kernel/Makefile               |    4 +-
> >  kernel/sysctl.c               |    9 +
> >  kernel/watchdog.c             |  570 +++++++++++++++++++++++++++++++++++++++++
> >  lib/Kconfig.debug             |   21 +-
> >  7 files changed, 605 insertions(+), 8 deletions(-)
> >  create mode 100644 kernel/watchdog.c
> 
> Updates to Documentation/kernel-parameters.txt ??

Thanks for the comments, will try to get them added in the next spin.

Cheers,
Don
