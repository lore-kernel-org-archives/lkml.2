Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1K2Ikb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 03:40:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63078 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1K2Ik1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 03:40:27 -0500
MIME-Version: 1.0
In-Reply-To: <20111129064630.GW19069@tbergstrom-lnx.Nvidia.com>
References: <1320339647-30255-1-git-send-email-pdeschrijver@nvidia.com>
	<20111129064630.GW19069@tbergstrom-lnx.Nvidia.com>
Date: Tue, 29 Nov 2011 09:40:27 +0100
Message-ID: <CACRpkdY-YL0RSY4+nL36sM9WwX+VbMkJP54djrCwYCQmw9AFEw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Change ARCH_NR_GPIO into a Kconfig variable
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        David Brown <davidb@codeaurora.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 7:46 AM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> On Thu, Nov 03, 2011 at 06:00:44PM +0100, Peter De Schrijver wrote:
>> This patchset converts ARCH_NR_GPIO to a Kconfig variable as suggested by
>> Russel King. It also converts some platforms to the new model.
>>
>> Peter De Schrijver (3):
>>   ARM: ARCH_NR_GPIO: Make ARCH_NR_GPIO a Kconfig variable
>>   ARM: mach-shmobile: Use CONFIG_ARCH_NR_GPIO
>>   ARM: mach-ux500 Use CONFIG_ARCH_NR_GPIO
>
> Ping? What should we do with this?

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Put it into Russell's patch tracker.

Yours,
Linus Walleij
