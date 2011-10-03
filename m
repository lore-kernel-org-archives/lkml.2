Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1JCKlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:41:49 -0400
Received: from shutemov.name ([188.40.19.243]:46370 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361Ab1JCKlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:41:35 -0400
Date: Mon, 3 Oct 2011 13:41:33 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org, avagin@parallels.com
Subject: Re: [PATCH v4 1/8] Basic kernel memory functionality for the Memory
 Controller
Message-ID: <20111003104133.GA29312@shutemov.name>
References: <1317637123-18306-1-git-send-email-glommer@parallels.com>
 <1317637123-18306-2-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317637123-18306-2-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 02:18:36PM +0400, Glauber Costa wrote:
> This patch lays down the foundation for the kernel memory component
> of the Memory Controller.
> 
> As of today, I am only laying down the following files:
> 
>  * memory.independent_kmem_limit
>  * memory.kmem.limit_in_bytes (currently ignored)
>  * memory.kmem.usage_in_bytes (always zero)
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Paul Menage <paul@paulmenage.org>
> CC: Greg Thelen <gthelen@google.com>

Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>

One comment bellow.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ebd1e86..8aaf4ce 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -72,8 +72,6 @@ static int really_do_swap_account __initdata = 0;
>  #else
>  #define do_swap_account		(0)
>  #endif
> -
> -
>  /*
>   * Statistics for memory cgroup.
>   */

Please drop this hunk.

-- 
 Kirill A. Shutemov
