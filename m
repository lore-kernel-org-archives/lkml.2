Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0L1Rel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:34:41 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:38254 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753447Ab0L1Rek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:34:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=X6ZD86fNjRV0mfMeNyXDoScNqMaFc40vszKDcqBhkVqLSrYcKq4N5RoLoTSTMRFwPOEPeQBLC/9DICwo6iXcHrgxR8oz1WyWXl09d/+DSR8TViEWw/2vtm83nszJ2LIN;
Date: Tue, 28 Dec 2010 09:34:35 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI fix
Message-ID: <20101228093435.628a8c15@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
e819eb8687767cefca7b6abf5ac6d5efcf581eeb:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2010-12-22 19:47:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Just one fix from Rafael for a problem introduce this cycle.

Rafael J. Wysocki (1):
      PCI hotplug: Fix unexpected driver unregister in pciehp_acpi.c

 drivers/pci/hotplug/pciehp_acpi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


-- 
Jesse Barnes, Intel Open Source Technology Center
