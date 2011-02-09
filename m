Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1BIKf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:35:29 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55533 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab1BIKf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:35:28 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/8] Intel MID SSP SPI merged driver
To: spi-devel-general@lists.sourceforge.net, russ.gorby@intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Date: Wed, 09 Feb 2011 10:06:32 +0000
Message-ID: <20110209100231.555.90520.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches begins with Russ Gorby's posted driver for the 
Medfield platform with the SSP providing clock and adds back support for
Moorestown in the form of additional quirks, as well as basic support for
clock slave. This allows the kernel to have one driver which can drive all
the SSP units in these modes rather than different drivers per device/mode.

---

Russ Gorby (1):
      Intel SPI master controller driver for the Medfield platform

Alan Cox (7):
      intel_mid_ssp_spi: Implement slave side quirk
      intel_mid_ssp_spi: Bounce data through the Langwell SRAM when needed
      intel_mid_ssp_spi: Add the QoS quirk for slave mode
      intel_mid_ssp_spi: Add chip definitions
      intel_mid_ssp_spi: Add the uglies needed for Moorestown master mode
      intel_mid_ssp_spi: Implement the MRST quirk
      intel_mid_ssp_spi: Re-introduce quirks fields



 drivers/spi/Kconfig                 |    7 
 drivers/spi/Makefile                |    1 
 drivers/spi/intel_mid_ssp_spi.c     | 1747 +++++++++++++++++++++++++++++++++++
 drivers/spi/intel_mid_ssp_spi_def.h |  149 +++
 4 files changed, 1904 insertions(+), 0 deletions(-)
 create mode 100644 drivers/spi/intel_mid_ssp_spi.c
 create mode 100644 drivers/spi/intel_mid_ssp_spi_def.h

-- 
	"It's 106 miles to Chicago, we've got a full tank of gas, the
	 sat-nav has crashed, it's dark and we're completely lost"
