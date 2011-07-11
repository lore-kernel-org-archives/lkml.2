Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab1GKQsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:48:51 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:40447 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758138Ab1GKQsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:48:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qMMUGVblmgZU+msmjNcnmuzzr+Tzcv4mxvIJKFDSiaXVe4KlYgl9YZCpO06gZB/TLWTrszHEeqoLL0fyB59qY8ayLhoJ0R/36StJmh2NqPjaG0dvXKilcuY65jAnbyMJ;
Date: Mon, 11 Jul 2011 09:48:47 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Paul Menage <menage@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH] Doc:cgroup:fix a cpuset's file description in
 cpusets.txt
Message-Id: <20110711094847.f9813b65.rdunlap@xenotime.net>
In-Reply-To: <1310288313-4908-1-git-send-email-wanlong.gao@gmail.com>
References: <1310288313-4908-1-git-send-email-wanlong.gao@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jul 2011 16:58:33 +0800 Wanlong Gao wrote:

> Only the root cpuset has cpuset.memory_pressure_enabled flag,
> but not the only one.
> 
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Applied.  Thanks.

> ---
>  Documentation/cgroups/cpusets.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
> index 5b0d78e..5c51ed4 100644
> --- a/Documentation/cgroups/cpusets.txt
> +++ b/Documentation/cgroups/cpusets.txt
> @@ -180,7 +180,7 @@ files describing that cpuset:
>   - cpuset.sched_load_balance flag: if set, load balance within CPUs on that cpuset
>   - cpuset.sched_relax_domain_level: the searching range when migrating tasks
>  
> -In addition, the root cpuset only has the following file:
> +In addition, only the root cpuset has the following file:
>   - cpuset.memory_pressure_enabled flag: compute memory_pressure?
>  
>  New cpusets are created using the mkdir system call or shell
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
