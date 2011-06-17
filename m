Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab1FQPFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:05:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47138 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab1FQPFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:05:14 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 17 Jun 2011 09:04:53 -0600
X-Google-Sender-Auth: bf-7fZClDAju0NzNkGPR-vK6sRU
Message-ID: <BANLkTikTPiqJZe1WeToBckWTPf_YYqRbew@mail.gmail.com>
Subject: [GIT PULL] spi fixes for v3.0-rc3
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2c53b436a30867eb6b47dd7bab23ba638d1fb0d2:

  Linux 3.0-rc3 (2011-06-13 15:29:59 -0700)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 spi/merge

Mike Frysinger (1):
      spi/bfin_spi: fix handling of default bits per word setting

 drivers/spi/spi_bfin5xx.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
