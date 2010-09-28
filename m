Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0I1Qbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:31:45 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:37861 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755007Ab0I1Qbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:31:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PLpmnu6Xd3SH1sbYiAMA1B1WYW70CGvmT8wEqrLKIBx+nM2hi3jiPMpRiX6wo0b8wqZ/9It7G1UhAH/X8NKzuTAcEWwkr/TGVEGInqzA86guqEBJZMz7FItv1Sn+NS1r;
Date: Tue, 28 Sep 2010 09:31:36 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI fix
Message-ID: <20100928093136.3efcf9c9@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
d56557af19867edb8c0e96f8e26399698a08857f:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 (2010-09-07 16:00:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Just one small fix so that pci_resource_alignment does the right thing
regardless of the underlying resource size length.

Cam Macdonell (1):
      PCI: fix pci_resource_alignment prototype

 drivers/pci/iov.c |    2 +-
 drivers/pci/pci.h |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
Jesse Barnes, Intel Open Source Technology Center
