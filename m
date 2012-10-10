Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab2JJH3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 03:29:10 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:43433 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab2JJH3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 03:29:05 -0400
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: [RESEND PATCH v1 0/3] cpuidle: (pSeries) pseries idle driver fixes. 
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Date: Wed, 10 Oct 2012 12:59:00 +0530
Message-ID: <20121010072859.29317.71472.stgit@deepthi.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12101007-5140-0000-0000-0000022F150D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series consists of a bunch of fixes for 
cpuidle back-end driver for ppc64 (pSeries) platform.

The series applies on 3.6-rc7 and has been tested on ppc64 pSeries
POWER7 system with snooze and nap states.

With these fixes, avg idle residency for nap on 50 percent idle system
increased from 96 to 99.4 percent and idle residency for snooze for
the same decreased from 4 to 0.6 percent, determined running spec power
benchmark runs.

 Deepthi Dharwar (3):
      cpuidle: (POWER) Fix snooze state problem persistant in the current cpuidle design on pseries.
      cpuidle: (POWER) Fix smt_snooze_delay functionality.
      cpuidle: (POWER) Fix target residency initialisation in pseries cpuidle


  arch/powerpc/include/asm/processor.h            |    4 +
 arch/powerpc/kernel/sysfs.c                     |    2 -
 arch/powerpc/platforms/pseries/processor_idle.c |   62 +++++++++++------------
 3 files changed, 32 insertions(+), 36 deletions(-)


-- Deepthi

