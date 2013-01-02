Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3ABNgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 08:36:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab3ABNgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 08:36:23 -0500
Date: Wed, 2 Jan 2013 14:36:21 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        gthelen@google.com, fengguang.wu@intel.com, glommer@parallels.com,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH V3 8/8] memcg: Document cgroup dirty/writeback memory
 statistics
Message-ID: <20130102133621.GG22160@dhcp22.suse.cz>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com>
 <1356456501-14818-1-git-send-email-handai.szj@taobao.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356456501-14818-1-git-send-email-handai.szj@taobao.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 26-12-12 01:28:21, Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
> 
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  Documentation/cgroups/memory.txt |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index addb1f1..2828164 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -487,6 +487,8 @@ pgpgin		- # of charging events to the memory cgroup. The charging
>  pgpgout		- # of uncharging events to the memory cgroup. The uncharging
>  		event happens each time a page is unaccounted from the cgroup.
>  swap		- # of bytes of swap usage
> +dirty          - # of bytes of file cache that are not in sync with the disk copy.
> +writeback      - # of bytes of file/anon cache that are queued for syncing to disk.
>  inactive_anon	- # of bytes of anonymous memory and swap cache memory on
>  		LRU list.
>  active_anon	- # of bytes of anonymous and swap cache memory on active
> -- 
> 1.7.9.5
> 

-- 
Michal Hocko
SUSE Labs
