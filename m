Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab1FWCAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:00:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58820 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab1FWCAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:00:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=V9cyXIU6AJna0S2OkHVoEImZeCTicozqvGAjcijX3m2vHGAVN+Dqtifl0h0gB+fLk7
         R9QGmbrCNpd8zciBh8Bj/KsE3YKlW7+rX98Bl6GxbzKkG+xsIviH5/YyVYFpcVP/D089
         ob2lraHx02tJsY1CD/SxN/Dpe3JEBuTsxuO+8=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 00/11] RFC spi-dw updates
Date: Wed, 22 Jun 2011 19:00:02 -0700
Message-Id: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch set contains a number of changes were buried inside of one
large patch in my last patch set.  The rework of the message/transfer
handling changes are not part of this patch set.


This patch set applies after commit ca632f5 on spi/next


Dirk Brandewie (11):
  spi-dw: expose platform data stucture.
  spi-dw: update function naming convention to match file naming
  spi-dw: change MRST prefix to generic prefix
  spi-dw: remove unused definition
  spi-dw: split spi_dw_enable_chip() into  spi_dw_enable()/spi_dw_disable()
  spi-dw: Force error on out of range chip select.
  spi-dw: Set number of available chip selects correctly
  spi-dw: Ensure fifo lenght is set.
  spi-dw: Fix condition in spi_dw_{writer/reader}
  spi-dw: Move checking of max_speed_hz value to be a prerequisite in spi_dw_setup
  spi-dw: remove noop else clause

 drivers/spi/spi-dw-mid.c   |   30 +++---
 drivers/spi/spi-dw-mmio.c  |   38 ++++----
 drivers/spi/spi-dw-pci.c   |   34 +++---
 drivers/spi/spi-dw.c       |  247 ++++++++++++++++++++------------------------
 drivers/spi/spi-dw.h       |   82 ++++++---------
 include/linux/spi/spi-dw.h |   42 ++++++++
 6 files changed, 241 insertions(+), 232 deletions(-)
 create mode 100644 include/linux/spi/spi-dw.h

-- 
1.7.3.4

