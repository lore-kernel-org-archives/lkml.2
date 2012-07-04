Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab2GDMsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:48:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35759 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab2GDMsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:48:00 -0400
Date: Wed, 4 Jul 2012 14:47:57 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, yinghan@google.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 1/7] memcg: update cgroup memory document
Message-ID: <20120704124757.GE29842@tiehlicka.suse.cz>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
 <1340881055-5511-1-git-send-email-handai.szj@taobao.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340881055-5511-1-git-send-email-handai.szj@taobao.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 28-06-12 18:57:35, Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
> 
> Document cgroup dirty/writeback memory statistics.
> 
> The implementation for these new interface routines come in a series
> of following patches.

I would expect this one the be the last...

> 
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>

Ackedy-by: Michal Hocko <mhocko@suse.cz>

> ---
>  Documentation/cgroups/memory.txt |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index dd88540..24d7e3c 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -420,6 +420,8 @@ pgpgin		- # of charging events to the memory cgroup. The charging
>  pgpgout		- # of uncharging events to the memory cgroup. The uncharging
>  		event happens each time a page is unaccounted from the cgroup.
>  swap		- # of bytes of swap usage
> +dirty		- # of bytes that are waiting to get written back to the disk.
> +writeback	- # of bytes that are actively being written back to the disk.
>  inactive_anon	- # of bytes of anonymous memory and swap cache memory on
>  		LRU list.
>  active_anon	- # of bytes of anonymous and swap cache memory on active
> -- 
> 1.7.1
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
