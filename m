Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab1KEBQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 21:16:51 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36607 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1KEBQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 21:16:50 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>, Jiri Kosina <trivial@kernel.org>
Subject: [PATCH TRIVIAL] MAINTAINERS: Update KVM doc path
Date: Sat,  5 Nov 2011 03:14:20 +0200
Message-Id: <1320455660-20989-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 506fe49..0acdc78 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3732,7 +3732,7 @@ M:	Marcelo Tosatti <mtosatti@redhat.com>
 L:	kvm@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Supported
-F:	Documentation/*/kvm.txt
+F:	Documentation/*/kvm/
 F:	arch/*/kvm/
 F:	arch/*/include/asm/kvm*
 F:	include/linux/kvm*
-- 
1.7.7.2

