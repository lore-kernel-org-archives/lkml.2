Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab1IQAmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 20:42:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49440 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab1IQAmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 20:42:00 -0400
Date: Sat, 17 Sep 2011 09:41:53 +0900
From: Tejun Heo <htejun@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 25/27] Initconst section fixes for percpu
Message-ID: <20110917004153.GV29319@htj.dyndns.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
 <1316117394-21666-26-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316117394-21666-26-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 15, 2011 at 01:09:52PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Cc: tj@kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

 Acked-by: Tejun Heo <tj@kernel.org>

Andrew, can you please take this one too?

Thank you very much.

> ---
>  include/linux/percpu.h |    2 +-
>  mm/percpu.c            |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> index 9ca008f..2b79f8f 100644
> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -107,7 +107,7 @@ enum pcpu_fc {
>  
>  	PCPU_FC_NR,
>  };
> -extern const char *pcpu_fc_names[PCPU_FC_NR];
> +extern const char * const pcpu_fc_names[PCPU_FC_NR];
>  
>  extern enum pcpu_fc pcpu_chosen_fc;
>  
> diff --git a/mm/percpu.c b/mm/percpu.c
> index bf80e55..15dd9a3 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1344,7 +1344,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
>  
>  #ifdef CONFIG_SMP
>  
> -const char *pcpu_fc_names[PCPU_FC_NR] __initdata = {
> +const char * const pcpu_fc_names[PCPU_FC_NR] __initconst = {
>  	[PCPU_FC_AUTO]	= "auto",
>  	[PCPU_FC_EMBED]	= "embed",
>  	[PCPU_FC_PAGE]	= "page",
> -- 
> 1.7.4.4

-- 
tejun
