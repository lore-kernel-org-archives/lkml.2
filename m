Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2DPPkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:40:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58183 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2DPPkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:40:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 00/12] at91: 3.4-rc3 fixes
Date: Mon, 16 Apr 2012 15:40:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net,
        plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204161540.08389.arnd@arndb.de>
X-Provags-ID: V02:K0:3wr3RjqKOh792ZJ0gm0ESMaXddquGJEm95m/uq6XOK9
 ntVJ/sIggc4tsxE4QbStoh6wwMqL9r1ii4PEvypIclCu79fFIh
 w+truCT8CPpudNDtF0q7RzmGI5q95oohuxpqALNxc3EPb/xS/C
 4pnr0EB0f+t/0OdrjaWXidd/fJ3hTyqkUB5iT3Sek1sEkm0KOQ
 TOJjtqzki7tYt+k339TLrIO9HMpWLu+7jaU1WeuF79+iomT8vY
 Fz6d+jRCY6KAUfQxa8x+36PvtqXUfh8uk+xK3kgGs1Z96ecubU
 wV7dV7NVeaXMAWadjXWZmKCnkFnHqlaKb7DModnJyeeCVslW9a
 sgxQLR9ggVAE8qHw6G4A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2012, Nicolas Ferre wrote:
> Here is another fixes series for AT91 that will go on top of 3.4-rc3.
> We experienced some issues while compiling some drivers as modules: Joachim has
> corrected several of them. We may reduce this number of exported values by
> reworking some drivers, in the future.
> Some drivers are also modified here, I would like to keep them in the series
> as the modifications are really related with our recent move to irqdomains or
> simply related with compiler annotations.

I looked at all the patches, they look good to me, but patch 9 does not
seem to be an actual bug-fix rather than a cleanup, so you might want
to put that into a different series.

	Arnd
