Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0ECNms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:42:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978Ab0ECNmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:42:46 -0400
Date: Mon, 3 May 2010 15:42:44 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_event: Use UTF-8 copyright symbol instead of \251
In-Reply-To: <20100501002811.GA2610@brick.ozlabs.ibm.com>
Message-ID: <alpine.LNX.2.00.1005031541390.9849@pobox.suse.cz>
References: <20100501002811.GA2610@brick.ozlabs.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 May 2010, Paul Mackerras wrote:

> As noted by Tejun Heo, the latin-1 copyright character \251 is invalid
> in ASCII or UTF-8.  This changes the character to its UTF-8 encoding
> in order to avoid problems with editors and other tools.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 9dbe8cd..d46a277 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4,7 +4,7 @@
>   *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
>   *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
>   *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
> - *  Copyright  ???  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>

Umm ... this looks odd.

> + *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>

This seems to add \251 again :) Maybe some of your tools got confused 
enough?

Anyway, I have dropped the patch from Tejun for now.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
