Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1DSTZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 15:25:14 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:33033 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753251Ab1DSTZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 15:25:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mCBuRrF1Uu3TmKU4tgALtSk/QOTgRFhgCSvtMwLbboJDMnbmXALpo/A3bgDo14mpnTl3EMeuYG4KOoBYg0giP8BW2liiR5eZNPKQwU/XALmvFIEYpA+tuQUGGT/iz+pN;
Date: Tue, 19 Apr 2011 12:25:03 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI fix
Message-ID: <20110419122503.3701d7fd@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
bb3c90f0de7b34995b5e35cf5dc97a3d428b3761:

  Merge branch 'for-linus' of git://git390.marist.edu/pub/scm/linux-2.6 (2011-04-08 07:36:14 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Just one rather low priority fix for one of the patches that went in
this cycle.

Randy Dunlap (1):
      PCI: pci-label: Fix build failure when CONFIG_NLS is set to 'm' by allmodconfig

 drivers/pci/Kconfig  |    4 +++-
 drivers/pci/Makefile |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
