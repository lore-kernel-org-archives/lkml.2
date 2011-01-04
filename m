Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751069Ab1ADKN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:13:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:47128 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1ADKNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:13:55 -0500
Date: Tue, 4 Jan 2011 11:13:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] writeback: fix typo of global_dirty_limits comment
In-Reply-To: <1294072608-3172-1-git-send-email-minchan.kim@gmail.com>
Message-ID: <alpine.LNX.2.00.1101041113440.26685@pobox.suse.cz>
References: <1294072608-3172-1-git-send-email-minchan.kim@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jan 2011, Minchan Kim wrote:

> Change runtime with real-time
> 
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/page-writeback.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index c340536..98b79e2 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -384,7 +384,7 @@ unsigned long determine_dirtyable_memory(void)
>   * - vm.dirty_background_ratio  or  vm.dirty_background_bytes
>   * - vm.dirty_ratio             or  vm.dirty_bytes
>   * The dirty limits will be lifted by 1/4 for PF_LESS_THROTTLE (ie. nfsd) and
> - * runtime tasks.
> + * real-time tasks.
>   */
>  void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
>  {

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
