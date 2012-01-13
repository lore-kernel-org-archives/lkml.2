Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab2AMPrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:47:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:62653 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab2AMPrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:47:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="96168438"
From: Alex Shi <alex.shi@intel.com>
To: linux-kernel@vger.kernel.org, cl@gentwo.org, eric.dumazet@gmail.com,
        tglx@linutronix.de, avi@redhat.com, akpm@linux-foundation.org,
        davem@davemloft.net, kaber@trash.net, a.p.zijlstra@chello.nl,
        ying.huang@intel.com, honrad.wilk@oracle.com, hpa@zytor.com,
        jeremy@goop.org
Subject: [PATH v2 0/5] Code clean up for percpu_xxx serial functions
Date: Fri, 13 Jan 2012 23:45:15 +0800
Message-Id: <1326469520-21239-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compare to v1 patch, this v2 patches has separate function replace
patches and final dead code clean up patch. 

The net, xen and x86 part code are independent. 

After each part was accepted in kernel, the final(5th) clean up code
do the real clean up in next merge window. I will refresh the patch
at that time. 

Any further comments are appreciated!

Regards
Alex 
