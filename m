Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2JaHEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:04:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50830 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab2JaHD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:03:59 -0400
X-IronPort-AV: E=Sophos;i="4.80,686,1344182400"; 
   d="scan'208";a="6106418"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: [PART2 Patch] some cleanups
Date: Wed, 31 Oct 2012 14:55:27 +0800
Message-Id: <1351666528-8226-1-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 14:48:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 14:49:05,
	Serialize complete at 2012/10/31 14:49:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

This patch is part2 of the following patchset:
    https://lkml.org/lkml/2012/10/29/319

Part1 is here:
    https://lkml.org/lkml/2012/10/31/30

This patch only does some cleanup, and no logic change. It can be applied
without the other parts.

Lai Jiangshan (1):
  node: cleanup node_state_attr

 drivers/base/node.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

-- 
1.8.0

