Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab1EXLuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 07:50:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45889 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755216Ab1EXLuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 07:50:04 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH] kernel: fix silly warning
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Date: Tue, 24 May 2011 12:35:06 +0100
Message-ID: <20110524113502.18829.44241.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

() should be (void)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 kernel/watchdog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 6e63097..7daa4b0 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -98,7 +98,7 @@ __setup("nosoftlockup", nosoftlockup_setup);
  * the thresholds with a factor: we make the soft threshold twice the amount of
  * time the hard threshold is.
  */
-static int get_softlockup_thresh()
+static int get_softlockup_thresh(void)
 {
 	return watchdog_thresh * 2;
 }

