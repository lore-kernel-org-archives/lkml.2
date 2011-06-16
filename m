Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab1FPNB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:01:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33666 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab1FPNB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:01:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SjtpJXvZjgPjEs5Zc8UkxS7XvfYdqHTzCW7ty8+/ixa7nH5114rWCyRMPoYI1560bf
         2tm0VWzOOB8K52WQsPdeRureslxJIQpcd7lfJKyxGYwVx0xNBOC8fwAhE4P1k68GxE6w
         n4/FYHvl84qsNRnDlaZesJphfINwWSdP/M1OQ=
MIME-Version: 1.0
In-Reply-To: <20110616100937.GA12317@elte.hu>
References: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
	<20110613120608.d5243bc9.kamezawa.hiroyu@jp.fujitsu.com>
	<20110616100937.GA12317@elte.hu>
Date: Thu, 16 Jun 2011 22:01:25 +0900
Message-ID: <BANLkTik8oETUSphYDfP8g8CgyHnDcaBXOg@mail.gmail.com>
Subject: Re: [-git build bug, PATCH] Re: [BUGFIX][PATCH 2/5] memcg: fix
 init_page_cgroup nid with sparsemem
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/16 Ingo Molnar <mingo@elte.hu>:
>
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> Date: Mon, 13 Jun 2011 10:09:17 +0900
>> Subject: [PATCH 2/5] [BUGFIX] memcg: fix init_page_cgroup nid with sparsemem
>
> This fresh upstream commit commit:
>
>  37573e8c7182: memcg: fix init_page_cgroup nid with sparsemem
>
> is causing widespread build failures on latest -git, on x86:
>
>  mm/page_cgroup.c:308:3: error: implicit declaration of function ‘node_start_pfn’ [-Werror=implicit-function-declaration]
>  mm/page_cgroup.c:309:3: error: implicit declaration of function ‘node_end_pfn’ [-Werror=implicit-function-declaration]
>
> On any config that has CONFIG_CGROUP_MEM_RES_CTLR=y enabled but
> CONFIG_NUMA disabled.
>
> For now i've worked it around with the patch below, but the real
> solution would be to make the page_cgroup.c code not depend on NUMA.
>
> Thanks,
>
>        Ingo
>
yes, very sorry. I'm now preparing a fix in this thread.

http://marc.info/?t=130819986800002&r=1&w=2

I think I'll be able to post a final fix, tomorrow. I'll cc you when I'll post.
Thanks,
-Kame
