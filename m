Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1J0DLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 23:11:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57247 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab1J0DLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 23:11:51 -0400
Message-ID: <1319685104.4598.3.camel@phoenix>
Subject: [linux-next 20111025] build failure with make u8500_defconfig
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Stephen Rothwell sfr"@canb.auug.org.au
Date: Thu, 27 Oct 2011 11:11:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below build error by "make u8500_defconfig" on linux-next 20111025.

  CC      arch/arm/common/gic.o
arch/arm/common/gic.c: In function 'gic_dist_init':
arch/arm/common/gic.c:290: error: 'irq_start' undeclared (first use in this function)
arch/arm/common/gic.c:290: error: (Each undeclared identifier is reported only once
arch/arm/common/gic.c:290: error: for each function it appears in.)
arch/arm/common/gic.c:296: error: 'struct gic_chip_data' has no member named 'irq_offset'
arch/arm/common/gic.c: In function 'gic_init':
arch/arm/common/gic.c:620: error: 'THIS_MODULE' undeclared (first use in this function)
make[1]: *** [arch/arm/common/gic.o] Error 1
make: *** [arch/arm/common] Error 2

Regards,
Axel

