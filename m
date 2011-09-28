Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1I1ODM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:03:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60060 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1I1ODK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:03:10 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=v1jNb7L17ooA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=n1lGCwRylf3qCRMiUyAA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCHv2 1/2] perf tools: Collect tracing event data files
 directly
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, eric.dumazet@gmail.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org, nhorman@tuxdriver.com
Date: Wed, 28 Sep 2011 10:03:08 -0400
In-Reply-To: <20110928135525.GS18553@somewhere>
References: <20110925133406.GB2702@jolsa.brq.redhat.com>
	 <1317028312-5156-1-git-send-email-jolsa@redhat.com>
	 <1317028312-5156-2-git-send-email-jolsa@redhat.com>
	 <1317044192.26514.1.camel@gandalf.stny.rr.com>
	 <20110926145606.GA8886@jolsa.brq.redhat.com>
	 <20110928135525.GS18553@somewhere>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317218589.4588.4.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 15:55 +0200, Frederic Weisbecker wrote:
> On Mon, Sep 26, 2011 at 04:56:06PM +0200, Jiri Olsa wrote:
> > On Mon, Sep 26, 2011 at 09:36:31AM -0400, Steven Rostedt wrote:
> > > On Mon, 2011-09-26 at 11:11 +0200, Jiri Olsa wrote:
> > > > Changing the way the event files are searched by quering specified
> > > > event files directly, instead of walking the events directory.
> > > > 
> > > > Hopefully this way is more straightforward and faster.
> > > 
> > > Have you looked at my code I posted earlier that uses the libparsevents?
> > > 
> > > It uses globs such that you could do -e sched:sched* and it will enable
> > > all sched events.
> > 
> > ops, haven't seen those changes yet..
> > I think I can go only with 2/2 patch, if the 1/2 collides with your changes
> 
> But it seems Steve's patches are not completely uncontroversial because
> of some crazy disagreements on where the libparsevent.so should lay (tools generic
> or tied to perf).

Which to me seems to be a silly road block, in which I never got a clear
answer for.

> 
> So until we get that situation solved, we should continue to move forward.

Sure, but it just forks the code even more, and it's almost to the point
where maintaining a fork will just be easier, not to mention quicker to
get out to the distros.

-- Steve



