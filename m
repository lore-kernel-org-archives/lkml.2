Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab1EMV0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 17:26:42 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:52917 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986Ab1EMV0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 17:26:40 -0400
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 00/13] wl12xx re-factor
Date: Sat, 14 May 2011 00:26:17 +0300
Message-Id: <1305321990-22041-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.4.1.343.ga91df
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luca,

this is the re-factor I was talking to you
about. Please have a look and give your
comments.

It probably won't work as is, I compile
tested only, but it shows the idea.

Felipe Balbi (13):
  net: wl12xx: sdio: id_tables should be __devinitconst
  net: wl12xx: sdio: add a context structure
  net: wl12xx: remove some unnecessary prints
  net: wl12xx: care for optional operations
  net: wl12xx: remove the nops
  net: wl12xx: remove unnecessary prints
  net: wl12xx: spi: add a context structure
  net: wl12xx: spi: add a platform_device
  net: wl12xx: sdio: add a platform_device
  net: wl12xx: main: add platform device
  net: wireless: wl12xx: re-factor all drivers
  net: wireless: wl12xx: mark some symbols static
  net: wl12xx: main: drop unneded plat_dev

 drivers/net/wireless/wl12xx/io.c                   |   10 +-
 drivers/net/wireless/wl12xx/io.h                   |   21 +--
 drivers/net/wireless/wl12xx/main.c                 |  191 +++++++++++-----
 drivers/net/wireless/wl12xx/sdio.c                 |  220 +++++++-----------
 drivers/net/wireless/wl12xx/spi.c                  |  246 ++++++++------------
 drivers/net/wireless/wl12xx/wl12xx.h               |   16 +-
 drivers/net/wireless/wl12xx/wl12xx_platform_data.c |    4 +-
 include/linux/wl12xx.h                             |    4 +-
 8 files changed, 336 insertions(+), 376 deletions(-)

-- 
1.7.4.1.343.ga91df

