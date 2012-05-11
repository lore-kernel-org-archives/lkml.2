Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab2EKSla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:41:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab2EKSl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:41:27 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/3] x86, reboot: Modify shutting down cpus
Date: Fri, 11 May 2012 14:41:12 -0400
Message-Id: <1336761675-24296-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set breaks apart my earlier attempt to modify shutting
down cpus during panic into a simple revert and a new patch.  This
makes it easier to follow the changes I am doing.

Don Zickus (3):
  Revert "x86, reboot: Use NMI instead of REBOOT_VECTOR to stop cpus"
  x86, reboot: use NMI to assist in shutting down if IRQ fails
  x86, reboot:  Update nonmi_ipi parameter

 arch/x86/kernel/smp.c |  100 ++++++++++++++++++++++--------------------------
 1 files changed, 46 insertions(+), 54 deletions(-)

-- 
1.7.7.6

