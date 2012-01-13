Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab2AMPzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:55:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:1497 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758374Ab2AMPze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:55:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95530484"
From: Alex Shi <alex.shi@intel.com>
To: linux-kernel@vger.kernel.org, cl@gentwo.org, eric.dumazet@gmail.com,
        tglx@linutronix.de, avi@redhat.com, akpm@linux-foundation.org,
        davem@davemloft.net, kaber@trash.net, a.p.zijlstra@chello.nl,
        ying.huang@intel.com, konrad.wilk@oracle.com, hpa@zytor.com,
        jeremy@goop.org
Subject: [PATH v2 0/5] Code clean up for percpu_xxx serial functions 
Date: Fri, 13 Jan 2012 23:53:33 +0800
Message-Id: <1326470018-22342-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am sorry for spelling mistaken on konrad's email address, so resend
for correct this. Please reply this resend email. 

---------------
Thanks for TJ's suggestion, I split the serial patch smaller for
potential bisection convenience.

Compare to v1 patch, this v2 patches has separate function replace
patches and final dead code clean up patch. 

The net, xen and x86 part code are independent. 

After each part was accepted in kernel, the final(5th) clean up code
do the real clean up in next merge window. I will refresh the patch
at that time. 

Any further comments are appreciated!

Regards
Alex 

