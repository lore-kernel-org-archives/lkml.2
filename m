Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1BVLcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 06:32:24 -0500
Received: from www.tglx.de ([62.245.132.106]:33750 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab1BVLcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 06:32:23 -0500
Date: Tue, 22 Feb 2011 12:32:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] debugobjects: print more data
In-Reply-To: <20110222094504.GA21489@redhat.com>
Message-ID: <alpine.LFD.2.00.1102221227070.2701@localhost6.localdomain6>
References: <20110222094504.GA21489@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011, Stanislaw Gruszka wrote:
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -334,6 +334,14 @@ EXPORT_SYMBOL_GPL(ktime_add_safe);
>  
>  static struct debug_obj_descr hrtimer_debug_descr;
>  
> +void hrtimer_debug_print(void *addr)

static please !

> +void timer_debug_print(void *addr)
> +void work_debug_print(void *addr)

Ditto

Thanks,

	tglx
