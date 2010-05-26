Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab0EZQDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:03:11 -0400
Received: from tex.lwn.net ([70.33.254.29]:35411 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab0EZQDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:03:09 -0400
Date: Wed, 26 May 2010 10:03:07 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] viafb video capture engine driver
Message-ID: <20100526100307.5114ea83@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

Mauro has now given me an ack for the via-camera driver - used on OLPC
XO 1.5 systems - so it's now ready for a pull:

  git://git.lwn.net/linux-2.6.git viafb-next

Thanks,

jon

Jonathan Corbet (1):
      Add the viafb video capture driver

 drivers/media/video/Kconfig      |   10 +
 drivers/media/video/Makefile     |    2 +
 drivers/media/video/via-camera.c | 1369 ++++++++++++++++++++++++++++++++++++++
 drivers/media/video/via-camera.h |   93 +++
 drivers/video/via/accel.c        |    2 +-
 drivers/video/via/via-core.c     |   16 +-
 include/linux/via-core.h         |    4 +-
 include/media/v4l2-chip-ident.h  |    4 +
 8 files changed, 1496 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/video/via-camera.c
 create mode 100644 drivers/media/video/via-camera.h
