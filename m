Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1GVMKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 08:10:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50712 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab1GVMKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 08:10:46 -0400
Date: Fri, 22 Jul 2011 14:09:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brian Marete <marete@toshnix.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] ftrace: Fix regression of :mod:module function
 enabling
Message-ID: <20110722120955.GA2672@elte.hu>
References: <tip-43dd61c9a09bd413e837df829e6bfb42159be52a@git.kernel.org>
 <CAHVUoiRsbOGbBVvzY8F2MY5TOVA=C6KLv3Wkbjs0HfYBnaMwzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHVUoiRsbOGbBVvzY8F2MY5TOVA=C6KLv3Wkbjs0HfYBnaMwzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brian Marete <marete@toshnix.com> wrote:

> On Sun, Jul 10, 2011 at 11:46 PM, tip-bot for Steven Rostedt
> <srostedt@redhat.com> wrote:
> > Commit-ID:  43dd61c9a09bd413e837df829e6bfb42159be52a
> > Gitweb:     http://git.kernel.org/tip/43dd61c9a09bd413e837df829e6bfb42159be52a
> > Author:     Steven Rostedt <srostedt@redhat.com>
> > AuthorDate: Thu, 7 Jul 2011 11:09:22 -0400
> > Committer:  Steven Rostedt <rostedt@goodmis.org>
> > CommitDate: Thu, 7 Jul 2011 11:30:08 -0400
> >
> 
> Hi,
> 
> Just a reminder - I don't believe this fix made it into 3.0.0.

No, it didn't make it, once it's upstream in the merge window we can 
forward it to -stable.

Thanks,

	Ingo
