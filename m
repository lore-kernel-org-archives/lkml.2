Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2JAOCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:02:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab2JAOCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:02:35 -0400
Date: Mon, 1 Oct 2012 16:03:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] uprobes: register/unregister bugfixes
Message-ID: <20121001140327.GA2389@redhat.com>
References: <20120930194119.GA11278@redhat.com> <20120930194438.GA11222@redhat.com> <20121001125552.GA27781@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001125552.GA27781@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01, Srikar Dronamraju wrote:
>
> > This is on top of "[PATCH 0/3] uprobes: mprotect fixes" series,
> > which is still waiting for review...
> >
>
> Did you mean [PATCH 0/4] uprobes: remove is_swbp_at_addr() from
> register/unregister?

Yes, sorry for confusion,

> I have already reviewed and acked "[PATCH 0/3] uprobes: mprotect fixes"
> series".

Yes, and I already added your acks, thanks.

> Got distracted by the register/unregister bug that we were discussing
> offline.

Yes. 2-6 try to fix the bugs I found by the code inspection, but
I do not think they can fix that bug, I guess there is yet another
problem we need to fix.

Oleg.

