Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab2ALT3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 14:29:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab2ALT3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 14:29:52 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH 0/6 v3] pagemap handles transparent hugepage
Date: Thu, 12 Jan 2012 14:34:52 -0500
Message-Id: <1326396898-5579-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for all your reviews and comments on the previous posts.

In this version, I newly added two patches. One is to separate arch
dependency commented by KOSAKI-san, and the other is to introduce
new type pme_t as commented by Andrew.
And I changed "export KPF_THP" patch to fix an unnoticed bug where
both of KPF_THP and with KPF_HUGE are set for hugetlbfs hugepage.

Thanks,
Naoya
