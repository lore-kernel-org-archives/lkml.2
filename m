Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab1AEHF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 02:05:57 -0500
Received: from mail-iw0-f194.google.com ([209.85.214.194]:55353 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1AEHF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 02:05:56 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.227.56]
In-Reply-To: <AANLkTi=uqcFrWujZTG8zy9zQoZ+=O6N1VBSjzgQbfX3Q@mail.gmail.com>
References: <AANLkTin7OYXzCYty8pDxyzE_Bg83=+L8jmcaoEMSf4QM@mail.gmail.com>
 <1294002510-2324-1-git-send-email-tardyp@gmail.com> <AANLkTi=uqcFrWujZTG8zy9zQoZ+=O6N1VBSjzgQbfX3Q@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 5 Jan 2011 09:05:35 +0200
Message-ID: <AANLkTingS+9iKG99PKkv-YZkABWt4uucaWdGBGQXGh7E@mail.gmail.com>
Subject: Re: [PATCH] mmc: add MMC_QUIRK_BROKEN_CLK_GATING
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Pierre Tardy <tardyp@gmail.com>, "Gao, Yunpeng" <yunpeng.gao@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Takashi Iwai <tiwai@suse.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 1:52 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> Do you have a candidate function driver to do this ...?

wl1271.

We don't use SDIO interrupts at all (the wl1271 has an external irq
line), so we will surely use this.
