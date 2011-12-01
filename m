Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab1LAJd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:33:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36557 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab1LAJd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:33:27 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/2] checkpatch: fix up complex macros context format
Date: Thu,  1 Dec 2011 09:33:00 +0000
Message-Id: <1322731981-22130-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a missing newline and correctly use the raw context for the
complex macro report.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

This could be considered to be a fix for:
  checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context.patch

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e29eeea..331e832 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2854,7 +2854,7 @@ sub process {
 					      "Macros with multiple statements should be enclosed in a do - while loop\n" . "$herectx");
 				} else {
 					ERROR("COMPLEX_MACRO",
-					      "Macros with complex values should be enclosed in parenthesis\n" . "$here$ctx");
+					      "Macros with complex values should be enclosed in parenthesis\n" . "$herectx");
 				}
 			}
 		}
-- 
1.7.5.4

