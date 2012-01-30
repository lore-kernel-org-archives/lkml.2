Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2A3REg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:04:36 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54636 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2A3REf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:04:35 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] selftests: Make run_tests executable
Date: Mon, 30 Jan 2012 18:04:29 +0100
Message-Id: <1327943069-28048-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the main script that launches the tests to
become executable. Otherwise people need to launch
it as an argument to a new bash instance.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/run_tests

diff --git a/tools/testing/selftests/run_tests b/tools/testing/selftests/run_tests
old mode 100644
new mode 100755
-- 
1.7.5.4

