Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935018Ab1JEQlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:41:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41666 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934922Ab1JEQlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:41:09 -0400
Message-ID: <4E8C88A1.4090308@gmail.com>
Date: Wed, 05 Oct 2011 11:41:05 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: [PULL] Devicetree for 3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

Please pull for 3.2. These commits don't have any dependencies and are
not dependencies for me, so they don't need to go in thru arm-soc.

Rob

The following changes since commit 976d167615b64e14bc1491ca51d424e2ba9a5e84:

  Linux 3.1-rc9 (2011-10-04 18:11:50 -0700)

are available in the git repository at:
  git://git.jdl.com/software/linux-3.0.git for-grant

Rob Herring (4):
      MAINTAINERS: update devicetree maintainers
      of/irq: of_irq_find_parent: check for parent equal to child
      devicetree: Add ARM pl061 gpio controller binding doc
      devicetree: Add ARM pl022 spi controller binding doc

 .../devicetree/bindings/gpio/pl061-gpio.txt        |   10 ++++++++++
 .../devicetree/bindings/spi/spi_pl022.txt          |   12 ++++++++++++
 MAINTAINERS                                        |    2 ++
 drivers/of/irq.c                                   |   14 +++++++-------
 4 files changed, 31 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/pl061-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi_pl022.txt
