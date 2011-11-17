Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab1KQFcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:32:35 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:37295 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab1KQFce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:32:34 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <rabin.vincent@stericsson.com>, <linus.walleij@stericsson.com>,
        <srinidhi.kasagar@stericsson.com>
Cc: <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <armando.visconti@st.com>, <shiraz.hashim@st.com>,
        <vipin.kumar@st.com>, <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <grant.likely@secretlab.ca>
Subject: [PATCH V2 0/5] stmpe: mfd & gpio updates
Date: Thu, 17 Nov 2011 11:02:19 +0530
Message-ID: <cover.1321507421.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since V1:
- V2 of this patchset also includes, earlier sent patches, Acked-by Linus:
	 mfd/stmpe: separate out controller and interface specific code
	 mfd/stmpe: Add support for SPI interface
- Issues with above patches are also fixed
- MODULE_DESCRIPTION and MODULE_AUTHOR are fixed in stmpe-spi and stmpe-i2c
  files
- gpio-stmpe patch is update to use stmpe->partnum instead of
  stmpe->variant->id_val
- Patch "mfd/stmpe: Move struct stmpe_variant_info to linux/mfd/stmpe.h" is
  dropped as it is no longer required.

Viresh Kumar (5):
  mfd/stmpe: separate out controller and interface specific code
  mfd/stmpe: Add support for SPI interface
  mfd/stmpe: Add support for stmpe variant 610
  mfd/stmpe: ADD support for stmpe variant 801
  gpio/gpio-stmpe: ADD support for stmpe variant 801

 drivers/gpio/gpio-stmpe.c |   31 +++++-
 drivers/mfd/Kconfig       |   19 ++++-
 drivers/mfd/Makefile      |    2 +
 drivers/mfd/stmpe-i2c.c   |  109 ++++++++++++++++++++
 drivers/mfd/stmpe-spi.c   |  150 +++++++++++++++++++++++++++
 drivers/mfd/stmpe.c       |  250 ++++++++++++++++++++++++++-------------------
 drivers/mfd/stmpe.h       |   53 ++++++++++
 include/linux/mfd/stmpe.h |    9 ++-
 8 files changed, 512 insertions(+), 111 deletions(-)
 create mode 100644 drivers/mfd/stmpe-i2c.c
 create mode 100644 drivers/mfd/stmpe-spi.c

-- 
1.7.2.2

