Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab1LULlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:41:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab1LULlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:41:07 -0500
Date: Wed, 21 Dec 2011 12:40:44 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCHv2 02/10] ftrace: Change mcount call replacement logic
Message-ID: <20111221114044.GA2901@m.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
 <1323105776-26961-3-git-send-email-jolsa@redhat.com>
 <1324409949.5916.78.camel@gandalf.stny.rr.com>
 <20111221095703.GB1726@m.redhat.com>
 <1324467296.5916.79.camel@gandalf.stny.rr.com>
 <1324467354.5916.80.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324467354.5916.80.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 06:35:54AM -0500, Steven Rostedt wrote:
> On Wed, 2011-12-21 at 06:34 -0500, Steven Rostedt wrote:
> > On Wed, 2011-12-21 at 10:57 +0100, Jiri Olsa wrote:
> > > On Tue, Dec 20, 2011 at 02:39:09PM -0500, Steven Rostedt wrote:
> > > > On Mon, 2011-12-05 at 18:22 +0100, Jiri Olsa wrote:
> > > 
> > > SNIP
> > > 
> > > >           <idle>-0     [001] ...1    13.258665: __schedule <-schedule
> > > >           <idle>-0     [001] ...1    13.258665: add_preempt_count <-__schedule
> > > >           <idle>-0     [001] ...2    13.258665: rcu_note_context_switch <-__schedule
> > > >           <idle>-0     [001] ...2    13.258665: rcu_utilization: Start context switch
> > > > 
> > > > I'll put this to the front of my patch queue and also add it to urgent.
> > > > I'll also rewrite your change log to remove the reference to the global
> > > 
> > > ok, I'll send new version without this one
> > 
> > No need, I've already queued it and will be the first patch in the
> > patchset I send out soon.
> > 
> 
> Or do you mean you'll send out a new patch series without this patch.

yep :)

> 
> /me should not send email out when he first wakes up.
> 
> -- Steve
> 
> 
