Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1LLWlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:41:06 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63049 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1LLWlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:41:02 -0500
Message-ID: <4EE682F3.9070905@gmail.com>
Date: Mon, 12 Dec 2011 23:40:51 +0100
From: roel <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        moderated for non-subscribers <ocfs2-devel@oss.oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ocfs2: Misplaced parens in unlikley
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misplaced parentheses

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/ocfs2/dlmglue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 81a4cd2..274529c 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -456,7 +456,7 @@ static void ocfs2_update_lock_stats(struct ocfs2_lock_res *res, int level,
 	stats->ls_gets++;
 	stats->ls_total += ktime_to_ns(kt);
 	/* overflow */
-	if (unlikely(stats->ls_gets) == 0) {
+	if (unlikely(stats->ls_gets == 0)) {
 		stats->ls_gets++;
 		stats->ls_total = ktime_to_ns(kt);
 	}
