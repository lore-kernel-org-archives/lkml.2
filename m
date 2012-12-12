Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab2LLAcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:32:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43826 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab2LLAcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:32:46 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH 0/5] Use IS_ERR() rather than a NULL check when necessary.
Date: Wed, 12 Dec 2012 01:24:49 +0100
Message-Id: <1355271894-5284-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following five patches replace NULL checks by calls to IS_ERR() when
checking the return values of functions that return ERR_PTR() on error.

Regards,
Cyril Roelandt.
---

Cyril Roelandt (5):
  staging: omap-thermal: fix error check in
    omap_thermal_expose_sensor() and in
    omap_thermal_register_cpu_cooling().
  media: davinci: fix return value check in vpbe_display_reqbufs().
  c2port: fix return value check in duramar2150_c2port_init().
  net: sfc: fix return value check in efx_ptp_probe_channel().
  spi: fix return value check in hspi_probe().

 drivers/media/platform/davinci/vpbe_display.c      |    2 +-
 drivers/misc/c2port/c2port-duramar2150.c           |    2 +-
 drivers/net/ethernet/sfc/ptp.c                     |    2 +-
 drivers/spi/spi-sh-hspi.c                          |    2 +-
 drivers/staging/omap-thermal/omap-thermal-common.c |    4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

-- 
1.7.10.4

