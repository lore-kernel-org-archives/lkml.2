Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1LULf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:35:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35340 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab1LULf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:35:56 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=IWQx1ipMXh4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=E1G3CSLJ3r7Dwg_cP4IA:9 a=mJ7r7bSqiBD-DcH-rBMA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324467354.5916.80.camel@gandalf.stny.rr.com>
Subject: Re: [PATCHv2 02/10] ftrace: Change mcount call replacement logic
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Wed, 21 Dec 2011 06:35:54 -0500
In-Reply-To: <1324467296.5916.79.camel@gandalf.stny.rr.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
	 <1323105776-26961-3-git-send-email-jolsa@redhat.com>
	 <1324409949.5916.78.camel@gandalf.stny.rr.com>
	 <20111221095703.GB1726@m.redhat.com>
	 <1324467296.5916.79.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 06:34 -0500, Steven Rostedt wrote:
> On Wed, 2011-12-21 at 10:57 +0100, Jiri Olsa wrote:
> > On Tue, Dec 20, 2011 at 02:39:09PM -0500, Steven Rostedt wrote:
> > > On Mon, 2011-12-05 at 18:22 +0100, Jiri Olsa wrote:
> > 
> > SNIP
> > 
> > >           <idle>-0     [001] ...1    13.258665: __schedule <-schedule
> > >           <idle>-0     [001] ...1    13.258665: add_preempt_count <-__schedule
> > >           <idle>-0     [001] ...2    13.258665: rcu_note_context_switch <-__schedule
> > >           <idle>-0     [001] ...2    13.258665: rcu_utilization: Start context switch
> > > 
> > > I'll put this to the front of my patch queue and also add it to urgent.
> > > I'll also rewrite your change log to remove the reference to the global
> > 
> > ok, I'll send new version without this one
> 
> No need, I've already queued it and will be the first patch in the
> patchset I send out soon.
> 

Or do you mean you'll send out a new patch series without this patch.

/me should not send email out when he first wakes up.

-- Steve


