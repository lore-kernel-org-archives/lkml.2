Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2KEQQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:16:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55206 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab2KEQQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:16:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/8] mfd: ab8500-core: Remove unused ab8500-gpio IRQ ranges
Date: Mon, 5 Nov 2012 16:16:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, linus.walleij@stericsson.com
References: <1352128236-11554-1-git-send-email-lee.jones@linaro.org> <1352128236-11554-2-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1352128236-11554-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211051616.24257.arnd@arndb.de>
X-Provags-ID: V02:K0:+t3JtubHqrbXIpF9YbaAZIFRZ8LRDYEksF7r/HZTqvM
 cgmV6pvyLl68IVAgzirVwnRlzXLaWVknwnWwJiA3EFz6/7dJfN
 WAw4wBCr5DV1ShdRC5hM+r0WfWA+88YywtNdRo/I+Omj6gq7Mf
 OVskU4veVvaU7JenMxUZl2OnlhPT1ufu/Ep907PKVOPKu8CCqW
 ZZDHqYJnF0s7E1MvUoyKqVkAJp0Sj8Pewi1O0XmwWT6n3JfRvY
 YroLKEIXiUZ0YZtI8Hb7Vq1nCtwaWMXlknzyiEw3vf0sRACY2j
 x2Kv4ANtWEVKG4dsOhEkSspeeOBlm+EOI21WNzRedj8eRQXAx1
 1hWKsz3Xt15vwXcueFkM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 November 2012, Lee Jones wrote:
> The IRQ ranges provided in ab8500-core to be passed on to the
> ab8500-gpio driver are not only redundant, but they are also
> causing a warning in the boot log. These IRQ ranges, like any
> other MFD related IRQ resource are passed though MFD core for
> automatic conversion to virtual IRQs; however, MFD core does
> not support IRQ mapping of IRQ ranges. Let's just remove them.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
