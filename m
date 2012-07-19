Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab2GSF6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 01:58:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:47108 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2GSF6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 01:58:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="194848089"
From: Chen Gong <gong.chen@linux.intel.com>
To: tglx@linutronix.de
Cc: tony.luck@intel.com, bp@amd64.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 0/5 V2] x86: mce: Bugfixes, cleanups and a new CMCI poll version
Date: Thu, 19 Jul 2012 13:59:36 -0400
Message-Id: <1342720781-4729-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/5] x86: mce: Disable preemption when calling raise_local()
[PATCH 2/5] x86: mce: Serialize mce injection
[PATCH 3/5] x86: mce: Split timer init
[PATCH 4/5] x86: mce: Remove the frozen cases in the hotplug code
[PATCH 5/5] x86: mce: Add cmci poll mode

The following series fixes a few interesting bugs (found by review in
context of the CMCI poll effort) and a cleanup to the timer/hotplug
code followed by a consolidated version of the CMCI poll
implementation. This series is based on Linus' tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Thanks Boris to point out how to use git to commit correct authorship :-).
