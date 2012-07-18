Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab2GRKgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:36:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab2GRKgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:36:12 -0400
From: Thomas Renninger <trenn@suse.de>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, initramfs@vger.kernel.org,
        bigeasy@linutronix.de
Subject: Early initrd file overwrite and ACPI table override making use of it
Date: Wed, 18 Jul 2012 12:36:02 +0200
Message-Id: <1342607764-66747-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
another attempt, this time making use of cpio encapsulation
of early files as discussed.
Would be great if this can get committed to the branch you created
and get queued for 3.6-rc1 mainline inclusion.

It is based on Linus' master branch on top of:
commit 8c84bf4166a4698296342841a549bbee03860ac0
Merge: bd0a521 5db9a4d
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jul 8 09:09:27 2012 -0700

    Merge branch 'for-3.5-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup

Thanks,

   Thomas

