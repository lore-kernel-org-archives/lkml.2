Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab0FAUot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:44:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28466 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab0FAUos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:44:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MREteMpCpBys6NgwMbzbOlZaPGqrjwf1/P0UBJxnriVMAGB5ksPss4yzSiwEXr3Pl
	WZ8R41jMUwdGBY2H/17/Q==
Date: Tue, 1 Jun 2010 13:44:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 5/5] oom: __oom_kill_task() must use find_lock_task_mm()
 too
In-Reply-To: <20100531183727.184F.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006011344120.13136@chino.kir.corp.google.com>
References: <20100531182526.1843.A69D9226@jp.fujitsu.com> <20100531183727.184F.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010, KOSAKI Motohiro wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Subject: [PATCH 5/5] oom: __oom_kill_task() must use find_lock_task_mm() too
> 
> __oom_kill_task also use find_lock_task_mm(). because if sysctl_oom_kill_allocating_task
> is true, __out_of_memory() don't call select_bad_process().
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

This code is removed as part of my oom killer rewrite as patch 12/18 "oom: 
remove unnecessary code and cleanup".
