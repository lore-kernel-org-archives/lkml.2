Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab0IHP6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:58:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46926 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab0IHP6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:58:39 -0400
Subject: Re: [GIT pull] Preparatory patch for semaphore cleanup
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100908155604.GA18064@elte.hu>
References: <alpine.LFD.2.00.1009081507250.2477@localhost6.localdomain6>
	 <AANLkTikYEjV8ikkPsfJ0d7WsikWHJ0n74u9uDS4uGHC+@mail.gmail.com>
	 <1283957961.23762.28.camel@laptop>  <20100908155604.GA18064@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Sep 2010 17:58:24 +0200
Message-ID: <1283961504.23762.34.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-08 at 17:56 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2010-09-08 at 07:54 -0700, Linus Torvalds wrote:
> > > On Wed, Sep 8, 2010 at 6:11 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > >
> > > > This patch just provides the DEFINE_SEMAPHORE macro which is required
> > > > for the various subsystem cleanups I sent out, so we can finally get
> > > > rid of init_MUTEX[_LOCKED] in 2.6.37.
> > > 
> > > Why is it called DEFINE_SEMAPHORE(), when two lines later the we have
> > > DECLARE_MUTEX()?
> > > 
> > > IOW, the whole DEFINE vs DECLARE thing seems confused. I'm not saying
> > > one is better than the other (maybe "define" is), but the mixing of
> > > names is worse than either, I feel..
> > 
> > The rest of the series, that Thomas didn't include in this pull, removes
> > all the DECLARE_MUTEX() users. So its temporary awkward-ness.
> 
> and DEFINE_MUTEX() is needed upstream so that we can spread those 

s/DEFINE_MUTEX/DEFINE_SEMAPHORE/

> patches into a dozen maintainer trees. Once those flow upstream 
> DECLARE_MUTEX() will be removed.


