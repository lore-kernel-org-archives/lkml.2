Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab2EEFfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 01:35:30 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:52472 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2EEFf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 01:35:28 -0400
Message-ID: <4FA4BC1D.80101@kernel.org>
Date: Sat, 05 May 2012 01:35:25 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ACPI patch for Linux-3.4-rc5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this ACPI patch.
It fixes a D3 issue new in 3.4-rc1.

thanks!
Len Brown, Intel Open Source Technology Center

The following changes since commit ec612fcf43e09f5e05d37baf4d3f138b3fcc2f3d:

  Merge branch 'd3' into release (2012-03-30 16:21:26 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

for you to fetch changes up to 1cc0c998fdf2cb665d625fb565a0d6db5c81c639:

  ACPI: Fix D3hot v D3cold confusion (2012-05-05 01:19:52 -0400)

----------------------------------------------------------------
Lin Ming (1):
      ACPI: Fix D3hot v D3cold confusion

 drivers/acpi/power.c   |  2 +-
 drivers/acpi/scan.c    | 17 +++++++----------
 drivers/pci/pci-acpi.c |  4 ++--
 include/acpi/actypes.h |  7 ++++---
 4 files changed, 14 insertions(+), 16 deletions(-)
