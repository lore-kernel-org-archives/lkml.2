Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab2BVSGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:06:18 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59595 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab2BVSGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:06:13 -0500
Date: Wed, 22 Feb 2012 19:06:19 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 0/3] power: max17042_battery: Add DT bindings
To: myungjoo.ham@samsung.com
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        cbou@mail.ru, Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1329933982-2529-1-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.8.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches adds bindings to max17042_battery driver making
it possible to instantiate it from device tree description.

First, convience patch, simply replaces kzalloc with devm_kzalloc
where possible.

Second, most intrusive patch adds variables orginally found only in
platform data to max17042_chip structure.  I decided it to do it that
way rather than allocating new platform data and then populating it
from device tree description.

Last patch adds DT bindings itself.

I would be grateful for any comments and I will be more than happy to
rework this patchset if needed.


Karol Lewandowski (3):
  max17042_battery: Use devm_kzalloc() where applicable
  max17042_battery: Preserve properties outside of platform data
  max17042_battery: Make it possible to instantiate driver from DT

 .../bindings/power_supply/max17042_battery.txt     |   18 +++++
 drivers/power/max17042_battery.c                   |   77 ++++++++++++++++----
 2 files changed, 79 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/max17042_battery.txt

-- 
1.7.8.3

