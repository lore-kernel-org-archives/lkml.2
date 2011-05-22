Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1EVMHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 08:07:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48796 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab1EVMHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 08:07:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VzO2I09cHkmAyWmjQ2X3NNNQ2T012dvA/mUGkFYmjq9lGhpTLpIx+zkCy4F/JtoGwv
         8Pp0MI6zZx5bIYZrZilYaJ8BNlZ3cZatzfTA4gZgyQh96+ipcQvsubskohFbMT+QqANw
         KfJAFP7ktqyxMPBiSbjS3b4pxKkliuo24grjc=
Date: Sun, 22 May 2011 14:07:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] perf tools updates
Message-ID: <20110522120731.GA1728@nowhere>
References: <1306028744-10603-1-git-send-email-fweisbec@gmail.com>
 <20110522084934.GB27167@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110522084934.GB27167@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 10:49:34AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Ingo, Arnaldo,
> > 
> > Please pull the perf/core branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	perf/core
> > 
> > Thanks,
> > 	Frederic
> > ---
> > 
> > Frederic Weisbecker (6):
> >       perf tools: Check we are able to read the event size on mmap
> >       perf tools: Remove junk code in mmap size handling
> >       perf tools: Move evlist sample helpers to evlist area
> >       perf tools: Pre-check sample size before parsing
> >       perf tools: Robustify dynamic sample content fetch
> >       perf tools: Propagate event parse error handling
> > 
> > 
> >  tools/perf/builtin-test.c |    9 ++++++++-
> >  tools/perf/builtin-top.c  |    7 ++++++-
> >  tools/perf/util/event.c   |   16 ++++++++++++++++
> >  tools/perf/util/event.h   |   12 +++++++++++-
> >  tools/perf/util/evlist.c  |   31 +++++++++++++++++++++++++++++++
> >  tools/perf/util/evlist.h  |    3 +++
> >  tools/perf/util/evsel.c   |   32 +++++++++++++++++++++++++++++++-
> >  tools/perf/util/header.c  |   31 -------------------------------
> >  tools/perf/util/header.h  |    2 --
> >  tools/perf/util/python.c  |   13 ++++++++++---
> >  tools/perf/util/session.c |   25 ++++++++++++++++++-------
> >  tools/perf/util/session.h |    2 ++
> >  12 files changed, 136 insertions(+), 47 deletions(-)
> 
> To get this upstream ASAP i pulled them into perf/urgent and resolved two 
> conflicts there (a contextual and a semantic one) - please double check my 
> resolutions.

Yeah looks good.

Thanks!
