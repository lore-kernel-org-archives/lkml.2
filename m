Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1JBTCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:02:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:32082 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab1JBTCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:02:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,477,1312182000"; 
   d="scan'208";a="73568384"
Date: Sun, 2 Oct 2011 21:05:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [GIT] [3.1] MFD fix
Message-ID: <20111002190519.GK4118@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have one last MFD fix for 3.1, a build failure for the jz4740 driver.

Thanks in advance for pulling this one:

The following changes since commit 38867a28a7dc9d69389990bcd42f6b7c77da3d9d:

  Merge branch 'fixes' of git://git.linaro.org/people/arnd/arm-soc (2011-09-20 14:23:16 -0700)

are available in the git repository at:

  git://git.infradead.org/users/sameo/mfd-2.6.git for-linus

Lars-Peter Clausen (1):
      mfd: Fix generic irq chip ack function name for jz4740-adc

 drivers/mfd/jz4740-adc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
