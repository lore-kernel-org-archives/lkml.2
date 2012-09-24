Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab2IXPWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:22:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756315Ab2IXPWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:22:38 -0400
Date: Mon, 24 Sep 2012 17:23:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] uprobes: Kill set_orig_insn()->is_swbp_at_addr()
Message-ID: <20120924152353.GB13098@redhat.com>
References: <20120923201950.GA27456@redhat.com> <1348477990.11847.11.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348477990.11847.11.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24, Peter Zijlstra wrote:
>
> On Sun, 2012-09-23 at 22:19 +0200, Oleg Nesterov wrote:
>
> > @@ -226,6 +245,10 @@ retry:
>
> Could you use:
>
> $ cat ~/.gitconfig
> [diff "default"]
> 	xfuncname = "^[[:alpha:]$_].*[^:]$"
>
> This avoids git-diff it using labels as function names.

Aha. Will do, thanks!

Oleg.

