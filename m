Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0FLBHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 21:07:01 -0400
Received: from mail.perches.com ([173.55.12.10]:1069 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab0FLBG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 21:06:58 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH 1/7] MAINTAINERS: Add patterns to CRYPTOGRAPHIC RANDOM NUMBER GENERATOR
Date: Fri, 11 Jun 2010 18:06:50 -0700
Message-Id: <200585bc27751483190333590cdb3db1ffe51244.1276304638.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1276304638.git.joe@perches.com>
References: <cover.1276304638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 55ad815..aa236b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1722,6 +1722,8 @@ CRYPTOGRAPHIC RANDOM NUMBER GENERATOR
 M:	Neil Horman <nhorman@tuxdriver.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
+F:	crypto/ansi_cprng.c
+F:	crypto/rng.c
 
 CS5535 Audio ALSA driver
 M:	Jaya Kumar <jayakumar.alsa@gmail.com>
-- 
1.7.1.244.gbdc4

