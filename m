Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab2CEVtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:49:15 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:52299 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755053Ab2CEVtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:49:13 -0500
Date: Mon, 5 Mar 2012 13:49:08 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20120305134908.4f764921@jbarnes-x220>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 174.253.226.109 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
45196cee28a5bcfb6ddbe2bffa4270cbed66ae4b:

  Merge tag 'usb-3.3-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb (2012-02-22 13:00:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci for-linus

A couple of fixes for booting specific machines, and one for a minor
memory leak on pre-_CRS platforms.

Jonathan Nieder (2):
      x86/PCI: use host bridge _CRS info on MSI MS-7253
      x86/PCI: do not tie MSI MS-7253 use_crs quirk to BIOS version

Yinghai Lu (1):
      PCI: fix memleak when ACPI _CRS is not used.

 arch/x86/pci/acpi.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

Thanks,
Jesse
