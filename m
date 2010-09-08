Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab0IHB3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 21:29:06 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:63106 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab0IHB2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 21:28:42 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/10] Hugepage migration (v5)
Date: Wed,  8 Sep 2010 10:19:31 +0900
Message-Id: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the 5th version of "hugepage migration" set.

Changes from v4 (mostly refactoring):
- remove unnecessary might_sleep() [3/10]
- define migrate_huge_pages() from copy of migrate_pages() [4/10]
- soft_offline_page() branches off to hugepage path. [8/10]

Thanks,
Naoya Horiguchi
