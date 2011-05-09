Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1EIHtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 03:49:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52461 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1EIHtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 03:49:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH 6/8] mm: proc: move show_numa_map() to fs/proc/task_mmu.c
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1303947349-3620-7-git-send-email-wilsons@start.ca>
References: <1303947349-3620-1-git-send-email-wilsons@start.ca> <1303947349-3620-7-git-send-email-wilsons@start.ca>
Message-Id: <20110509165102.1663.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  9 May 2011 16:49:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Moving show_numa_map() from mempolicy.c to task_mmu.c solves several
> issues.
> 
>   - Having the show() operation "miles away" from the corresponding
>     seq_file iteration operations is a maintenance burden.
> 
>   - The need to export ad hoc info like struct proc_maps_private is
>     eliminated.
> 
>   - The implementation of show_numa_map() can be improved in a simple
>     manner by cooperating with the other seq_file operations (start,
>     stop, etc) -- something that would be messy to do without this
>     change.
> 
> Signed-off-by: Stephen Wilson <wilsons@start.ca>
> ---
>  fs/proc/task_mmu.c |  170 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  mm/mempolicy.c     |  168 ---------------------------------------------------
>  2 files changed, 168 insertions(+), 170 deletions(-)

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




