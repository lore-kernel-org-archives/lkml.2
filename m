Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031216Ab2EROKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:10:15 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61499 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031199Ab2EROKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:10:11 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC V2 1/6] time: remove obsolete declaration
Date: Fri, 18 May 2012 16:09:53 +0200
Message-Id: <63e00aa3b2255efae9e974b5d2154d4a2510156c.1337348892.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <cover.1337348892.git.richardcochran@gmail.com>
References: <cover.1337348892.git.richardcochran@gmail.com>
In-Reply-To: <cover.1337348892.git.richardcochran@gmail.com>
References: <cover.1337348892.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function, timekeeping_leap_insert, was removed in commit
6b43ae8a619d17c4935c3320d2ef9e92bdeed05d

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 include/linux/time.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 33a92ea..179f4d6 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -167,7 +167,6 @@ extern void get_monotonic_boottime(struct timespec *ts);
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
-extern void timekeeping_leap_insert(int leapsecond);
 extern int timekeeping_inject_offset(struct timespec *ts);
 
 struct tms;
-- 
1.7.2.5

