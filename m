Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1GKBuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 21:50:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab1GKBuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 21:50:20 -0400
Date: Sun, 10 Jul 2011 21:49:43 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: one more cpufreq fix.
Message-ID: <20110711014942.GA31124@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed Andrew has been carrying this for a little while. This should go into 3.0

	Dave


Please pull from ..
master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq.git/ fixes

 drivers/cpufreq/acpi-cpufreq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 50f4ddd4ff713d2599e2f246775fe2206090126e
Author: Luming Yu <luming.yu@gmail.com>
Date:   Fri Jul 8 16:37:44 2011 -0400

    [CPUFREQ] fix cpumask memory leak in acpi-cpufreq on cpu hotplug.
    
    I came across a memory leak during a cyclic cpu-online-offline test.
    
    Signed-off-by: Yu Luming <luming.yu@intel.com>
    Cc: Len Brown <lenb@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Jones <davej@redhat.com>
