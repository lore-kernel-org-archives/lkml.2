Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2DPDiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 23:38:21 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:55580 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab2DPDiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 23:38:13 -0400
Message-ID: <4F8B9406.9080204@linux.vnet.ibm.com>
Date: Mon, 16 Apr 2012 11:37:42 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Paul Turner <pjt@google.com>, Dhaval Giani <dhaval.giani@gmail.com>
Subject: [RFC PATCH 0/4] linsched: fix issues to make the test results more
 accurately
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12041603-2000-0000-0000-0000071F1B5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fix some issues in the main loop of linsched, help
it to behave more like the real world, in order to make the test
results accurately.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 b/arch/linsched/kernel/irq.c |    4 ++++
 b/tools/linsched/hrtimer.c   |    1 -
 b/tools/linsched/numa.c      |    4 ++++
 tools/linsched/hrtimer.c     |   33 ++++++++++++++++++++++++++++++++-
 4 files changed, 40 insertions(+), 2 deletions(-)

