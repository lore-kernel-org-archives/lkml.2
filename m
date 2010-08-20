Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab0HTKFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 06:05:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50695 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0HTKFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 06:05:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 3/4] writeback: nr_dirtied and nr_entered_writeback in /proc/vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        fengguang.wu@intel.com, jack@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, david@fromorbit.com, npiggin@kernel.dk,
        hch@lst.de, axboe@kernel.dk
In-Reply-To: <1282296689-25618-4-git-send-email-mrubin@google.com>
References: <1282296689-25618-1-git-send-email-mrubin@google.com> <1282296689-25618-4-git-send-email-mrubin@google.com>
Message-Id: <20100820190329.6000.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 20 Aug 2010 19:05:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index f389168..073a496 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -732,6 +732,9 @@ static const char * const vmstat_text[] = {
>  	"nr_isolated_anon",
>  	"nr_isolated_file",
>  	"nr_shmem",
> +	"nr_dirtied",
> +	"nr_entered_writeback",
> +
>  #ifdef CONFIG_NUMA
>  	"numa_hit",
>  	"numa_miss",

'nr_entered_writeback' seems ok. but nr_dirtied seems a bit easy confusable
with 'nr_dirty'. Can you please choice more clear meaningful name?

Otherwise looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




