Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab0CQJvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:51:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57824 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab0CQJvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:51:00 -0400
Date: Wed, 17 Mar 2010 10:50:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to lock
Message-ID: <20100317095038.GC17146@elte.hu>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <20100317014755.GC5258@nowhere>
 <4BA085DE.40604@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA085DE.40604@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> On 03/17/10 10:47, Frederic Weisbecker wrote:
> > On Sun, Mar 14, 2010 at 07:38:37PM +0900, Hitoshi Mitake wrote:
> >> I implemented it on the branch perf/inject of Frederic's
> random-tracing tree.
> >> Because the branch is hottest place of lock and tracing :)
> >
> >
> > Ouch! You shouldn't do this. The patches inside were
> > trials submitted for review and the resulting discussion
> > concluded that the injection must be redesigned.
> 
> Oh, sorry...
> And I'd like to look at redesigning way of inject.
> 
> >
> > More generally I don't recommend you to base your patches
> > on my tree. I use it as a buffer when I send patches
> > for review or for pull requests.
> >
> > The branches inside can be randomly rebased (unless a
> > branch is waiting to be pulled) and they are pretty async
> > with the -tip tree.
> >
> > The hottest and most sync tree on which you should base your patches
> > for perf is:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> > 	perf/core
> >
> > With that you have best chances to work on a sane and up-to-date
> > base.
> >
> > Thanks.
> >
> >
> 
> I'll work on tip/perf/core from next time :)

You can also use tip:master for convenience - especially for RFC patches. That 
way you will have the latest and greatest (and tested) branches combined :)

	Ingo
