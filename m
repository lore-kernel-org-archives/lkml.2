Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1C1KZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 06:25:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:6649 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab1C1KZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 06:25:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,253,1299484800"; 
   d="scan'208";a="409641782"
Date: Mon, 28 Mar 2011 12:24:58 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andres Salomon <dilinger@queued.net>
Subject: [GIT] [2.6.39] MFD fix
Message-ID: <20110328102457.GB2809@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a compilation fix for the cs5535 MFD driver on non x86 architectures,
sorry about that.
Stephen already asked for taking this fix [1], and this is a pull request for
the same patch.

Thanks for pulling this one:

The following changes since commit 18bcd0c8cb7d85a9063b88ec810dc1cdc0974518:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6 (2011-03-27 20:37:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Andres Salomon (1):
      mfd: Allow cs5535-mfd to build on X86 only

 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


[1] https://lkml.org/lkml/2011/3/28/23

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
