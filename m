Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab0DWUhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 16:37:14 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:52848 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757103Ab0DWUhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 16:37:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MJQn7+vA7fH/U30Xcj7N4CH2PKHhbINP2ZxUNgyLQPqDwaV2+n2kPXQOOjR0OYfDrK0XKiG/SE/UgvR9L7+OqQrcFqKjMB6ooIven2c+b6IKu+DZr2x9Wa1RN5PoeaBF;
Date: Fri, 23 Apr 2010 13:37:04 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20100423133704.3e240d5d@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
cf90bfe2ebaf9d32f37acbebb7425c280fd6cd30: Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

A few more fixes for the new resource management code, and a couple of
misc. fixes from Alexander and Matthew.

Alexander Duyck (1):
      PCI aerdrv: use correct bit defines and add 2ms delay to aer_root_reset

Bjorn Helgaas (3):
      x86/PCI: ignore Consumer/Producer bit in ACPI window descriptions
      PCI: revert broken device warning
      x86/PCI: parse additional host bridge window resource types

Matthew Garrett (1):
      PCI: Ensure we re-enable devices on resume

 arch/x86/pci/acpi.c           |   42 +++++++++++++++++++++++++++++++++++-----
 drivers/pci/pci.c             |    6 +----
 drivers/pci/pcie/aer/aerdrv.c |   10 +++++++-
 drivers/pci/probe.c           |   23 ++++++---------------
 4 files changed, 52 insertions(+), 29 deletions(-)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
