Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0HWUdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:33:32 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38682 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab0HWUd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:33:29 -0400
Date: Mon, 23 Aug 2010 21:33:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [GIT] platform driver fixes
Message-ID: <20100823203324.GA31550@srcf.ucam.org>
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

One fix from Jon to deal with a missing dependency in Kconfig, and one 
from me to handle some breakage in the hp-wmi driver that leaves the 
rfkill interface broken on some hardware

The following changes since commit 9ee47476d6734c9deb9ae9ab05d963302f6b6150:

  Merge branch 'radix-tree' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev (2010-08-22 19:55:14 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Jonathan Corbet (1):
      ACPI_TOSHIBA needs LEDS support

Matthew Garrett (1):
      hp-wmi: Fix query interface

 drivers/platform/x86/Kconfig  |    4 ++-
 drivers/platform/x86/hp-wmi.c |   64 ++++++++++++++++-------------------------
 2 files changed, 28 insertions(+), 40 deletions(-)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
