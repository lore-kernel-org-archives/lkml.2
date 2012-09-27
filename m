Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab2I0Fj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:39:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:38490 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab2I0Fj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:39:26 -0400
X-IronPort-AV: E=Sophos;i="4.80,494,1344182400"; 
   d="scan'208";a="5925252"
From: wency@cn.fujitsu.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH 0/4] bugfix for memory hotplug
Date: Thu, 27 Sep 2012 13:45:01 +0800
Message-Id: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 13:39:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 13:39:35,
	Serialize complete at 2012/09/27 13:39:35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

Wen Congyang (2):
  memory-hotplug: clear hwpoisoned flag when onlining pages
  memory-hotplug: auto offline page_cgroup when onlining memory block
    failed

Yasuaki Ishimatsu (2):
  memory-hotplug: add memory_block_release
  memory-hotplug: add node_device_release

 drivers/base/memory.c |    9 ++++++++-
 drivers/base/node.c   |   11 +++++++++++
 mm/memory_hotplug.c   |    8 ++++++++
 mm/page_cgroup.c      |    3 +++
 4 files changed, 30 insertions(+), 1 deletions(-)

