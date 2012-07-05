Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072Ab2GENhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:37:55 -0400
Received: from plane.gmane.org ([80.91.229.3]:53047 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab2GENhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:37:53 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [Patch] mm/policy: use int instead of unsigned for nid
Date: Thu, 5 Jul 2012 13:37:31 +0000 (UTC)
Message-ID: <jt45ar$lq0$3@dough.gmane.org>
References: <1341370901-14187-1-git-send-email-amwang@redhat.com>
 <alpine.DEB.2.00.1207032342120.32556@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 117.57.98.8
User-Agent: slrn/0.9.9p1 (Linux)
Cc: linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jul 2012 at 06:43 GMT, David Rientjes <rientjes@google.com> wrote:
> On Wed, 4 Jul 2012, Cong Wang wrote:
>
>> From: WANG Cong <xiyou.wangcong@gmail.com>
>> 
>> 'nid' should be 'int', not 'unsigned'.
>> 
>
> unsigned is already of type int, so you're saying these occurrences should 
> become signed, but that's not true since they never return NUMA_NO_NODE.  
> They are all safe returning unsigned.
>

Yeah, I knew, just thought using 'int' is consistent, this is a
trivial patch, not a bugfix.

> And alloc_page_interleave() doesn't exist anymore since the sched/numa 
> bits were merged into sched/core, so nobody could apply this patch anyway.

Ah, I made this patch against linus tree...

