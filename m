Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1DRW5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 18:57:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:52675 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1DRW5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 18:57:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,236,1301900400"; 
   d="scan'208";a="911338140"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
        mingo@elte.hu
Subject: [RFC PATCHSET] x86, cpu: Clean up and unify the NOP selection infrastructure
Date: Mon, 18 Apr 2011 15:35:57 -0700
Message-Id: <1303166160-10315-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a RFC patchset to clean up and unify the NOP selection.  In
particular, this patchset gets rid of data structures built using
assembly, moves the selection of an atomic 5-byte NOP into the same
infrastructure as everything else, and does some small amount of 32-
vs. 64-bit unification.

Comments appreciated.

	[PATCH 1/3] x86, percpu: Use ASM_NOP4 instead of hardcoding P6_NOP4
	[PATCH 2/3] x86, cpu: Clean up and unify the NOP selection infrastructure
	[PATCH 3/3] x86, cpu: Change NOP selection for certain Intel CPUs
