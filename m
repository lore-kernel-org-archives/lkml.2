Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab0HYIJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 04:09:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35081 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab0HYIJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 04:09:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 25 Aug 2010 17:04:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-mm@kvack.org
Cc: "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "menage@google.com" <menage@google.com>,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: [PATCH 0/5] memcg: towards I/O aware memcg v6.
Message-Id: <20100825170435.15f8eb73.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is v6. Thank you all for kindly reviews.

Major changes from v5 is
 a) changed ID allocation logic. Maybe much clearer than v6.
 b) fixed typos and bugs.

Patch brief view:
 1. changes css ID allocation in kernel/cgroup.c
 2. use ID-array in memcg.
 3. record ID to page_cgroup rather than pointer.
 4. make update_file_mapped to be RCU aware routine instead of spinlock.
 5. make update_file_mapped as general-purpose function.


Thanks,
-Kame

