Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab2FFV1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:27:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:52058 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab2FFV1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:27:15 -0400
Message-Id: <20120606211746.693649684@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jun 2012 21:27:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <borislav.petkov@amd.com>,
        Chen Gong <gong.chen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 0/6] x86: mce: Bugfixes, cleanups and a new CMCI poll version
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes a few interesting bugs (found by review in
context of the CMCI poll effort) and a cleanup to the timer/hotplug
code followed by a consolidated version of the CMCI poll
implementation. This series is based on

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

which contains the bugfix for the dropped timer interval init.

Thanks,

	tglx

