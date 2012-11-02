Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152Ab2KBQdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:33:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758863Ab2KBQdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:33:38 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Tony Luck <tony.luck@intel.com>, Andi Kleen <andi.kleen@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/2] HWPOISON: improve logging
Date: Fri,  2 Nov 2012 12:33:11 -0400
Message-Id: <1351873993-9373-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

These 2 patches fix or add the kernel messages which help users to
know what kind of pages are hit by errors and/or how the impact is.

Originally these were posted as part of patchsets which are pending
due to unsolved issues, but these are simple enough and related only
to memory error handling (no change on IO error handling,) so I think
these 2 can be separated from whole things and go into mainline first.

Thanks,
Naoya
