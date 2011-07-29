Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1G2BtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 21:49:02 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16200 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab1G2BtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 21:49:00 -0400
X-AuditID: cbfee61a-b7cf0ae000006bc6-16-4e32118a7f57
Date: Fri, 29 Jul 2011 10:48:46 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: Question about "Inconsistent kallsyms data"
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <rmk@arm.linux.org.uk>
Message-id: <02ae01cc4d91$aed71670$0c854350$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcxNkadJndpsXyTiSgyzJNozxjI9bw==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

When build with s5pc100_defconfig, happens following.

...
KSYM    .tmp_kallsyms2.S
AS      .tmp_kallsyms2.o
LD      vmlinux
SYSMAP  System.map
SYSMAP  .tmp_System.map
Inconsistent kallsyms data
This is a bug - please report about it
Try make KALLSYMS_EXTRA_PASS=1 as a workaround
make[1]: *** [vmlinux] Error 1
make: *** [sub-make] Error 2

Its HEAD is following (current latest mainline)
(commit 55f9c40ff632d03c527d6a6ceddcda0a224587a6)
Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc

Please kindly let me know how it should be fixed...

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

