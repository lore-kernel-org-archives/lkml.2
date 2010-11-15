Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab0KODLK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:11:10 -0500
Received: from mail.perches.com ([173.55.12.10]:1186 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932749Ab0KODFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:41 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/44] drivers/s390/net: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:40 -0800
Message-Id: <ea09773876fb36a52a9a750110b381d20767ac12.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/s390/net/qeth_core_sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index 42fa783..b5e967c 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -372,7 +372,7 @@ static ssize_t qeth_dev_performance_stats_store(struct device *dev,
 	i = simple_strtoul(buf, &tmp, 16);
 	if ((i == 0) || (i == 1)) {
 		if (i == card->options.performance_stats)
-			goto out;;
+			goto out;
 		card->options.performance_stats = i;
 		if (i == 0)
 			memset(&card->perf_stats, 0,
-- 
1.7.3.1.g432b3.dirty

