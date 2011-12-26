Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1LZIni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 03:43:38 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39775 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1LZInb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 03:43:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Dec 2011 17:42:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] pagemap: document KPF_THP and make page-types aware
 of it
Message-Id: <20111226174217.ab33a2eb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1324506228-18327-5-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1324506228-18327-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1324506228-18327-5-git-send-email-n-horiguchi@ah.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 17:23:48 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> page-types, which is a common user of pagemap, gets aware of thp
> with this patch. This helps system admins and kernel hackers know
> about how thp works.
> Here is a sample output of page-types over a thp:
> 
>   $ page-types -p <pid> --raw --list
> 
>   voffset offset  len     flags
>   ...
>   7f9d40200       3f8400  1       ___U_lA____Ma_bH______t____________
>   7f9d40201       3f8401  1ff     ________________T_____t____________
> 
>                flags      page-count       MB  symbolic-flags                     long-symbolic-flags
>   0x0000000000410000             511        1  ________________T_____t____________        compound_tail,thp
>   0x000000000040d868               1        0  ___U_lA____Ma_bH______t____________        uptodate,lru,active,mmap,anonymous,swapbacked,compound_head,thp
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Acked-by: Wu Fengguang <fengguang.wu@intel.com>
> 
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

