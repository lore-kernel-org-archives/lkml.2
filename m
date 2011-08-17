Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab1HQFZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 01:25:49 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:56534 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1HQFZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 01:25:47 -0400
Subject: Re: [linux-next] mtd: build error due to unknown field
 'bbt_options' specified in initializer
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>
Date: Wed, 17 Aug 2011 08:27:27 +0300
In-Reply-To: <1312787065.13157.1.camel@phoenix>
References: <1312787065.13157.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313558852.2679.8.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 15:04 +0800, Axel Lin wrote:
> struct platform_nand_data doest not have bbt_options field.
> Thus "make orion5x_defconfig;make" has below build error:
> 
>   CC      arch/arm/mach-orion5x/ts78xx-setup.o
> arch/arm/mach-orion5x/ts78xx-setup.c:278: error: unknown field 'bbt_options' specified in initializer
> make[1]: *** [arch/arm/mach-orion5x/ts78xx-setup.o] Error 1
> make: *** [arch/arm/mach-orion5x] Error 2

The fix is added to l2-mtd-2.6.git, thanks for reporting.

-- 
Best Regards,
Artem Bityutskiy

