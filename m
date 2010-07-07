Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab0GGToK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 15:44:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:47950 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab0GGToI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 15:44:08 -0400
Subject: Re: [PATCH 2/2] sched: make sched_param arugment static variables
 in some sched_setscheduler() caller
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rostedt@goodmis.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       James Morris <jmorris@namei.org>
In-Reply-To: <20100706170220.f3219001.akpm@linux-foundation.org>
References: <20100702144941.8fa101c3.akpm@linux-foundation.org>
	 <20100706091607.CCCC.A69D9226@jp.fujitsu.com>
	 <20100706095013.CCD9.A69D9226@jp.fujitsu.com>
	 <1278454438.1537.54.camel@gandalf.stny.rr.com>
	 <20100706161253.79bfb761.akpm@linux-foundation.org>
	 <1278460187.1537.107.camel@gandalf.stny.rr.com>
	 <20100706170220.f3219001.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 07 Jul 2010 21:43:46 +0200
Message-ID: <1278531826.1946.117.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-06 at 17:02 -0700, Andrew Morton wrote:
> > Well this is also the way sched.c adds all its extra code.
> 
> The sched.c hack sucks too. 

Agreed, moving things to kernel/sched/ and adding some internal.h thing
could cure that, but I simply haven't gotten around to cleaning that
up..
