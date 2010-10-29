Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab0J2DoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 23:44:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:46952 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277Ab0J2DoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 23:44:00 -0400
Date: Thu, 28 Oct 2010 20:41:42 -0700
From: Greg KH <gregkh@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jon Masters <jcm@redhat.com>, corbet <corbet@lwn.net>,
        Jake Edge <jake@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>, lmr@redhat.com,
        autotest@test.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [ANNOUNCE] ktest.pl: Easy and flexible testing script for
	Linux Kernel Developers
Message-ID: <20101029034142.GA12125@suse.de>
References: <1288294944.18238.346.camel@gandalf.stny.rr.com> <20101029002740.GA7688@suse.de> <1288321849.18238.395.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288321849.18238.395.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 11:10:49PM -0400, Steven Rostedt wrote:
> On Thu, 2010-10-28 at 17:27 -0700, Greg KH wrote:
> 
> > > Maybe this should go into the tools directory?
> > 
> > Yes please, I think that would be a great idea.
> 
> Should I try to get this into 2.6.37?  Since it is a stand alone tool, I
> can hardly expect that it would break anything else.

I don't see why not, but perhaps you might want to wait for people to
test it a bit?  Then get it into .38?

thanks,

greg k-h
