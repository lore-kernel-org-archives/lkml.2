Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab2IYCC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 22:02:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48920 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2IYCCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 22:02:54 -0400
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jbacik@fusionio.com, dave@jikos.cz,
        linuxram@linux.vnet.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [resend][PATCH v2 0/2] btrfs-progs: some bugfixes 
Date: Tue, 25 Sep 2012 10:02:14 +0800
Message-Id: <1348538536-29838-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092502-2876-0000-0000-000000738EC5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Some misc bugs are found when i work on other tasks.
Now send out them for interview, thanks.

Zhi Yong Wu (2):
  btrfs-progs: Close file descriptor on exit
  btrfs-progs: Fix up memory leakage

 cmds-filesystem.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

-- 
1.7.6.5

