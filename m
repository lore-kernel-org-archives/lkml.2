Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab0FCULe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:11:34 -0400
Received: from smtp-out.google.com ([74.125.121.35]:20144 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab0FCULd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:11:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=UFPR2LFN2NPV1WSQv37pgEHtXKqQn4R5Eqr6pe4ujYGeE1qvz1CY+7RtLvFq/rQIc
	FGnJfo0/KUMHwpCTnfn1g==
Date: Thu, 3 Jun 2010 13:11:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/5] oom: select_bad_process: check PF_KTHREAD instead
 of !mm to skip kthreads
In-Reply-To: <20100603142717.GC3548@redhat.com>
Message-ID: <alpine.DEB.2.00.1006031308430.10856@chino.kir.corp.google.com>
References: <20100601212023.GA24917@redhat.com> <alpine.DEB.2.00.1006011424200.16725@chino.kir.corp.google.com> <20100602223612.F52D.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006021405280.32666@chino.kir.corp.google.com> <20100602213331.GA31949@redhat.com>
 <alpine.DEB.2.00.1006021437010.4765@chino.kir.corp.google.com> <20100603142717.GC3548@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010, Oleg Nesterov wrote:

> David, I don't understand why do you refuse to re-diff your changes
> on top of Kosaki's work. If nothing else, this will help to review
> your changes.
> 

I simply don't have enough time in a day to rebase my rewrite patches on 
top of what Andrew may or may not merge into -mm.  When he merges 
something, that would be different.

I don't think we need to push anything to -mm right now that isn't rc 
material since the rewrite should make it in before the merge window.  If 
there are outstanding fixes that should go into rc (and probably stable 
material as well), those need to be pushed to Andrew immediately.  I 
disagree that I've seen any to date that are immediate fixes.
