Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab1DMQHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:07:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49755 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933Ab1DMPz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:28 -0400
Date: Wed, 13 Apr 2011 16:55:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, platform-drivers-x86@vger.kernel.org
Subject: [GIT PULL] Build fix in x86 platform tree
Message-ID: <20110413155523.GB30607@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple build fix for the Intel pmic driver.

The following changes since commit aaa119a3d4e0b7421c82ae3fbe288e65d0f3485f:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6 (2011-04-12 17:18:05 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Matthew Garrett (1):
      x86 platform drivers: Build fix for intel_pmic_gpio

 drivers/platform/x86/intel_pmic_gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


-- 
Matthew Garrett | mjg59@srcf.ucam.org
