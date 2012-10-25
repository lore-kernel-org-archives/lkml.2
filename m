Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946174Ab2JYPOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:14:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946074Ab2JYPN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:13:59 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi.kleen@intel.com>, Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Akira Fujita <a-fujita@rs.jp.nec.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org
Subject: [PATCH 0/3] HWPOISON: improve error_remove_page()
Date: Thu, 25 Oct 2012 11:12:46 -0400
Message-Id: <1351177969-893-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset does two things:
- logs file information to help users estimate memory error's impact, and
- adds ext[34]_error_remove_page() to use ext[34]-specific error handling code.

Any comments are welcomed.

Thanks,
Naoya
