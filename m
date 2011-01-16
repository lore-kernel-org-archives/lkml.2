Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1APTpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 14:45:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39844 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab1APTpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 14:45:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 0/2] ACPI / PCI: Post-merge fixes
Date: Sun, 16 Jan 2011 20:41:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andres Salomon <dilinger@queued.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101162041.02419.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse, Len,

The following two patches fix issues introduced by the last PCI merge.
The both of them have been tested by the respective reporters.  Please push
them to Linus or let me know if I should push.

[1/2] - Fix build problem in the PCIe AER driver for !CONFIG_ACPI

[2/2] - Fix boot crash on XO-1 related to APEI

Thanks,
Rafael

