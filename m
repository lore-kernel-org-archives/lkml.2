Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1AUQkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:40:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:50471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab1AUQkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:40:01 -0500
Date: Fri, 21 Jan 2011 16:39:49 GMT
From: tip-bot for John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1294939849-20608-1-git-send-email-john.stultz@linaro.org>
References: <1294939849-20608-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] rtc: Cleanup removed UIE emulation declaration
Message-ID: <tip-1daeddd5962acad1bea55e524fc0fadf32654a21@git.kernel.org>
Git-Commit-ID: 1daeddd5962acad1bea55e524fc0fadf32654a21
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 Jan 2011 16:39:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1daeddd5962acad1bea55e524fc0fadf32654a21
Gitweb:     http://git.kernel.org/tip/1daeddd5962acad1bea55e524fc0fadf32654a21
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Thu, 13 Jan 2011 09:30:49 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Jan 2011 17:38:18 +0100

rtc: Cleanup removed UIE emulation declaration

rtc_dev_update_irq_enable_emul was removed in commit
042620a018afcfba1d678062b62e463b9e43a68d (UIE emulation is
now handled via hrtimer), but the declaration was missed.
This patch cleans it up.

Signed-off-by: John Stultz <john.stultz@linaro.org>
LKML-Reference: <1294939849-20608-1-git-send-email-john.stultz@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/rtc.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 3c995b4..ea76069 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -235,8 +235,6 @@ extern int rtc_irq_set_freq(struct rtc_device *rtc,
 				struct rtc_task *task, int freq);
 extern int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled);
 extern int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled);
-extern int rtc_dev_update_irq_enable_emul(struct rtc_device *rtc,
-						unsigned int enabled);
 
 void rtc_aie_update_irq(void *private);
 void rtc_uie_update_irq(void *private);
