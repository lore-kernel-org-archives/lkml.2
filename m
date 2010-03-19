Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013Ab0CSESv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 00:18:51 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:52564 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab0CSESt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 00:18:49 -0400
Date: Fri, 19 Mar 2010 09:48:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Greg Thelen <gthelen@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Kirill A. Shutemov" <kirill@shutemov.name>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] memcg: fix typo in memcg documentation
Message-ID: <20100319041842.GI18054@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1268949879-29478-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1268949879-29478-1-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Thelen <gthelen@google.com> [2010-03-18 15:04:39]:

> Updated memory.txt to be more consistent: s/swapiness/swappiness/
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  Documentation/cgroups/memory.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index f8bc802..3a6aecd 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -340,7 +340,7 @@ Note:
>  5.3 swappiness
>    Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
> 
> -  Following cgroups' swapiness can't be changed.
> +  Following cgroups' swappiness can't be changed.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
