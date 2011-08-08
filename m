Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1HHHEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 03:04:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47335 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1HHHEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 03:04:36 -0400
Subject: [linux-next] mtd: build error due to unknown field 'bbt_options'
 specified in initializer
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 15:04:25 +0800
Message-ID: <1312787065.13157.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct platform_nand_data doest not have bbt_options field.
Thus "make orion5x_defconfig;make" has below build error:

  CC      arch/arm/mach-orion5x/ts78xx-setup.o
arch/arm/mach-orion5x/ts78xx-setup.c:278: error: unknown field 'bbt_options' specified in initializer
make[1]: *** [arch/arm/mach-orion5x/ts78xx-setup.o] Error 1
make: *** [arch/arm/mach-orion5x] Error 2

Regards,
Axel


