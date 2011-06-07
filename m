Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab1FGEJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 00:09:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19298 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1FGEJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 00:09:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=DtVV4ULXQPWGx08Y7EhwJ+0O1/O7anFnQ3SPeDcjy47kNuSoHr5BQhl4ps63dh5Ot9
         x8Rq6+ieoDLcSYuNIkcA==
Date: Mon, 6 Jun 2011 21:09:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Steven Rostedt <rostedt@goodmis.org>, Pekka Enberg <penberg@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Matt Mackall <mpm@selenic.com>, Paul Mundt <lethal@linux-sh.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] slob/lockdep: Fix gfp flags passed to
 lockdep
In-Reply-To: <1307369665.31814.20.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1106062106580.22635@chino.kir.corp.google.com>
References: <1307369665.31814.20.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011, Steven Rostedt wrote:

> 
> Ingo,
> 
> Please pull the latest tip/lockdep/devel tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/lockdep/devel
> 
> 
> Steven Rostedt (1):
>       slob/lockdep: Fix gfp flags passed to lockdep

Shouldn't this be going into Pekka's slab tree?
