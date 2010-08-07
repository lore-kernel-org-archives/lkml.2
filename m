Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab0HGP05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 11:26:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:32917 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab0HGP0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 11:26:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=MIcgTaRzMapzdfkp04J5hZXuSaOfPIG6SNRpv06YVFlVdnfEAoDY8bIYRGv0E5HrEy
         zq5pQEo+bOznk90sqBi84Opx5W4hHNvvUiS32JbqNTV5Bf5ypmLtbhyB7SB0mU4h5A0g
         zOPP2dNL/geNXxNCCbWWAw8DWS/r9YhuCxTug=
From: Namhyung Kim <namhyung@gmail.com>
To: tj@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] percpu: add missing markup in mm/memcontrol.c
Date: Sun,  8 Aug 2010 00:26:52 +0900
Message-Id: <1281194812-18052-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup->stat is a percpu pointer but was missing __percpu markup.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 20a8193..edf5011 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -252,7 +252,7 @@ struct mem_cgroup {
 	/*
 	 * percpu counter.
 	 */
-	struct mem_cgroup_stat_cpu *stat;
+	struct mem_cgroup_stat_cpu __percpu *stat;
 };
 
 /* Stuffs for move charges at task migration. */
-- 
1.7.0.4

