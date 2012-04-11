Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534Ab2DKP5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:57:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22525 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758277Ab2DKP5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:57:21 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=TWBfIqSxIMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pGLkceISAAAA:8 a=D19gQVrFAAAA:8 a=Db_W8k9CFCB-4gJVHfwA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334159837.23924.253.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, peterz@infradead.org, tglx@linutronix.de,
        mingo@redhat.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, Fabio Checconi <fchecconi@gmail.com>,
        Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>,
        Dhaval Giani <dhaval.giani@gmail.com>, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, Dario Faggioli <raistlin@linux.it>,
        Insop Song <insop.song@ericsson.com>, liming.wang@windriver.com
Date: Wed, 11 Apr 2012 11:57:17 -0400
In-Reply-To: <4F83EB49.3050100@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
	 <CAJd=RBBm8yDBrZFj48tP_5WsG=z0Rsv_=j=kArV1Mj6yJvQjVA@mail.gmail.com>
	 <4F7F285A.1010703@gmail.com>
	 <CAJd=RBC13JUuX0gtQidpNc=T+pnPgtKVQwRsP-mPQeiyfd9fPA@mail.gmail.com>
	 <4F81F2F1.8010105@gmail.com>
	 <CAJd=RBBDbqD5UwDwBsu9zMA2P4V2-m+v4QTN0An7KCSZZ=z+-A@mail.gmail.com>
	 <4F83EB49.3050100@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 10:11 +0200, Juri Lelli wrote:
> On 04/09/2012 02:28 PM, Hillf Danton wrote:
> > On Mon, Apr 9, 2012 at 4:20 AM, Juri Lelli<juri.lelli@gmail.com>  wrote:
> >>
> >> Do you mean at kernel_init time?
> >> Could you be more precise about the problem Steven encountered?
> >>
> > After change from kernel/sched_rt.c to kernel/sched/rt.c, I could not
> > find the git history of that fix, related to RCU IIRC, by Steven in mainline.
> > Steven, please give a link.
> >
> 
> Ok, found!
> https://lkml.org/lkml/2011/6/14/366
>   

I doubt you'll hit this same bug, but it doesn't hurt to add it. If a
boot time kernel thread starts using edf, then it would be required. And
you never know who may do that ;-)

-- Steve


