Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab1L3EBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 23:01:19 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41924 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab1L3EBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 23:01:15 -0500
Message-ID: <4EFD3787.5040307@gmail.com>
Date: Thu, 29 Dec 2011 23:01:11 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] pagemap: export KPF_THP
References: <1324506228-18327-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1324506228-18327-4-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1324506228-18327-4-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/21/11 5:23 PM), Naoya Horiguchi wrote:
> This flag shows that a given pages is a subpage of transparent hugepage.
> It helps us debug and test kernel by showing physical address of thp.
> 
> Signed-off-by: Naoya Horiguchi<n-horiguchi@ah.jp.nec.com>
> Nacked-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Wu Fengguang<fengguang.wu@intel.com>

ok, many people like this patch. so I don't argue this anymore.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




