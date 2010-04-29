Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0D2DOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 23:14:18 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:40108 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750838Ab0D2DOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 23:14:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jW5hu/w3w183ffsJ5niPJW5DLeUZs3Deg0tj81bFKzmgWf2U0YihJy4GCbb+HhP1FtP2a2v2I5lINiCp6M+WEJK9pAuZqWKgZ+FZ+OqINbY44zJKq0wpORbz7YJCbcPv;
Date: Wed, 28 Apr 2010 20:14:23 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20100428201423.316d4761@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
b91ce4d14a21fc04d165be30319541e0f9204f15: Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Two fixes from Bjorn for _CRS related stuff.  The "compute address
space" one hasn't seen any soak time in -next, which I'm nervous about,
but it seems like a good related change, so I'll leave it up to you.

If you don't want it, just let me know and I'll drop it and resend just
the BIOS_END patch, which definitely fixes real bugs.

Bjorn Helgaas (2):
      x86/PCI: never allocate PCI MMIO resources below BIOS_END
      x86/PCI: compute Address Space length rather than using _LEN

 arch/x86/pci/acpi.c |   40 ++--------------------------------------
 arch/x86/pci/i386.c |    3 +++
 2 files changed, 5 insertions(+), 38 deletions(-)


-- 
Jesse Barnes, Intel Open Source Technology Center
