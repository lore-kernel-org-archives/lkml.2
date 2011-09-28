Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab1I1AxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 20:53:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47805 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1I1AxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 20:53:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Sep 2011 09:52:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wizard <wizarddewhite@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH]   fix find_next_system_ram comments
Message-Id: <20110928095217.37650ffd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1317045482-3355-1-git-send-email-wizarddewhite@gmail.com>
References: <1317045482-3355-1-git-send-email-wizarddewhite@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 21:58:02 +0800
Wizard <wizarddewhite@gmail.com> wrote:

> The purpose of find_next_system_ram() is to find a the lowest
> memory resource which contain or overlap the [res->start, res->end),
> not just contain.
> 
> In this patch, I make this comment more exact and fix one typo.
> 
> Signed-off-by: Wizard <wizarddewhite@gmail.com>

Thank you for catching.

Please hear Randy's advice :)

> ---
>  kernel/resource.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 3b3cedc..2751a8c 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -279,7 +279,8 @@ EXPORT_SYMBOL(release_resource);
>  
>  #if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
>  /*
> - * Finds the lowest memory reosurce exists within [res->start.res->end)
> + * Finds the lowest memory resource which contains or overlaps
> + * [res->start.res->end)
>   * the caller must specify res->start, res->end, res->flags and "name".
>   * If found, returns 0, res is overwritten, if not found, returns -1.
>   */
> -- 
> 1.6.3.3
> 
> 

