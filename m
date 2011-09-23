Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab1IWBP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 21:15:27 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:37279 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1IWBP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 21:15:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-127.messagelabs.com!1316740520!32530569!17
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/page_cgroup.c: quiet sparse noise
Date: Thu, 22 Sep 2011 18:15:08 -0700
User-Agent: KMail/1.9.9
CC: <linux-mm@kvack.org>, <containers@lists.linux-foundation.org>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>, <bsingharora@gmail.com>,
        <nishimura@mxp.nes.nec.co.jp>, <kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109221815.08891.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite the sparse noise:

warning: symbol 'swap_cgroup_ctrl' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 6bdc67d..eead840 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -357,7 +357,7 @@ struct swap_cgroup_ctrl {
 	spinlock_t	lock;
 };
 
-struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
+static struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
 
 struct swap_cgroup {
 	unsigned short		id;
