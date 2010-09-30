Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab0I3TJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:09:47 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:39138 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab0I3TJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:09:46 -0400
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, joe@perches.com, christophe-h.ricard@st.com
Subject: [PATCH 0/3] New stm i2c tpm device driver 
Date: Thu, 30 Sep 2010 16:09:19 -0300
Message-Id: <cover.1285870690.git.srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches include a new STMicroelectronics i2c tpm device 
driver together with a document describing the platform on which the 
code was tested, and subsequent improvements submitted by Joe Perches.

Christophe Henri RICARD (1):
  TPM: New I2C TPM device driver

Joe Perches (2):
  drivers/char/tpm/tpm_stm_st19_i2c.c: Use pr_fmt, pr_<level> and
    FUNC_ENTER
  drivers/char/tpm/tpm_stm_st19_i2c.c: Add missing break and neatening

 Documentation/tpm/tpm_stm_st19_i2c.txt |  168 +++++++
 drivers/char/tpm/Kconfig               |    9 +
 drivers/char/tpm/Makefile              |    1 +
 drivers/char/tpm/tpm_stm_st19_i2c.c    |  835 ++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_stm_st19_i2c.h    |   63 +++
 include/linux/i2c/tpm_stm_st19_i2c.h   |   45 ++
 6 files changed, 1121 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/tpm/tpm_stm_st19_i2c.txt
 create mode 100644 drivers/char/tpm/tpm_stm_st19_i2c.c
 create mode 100644 drivers/char/tpm/tpm_stm_st19_i2c.h
 create mode 100644 include/linux/i2c/tpm_stm_st19_i2c.h

-- 
1.7.2.2

