Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab0KROiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:38:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39941 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758393Ab0KROiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:38:06 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=emhYPqQk1oIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=zSpnK0ahSeGKoZPnM38A:9 a=wEELbxF5wAtvL-cAuIeWeT0JHisA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [ANNOUNCE v2] ktest.pl: Easy and flexible testing script for
 Linux Kernel Developers (now with config bisect)
From: Steven Rostedt <rostedt@goodmis.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jon Masters <jcm@redhat.com>, corbet <corbet@lwn.net>,
        Jake Edge <jake@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>, lmr@redhat.com,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Clark Williams <williams@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <20101118142623.GB13933@redhat.com>
References: <1289259910.12418.77.camel@gandalf.stny.rr.com>
	 <1290089317.30543.114.camel@gandalf.stny.rr.com>
	 <20101118142623.GB13933@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Nov 2010 09:38:03 -0500
Message-ID: <1290091083.30543.125.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Finally remembered to remove that annoying autotest@test.kernel.org
  from the Cc list ]

On Thu, 2010-11-18 at 09:26 -0500, Vivek Goyal wrote:
> On Thu, Nov 18, 2010 at 09:08:37AM -0500, Steven Rostedt wrote:
> > Question:
> > 
> > Has anyone tried this out? Does anyone feel that I should get this ready
> > to be included in 2.6.38 tools directory?
> > 
> > Just want to know if I should go ahead and prepare it, or if it will
> > just be a waste of my time.
> 
> I had done some testing only on initial internal version but did not
> get a chance to do more testing later.
> 
> But I believe it is worth to put effort to keep this script going. I am
> especially interested in part where I can just automate compilation and
> testing of a patch on a remote machine.

Thanks for the reply! I'll start setting up a git tree that places all
the changes into the tools directory.

-- Steve


