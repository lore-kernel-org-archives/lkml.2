Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab1CGVh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:37:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab1CGVh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:37:26 -0500
Date: Mon, 7 Mar 2011 16:37:16 -0500
From: Don Zickus <dzickus@redhat.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] watchdog, nmi:  Allow hardlockup to panic by default
Message-ID: <20110307213716.GT11359@redhat.com>
References: <1299184439-9215-1-git-send-email-dzickus@redhat.com>
 <4D717289.40403@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D717289.40403@fastmail.fm>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 11:15:21PM +0000, Jack Stone wrote:
> On 03/03/2011 20:33, Don Zickus wrote:
> > Add a Kconfig option to allow users to set the hardlockup to panic
> > by default.  Also add in a 'nmi_watchdog=nopanic' to override this.
> > 
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> >
> [snip]
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index 2b97418..80bd292 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -176,6 +176,23 @@ config HARDLOCKUP_DETECTOR
> >  	def_bool LOCKUP_DETECTOR && PERF_EVENTS && HAVE_PERF_EVENTS_NMI && \
> >  		 !ARCH_HAS_NMI_WATCHDOG
> >  
> > +config BOOTPARAM_HARDLOCKUP_PANIC
> > +	bool "Panic (Reboot) On Soft Lockups"
> 
> Did you mean Hard Lockups here?

Yes. Thanks! :-)

Cheers,
Don
