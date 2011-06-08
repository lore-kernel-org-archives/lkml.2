Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1FHCav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 22:30:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53613 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1FHCau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 22:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Sgn3ws6DKpAFcAxWNWnwl8w5DARgR7fnOWXv7Qxr6uOoZ53g7rCkxNjGt/84nQVh/b
         Qvukm8roND5BbHLmaNXA==
Date: Tue, 7 Jun 2011 19:30:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] trace: Set __GFP_NORETRY flag for ring buffer allocating
 process
In-Reply-To: <1307491302-9236-1-git-send-email-vnagarnaik@google.com>
Message-ID: <alpine.DEB.2.00.1106071929570.15402@chino.kir.corp.google.com>
References: <1307490088-8612-1-git-send-email-vnagarnaik@google.com> <1307491302-9236-1-git-send-email-vnagarnaik@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011, Vaibhav Nagarnaik wrote:

> The tracing ring buffer is allocated from kernel memory. While
> allocating a large chunk of memory, OOM might happen which destabilizes
> the system. Thus random processes might get killed during the
> allocation.
> 
> This patch adds __GFP_NORETRY flag to the ring buffer allocation calls
> to make it fail more gracefully if the system will not be able to
> complete the allocation request.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>

Acked-by: David Rientjes <rientjes@google.com>
