Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1EYHH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:07:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51261 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab1EYHHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:07:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDCAAC0.20102@jp.fujitsu.com>
Date: Wed, 25 May 2011 16:07:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, aarcange@redhat.com,
        akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com,
        kamezawa.hiroyu@jp.fujitsu.com
CC: kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH 0/4] fix pagewalk minor issues
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While reviewing Stephen's numa_maps improvement, I've found recent pagewalk changes
made some minor issues.

This series fix them. I think only [1/4] need to backport to -stable.


KOSAKI Motohiro (4):
  pagewalk: Fix walk_page_range() don't check find_vma() result
    properly
  pagewalk: don't look up vma if walk->hugetlb_entry is unused
  pagewalk: add locking-rule commnets
  pagewalk: fix code comment for THP

 include/linux/mm.h |    1 +
 mm/pagewalk.c      |   49 ++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 43 insertions(+), 7 deletions(-)

-- 
1.7.3.1



