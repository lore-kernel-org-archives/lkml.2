Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1E2Pat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 11:30:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64282 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1E2Pas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 11:30:48 -0400
Date: Sun, 29 May 2011 08:30:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: gpio: gpio-exynos4 build fails in mainline
Message-Id: <20110529083032.d3d16059.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090202.4DE266A3.0090:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

probably should depend on ARM or some ARM sub-arch/mach-type?


drivers/gpio/gpio-exynos4.c:18:11: error: unable to open 'mach/map.h'


on x86_64

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
