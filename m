Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab1LUWUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 17:20:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab1LUWUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 17:20:41 -0500
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
Subject: [PATCH 0/4 v2] pagemap handles transparent hugepage
Date: Wed, 21 Dec 2011 17:23:44 -0500
Message-Id: <1324506228-18327-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Thanks for all your reviews and comments on the previous post.
I made some changes based on the feedbacks and added another patch
(patch 2) to optimize huge pmd check as recommended by David.

Thanks,
Naoya
