Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1LSSiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 13:38:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab1LSSiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 13:38:15 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [RFC][PATCH 0/3] pagemap handles transparent hugepage
Date: Mon, 19 Dec 2011 13:38:36 -0500
Message-Id: <1324319919-31720-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Transparent hugepage (thp) splits itself when kernel cannot work on it
in hugepage unit. Thp split can reduce performance merit of thp, so we
are now making efforts to handle thp as it is if possible.
As one of such efforts, I suggest to make pagemap aware of thp.

Could you review and comment on them?

Thanks,
Naoya
