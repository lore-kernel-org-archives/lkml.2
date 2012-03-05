Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab2CEDu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 22:50:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53506 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab2CEDu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 22:50:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of robherring2@gmail.com designates 10.101.190.10 as permitted sender) smtp.mail=robherring2@gmail.com; dkim=pass header.i=robherring2@gmail.com
Message-ID: <4F5437FE.2000306@gmail.com>
Date: Sun, 04 Mar 2012 21:50:22 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PULL] generic irq chip and pl061 irqdomain support
References: <4F3ADFE7.4090409@gmail.com>
In-Reply-To: <4F3ADFE7.4090409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

On 02/14/2012 04:27 PM, Rob Herring wrote:
> Grant,
> 
> Please pull. This is based on your current branch which you have said
> you plan to rebase, so feel free to rebase these as you need to. This
> has been tested on highbank and i.MX5.
> 

Ping.

I've rebased onto your current tree. Updated pull request:

The following changes since commit 280ad7fda5f95211857fda38960f2b6fdf6edd3e:

  mfd: twl-core: Add IRQ_DOMAIN dependency (2012-02-26 16:48:06 -0700)

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

> 
> The following changes since commit 98ecf5260207e45ad587a5dc16c39f5ede467a45:
> 
>   irq_domain/microblaze: Convert microblaze to use irq_domains
> (2012-02-05 23:02:26 -0700)
> 
> are available in the git repository at:
>   git://sources.calxeda.com/kernel/linux.git irqdomain-for-grant
> 
> Rob Herring (3):
>       ARM: kconfig: always select IRQ_DOMAIN
>       irq: add irq_domain support to generic-chip
>       gpio: pl061: enable interrupts with DT style binding
> 
>  .../devicetree/bindings/gpio/pl061-gpio.txt        |   15 ++
>  arch/arm/Kconfig                                   |    2 +-
>  arch/arm/common/Kconfig                            |    2 -
>  drivers/gpio/gpio-pl061.c                          |   48 ++++---
>  include/linux/irq.h                                |   15 ++
>  kernel/irq/generic-chip.c                          |  152
> +++++++++++++++++---
>  6 files changed, 186 insertions(+), 48 deletions(-)
> 
> Rob

