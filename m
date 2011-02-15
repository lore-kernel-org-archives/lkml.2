Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1BOQxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:53:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49355 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab1BOQxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:53:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rihS6Yq+wL/Sa2rlOkLEHjVuuY7MihLXEo8sTAZQ5Vqu5rlEfjv4763Zyy35ZpZbEf
         hOymxsMPdi2s9PiKwLLVRbu7leWpC9nYwKaeuj+GFkwNC9aIu/+wZh1fMHzF0fTSd9Zh
         6vqWaNQgu02cgxinG7yTpZ4XE02ZGhQaMKAfU=
Date: Tue, 15 Feb 2011 17:53:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/14] [GIT PULL][v2.6.39] tracing/filter: More robust
 filtering
Message-ID: <20110215165302.GA2272@nowhere>
References: <20110208015617.902200587@goodmis.org>
 <20110215044425.GA9994@elte.hu>
 <1297776787.23343.104.camel@gandalf.stny.rr.com>
 <1297787362.23343.109.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297787362.23343.109.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 11:29:22AM -0500, Steven Rostedt wrote:
> On Tue, 2011-02-15 at 08:33 -0500, Steven Rostedt wrote:
> 
> > Thanks for letting me waste three days on developing this. I even posted
> > an RFC a while back, and no one complained then.
> 
> Sorry about being a bit bitchy in my reply here. I need to make a note
> not to reply to LKML before my first cup of coffee. ;)
> 
> Arnaldo,
> 
> Thanks for the post, I'll help you out where you need it. trace-cmd has
> some features that reports back to the user on failed filter usage. We
> can incorporate that into perf.

Cool!

That said I agree that we should not block improvements in the generic
filtering code because of issues in perf uses of filters.

I believe it used to work better in perf by the past, but I saw similar
issues lately like those Ingo noticed. So probably something
broke and we need to investigate. But until then your patches are
still nice improvements: lesser memory usage, lesser kernel stack usage in the
fast path, lesser limitation, faster and smarter filter evaluation...
