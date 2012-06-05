Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335Ab2FEBtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 21:49:31 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34750 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761276Ab2FEBt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 21:49:28 -0400
From: Andrew Armenia <andrew@asquaredlabs.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Armenia <andrew@asquaredlabs.com>
Subject: [PATCH 0/3] Multiple piix4-compatible SMBus support
Date: Mon,  4 Jun 2012 21:49:21 -0400
Message-Id: <1338860964-10803-1-git-send-email-andrew@asquaredlabs.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <20120604091643.208956fe@endymion.delvare>
References: <20120604091643.208956fe@endymion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches make it easier to support multiple SMBus controllers
that may be present within one piix4-compatible PCI device, and
enable support for the secondary SMBus controller found in the AMD
SP5100 chipset.

Andrew Armenia (3):
  i2c-piix4: eliminate global I/O base address
  i2c-piix4: separate registration and probing code
  i2c-piix4: support aux SMBus on AMD chipsets

 drivers/i2c/busses/i2c-piix4.c |  179 +++++++++++++++++++++++++++++++++-------
 1 file changed, 151 insertions(+), 28 deletions(-)

-- 
1.7.10

