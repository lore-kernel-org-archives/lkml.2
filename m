Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab2HTXYC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 19:24:02 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48732 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab2HTXYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 19:24:00 -0400
MIME-Version: 1.0
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 20 Aug 2012 17:23:38 -0600
Message-ID: <CAErSpo5uZmLsEzEdFvV4MUPBgHjmZfGeD6EdNR=-jf-MqWuthw@mail.gmail.com>
Subject: [GIT PULL] PCI updates for v3.6
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git for-linus

for you to fetch changes up to 9f6445a05b712663b8101a5d2c060a5c40a41fe4:

  Merge branch 'pci/rafael-3.6-fixes' into for-linus (2012-08-15 12:10:39 -0600)


Here are two patches from Rafael Wysocki.  One fixes an EHCI-related
hibernation crash on ASUS boxes.  We fixed a similar suspend issue in
v3.6-rc1, and this applies the same fix to the hibernate path.  The
other fixes D3/D3cold/D4 messages related to the D3cold support we
merged in v3.6-rc1.

We'd like both to be included in v3.6.

----------------------------------------------------------------

Bjorn Helgaas (1):
      Merge branch 'pci/rafael-3.6-fixes' into for-linus

Rafael J. Wysocki (2):
      PCI / PM: Fix D3/D3cold/D4 messages printed by acpi_pci_set_power_state()
      PCI: EHCI: Fix crash during hibernation on ASUS computers

 drivers/pci/pci-acpi.c   | 4 ++--
 drivers/pci/pci-driver.c | 7 +++++++
 2 files changed, 9 insertions(+), 2 deletions(-)
