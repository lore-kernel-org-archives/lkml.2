Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab1FNAHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 20:07:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab1FNAHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 20:07:50 -0400
Date: Mon, 13 Jun 2011 20:07:15 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: cpufreq pull request.
Message-ID: <20110614000715.GA3018@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from ..
master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq.git/ fixes

 MAINTAINERS                     |    1 -
 drivers/cpufreq/cpufreq_stats.c |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

commit 13f067537f34456443f61c950cd6dc37d1d5f3ee
Author: Dave Jones <davej@redhat.com>
Date:   Sun Jun 12 16:35:28 2011 -0400

    [CPUFREQ] Remove cpufreq_stats sysfs entries on module unload.
    
    cpufreq_stats leaves behind its sysfs entries, which causes a panic
    when something stumbled across them.
    (Discovered by unloading cpufreq_stats while powertop was loaded).
    
    Signed-off-by: Dave Jones <davej@redhat.com>
    Cc: stable@kernel.org

commit 89b882a25e703b72c3e84c582357e3e864d8ccca
Author: Joe Perches <joe@perches.com>
Date:   Wed Jun 1 10:59:10 2011 -0700

    MAINTAINERS: Update CPU FREQUENCY patterns
    
    Commit bb0a56ecc4ba ("[CPUFREQ] Move x86 drivers to drivers/cpufreq/")
    moved the files, remove the old pattern.
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Dave Jones <davej@redhat.com>
