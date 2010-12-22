Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab0LVSCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 13:02:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab0LVSC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 13:02:29 -0500
Date: Wed, 22 Dec 2010 19:02:28 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hrtimer: fix a typo in comment
In-Reply-To: <1291785527.1672.4.camel@leonhard>
Message-ID: <alpine.LNX.2.00.1012221902110.16569@pobox.suse.cz>
References: <1291784991-5047-1-git-send-email-namhyung@gmail.com> <1291785527.1672.4.camel@leonhard>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010, Namhyung Kim wrote:

> Oops. I forgot CC-ing to trivial.
> 
> 
> 2010-12-08 (수), 14:09 +0900, Namhyung Kim:
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > ---
> >  kernel/hrtimer.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> > index 72206cf..66163df 100644
> > --- a/kernel/hrtimer.c
> > +++ b/kernel/hrtimer.c
> > @@ -1774,7 +1774,7 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
> >  	}
> >  
> >  	/*
> > -	 * A NULL parameter means "inifinte"
> > +	 * A NULL parameter means "infinite"
> >  	 */
> >  	if (!expires) {
> >  		schedule();

Doesn't seem to be in linux-next as of today. Applied now.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
