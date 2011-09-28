Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab1I1Nzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:55:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50753 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1I1Nzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:55:32 -0400
Date: Wed, 28 Sep 2011 15:55:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, acme@redhat.com,
        eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, linux-kernel@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [PATCHv2 1/2] perf tools: Collect tracing event data files
 directly
Message-ID: <20110928135525.GS18553@somewhere>
References: <20110925133406.GB2702@jolsa.brq.redhat.com>
 <1317028312-5156-1-git-send-email-jolsa@redhat.com>
 <1317028312-5156-2-git-send-email-jolsa@redhat.com>
 <1317044192.26514.1.camel@gandalf.stny.rr.com>
 <20110926145606.GA8886@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110926145606.GA8886@jolsa.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 04:56:06PM +0200, Jiri Olsa wrote:
> On Mon, Sep 26, 2011 at 09:36:31AM -0400, Steven Rostedt wrote:
> > On Mon, 2011-09-26 at 11:11 +0200, Jiri Olsa wrote:
> > > Changing the way the event files are searched by quering specified
> > > event files directly, instead of walking the events directory.
> > > 
> > > Hopefully this way is more straightforward and faster.
> > 
> > Have you looked at my code I posted earlier that uses the libparsevents?
> > 
> > It uses globs such that you could do -e sched:sched* and it will enable
> > all sched events.
> 
> ops, haven't seen those changes yet..
> I think I can go only with 2/2 patch, if the 1/2 collides with your changes

But it seems Steve's patches are not completely uncontroversial because
of some crazy disagreements on where the libparsevent.so should lay (tools generic
or tied to perf).

So until we get that situation solved, we should continue to move forward.
