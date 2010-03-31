Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab0CaVZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:25:51 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36939 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab0CaVZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:25:48 -0400
Date: Wed, 31 Mar 2010 22:25:45 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] x86 platform driver tree
Message-ID: <20100331212545.GA25249@srcf.ucam.org>
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

Minor fix to asus-laptop, along with a new driver that enables hotkeys 
on newer Acer devices. It has no impact on any existing drivers, so I 
think it's safe to include at this point.

The following changes since commit 2eaa9cfdf33b8d7fb7aff27792192e0019ae8fc6:
  Linus Torvalds (1):
        Linux 2.6.34-rc3

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Corentin Chary (1):
      asus-laptop: fix warning in asus_handle_init

Yong Wang (1):
      eeepc-wmi: new driver for WMI based hotkeys on Eee PC laptops

 drivers/platform/x86/Kconfig       |   10 +++
 drivers/platform/x86/Makefile      |    1 +
 drivers/platform/x86/asus-laptop.c |    4 +-
 drivers/platform/x86/eeepc-wmi.c   |  157 ++++++++++++++++++++++++++++++++++++
 4 files changed, 170 insertions(+), 2 deletions(-)
 create mode 100644 drivers/platform/x86/eeepc-wmi.c

-- 
Matthew Garrett | mjg59@srcf.ucam.org
