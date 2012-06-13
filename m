Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab2FMQ6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:58:53 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63824 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab2FMQ6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:58:51 -0400
From: Andrew Armenia <andrew@asquaredlabs.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Armenia <andrew@asquaredlabs.com>
Subject: [PATCH 0/3] i2c-piix4: Multiple piix4-compatible SMBus support (revised)
Date: Wed, 13 Jun 2012 12:59:06 -0400
Message-Id: <1339606749-4578-1-git-send-email-andrew@asquaredlabs.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <20120613094739.360967aa@endymion.delvare>
References: <20120613094739.360967aa@endymion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a revision to the earlier patch set I submitted, which adds
support for the secondary SMBus controller found on certain AMD
chipsets, notably the SB700 and its derivative the SP5100.

Andrew Armenia (3):
  i2c-piix4: eliminate piix4_smba global variable
  i2c-piix4: separate registration and probing code
  i2c-piix4: support AMD auxiliary SMBus controller

 Documentation/i2c/busses/i2c-piix4 |   13 ++-
 drivers/i2c/busses/Kconfig         |    6 +-
 drivers/i2c/busses/i2c-piix4.c     |  200 ++++++++++++++++++++++++++++--------
 3 files changed, 175 insertions(+), 44 deletions(-)

-- 
1.7.10

