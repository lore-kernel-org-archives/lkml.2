Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab1ASWDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:03:03 -0500
Received: from zfrontend2.aha.ru ([195.2.83.148]:45401 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753508Ab1ASWDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:03:01 -0500
From: "werner" <w.landgraf@ru.ru>
Subject: 
To: aarcange@redhat.com, bp@amd64.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Wed, 19 Jan 2011 18:02:56 -0400
Message-ID: <web-442704529@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Only for your information, after the crash report, I 
recompiled the kernel with switching off HUGEPAGE, and 
then it runs normally.  This means, that the problem 
really was caused by khugepaged, not by any other change 
from 2.6.37 to 2.6.38-rc1 .  Below I dont give the whole 
configure file, but only that part where is the difference 
(the line marked as comment)

I didnt yet try any patch.

wl


  ...
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
---
Professional hosting for everyone - http://www.host.ru
