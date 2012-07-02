Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab2GBGXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 02:23:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289Ab2GBGXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 02:23:02 -0400
Message-ID: <4FF13E0D.6000601@redhat.com>
Date: Mon, 02 Jul 2012 02:22:05 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 37/40] autonuma: page_autonuma change #include for sparse
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-38-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-38-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:56 AM, Andrea Arcangeli wrote:
> sparse (make C=1) warns about lookup_page_autonuma not being declared,
> that's a false positive, but we can shut it down by being less strict
> in the includes.
>
> Signed-off-by: Andrea Arcangeli<aarcange@redhat.com>

It is a one line change.  Please fold it into the patch
that introduced the issue, and reduce the size of the
patch series.

> diff --git a/mm/page_autonuma.c b/mm/page_autonuma.c
> index bace9b8..2468c9e 100644
> --- a/mm/page_autonuma.c
> +++ b/mm/page_autonuma.c
> @@ -1,6 +1,6 @@
>   #include<linux/mm.h>
>   #include<linux/memory.h>
> -#include<linux/autonuma_flags.h>
> +#include<linux/autonuma.h>
>   #include<linux/page_autonuma.h>
>   #include<linux/bootmem.h>
>


-- 
All rights reversed
