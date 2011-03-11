Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab1CKAoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:44:18 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:38897 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752732Ab1CKAoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:44:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BFO9XT0rmLdquOz5N3ve6dZN1clkJOUaFGJHk8BRl9zjf4lVfkJ5rMJ8R4S8wuN58oE41c5tac4cc5CBUZvxznjwbU9zVMBeJcwRlBtzeFUcDNRDyLAw3sR91URIDiXV;
Date: Thu, 10 Mar 2011 16:44:14 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] kbuild: reenable section mismatch analysis
Message-Id: <20110310164414.2892219e.rdunlap@xenotime.net>
In-Reply-To: <20110310164100.5af81e3b.akpm@linux-foundation.org>
References: <20110216200734.GA25184@merkur.ravnborg.org>
	<1298062040-2774-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<20110310164100.5af81e3b.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 16:41:00 -0800 Andrew Morton wrote:

> On Fri, 18 Feb 2011 21:47:20 +0100
> Uwe Kleine-K__nig  <u.kleine-koenig@pengutronix.de> wrote:
> 
> > This was disabled in commit
> > 
> > 	e5f95c8 (kbuild: print only total number of section mismatces found)
> > 
> > because there were too many warnings.  Now we're down to a reasonable
> > number again, so we start scaring people with the details.
> > 
> > Signed-off-by: Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de>
> > ---
> >  lib/Kconfig.debug |    4 ----
> >  1 files changed, 0 insertions(+), 4 deletions(-)
> > 
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index 2b97418..0f77ed1 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -102,11 +102,7 @@ config HEADERS_CHECK
> >  
> >  config DEBUG_SECTION_MISMATCH
> >  	bool "Enable full Section mismatch analysis"
> > -	depends on UNDEFINED || (BLACKFIN)
> >  	default y
> > -	# This option is on purpose disabled for now.
> > -	# It will be enabled when we are down to a reasonable number
> > -	# of section mismatch warnings (< 10 for an allyesconfig build)
> >  	help
> >  	  The section mismatch analysis checks if there are illegal
> >  	  references from one section to another section.
> 
> eaaaargh!  650 lines of crap added to my i386 allmodconfig build output.

Each message is a bit longish, yes.

> I'll be locally opting out of this one, thanks.
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
