Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2L1BKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 20:10:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58564 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab2L1BKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 20:10:52 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50DCF185.7050408@jp.fujitsu.com>
Date: Fri, 28 Dec 2012 10:10:29 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sha Zhengju <handai.szj@gmail.com>
CC: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, akpm@linux-foundation.org, gthelen@google.com,
        fengguang.wu@intel.com, glommer@parallels.com,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH V3 8/8] memcg: Document cgroup dirty/writeback memory
 statistics
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com> <1356456501-14818-1-git-send-email-handai.szj@taobao.com>
In-Reply-To: <1356456501-14818-1-git-send-email-handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/12/26 2:28), Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
> 
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>

I don't think your words are bad but it may be better to sync with meminfo's text.

> ---
>   Documentation/cgroups/memory.txt |    2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index addb1f1..2828164 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -487,6 +487,8 @@ pgpgin		- # of charging events to the memory cgroup. The charging
>   pgpgout		- # of uncharging events to the memory cgroup. The uncharging
>   		event happens each time a page is unaccounted from the cgroup.
>   swap		- # of bytes of swap usage
> +dirty          - # of bytes of file cache that are not in sync with the disk copy.
> +writeback      - # of bytes of file/anon cache that are queued for syncing to disk.
>   inactive_anon	- # of bytes of anonymous memory and swap cache memory on
>   		LRU list.
>   active_anon	- # of bytes of anonymous and swap cache memory on active
> 

Documentation/filesystems/proc.txt

       Dirty: Memory which is waiting to get written back to the disk
   Writeback: Memory which is actively being written back to the disk

even if others are not ;(

Thanks,
-Kame





