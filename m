Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab2CFQMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:12:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38974 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2CFQMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:12:19 -0500
Date: Tue, 6 Mar 2012 08:11:34 -0800
From: tip-bot for Mika Westerberg <mika.westerberg@linux.intel.com>
Message-ID: <tip-gyrbptvkozsbp2yk3ssu084o@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, alan@linux.intel.com,
        hpa@zytor.com, mingo@redhat.com, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org, mika.westerberg@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        mjg@redhat.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mika.westerberg@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/mid/thermal: Add msic_thermal alias
Git-Commit-ID: 634830704d80ee0f544c16ea3c19dd2e819d2256
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Mar 2012 08:12:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  634830704d80ee0f544c16ea3c19dd2e819d2256
Gitweb:     http://git.kernel.org/tip/634830704d80ee0f544c16ea3c19dd2e819d2256
Author:     Mika Westerberg <mika.westerberg@linux.intel.com>
AuthorDate: Mon, 5 Mar 2012 15:01:03 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Mar 2012 09:01:25 +0100

x86/mid/thermal: Add msic_thermal alias

This device is called "msic_thermal" instead of "msic_sensor" on
actual boards so rename it.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[ Updated to rename rather than add an entry as er discussion with Mika & Durgadoss R]
Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-gyrbptvkozsbp2yk3ssu084o@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/platform/x86/intel_mid_thermal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/intel_mid_thermal.c b/drivers/platform/x86/intel_mid_thermal.c
index d824a71..5917b3c 100644
--- a/drivers/platform/x86/intel_mid_thermal.c
+++ b/drivers/platform/x86/intel_mid_thermal.c
@@ -543,7 +543,7 @@ static int mid_thermal_remove(struct platform_device *pdev)
 	return configure_adc(0);
 }
 
-#define DRIVER_NAME "msic_sensor"
+#define DRIVER_NAME "msic_thermal"
 
 static const struct platform_device_id therm_id_table[] = {
 	{ DRIVER_NAME, 1 },
