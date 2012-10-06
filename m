Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab2JFHLf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 03:11:35 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53887 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2JFHLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 03:11:32 -0400
Date: Sat, 6 Oct 2012 12:41:10 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] uprobes: Simplify is_swbp_at_addr(), remove stale
 comments
Message-ID: <20121006071110.GE27781@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120923201921.GA27424@redhat.com>
 <20120923201953.GA27463@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120923201953.GA27463@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100607-2876-0000-0000-000000C633E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-23 22:19:53]:

> After the previous change is_swbp_at_addr() is always called with
> current->mm. Remove this check and move it close to its single caller.
> 
> Also, remove the obsolete comment about is_swbp_at_addr() and
> uprobe_state.count.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

