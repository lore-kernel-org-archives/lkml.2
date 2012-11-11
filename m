Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab2KJNsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 08:48:51 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34306 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2KJNss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 08:48:48 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>, Jon Masters <jonathan@jonmasters.org>,
        Jon Masters <jcm@redhat.com>
Subject: [PATCH update 0/3] HW-latency: hardware latency test 0.10
Date: Sat, 10 Nov 2012 21:48:19 -0500
Message-Id: <1352602102-2390-1-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the previous patch series to ACK all comments I've recevied so far
for the tool: e.g. 1.Acked Jon Masters in source code as many code are from
jcm, thanks very much Jon. 2. squashed all changes against new file I added into
one. 3. Make it useful on non-x86.

Please review and commit to misc tree. I will update the patch series if anyone
has anymore comments.

Thanks very much!!!
 
Luming Yu (3):
  HW-latency: hardware latency test 0.10
  x86: Delete too many "Fast TSC .." in dmesg from HW_latency cyclic
    sampling
  fs: Fix crash caused by write to dummy debugfs interface like
    HW_latency exposed

 arch/x86/kernel/tsc.c          |   2 +-
 drivers/misc/Kconfig           |   6 +
 drivers/misc/Makefile          |   1 +
 drivers/misc/hw_latency_test.c | 939 +++++++++++++++++++++++++++++++++++++++++
 fs/libfs.c                     |   2 +-
 5 files changed, 948 insertions(+), 2 deletions(-)
 create mode 100644 drivers/misc/hw_latency_test.c

-- 
1.7.12.1

