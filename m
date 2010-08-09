Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab0HIM10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:27:26 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:34919 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab0HIM1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:27:24 -0400
Date: Mon, 9 Aug 2010 14:26:28 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-serial@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        Claudio Scordino <claudio@evidence.eu.com>
Subject: [GIT PULL] arch/cris changes for 2.6.36
Message-ID: <20100809122628.GC17485@axis.com>
References: <20100806085337.GA17485@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806085337.GA17485@axis.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I lost one patch in the last pull request (sorry Claudio), please pull the below tree
which adds an ioctl to the CRISv10 serial driver.


The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:
  Linus Torvalds (1):
        Linux 2.6.35

are available in the git repository at:

  git://www.jni.nu/cris.git rs485fix

Claudio Scordino (1):
      CRIS: ioctl for getting RS485 information

 arch/cris/include/asm/ioctls.h |    1 +
 drivers/serial/crisv10.c       |   11 +++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)


Thanks again,

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
