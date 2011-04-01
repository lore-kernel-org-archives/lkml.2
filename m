Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab1DAPUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:20:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab1DAPUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:20:35 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=esbOCb5XK58A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=Nx3cEeQ_6quQnEfi0vIA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/4] [GIT PULL] jump label: Cleanups for 2.6.39
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, jbaron@redhat.com
In-Reply-To: <20110401143202.GA1910@jolsa.brq.redhat.com>
References: <20110317164148.550876008@goodmis.org>
	 <20110401143202.GA1910@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Apr 2011 11:20:31 -0400
Message-ID: <1301671231.2160.24.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 16:32 +0200, Jiri Olsa wrote:
> On Thu, Mar 17, 2011 at 12:41:48PM -0400, Steven Rostedt wrote:
> > 
> > Ingo,
> > 
> > Please pull the latest tip/perf/urgent tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > tip/perf/urgent
> 
> hi,
> 
> I have a change to use batch update for jump label key's entries.
> 
> I wanted to rebase it to latest Jason's changes, but I dont see them
> in the mentioned git tree and branch.. not sure what I missed.
> 
> also, any idea when this could get in?

Yes, I still need to rebase these for 2.6.39+. I've been sucked into my
real job for a little bit, but when I get a chance, I'll push these out.
I'll have them out by Monday.

Thanks,

-- Steve


