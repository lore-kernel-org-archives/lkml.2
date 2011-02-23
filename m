Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab1BWFmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:42:46 -0500
Received: from mail.perches.com ([173.55.12.10]:3858 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab1BWFmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:35 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 18/18] MAINTAINERS: Update WINBOND CIR pattern
Date: Tue, 22 Feb 2011 21:42:11 -0800
Message-Id: <ea1ef222215810169e9dd4c29b2e5c03cbd667e1.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 5b2e303f6df1e0b1a903950c5d613a20c8c71a37
("[media] rc-core: convert winbond-cir")
moved the files, update the pattern.

cc: David Härdeman <david@hardeman.nu>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2b4dfa4..c0548be 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6787,7 +6787,7 @@ F:	drivers/scsi/wd7000.c
 WINBOND CIR DRIVER
 M:	David Härdeman <david@hardeman.nu>
 S:	Maintained
-F:	drivers/input/misc/winbond-cir.c
+F:	drivers/media/rc/winbond-cir.c
 
 WIMAX STACK
 M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
-- 
1.7.4.rc3

