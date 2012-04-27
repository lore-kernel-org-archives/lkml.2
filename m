Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab2D0HlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:41:22 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:55287 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2D0HlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:41:21 -0400
Message-ID: <4F9A4D9B.6080302@linux.vnet.ibm.com>
Date: Fri, 27 Apr 2012 15:41:15 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Paul Turner <pjt@google.com>, Dhaval Giani <dhaval.giani@gmail.com>
Subject: [PATCH 0/2] linsched: add the ability of setting proc parameters
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12042707-5564-0000-0000-00000260E02E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add the ability of setting proc parameters to linsched.
Currently only support few parameter, we can set the value in:
tools/linsched/tests/proc.conf

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 b/arch/linsched/kernel/misc.c     |    3 --
 b/tools/linsched/Makefile.inc     |    3 +-
 b/tools/linsched/linsched_proc.c  |   46 ++++++++++++++++++++++++++++++++++++++
 b/tools/linsched/linsched_proc.h  |    6 ++++
 b/tools/linsched/linux_linsched.c |    1 
 b/tools/linsched/tests/proc.conf  |    5 ++++
 tools/linsched/linux_linsched.c   |   30 ++++++++++++++++++++++++
 7 files changed, 90 insertions(+), 4 deletions(-)

