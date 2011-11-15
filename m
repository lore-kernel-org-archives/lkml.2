Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1KOBhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 20:37:01 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33694 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1KOBg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 20:36:59 -0500
Date: Mon, 14 Nov 2011 17:36:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Paul Menage <paul@paulmenage.org>
Cc: lizf@cn.fujitsu.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Replace Paul Menage with Tejun Heo as cgroups
 maintainer
Message-ID: <20111115013655.GH30922@google.com>
References: <1321320612-57855-1-git-send-email-paul@paulmenage.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321320612-57855-1-git-send-email-paul@paulmenage.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing akpm, Ingo and Frederic)

On Mon, Nov 14, 2011 at 05:30:12PM -0800, Paul Menage wrote:
> As is probably painfully obvious, I don't have time to be a cgroups
> maintainer.  Rather than have me continue to hope that I'll magically
> find more spare time, instead Tejun has kindly agreed to take over the
> role, along with Li Zefan.
> 
> Signed-off-by: Paul Menage <paul@paulmenage.org>
> ---
> 
> Tejun, Li - can I get your acks before I send this on to mainline?

Sure,

 Acked-by: Tejun Heo <tj@kernel.org>

I'll set up cgroup korg git tree and do standard for-next / for-fixes
branch management.  I won't be committing patches unless co-acked by
Li Zefan.

If anyone objects / has better ideas, please speak up.

Thank you.

>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4808256..055b7f6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1926,7 +1926,7 @@ S:	Maintained
>  F:	drivers/connector/
>  
>  CONTROL GROUPS (CGROUPS)
> -M:	Paul Menage <paul@paulmenage.org>
> +M:	Tejun Heo <tj@kernel.org>
>  M:	Li Zefan <lizf@cn.fujitsu.com>
>  L:	containers@lists.linux-foundation.org
>  S:	Maintained
> -- 
> 1.7.5.4
> 

-- 
tejun
