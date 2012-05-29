Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab2E2Orp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 10:47:45 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:46970 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753851Ab2E2Orn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 10:47:43 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 73ueShoVM1kOQ24MgRjlmrYX5RUYGSso2n4nAW3hRLtUOeA
 mSlatHIDESp4.546pKTjxyq7Ua_ahbbsiZ1PU7ELf0fkx1bxLbnEKOoL.Pwb
 WLrty8S73bA8zQcZXxsTqPLvW7GdUUp9NtCNNRiWGwkACBBtf2BQHAHZJk4l
 2CN5kwyrZas5hQw8u0YiUNLX_KPJcpgKktEOO.bIGMyQkdMJZc3TMA1vyepS
 E1Cr4W.Q4R47VW7BIWXhprJqmAyGk0VV5NzbD0FGyctKXhCjcn_yDPajDThs
 hjzf98agZD6ZD_PE4SYyNG5R7tEH..yJfIWUmWTFmjZKKjL_boPQN2Ybyyry
 18kGMyDMMXWMHFa910YNf5g8vbJWBnnwdH4XYCXi6Nr2TsuQ_aORgDzaiFG6
 k
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 09:47:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge
 infrastructure
In-Reply-To: <1337951028-3427-17-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1205290944040.4666@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-17-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012, Glauber Costa wrote:

> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -696,7 +696,7 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
>  	  then swapaccount=0 does the trick).
>  config CGROUP_MEM_RES_CTLR_KMEM
>  	bool "Memory Resource Controller Kernel Memory accounting (EXPERIMENTAL)"
> -	depends on CGROUP_MEM_RES_CTLR && EXPERIMENTAL
> +	depends on CGROUP_MEM_RES_CTLR && EXPERIMENTAL && !SLOB
>  	default n

Ok so SLOB is not supported at all.

