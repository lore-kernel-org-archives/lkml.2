Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab0FCGhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:37:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:14935 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933338Ab0FCGhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:37:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Afh8yf6Z1GtrrsMhrgRVKqRRfjIGwSstGAh6soYsjxa/pCTCebcEeXBNOH/B85MlU
	Rd/YC5ar7XxSjdXE6N2qQ==
Date: Wed, 2 Jun 2010 23:37:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 06/12] oom: remove warning for in mm-less task
 __oom_kill_process()
In-Reply-To: <20100603145330.7259.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006022336440.22441@chino.kir.corp.google.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com> <20100603145330.7259.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010, KOSAKI Motohiro wrote:

> If the race of mm detach in task exiting vs oom is happen,
> find_lock_task_mm() can be return NULL.
> 
> So, the warning is pointless.
> 

Oh, please.  This isn't rc material.

I already remove this entire function in my patchset, why are you even 
bothering?
