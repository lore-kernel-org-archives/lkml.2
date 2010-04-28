Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab0D1Wlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:41:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab0D1Wlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:41:35 -0400
Date: Thu, 29 Apr 2010 00:41:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@au1.ibm.com>
Subject: Re: [PATCH] trivial: use (C) instead of \251
In-Reply-To: <4BD80037.9060704@kernel.org>
Message-ID: <alpine.LNX.2.00.1004290040510.9849@pobox.suse.cz>
References: <4BD80037.9060704@kernel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010, Tejun Heo wrote:

> The latin-1 copyright character \251 is invalid in ASCII or UTF-8 and
> causes annoying problems with some editors and tools.  Use (C)
> instead.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Paul Mackerras <paulus@au1.ibm.com>
> ---
> I'm not really sure this would survive transport over mail in
> appliable form, attaching the patch too just in case.

It didn't survive :) But it was easy enough to fix by hand. Applied, 
thanks Tejun.

>  kernel/perf_event.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 2f3fbf8..827ec53 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4,7 +4,7 @@
>   *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
>   *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
>   *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
> - *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
> + *  Copyright (C) 2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
>   *
>   * For licensing details see kernel-base/COPYING
>   */
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
