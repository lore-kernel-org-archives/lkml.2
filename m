Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1LZI1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 03:27:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57071 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1LZI1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 03:27:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Dec 2011 17:26:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pagemap: avoid splitting thp when reading
 /proc/pid/pagemap
Message-Id: <20111226172626.49792a03.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1324506228-18327-2-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1324506228-18327-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1324506228-18327-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 17:23:45 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Thp split is not necessary if we explicitly check whether pmds are
> mapping thps or not. This patch introduces the check and the code
> to generate pagemap entries for pmds mapping thps, which results in
> less performance impact of pagemap on thp.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> 
> Changes since v1:
>   - move pfn declaration to the beginning of pagemap_pte_range()
> ---

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


