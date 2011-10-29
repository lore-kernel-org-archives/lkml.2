Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab1J2K6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 06:58:18 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48941 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab1J2K6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 06:58:17 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 29 Oct 2011 12:57:54 +0200
X-Google-Sender-Auth: alSY2IQqtBoMpZL-tBAUKMEgh6Y
Message-ID: <CACxGe6sNC0FseUj2pSL0y4yEJaFg=gNAP=54Ow6n8jXe2mBapA@mail.gmail.com>
Subject: [git pull] trivial gpio build failure fixups
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

nothing to say here, subject says it all.

g.

The following changes since commit ec7ae517537ae5c7b0b2cd7f562dfa3e7a05b954:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
(2011-10-28 16:44:18 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 devicetree/merge

Grant Likely (1):
      gpio: Fix ARM versatile-express build failure

Kalle Valo (1):
      of: include errno.h

 arch/arm/mach-vexpress/include/mach/gpio.h |    1 +
 include/linux/of.h                         |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-vexpress/include/mach/gpio.h


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
