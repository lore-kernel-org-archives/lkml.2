Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab1BWFme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:42:34 -0500
Received: from mail.perches.com ([173.55.12.10]:3853 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab1BWFma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:30 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/18] MAINTAINERS: Remove ASOC CODEC DRIVERS files not in tree
Date: Tue, 22 Feb 2011 21:41:56 -0800
Message-Id: <b72c1e7aee0794004f96ed8fae7e65c58efe7b0d.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove these patterns until such files are actually in the tree.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3c22026..920d8d3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -523,8 +523,6 @@ L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://wiki.analog.com/
 S:	Supported
 F:	sound/soc/codecs/ad1*
-F:	sound/soc/codecs/adau*
-F:	sound/soc/codecs/adav*
 F:	sound/soc/codecs/ssm*
 
 ANALOG DEVICES INC ASOC DRIVERS
-- 
1.7.4.rc3

