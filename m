Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab0HWLim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 07:38:42 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:49098 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab0HWLij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 07:38:39 -0400
X-IronPort-AV: E=Sophos;i="4.56,257,1280721600"; 
   d="scan'208";a="110813550"
Subject: [GIT] Xen pvhvm driver, emulated device unplug fixes
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Mon, 23 Aug 2010 12:38:36 +0100
Message-ID: <1282563516.12544.452.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These patches make it possible to inhibit the Xen emulated device unplug
on the kernel command line (mostly "Just In Case") and renames
xen_emul_unplug=ignore to the clearer xen_emul_unplug=unnecessary.

Since it changes the name of a command line option we'd like to get it
in before 2.6.36 proper.

The third changeset is a pure cleanup which you could ignore for 2.6.36
if you wanted. I can resend without if you prefer.

Ian.

The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:
  Linus Torvalds (1):
        Linux 2.6.36-rc1

are available in the git repository at:

  git://xenbits.xensource.com/people/ianc/linux-2.6.git for-upstream/pvhvm

Ian Campbell (3):
      xen: pvhvm: allow user to request no emulated device unplug
      xen: pvhvm: rename xen_emul_unplug=ignore to =unnnecessary
      xen: pvhvm: make it clearer that XEN_UNPLUG_* define bits in a bitfield

 Documentation/kernel-parameters.txt |    6 ++++--
 arch/x86/xen/platform-pci-unplug.c  |   18 ++++++++++++------
 drivers/block/xen-blkfront.c        |    2 +-
 include/xen/platform_pci.h          |   14 +++++++++-----
 4 files changed, 26 insertions(+), 14 deletions(-)


