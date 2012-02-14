Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab2BNW14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 17:27:56 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64019 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329Ab2BNW1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 17:27:54 -0500
Message-ID: <4F3ADFE7.4090409@gmail.com>
Date: Tue, 14 Feb 2012 16:27:51 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PULL] generic irq chip and pl061 irqdomain support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

Please pull. This is based on your current branch which you have said
you plan to rebase, so feel free to rebase these as you need to. This
has been tested on highbank and i.MX5.


The following changes since commit 98ecf5260207e45ad587a5dc16c39f5ede467a45:

  irq_domain/microblaze: Convert microblaze to use irq_domains
(2012-02-05 23:02:26 -0700)

are available in the git repository at:
  git://sources.calxeda.com/kernel/linux.git irqdomain-for-grant

Rob Herring (3):
      ARM: kconfig: always select IRQ_DOMAIN
      irq: add irq_domain support to generic-chip
      gpio: pl061: enable interrupts with DT style binding

 .../devicetree/bindings/gpio/pl061-gpio.txt        |   15 ++
 arch/arm/Kconfig                                   |    2 +-
 arch/arm/common/Kconfig                            |    2 -
 drivers/gpio/gpio-pl061.c                          |   48 ++++---
 include/linux/irq.h                                |   15 ++
 kernel/irq/generic-chip.c                          |  152
+++++++++++++++++---
 6 files changed, 186 insertions(+), 48 deletions(-)

Rob
