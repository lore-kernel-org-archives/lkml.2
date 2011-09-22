Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab1IVNSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:18:05 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59154 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab1IVNSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:18:01 -0400
Subject: [linux-next next-20110922] build failure due to missing
 arch/arm/mach-nuc93x/Kconfig
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Wan ZongShun <mcuos.com@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 21:17:53 +0800
Message-ID: <1316697473.6704.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below error with today's linux-next tree (next-20110922).

$ make menuconfig
scripts/kconfig/mconf Kconfig
arch/arm/Kconfig:972: can't open file "arch/arm/mach-nuc93x/Kconfig"
make[1]: *** [menuconfig] Error 1
make: *** [menuconfig] Error 2

Regards,
Axel

