Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0IWTy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:54:57 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53833 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab0IWTyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:54:55 -0400
Date: Thu, 23 Sep 2010 20:54:50 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [GIT] x86 platform driver update
Message-ID: <20100923195450.GA27852@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Just an update to MAINTAINERS and a fix for a regression in the Thinkpad 
hotkey handling.

The following changes since commit 57aebd7739c8dbbf403876ee1e9673fafc83d856:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu (2010-09-23 08:06:55 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Henrique de Moraes Holschuh (1):
      thinkpad-acpi: avoid keymap pitfall

Lee, Chun-Yi (1):
      Change MSI LAPTOP driver maintainer to Lee, Chun-Yi

 MAINTAINERS                          |    4 +---
 drivers/platform/x86/thinkpad_acpi.c |    5 +++--
 2 files changed, 4 insertions(+), 5 deletions(-)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
