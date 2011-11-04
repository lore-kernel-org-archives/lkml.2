Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab1KDJzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 05:55:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41300 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab1KDJzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 05:55:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Nov 2011 18:54:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        akpm@linux-foundation.org, yinghan@google.com
Subject: Re: [PATCH] memcg: doc the pagefault count
Message-Id: <20111104185437.406a3764.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1320398121-17336-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1320398121-17336-1-git-send-email-gaowanlong@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Nov 2011 17:15:21 +0800
Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:

> Pagefault count has added to memcg stats since commit 456f998e,
> but forgot to doc it.
> 
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Thanks,
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  Documentation/cgroups/memory.txt |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index cc0ebc5..081f4f44 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -389,6 +389,13 @@ mapped_file	- # of bytes of mapped file (includes tmpfs/shmem)
>  pgpgin		- # of pages paged in (equivalent to # of charging events).
>  pgpgout		- # of pages paged out (equivalent to # of uncharging events).
>  swap		- # of bytes of swap usage
> +
> +pgfault		- # of page-faults
> +pgmajfault	- # of major page-faults
> +		These two are different from "pgpgin"/"pgpgout" stat which
> +		count number of pages charged/discharged to the cgroup and
> +		have no meaning of reading/writing page to disk.
> +




