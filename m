Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab1BQBz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:55:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49957 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab1BQBz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:55:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 17 Feb 2011 10:49:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Jiri Kosina <jkosina@suse.cz>, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: clarify use_hierarchy documentation
Message-Id: <20110217104932.9e2c741b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1297907483-3672-1-git-send-email-gthelen@google.com>
References: <1297907483-3672-1-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011 17:51:23 -0800
Greg Thelen <gthelen@google.com> wrote:

> The memcg code does not allow changing memory.use_hierarchy if the
> parent cgroup has enabled use_hierarchy.  Update documentation to match
> the code.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Thank you,
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Because I tend to read linux-mm list 1st, I'm glad if you CC linux-mm in
the next time.

> ---
>  Documentation/cgroups/memory.txt |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index 7781857..b6ed61c 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -485,8 +485,9 @@ The feature can be disabled by
>  
>  # echo 0 > memory.use_hierarchy
>  
> -NOTE1: Enabling/disabling will fail if the cgroup already has other
> -       cgroups created below it.
> +NOTE1: Enabling/disabling will fail if either the cgroup already has other
> +       cgroups created below it, or if the parent cgroup has use_hierarchy
> +       enabled.
>  
>  NOTE2: When panic_on_oom is set to "2", the whole system will panic in
>         case of an OOM event in any cgroup.
> -- 
> 1.7.3.1
> 
> 

