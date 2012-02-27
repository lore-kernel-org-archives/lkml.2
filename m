Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2B0UCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 15:02:30 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54473 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2B0UC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 15:02:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of robherring2@gmail.com designates 10.236.155.101 as permitted sender) smtp.mail=robherring2@gmail.com; dkim=pass header.i=robherring2@gmail.com
Message-ID: <4F4BE150.3000903@gmail.com>
Date: Mon, 27 Feb 2012 14:02:24 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PULL] DT fixes for 3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

Please pull these few fixes and doc updates for 3.3.

Rob

The following changes since commit 6b21d18ed50c7d145220b0724ea7f2613abf0f95:

  Linux 3.3-rc5 (2012-02-25 12:18:16 -0800)

are available in the git repository at:
  git://sources.calxeda.com/kernel/linux.git fixes-for-grant

Baruch Siach (1):
      of/mdio: fix fixed link bus name

Danny Kukawka (1):
      of/fdt.c: asm/setup.h included twice

Jamie Iles (1):
      of: add picochip vendor prefix

Tobias Klauser (1):
      doc: dt: Fix broken reference in gpio-leds documentation

 Documentation/devicetree/bindings/gpio/led.txt     |    6 +++---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/of/fdt.c                                   |    1 -
 drivers/of/of_mdio.c                               |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)
