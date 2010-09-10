Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab0IJXTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:19:35 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52023 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab0IJXTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:19:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ARzBjdPcNbxbmc5w+MpHy2h/7SEIibZKgxXuZVf0oNdpZj/K6n2bY8/szDrul2/JyL
         bgY8RNKZZWUMJ5IEFJdZOjOBBBhfFq8CUzRzmy3c+jUQxpqsZjnQGfen6egBGkU+uiYl
         RuCDkj3vrYD7m5DIpmkooMbpyQoGNdWUSYVfE=
From: wellsk40@gmail.com
To: linus.walleij@stericsson.com, spi-devel-general@lists.sourceforge.net
Cc: sameo@linux.intel.com, rabin.vincent@stericsson.com,
        srinidhi.kasagar@stericsson.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, tj@kernel.org,
        grant.likely@secretlab.ca, Lukasz.Baj@tieto.com,
        quentinyang05@gmail.com, Kevin Wells <wellsk40@gmail.com>
Subject: [PATCH 5/5] spi: amba_pl022: Remove unused fields from pl022_config_chip
Date: Fri, 10 Sep 2010 09:19:39 -0700
Message-Id: <1284135579-13578-6-git-send-email-wellsk40@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1284135579-13578-1-git-send-email-wellsk40@gmail.com>
References: <1284135579-13578-1-git-send-email-wellsk40@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Wells <wellsk40@gmail.com>

Some of the fields in the pl022_config_chip structure are no
longer needed with the spi->mode updates. These fields have been
removed.

Signed-off-by: Kevin Wells <wellsk40@gmail.com>
---
 include/linux/amba/pl022.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/amba/pl022.h b/include/linux/amba/pl022.h
index abf26cc..0ad6977 100644
--- a/include/linux/amba/pl022.h
+++ b/include/linux/amba/pl022.h
@@ -271,19 +271,13 @@ struct pl022_ssp_controller {
  */
 struct pl022_config_chip {
 	struct device *dev;
-	enum ssp_loopback lbm;
 	enum ssp_interface iface;
 	enum ssp_hierarchy hierarchy;
 	bool slave_tx_disable;
 	struct ssp_clock_params clk_freq;
-	enum ssp_rx_endian endian_rx;
-	enum ssp_tx_endian endian_tx;
-	enum ssp_data_size data_size;
 	enum ssp_mode com_mode;
 	enum ssp_rx_level_trig rx_lev_trig;
 	enum ssp_tx_level_trig tx_lev_trig;
-	enum ssp_spi_clk_phase clk_phase;
-	enum ssp_spi_clk_pol clk_pol;
 	enum ssp_microwire_ctrl_len ctrl_len;
 	enum ssp_microwire_wait_state wait_state;
 	enum ssp_duplex duplex;
-- 
1.7.2.2

