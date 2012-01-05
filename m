Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab2AEEoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 23:44:14 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41714 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878Ab2AEEoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 23:44:12 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 4 Jan 2012 21:43:51 -0700
X-Google-Sender-Auth: d44G226xxpUEUS6GfQ63ZQ_Robg
Message-ID: <CACxGe6u_jVHnZhwvg_-+gDGBKnOpuwUnoTErCGUJ_pHhBgnS3A@mail.gmail.com>
Subject: [GIT PULL] spi changes for v3.3
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the spi changes I've got queued for 3.3.  Primarily driver
changes with one core spi bug fix.

There is a signed tag for this commit: spi-for-linus-20120104

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 spi/merge

Grant Likely (1):
      Merge branch 'spi/next' (early part) into spi/merge

Laurent Pinchart (1):
      spi: Fix device unregistration when unregistering the bus master

Shubhrajyoti D (3):
      spi/omap: Use a workqueue per omap2_mcspi controller
      spi/omap: call pm_runtime_disable in error path and remove
      spi/omap: Correct the error path

Tomoya MORINAGA (2):
      spi-topcliff-pch: Support new device LAPIS Semiconductor ML7831 IOH
      spi-topcliff-pch: Change company name OKI SEMICONDUCTOR to LAPIS
Semiconductor

 drivers/spi/Kconfig            |    6 ++--
 drivers/spi/spi-omap2-mcspi.c  |   51 +++++++++++++++++++++++++---------------
 drivers/spi/spi-topcliff-pch.c |   13 ++++++----
 drivers/spi/spi.c              |    2 +-
 4 files changed, 44 insertions(+), 28 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
