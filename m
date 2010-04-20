Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0DTQL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:11:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407Ab0DTQL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:11:57 -0400
Date: Tue, 20 Apr 2010 12:11:43 -0400
From: Don Zickus <dzickus@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, peterz@infradead.org,
       gorcunov@gmail.com, aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100420161143.GT15159@redhat.com>
References: <1271777043-3807-1-git-send-email-dzickus@redhat.com>
 <1271777043-3807-2-git-send-email-dzickus@redhat.com>
 <20100420085350.fce77f4f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420085350.fce77f4f.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 08:53:50AM -0700, Randy Dunlap wrote:
> On Tue, 20 Apr 2010 11:23:58 -0400 Don Zickus wrote:
> 
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 7331a16..98e3f5f 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -948,8 +948,11 @@ config PERF_USE_VMALLOC
> >  
> >  config PERF_EVENTS_NMI
> >  	bool
> > +	depends on PERF_EVENTS
> >  	help
> > -	  Arch has support for nmi_watchdog
> > +	  Arch can generate an NMI using the perf event subsystem
> 
> Hi Don,
> 
> I realize that you didn't introduce Arch in this help text,
> but can we eliminate him, please?  E.g.:

yup.

Thanks,
Don
