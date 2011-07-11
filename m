Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab1GKV2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:28:52 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36667 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab1GKV2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:28:49 -0400
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, cjb@laptop.org, matsumur@nts.ricoh.co.jp,
        linux-pci@vger.kernel.org
Subject: [Patch 0/1] mmc: Added quirks for Ricoh 1180:e823 lower base clock frequency
Date: Mon, 11 Jul 2011 16:28:34 -0500
Message-Id: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ricoh 1180:e823 does not recognize certain types of SD/MMC cards.
- Buffalo SD 512MB
  dmesg: I/O error, dev mmcblk0, sector xxx
- Kingston SD 2GB
  dmesg: I/O error, dev mmcblk0, sector xxx
- Patriot Micro SDHC
  dmesg: I/O error, dev mmcblk0, sector xxx. 

Lowering the SD base clock frequency from 200Mhz to 50Mhz fixes
this issue. This solution was suggest by Koji Matsumuro, Ricoh
Company,Ltd. The patch was tested on Toshiba Tecra R850 by Daniel 
Manrique.

Details can be found in:

http://launchpad.net/bugs/773524



