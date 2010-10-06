Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab0JFU5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:57:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56255 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759477Ab0JFU5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:57:34 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com,
        x86@kernel.org
Subject: HWPOISON huge page signal fixes
Date: Wed,  6 Oct 2010 22:57:19 +0200
Message-Id: <1286398641-11862-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix the address granuality reporting for hugepage
hwpoison errors. This requires some straight forward changes
in the MM (to return this information from handle_mm_fault)
and in the x86 fault handler (to pass this information on)

Any reviews and acks appreciated.

I plan to carry this in my tree for now. Targetted for 2.6.37

Thanks,
-Andi

