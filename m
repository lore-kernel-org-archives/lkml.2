Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab1EPVXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:23:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50928 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1EPVXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:23:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=vmjjQghDz50LK8g3izcIzj0751Gd/nqpb0rjbi+Sh29pyapjE6MQtzbRWYasO6CFcy
         jYKuAbe79FXyTXUTobPg==
Date: Mon, 16 May 2011 14:23:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Nazarewicz <mina86@mina86.com>
cc: John Stultz <john.stultz@linaro.org>, Jiri Slaby <jirislaby@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] checkpatch.pl: Add check for current->comm
 references
In-Reply-To: <op.vve2a6hp3l0zgt@mnazarewicz-glaptop>
Message-ID: <alpine.DEB.2.00.1105161422490.4353@chino.kir.corp.google.com>
References: <1305241371-25276-1-git-send-email-john.stultz@linaro.org> <1305241371-25276-4-git-send-email-john.stultz@linaro.org> <4DCCD0C3.9090908@gmail.com> <op.vve2a6hp3l0zgt@mnazarewicz-glaptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011, Michal Nazarewicz wrote:

> On Fri, 13 May 2011 08:33:39 +0200, Jiri Slaby wrote:
> > This should be something like \b(current|task|tsk|t)->comm\b to catch
> > also non-current comm accesses...
> 
> Or \b(?:current|task|tsk|t)\s*->\s*comm\b.
> 

Add 'p' to the mix :)

$ grep -r "struct task_struct \*p[; ]" * | wc -l
119
