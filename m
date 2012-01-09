Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab2AIAnO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 19:43:14 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:9406 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab2AIAnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 19:43:13 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-1d-4f0a381c5ffe
From: Kukjin Kim <kgene.kim@samsung.com>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, "'Linus'" <torvalds@linux-foundation.org>,
        linux-samsung-soc@vger.kernel.org
Subject: Build error at drivers/base/power/domain_governor.c when PM_RUNTIME is
 not set
Date: Mon, 09 Jan 2012 09:43:06 +0900
Message-id: <018a01ccce67$a6eee850$f4ccb8f0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczOZ6bOR5gUvfpQTgG6NXVINC9Awg==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

This is just reporting of build error.

Current mainline happens build error at drivers/base/power/domain_governor.c
file like following when CONFIG_PM_RUNTIME is not set. For example, it
happens with s3c6400_defconfig now.

drivers/base/power/domain_governor.c: In function 'default_stop_ok':
drivers/base/power/domain_governor.c:25: error: 'struct dev_pm_info' has no
member named 'max_time_suspended_ns'
drivers/base/power/domain_governor.c:29: error: 'struct dev_pm_info' has no
member named 'max_time_suspended_ns'
drivers/base/power/domain_governor.c: In function 'default_power_down_ok':
drivers/base/power/domain_governor.c:94: error: 'struct dev_pm_info' has no
member named 'max_time_suspended_ns'
drivers/base/power/domain_governor.c:98: error: 'struct dev_pm_info' has no
member named 'max_time_suspended_ns'
drivers/base/power/domain_governor.c:100: error: 'struct dev_pm_info' has no
member named 'suspend_time'

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

