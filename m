Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab0FCUMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:12:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13823 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab0FCUM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:12:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=kmsUhCmdZ5aWo69LIx4qbYHvPduofVcmDZ3phJdfrhkUKv/ui1RtlVpf57NZIoxaI
	mbrgnyf9pTYJVzgS4TeyA==
Date: Thu, 3 Jun 2010 13:12:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 08/12] oom: dump_tasks() use find_lock_task_mm() too
In-Reply-To: <20100603152652.GA8743@redhat.com>
Message-ID: <alpine.DEB.2.00.1006031312130.10856@chino.kir.corp.google.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com> <20100603152350.725F.A69D9226@jp.fujitsu.com> <20100603152652.GA8743@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010, Oleg Nesterov wrote:

> (off-topic)
> 
> out_of_memory() calls dump_header()->dump_tasks() lockless, we
> need tasklist.
> 

Already fixed in my rewrite patchset, as most of these things are.  Sigh.
