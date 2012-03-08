Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab2CHUe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:34:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31292 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab2CHUe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:34:26 -0500
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=HIWqMhtmd3UA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=vawYcNCNRCoAxZilFXkA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331238865.25686.474.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH-RT] preempt.h: Fix implicit declaration of
 'preempt_check_resched_rt'
From: Steven Rostedt <rostedt@goodmis.org>
To: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        rt-users <linux-rt-users@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Date: Thu, 08 Mar 2012 15:34:25 -0500
In-Reply-To: <20120308142257.145e0968@redhat.com>
References: <1331237591-4406-1-git-send-email-jkacur@redhat.com>
	 <1331237840.25686.470.camel@gandalf.stny.rr.com>
	 <20120308142257.145e0968@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 14:22 -0600, Clark Williams wrote:
> On Thu, 08 Mar 2012 15:17:20 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Thu, 2012-03-08 at 21:13 +0100, John Kacur wrote:
> > > When building a non-preempt kernel where CONFIG_PREEMPT_COUNT is not
> > > defined the following build break occurs.
> > > 
> > > /home/jkacur/linux-rt/block/blk-softirq.c: In function ‘trigger_softirq’:
> > > /home/jkacur/linux-rt/block/blk-softirq.c:54: error: implicit declaration of function ‘preempt_check_resched_rt’
> > > make[2]: *** [block/blk-softirq.o] Error 1
> > > make[1]: *** [block/blk-softirq.o] Error 2
> > > make: *** [sub-make] Error 2
> > > 
> > > This patch fixes the build error by adding a define to the
> > > !CONFIG_PREEMPT_COUNT section.
> > > 
> > > Signed-off-by: Clark Williams <williams@redhat.com>
> > 
> > Why Clark's SOB? Did he write it and send it to you?
> 
> I suppose to be technically correct it should have been a Tested-by:
> 
> John found it while I was working on it and I tested it for him.

Either a "Reported-by" if you mentioned it to John and he fixed it, or a
"Tested-by" if he fixed it and you tested it. You can have both if that
is true too.

But "Signed-off-by" has supposed legal significance. It means that you
are responsible for this patch. Either you authored it, or it went
through you to get to the git repo (ie. you are the maintainer that took
the patch).

All other tags are FYI only. Only the SOB is required and has real
meaning. Also, you should *never* add a SOB to a patch without the
person explicitly giving it to you.

-- Steve


