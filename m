Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab2GQPzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:55:40 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34368 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2GQPzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:55:38 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 2/2] [trivial] tools: testing: Fix typo in tools
Date: Wed, 18 Jul 2012 00:56:18 +0900
Message-Id: <1342540578-8830-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.11.2.194.g7bdb748
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in tools/testing.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 tools/testing/ktest/examples/include/defaults.conf |    2 +-
 tools/testing/ktest/examples/include/tests.conf    |    2 +-
 tools/testing/selftests/vm/run_vmtests             |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/ktest/examples/include/defaults.conf b/tools/testing/ktest/examples/include/defaults.conf
index 323a552..63a1a83 100644
--- a/tools/testing/ktest/examples/include/defaults.conf
+++ b/tools/testing/ktest/examples/include/defaults.conf
@@ -33,7 +33,7 @@ DEFAULTS
 THIS_DIR := ${PWD}
 
 
-# to orginize your configs, having each machine save their configs
+# to organize your configs, having each machine save their configs
 # into a separate directly is useful.
 CONFIG_DIR := ${THIS_DIR}/configs/${MACHINE}
 
diff --git a/tools/testing/ktest/examples/include/tests.conf b/tools/testing/ktest/examples/include/tests.conf
index 4fdb811..60cedb1 100644
--- a/tools/testing/ktest/examples/include/tests.conf
+++ b/tools/testing/ktest/examples/include/tests.conf
@@ -47,7 +47,7 @@ BUILD_NOCLEAN = 1
 # Build, install, boot and test with a randconfg 10 times.
 # It is important that you have set MIN_CONFIG in the config
 # that includes this file otherwise it is likely that the
-# randconfig will not have the neccessary configs needed to
+# randconfig will not have the necessary configs needed to
 # boot your box. This version of the test requires a min
 # config that has enough to make sure the target has network
 # working.
diff --git a/tools/testing/selftests/vm/run_vmtests b/tools/testing/selftests/vm/run_vmtests
index 8b40bd5..4c53cae 100644
--- a/tools/testing/selftests/vm/run_vmtests
+++ b/tools/testing/selftests/vm/run_vmtests
@@ -36,7 +36,7 @@ mkdir $mnt
 mount -t hugetlbfs none $mnt
 
 echo "--------------------"
-echo "runing hugepage-mmap"
+echo "running hugepage-mmap"
 echo "--------------------"
 ./hugepage-mmap
 if [ $? -ne 0 ]; then
@@ -50,7 +50,7 @@ shmall=`cat /proc/sys/kernel/shmall`
 echo 268435456 > /proc/sys/kernel/shmmax
 echo 4194304 > /proc/sys/kernel/shmall
 echo "--------------------"
-echo "runing hugepage-shm"
+echo "running hugepage-shm"
 echo "--------------------"
 ./hugepage-shm
 if [ $? -ne 0 ]; then
@@ -62,7 +62,7 @@ echo $shmmax > /proc/sys/kernel/shmmax
 echo $shmall > /proc/sys/kernel/shmall
 
 echo "--------------------"
-echo "runing map_hugetlb"
+echo "running map_hugetlb"
 echo "--------------------"
 ./map_hugetlb
 if [ $? -ne 0 ]; then
-- 
1.7.4.4

