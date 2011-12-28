Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1L1Opg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 09:45:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45155 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab1L1Opd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 09:45:33 -0500
Message-ID: <4EFB2B8A.9010902@gmail.com>
Date: Wed, 28 Dec 2011 08:45:30 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PULL] Devicetree for 3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

Please pull device tree updates for 3.3. Pretty much a random collection
of minor changes. I'm including i2c-designware DT binding support here
as I've gotten no response from Ben.

Rob

The following changes since commit 384703b8e6cd4c8ef08512e596024e028c91c339:

  Linux 3.2-rc6 (2011-12-16 18:36:26 -0800)

are available in the git repository at:
  git://sources.calxeda.com/kernel/linux.git for-grant

Benoit Cousson (1):
      of/base: Take NULL string into account for property with multiple
strings

David Daney (1):
      OF/device-tree: Add some entries to vendor-prefixes.txt

Dong Aisheng (1):
      dt: reform for_each_property to for_each_property_of_node

Olof Johansson (1):
      dt/i2c: Enumerate some of the known trivial i2c devices

Rob Herring (3):
      i2c-designware: add OF binding support
      dt: add empty of_get_node/of_put_node functions
      irq: check domain hwirq range for DT translate

Sam Ravnborg (1):
      of/pdt: fix section mismatch warning

Uwe Kleine-König (1):
      ARM/of: allow *machine_desc.dt_compat to be const

 .../devicetree/bindings/i2c/i2c-designware.txt     |   22 ++++++++
 .../devicetree/bindings/i2c/trivial-devices.txt    |   58
++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    3 +
 arch/arm/include/asm/mach/arch.h                   |    2 +-
 drivers/i2c/busses/i2c-designware-platdrv.c        |   12 ++++
 drivers/of/base.c                                  |   10 ++--
 drivers/of/fdt.c                                   |    4 +-
 drivers/of/pdt.c                                   |    2 +-
 include/linux/of.h                                 |   33 ++++++------
 include/linux/of_fdt.h                             |    4 +-
 kernel/irq/irqdomain.c                             |    3 +
 11 files changed, 124 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-designware.txt
 create mode 100644
Documentation/devicetree/bindings/i2c/trivial-devices.txt
