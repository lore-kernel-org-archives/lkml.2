Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1BTX2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 18:28:38 -0500
Received: from eazy.amigager.de ([213.239.192.238]:50074 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab1BTX2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 18:28:36 -0500
From: Tino Keitel <tino@tikei.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] .gitignore: ignore *.xz files
Date: Mon, 21 Feb 2011 00:28:29 +0100
Message-Id: <1298244509-11484-1-git-send-email-tino@tikei.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel image can now be xz compressed. Ignore such files.

Signed-off-by: Tino Keitel <tino@tikei.de>
---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index 8faa6c0..c0128d3 100644
--- a/.gitignore
+++ b/.gitignore
@@ -29,6 +29,7 @@ modules.builtin
 *.bz2
 *.lzma
 *.lzo
+*.xz
 *.patch
 *.gcno
 
-- 
1.7.2.3

