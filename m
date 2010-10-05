Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab0JEIqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:46:32 -0400
Received: from smtp.nokia.com ([192.100.122.230]:41404 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab0JEIqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:46:31 -0400
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: tony@atomide.com
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        khilman@deeprootsystems.com, akpm@linux-foundation.org, zmc@lurian.net,
        a.j.buxton@gmail.com, ext-eugeny.kuznetsov@nokia.com
Subject: [PATCH 0/1] omap: Ptr "isr_reg" tracked as NULL was dereferenced
Date: Tue,  5 Oct 2010 12:42:09 +0400
Message-Id: <cover.1286261378.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 05 Oct 2010 08:45:43.0691 (UTC) FILETIME=[B25C05B0:01CB6469]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is patch which fixes bug in /arch/arm/plat-omap/gpio.c file.
Pointer which may have NULL value in some cases (depend on kernel
configuration and GPIO method) is dereferenced later in code.
If pointer is NULL it mean some kernel bug.

Thanks,
Best Regards,
Evgeny

Evgeny Kuznetsov (1):
  omap: Ptr "isr_reg" tracked as NULL was dereferenced

 arch/arm/plat-omap/gpio.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

