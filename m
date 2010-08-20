Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab0HTMTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:19:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab0HTMTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:19:21 -0400
Date: Fri, 20 Aug 2010 08:19:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] lockup_detector: Make callback function static
Message-ID: <20100820121917.GC4879@redhat.com>
References: <1282273431.16443.32.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282273431.16443.32.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 11:03:51AM +0800, Lin Ming wrote:
> watchdog_overflow_callback is only used in kernel/watchdog.c.

Acked-by: Don Zickus <dzickus@redhat.com>

> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  kernel/watchdog.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 613bc1f..b60e2a8 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -202,7 +202,7 @@ static struct perf_event_attr wd_hw_attr = {
>  };
>  
>  /* Callback function for perf event subsystem */
> -void watchdog_overflow_callback(struct perf_event *event, int nmi,
> +static void watchdog_overflow_callback(struct perf_event *event, int nmi,
>  		 struct perf_sample_data *data,
>  		 struct pt_regs *regs)
>  {
> 
> 
