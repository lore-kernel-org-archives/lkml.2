Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab1CRS7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:59:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888Ab1CRS7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:59:07 -0400
Date: Fri, 18 Mar 2011 14:58:08 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        jwjstone@fastmail.fm, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] watchdog, nmi:  Allow hardlockup to panic by
 default
Message-ID: <20110318185808.GA12142@redhat.com>
References: <1299533860-1642-1-git-send-email-dzickus@redhat.com>
 <20110317185013.7c8be1e0.akpm@linux-foundation.org>
 <20110318171932.GH2743@redhat.com>
 <20110318112353.66ce884b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318112353.66ce884b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 11:23:53AM -0700, Andrew Morton wrote:
> > 
> > 
> > > 
> > > >  static int __init hardlockup_panic_setup(char *str)
> > > >  {
> > > >  	if (!strncmp(str, "panic", 5))
> > > >  		hardlockup_panic = 1;
> > > > +	else if (!strncmp(str, "nopanic", 5))
> > > 
> > > s/5/7/
> > 
> > doh.
> > 
> > I can send a refreshed patch with the above changes.
> 
> I fixed that up.

Thanks!

Cheers,
Don

