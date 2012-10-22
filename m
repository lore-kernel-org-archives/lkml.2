Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab2JVOvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:51:12 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:50340 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab2JVOvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:51:10 -0400
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH v2 00/10] sta2x11-mfd patches
Date: Mon, 22 Oct 2012 16:50:31 +0200
Message-Id: <1350917441-4478-1-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

Hi,

this is v2 of a patchset already submitted on 2012/09/12
(see https://lkml.org/lkml/2012/9/12/139).
Here's a summary of changes in v2:

* Added regmap support.
* Added driver for sta2x11 scr (otp) registers.
* Changelog entries reviewed and fixed.

Davide Ciminaghi (10):
  drivers/mfd/sta2x11-mfd: add apb-soc regs driver and factor out
    common code
  drivers/mfd/sta2x11-mfd: add regmap support
  drivers/mfd/sta2x11-mfd: add sta2x11_mfd_get_regs_data() function
  drivers/mfd/sta2x11-mfd: use defines for platform devices' names
  drivers/mfd/sta2x11-mfd: only add sta2x11_mfd if it hasn't already
    been added
  drivers/mfd/sta2x11-mfd: platform probe: don't mind about gpio
    platform data
  drivers/mfd/sta2x11-mfd: use one lock per device instead of one lock
    per mfd
  drivers/mfd/sta2x11-mfd: add scr (otp registers) platform driver
  drivers/mfd/sta2x11-mfd: add defines for some sta2x11 sctl registers
  drivers/mfd/sta2x11-mfd: add myself to copyright

 drivers/mfd/Kconfig             |    1 +
 drivers/mfd/sta2x11-mfd.c       |  531 +++++++++++++++++++++++++++------------
 include/linux/mfd/sta2x11-mfd.h |  198 ++++++++++++++-
 3 files changed, 572 insertions(+), 158 deletions(-)

-- 
1.7.10.4

