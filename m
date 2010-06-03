Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab0FCWCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 18:02:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab0FCWCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 18:02:35 -0400
Date: Fri, 4 Jun 2010 00:01:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 08/12] oom: dump_tasks() use find_lock_task_mm() too
Message-ID: <20100603220103.GA8511@redhat.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com> <20100603152350.725F.A69D9226@jp.fujitsu.com> <20100603152652.GA8743@redhat.com> <alpine.DEB.2.00.1006031312130.10856@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1006031312130.10856@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, David Rientjes wrote:
>
> On Thu, 3 Jun 2010, Oleg Nesterov wrote:
>
> > (off-topic)
> >
> > out_of_memory() calls dump_header()->dump_tasks() lockless, we
> > need tasklist.

forgot to mention, __out_of_memory() too.

> Already fixed in my rewrite patchset, as most of these things are.  Sigh.

In 3/18, without any note in the changelog. Another minor thing
which can be fixed before rewrite.

And please note that it was me who pointed out we need tasklist
during the previous discussion. I'd suggest you to send a separate
patch on top of Kosaki's patches.

OK, this is boring ;) I am going to ignore everything except
technical issues in this thread.

Oleg.

