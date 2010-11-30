Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab0K3UHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:07:47 -0500
Received: from smtp-out.google.com ([74.125.121.35]:7823 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab0K3UHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:07:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=tfCYKcILNJb7nPijU8Jao8gtuI9c2gz2LeDNyLMWP5UWaMwQS+mw8CysG+u4jISAwd
         34WZGz4Fj2gffExtyWzg==
Date: Tue, 30 Nov 2010 12:07:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH 2/4] Revert "oom: deprecate oom_adj tunable"
In-Reply-To: <20101130220221.832B.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011301205510.12979@chino.kir.corp.google.com>
References: <20101123160259.7B9C.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011271737110.3764@chino.kir.corp.google.com> <20101130220221.832B.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, KOSAKI Motohiro wrote:

> > Because NOTHING breaks with the new mapping.  Eight months later since 
> > this was initially proposed on linux-mm, you still cannot show a single 
> > example that depended on the exponential mapping of oom_adj.  I'm not 
> > going to continue responding to your criticism about this point since your 
> > argument is completely and utterly baseless.
> 
> No regression mean no break. Not single nor multiple. see?
> 

Nothing breaks.  If something did, you could respond to my answer above 
and provide a single example of a real-world example that broke as a 
result of the new linear mapping.

> All situation can be calculated on userland. User process can be know
> their bindings.
> 

Yes, but the proportional priority-based oom_score_adj values allow users 
to avoid recalculating and writing that value anytime a mempolicy 
attachment changes, its nodemask changes, it moves to another cpuset, its 
set of mems changes, its memcg attachment changes, its limit is modiifed, 
etc.
