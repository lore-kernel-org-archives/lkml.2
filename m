Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab1EZLiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:38:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:57296 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344Ab1EZLiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:38:01 -0400
From: GuanXuetao <gxt@mprc.pku.edu.cn>
To: arnd@arndb.de
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] unicore32: change PERCPU to PERCPU_SECTION
Date: Thu, 26 May 2011 11:36:57 +0000
Message-Id: <82f1e7bdd9b81c5d1a807ab82d7037fa63492a7a.1306408804.git.gxt@mprc.pku.edu.cn>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 May 2011 11:37:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <gxt@mprc.pku.edu.cn>

see commit from Tejun Heo <0415b00d175e0d8945e6785aad21b5f157976ce0>
  percpu: Always align percpu output section to PAGE_SIZE

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/kernel/vmlinux.lds.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/unicore32/kernel/vmlinux.lds.S b/arch/unicore32/kernel/vmlinux.lds.S
index 9bf7f7a..77e407e 100644
--- a/arch/unicore32/kernel/vmlinux.lds.S
+++ b/arch/unicore32/kernel/vmlinux.lds.S
@@ -30,7 +30,7 @@ SECTIONS
 	HEAD_TEXT_SECTION
 	INIT_TEXT_SECTION(PAGE_SIZE)
 	INIT_DATA_SECTION(16)
-	PERCPU(L1_CACHE_BYTES, PAGE_SIZE)
+	PERCPU_SECTION(L1_CACHE_BYTES)
 	__init_end = .;
 
 	_stext = .;
-- 
1.7.5.2

