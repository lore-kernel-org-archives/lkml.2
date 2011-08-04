Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab1HDQ5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:57:31 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58431 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1HDQ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:57:27 -0400
MIME-Version: 1.0
Date: Thu, 4 Aug 2011 18:57:26 +0200
Message-ID: <CACRpkdYBYekj_uP=Pi_=sfDwn51naY4XoX8RK13f8d5ifs=j1w@mail.gmail.com>
Subject: PL08x driver in arch/arm/mach-pnx4008/dma.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>, Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

I noticed another copy of the ARM PL08x driver in the above path,
and we are now working to unify the different PL08x derivates in
drivers/dma/amba-pl08x.c

I couldn't find a maintainer in MAINTAINERS, but it seems you
wrote a lot of the code.

Are you or someone else maintaining the PNX4008 able to look
into moving over to the generic driver?

Thanks,
Linus Walleij
