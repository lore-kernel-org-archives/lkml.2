Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2GZOdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:33:08 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:59733 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2GZOdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:33:05 -0400
Date: Thu, 26 Jul 2012 09:31:01 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Peter Huewe <peter.huewe@infineon.com>, Bryan Freed <bfreed@chromium.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT PULL] New TPM driver and features
Message-ID: <20120726143101.GA24237@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072614-5518-0000-0000-000006597A54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

  Please pull the following changes available since commit
663728418e3494f8e4a82f5d1b2f23c22d11be35:

  Smack: Maintainer Record (2012-07-13 15:59:44 -0700)

are available in the git repository at:
  git://github.com/shpedoikal/linux.git tpmdd-7-25-12

Bryan Freed (1):
      CHROMIUM: tpm: tpm_i2c_infineon: Lock the I2C adapter for a sequence of requests.

Kent Yoder (3):
      tpm: modularize event log collection
      tpm: Move tpm_get_random api into the TPM device driver
      hw_random: add support for the TPM chip as a hardware RNG source

Peter Huewe (1):
      char/tpm: Add new driver for Infineon I2C TIS TPM

 drivers/char/hw_random/Kconfig                  |   13 +
 drivers/char/hw_random/Makefile                 |    1 +
 drivers/char/hw_random/tpm-rng.c                |   55 ++
 drivers/char/tpm/Kconfig                        |   11 +
 drivers/char/tpm/Makefile                       |    2 +
 drivers/char/tpm/tpm.c                          |   54 ++-
 drivers/char/tpm/tpm.h                          |   23 +
 drivers/char/tpm/tpm_acpi.c                     |  104 ++++
 drivers/char/tpm/{tpm_bios.c => tpm_eventlog.c} |  147 +-----
 drivers/char/tpm/tpm_eventlog.h                 |   71 +++
 drivers/char/tpm/tpm_i2c_infineon.c             |  748 +++++++++++++++++++++++
 include/linux/tpm.h                             |    4 +
 security/keys/trusted.c                         |   47 +--
 13 files changed, 1095 insertions(+), 185 deletions(-)
 create mode 100644 drivers/char/hw_random/tpm-rng.c
 create mode 100644 drivers/char/tpm/tpm_acpi.c
 rename drivers/char/tpm/{tpm_bios.c => tpm_eventlog.c} (75%)
 create mode 100644 drivers/char/tpm/tpm_eventlog.h
 create mode 100644 drivers/char/tpm/tpm_i2c_infineon.c

Thanks,
Kent

