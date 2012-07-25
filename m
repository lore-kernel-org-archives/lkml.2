Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2GYUGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 16:06:44 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:9304 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab2GYUGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 16:06:42 -0400
Message-ID: <501051D1.7060901@tilera.com>
Date: Wed, 25 Jul 2012 16:06:41 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] tile pci build fixes for 3.6-rc1
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

This fixes a couple of issues with the pci_bus.subordinate removal from pci-next
as it affected the tile architecture.  One commit does the bombing for tilegx PCI
(added during the merge window, so missed the pci-next bombing) and the other
commit undoes a buggy part of the bombing for tilepro PCI.  Thanks!

Chris Metcalf (2):
      tilegx pci: fix semantic merge conflict with 3527ed81c
      tilepro pci: fix pci_bus.subordinate bad bombing from b918c62e

 arch/tile/kernel/pci.c    |    2 +-
 arch/tile/kernel/pci_gx.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

