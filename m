Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab2HTLEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:04:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40851 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab2HTLEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:04:46 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 3/3] MAINTAINERS: update maintain status of FIRMWARE LOADER
Date: Mon, 20 Aug 2012 19:04:17 +0800
Message-Id: <1345460657-24093-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345460657-24093-1-git-send-email-ming.lei@canonical.com>
References: <1345460657-24093-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently firmware loader code has been cleaned up much and
cache/uncache firmware mechanism is introduced, so later
drivers should apply the mechanism to solve the problem
of firmware lost during suspend/resume cycle.

For the sake of helping the related problems, I'd like to
volunteer to maintain the code and help on drivers' related
problem, so update the item.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 MAINTAINERS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fb87989..cafa5e3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2858,7 +2858,9 @@ F:	include/linux/firewire*.h
 F:	tools/firewire/
 
 FIRMWARE LOADER (request_firmware)
-S:	Orphan
+M:	Ming Lei <ming.lei@canonical.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
 F:	Documentation/firmware_class/
 F:	drivers/base/firmware*.c
 F:	include/linux/firmware.h
-- 
1.7.9.5

