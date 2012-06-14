Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab2FNIYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:24:09 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:39889 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710Ab2FNIYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:24:07 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: apw@canonical.com
Cc: srinivas.kandagatla@st.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3.5.0-rc2] checkpatch:Fix un-necessary whitespace warning.
Date: Thu, 14 Jun 2012 09:16:31 +0100
Message-Id: <1339661791-18185-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch fixes "check spaces before a quoted newline" to consider
only new lines added in the patch, rather than checking all the lines in
the patch.

Without this patch the "check spaces before a quoted newline" will check
all the lines in the patch and throw un-nessary warnings.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e5bd60f..6fdd2a3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1788,7 +1788,7 @@ sub process {
 		}
 
 # check for spaces before a quoted newline
-		if ($rawline =~ /^.*\".*\s\\n/) {
+		if ($rawline =~ /^\+.*\".*\s\\n/) {
 			WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
 			     "unnecessary whitespace before a quoted newline\n" . $herecurr);
 		}
-- 
1.7.0.4

