Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0FAHUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 03:20:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28110 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0FAHUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 03:20:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=xBio2N/g22waYXdN4uD0xQCiP6nvvyCtPSXlXfNdcydXJq0VBeM2gdfwPf72Z+EOB
	Ohzu87/QyeH6gAPn7gxOA==
Date: Tue, 1 Jun 2010 00:20:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 2/5] oom: remove warning for in mm-less task
 __oom_kill_process()
In-Reply-To: <20100601144705.243D.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006010020140.30615@chino.kir.corp.google.com>
References: <20100601144238.243A.A69D9226@jp.fujitsu.com> <20100601144705.243D.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010, KOSAKI Motohiro wrote:

> If the race of mm detach in task exiting vs oom is happen,
> find_lock_task_mm() can be return NULL.
> 
> So, the warning is pointless. remove it.
> 

This is already removed with my patch 
oom-remove-unnecessary-code-and-cleanup.patch from my oom killer rewrite.
