Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab0LWPJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 10:09:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57373 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0LWPJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 10:09:38 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=zstmFHb1TK0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=NpKYuIlD-FuZJRIY1M4A:9 a=48NQqajrJ9bbk2ocOC8A:7 a=8OZ00dB6lVxEFG46XmUGx8CixBAA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/4] plist: shrink struct plist_head
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4D12B04A.3030705@cn.fujitsu.com>
References: <4D107982.9090700@cn.fujitsu.com>
	 <4D12B04A.3030705@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Dec 2010 10:09:35 -0500
Message-ID: <1293116975.22802.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 10:13 +0800, Lai Jiangshan wrote:
> On 12/21/2010 05:55 PM, Lai Jiangshan wrote:
> > struct plist_head is big, and the field prio_list
> > in the struct plist_head is used seldom. So it can be
> > removed and we use the first plist_node's prio_list
> > when needed.
> > 
> > The size of struct plist_head is decreased a half after shinked.
> > The size of struct rtmutex and struct task_struct are
> > also decreased after struct plist_head shrinked.
> > 
> > Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> >  include/linux/plist.h |   47 ++++++++++++++++++++++---------------------
> >  lib/plist.c           |   54 ++++++++++++++++++++++++++++++++------------------
> >  2 files changed, 59 insertions(+), 42 deletions(-)
> > 
> 
> Hi, Ingo, Thomas, Steven,
> 
> Any comments about this patch?

Sorry, I've been trying to get a bunch done before the holiday break.
I'll try to see if I can look at this today. I'll be pushing out your
port of the rtmutex code today. Heh, I need to update it to your latest
changes :-)

Anyway, after today, I'm off till Jan 3rd, so anything not done today
will need to wait till then.

-- Steve


