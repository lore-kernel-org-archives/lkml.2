Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab0C2Hef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 03:34:35 -0400
Received: from mail.perches.com ([173.55.12.10]:1202 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab0C2Hec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 03:34:32 -0400
From: Joe Perches <joe@perches.com>
To: devel@driverdev.osuosl.org
Cc: Simon Horman <horms@verge.net.au>, Jason Baldus <jason.baldus@gmail.com>,
       Greg KH <gregkh@suse.de>, Scott Smedley <ss@aao.gov.au>,
       Harley Sweeten <hsweeten@visionengravers.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] drivers/staging/dt3155: Large cleanups
Date: Mon, 29 Mar 2010 00:34:27 -0700
Message-Id: <cover.1269847733.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <20100329032301.GC27607@verge.net.au>
References: <20100329032301.GC27607@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A large set of cleanups to dt3155.
Integrated separate files into a single file
Made most functions and variables static
Checkpatch cleanups

Compile tested only

Joe Perches (3):
  drivers/staging/dt3155: Integrate 3 badly styled files into 1 clean file
  drivers/staging/dt3155/allocator: sparse cleanups
  drivers/staging/dt3155: Remove old files

 drivers/staging/dt3155/Makefile      |    5 +-
 drivers/staging/dt3155/allocator.c   |   15 +-
 drivers/staging/dt3155/allocator.h   |    4 +-
 drivers/staging/dt3155/dt3155_drv.c  | 1095 ------------------------
 drivers/staging/dt3155/dt3155_drv.h  |   45 -
 drivers/staging/dt3155/dt3155_io.c   |  175 ----
 drivers/staging/dt3155/dt3155_io.h   |   51 --
 drivers/staging/dt3155/dt3155_isr.c  |  516 ------------
 drivers/staging/dt3155/dt3155_isr.h  |   77 --
 drivers/staging/dt3155/dt3155_main.c | 1524 ++++++++++++++++++++++++++++++++++
 10 files changed, 1535 insertions(+), 1972 deletions(-)
 delete mode 100644 drivers/staging/dt3155/dt3155_drv.c
 delete mode 100644 drivers/staging/dt3155/dt3155_drv.h
 delete mode 100644 drivers/staging/dt3155/dt3155_io.c
 delete mode 100644 drivers/staging/dt3155/dt3155_isr.c
 delete mode 100644 drivers/staging/dt3155/dt3155_isr.h
 create mode 100644 drivers/staging/dt3155/dt3155_main.c

