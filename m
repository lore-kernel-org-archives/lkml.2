Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab2IXPEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:04:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab2IXPEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:04:21 -0400
Message-ID: <1348499060.2320.103.camel@ul30vt.home>
Subject: [GIT PULL] VFIO fixes for 3.6
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Date: Mon, 24 Sep 2012 09:04:20 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit c46de2263f42fb4bbde411b9126f471e9343cb22:

  Merge branch 'for-linus' of git://git.kernel.dk/linux-block (2012-09-19 11:04:34 -0700)

are available in the git repository at:


  git://github.com/awilliam/linux-vfio.git tags/vfio-for-linus

for you to fetch changes up to b68e7fa879cd3b1126a7c455d9da1b70299efc0d:

  vfio: Fix virqfd release race (2012-09-21 10:48:28 -0600)

----------------------------------------------------------------
VFIO doc update and virqfd race fix

----------------------------------------------------------------
Alex Williamson (2):
      vfio: Trivial Documentation correction
      vfio: Fix virqfd release race

 Documentation/vfio.txt            |  2 +-
 drivers/vfio/pci/vfio_pci_intrs.c | 76 ++++++++++++++++++++++++++++-----------
 2 files changed, 57 insertions(+), 21 deletions(-)


