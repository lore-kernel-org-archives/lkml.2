Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2BTOcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 09:32:07 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:52565
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2BTOcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 09:32:06 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 0/2] Fix typo in staging 
Date: Mon, 20 Feb 2012 23:31:29 +0900
Message-Id: <1329748291-1768-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 2 typo "scaning" and "erorr" in files within staging tree.

Masanari Iida (2):
  [trivial] staging: Fix typo in unioxx5.c
  [trivial] staging: Fix typo in bssdb.c

 drivers/staging/comedi/drivers/unioxx5.c |    2 +-
 drivers/staging/vt6655/bssdb.c           |    4 ++--
 drivers/staging/vt6656/bssdb.c           |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

-- 
1.7.6.5

