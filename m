Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1KCOB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:01:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:37104 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab1KCOB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:01:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,450,1315206000"; 
   d="scan'208";a="80865370"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] remap-log: fix map generator
Date: Thu,  3 Nov 2011 16:01:50 +0200
Message-Id: <1320328912-15148-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

sorry for re-sending, but I've decided to CC LKML this time because there
may be other people interested in this.

We have found your remap-log tool [1] and started using it - it is very
useful and thank you for sharing it.

I have found a bug in this tool though. I am providing two patches which fix
the bug, but differently. I prefer the first one though.

The code of remap-log is a bit tricky and I am not 100% sure my fixes are
correct. Could you please take a look?

Should we try to make remap-log be part of the kernel? I think linux-next
could use it to compare build logs and bug people about new warnings.

Or should we setup a separate git tree for this tool?

[1] http://thread.gmane.org/gmane.linux.kernel/409379

--
Best Regards,
Artem Bityutskiy
