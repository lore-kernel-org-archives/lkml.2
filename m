Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1JWJYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 05:24:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33009 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab1JWJYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 05:24:17 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/12 RESEND] Mainly checkpatch fixes
Date: Sun, 23 Oct 2011 10:22:42 +0100
Message-Id: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending patches. Reduces the number of checkpatch warnings, removing forward declarations and whitespace changes.

Last patch removes some redundant code.

Mark Einon (12):
      staging: et131x: Remove unused rx_ring.recv_buffer_pool
      staging: et131x: Remove redundant et131x_reset_recv() call
      staging: et131x: Remove call to find pci pm capability
      staging: et131x: Remove unused rx_ring.recv_packet_pool
      staging: et131x: Remove some forward declarations
      staging: et131x: Remove forward declaration of et131x_adapter_setup
      staging: et131x: Remove more forward declarations
      staging: et131x: Remove yet more forward declarations
      staging: et131x: Remove even more forward declarations
      staging: et131x: Remove last of the forward declarations
      staging: et131x: Mainly whitespace changes to appease checkpatch
      staging: et131x: Remove redundant check and return statement

 drivers/staging/et131x/et131x.c | 2465 +++++++++++++++++++--------------------
 1 files changed, 1201 insertions(+), 1264 deletions(-)

