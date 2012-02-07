Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab2BGNJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:09:27 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:43574 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab2BGNJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:09:25 -0500
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dan.Morav@nuvoton.com, KC@nuvoton.com,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: [PATCH 0/2] New Nuvoton I2C driver 
Date: Tue,  7 Feb 2012 11:06:52 -0200
Message-Id: <1328620014-9369-1-git-send-email-srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <y>
References: <y>
x-cbid: 12020713-8936-0000-0000-000005D6D1F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please review and test Dan, I've ported to 3.3.


Dan.Morav@nuvoton.com (1):
  TPM: Nuvoton I2C driver

Rajiv Andrade (1):
  tpm_nuvoton_i2c: Use exported symbol for status probe

 drivers/char/tpm/Kconfig           |    9 +
 drivers/char/tpm/Makefile          |    1 +
 drivers/char/tpm/tpm_nuvoton_i2c.c |  662 ++++++++++++++++++++++++++++++++++++
 3 files changed, 672 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_nuvoton_i2c.c

-- 
1.7.3.4

