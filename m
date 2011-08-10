Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1HJR31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 13:29:27 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:48793 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1HJR30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 13:29:26 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Arend van Spriel <arend@broadcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Date: Wed, 10 Aug 2011 22:59:17 +0530
Message-Id: <20110810172917.23280.9440.sendpatchset@oc5400248562.ibm.com>
Subject: [PATCH 0/2][cleanup] memcg: renaming of mem variable to memcg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 This is the memcg cleanup patch for that was talked little ago to change the  "struct
 mem_cgroup *mem" variable to  "struct mem_cgroup *memcg".

 The patch is though trivial, it is huge one.
 Testing : Compile tested with following configurations.
 1) CONFIG_CGROUP_MEM_RES_CTLR=y  CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
 2) CONFIG_CGROUP_MEM_RES_CTLR=y  CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n
 3) CONFIG_CGROUP_MEM_RES_CTLR=n  CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n

 Also tested basic mounting with memcgroup.
 Raghu.




