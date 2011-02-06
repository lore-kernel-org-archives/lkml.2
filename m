Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1BFUBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:01:10 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:49916 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab1BFUBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:01:09 -0500
Subject: [PATCH] [TRIVIAL] Documentation: default_message_level is a typo
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 06 Feb 2011 21:00:41 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1297022468.1741.1.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's default_message_loglevel, not default_message_level.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/sysctl/kernel.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 11d5ced..36f0075 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -367,7 +367,7 @@ the different loglevels.
 
 - console_loglevel: messages with a higher priority than
   this will be printed to the console
-- default_message_level: messages without an explicit priority
+- default_message_loglevel: messages without an explicit priority
   will be printed with this priority
 - minimum_console_loglevel: minimum (highest) value to which
   console_loglevel can be set
-- 
1.7.4



