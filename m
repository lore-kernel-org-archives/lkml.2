Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab1CBVjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:39:14 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50903 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab1CBVjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:39:12 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 2 Mar 2011 14:38:52 -0700
X-Google-Sender-Auth: A5zu7WkVZMKZhRN9-e3kcBaWR6o
Message-ID: <AANLkTimvaSwM0NmjWEC0S=uRCdc6MmSzB-3xqhTV7Y=y@mail.gmail.com>
Subject: [git pull] device tree bug fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Cc: Andres Salomon <dilinger@queued.net>, Michal Simek <monstr@monstr.eu>,
        Paul Bolle <pebolle@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A few more patches for .28

The following changes since commit dd9c1549edef02290edced639f67b54a25abbe0e:

  Linux 2.6.38-rc7 (2011-03-01 13:55:12 -0800)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 devicetree/merge

Andres Salomon (2):
      x86: OLPC: have prom_early_alloc BUG rather than return NULL
      of/promtree: allow DT device matching by fixing 'name' brokenness (v5)

Michal Simek (1):
      of: Add missing of_address.h to xilinx ehci driver

Paul Bolle (1):
      of/flattree: Drop an uninteresting message to pr_debug level

 arch/x86/platform/olpc/olpc_dt.c  |    3 +-
 drivers/of/pdt.c                  |  112 ++++++++++++++-----------------------
 drivers/usb/host/ehci-xilinx-of.c |    1 +
 fs/proc/proc_devtree.c            |    2 +-
 4 files changed, 45 insertions(+), 73 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
