Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab1I3UTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:19:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50095 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab1I3UTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:19:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas FERRE <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91 fixes for 3.1
Date: Fri, 30 Sep 2011 22:17:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
References: <4E838F77.2040705@atmel.com>
In-Reply-To: <4E838F77.2040705@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109302217.13937.arnd@arndb.de>
X-Provags-ID: V02:K0:9UVdopYTn9bWn692zv2/mpr+JTweGcIwtptV7oyT774
 IiktFY3USqSZtgT2VtIQXAMHDFAfkFosq8Dsk7gLR99s5uvpVV
 10QhMDGs59jxbgbwWPFNHIhhEmTCL8qCCWBiOjEHt1/gYVx7A0
 3b1cIFmLHUZP2qFBLsC+LmR5TW9qY/Kljo63HKKJf6o3I3mlhz
 6QKo3VY0h+qCbcJ5BlpXZO4muLm43PsKJQGGrwsOinwbMmDNGy
 t2ipy0oG9kDDvry84tjtwk4cN94OuqSnFT6ssAPIhCzM3CKwI9
 PkNqekNYOx787Mvl7+PlGn8ENN+efsjMo2LQ3iX0DZzmNmyZvX
 uVwplHhXqh2aTdNjEPSM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 September 2011, Nicolas FERRE wrote:
> Here is a couple of fixes that may be included in 3.1-final.
> The Kconfig modification will allow to select the PWM driver for SAM9G45 
> SoC. This will also benefit to stable kernels.
> The new defconfig for SAM9G45 family will allow us to better monitor the 
> health of this port through automatic compilation mechanism. I find it 
> interesting to have it included the sooner.
> 
> The pull is based on the following changes since commit 
> a102a9ece5489e1718cd7543aa079082450ac3a2:
> 
>    Linux 3.1-rc8 (2011-09-27 15:48:34 -0700)
> 
> are available in the git repository at:
>    git://github.com/at91linux/linux-at91.git at91-fixes

Hi Nicolas,

I've pulled them into the fixes branch now. My feeling however is that
these by themselves are not reason enough to send a pull request to Linus,
so they will probably be the first thing I send in the 3.2 merge window,
unless some other important fixes appear.

	Arnd
