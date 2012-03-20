Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab2CTV7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 17:59:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab2CTV7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 17:59:01 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Robert Lee <rob.lee@linaro.org>
Subject: Re: [PATCH v8 0/8] Consolidate cpuidle functionality
Date: Tue, 20 Mar 2012 21:58:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: len.brown@intel.com, akpm@linux-foundation.org, rjw@sisk.pl,
        khilman@ti.com, robherring2@gmail.com, Baohua.Song@csr.com,
        amit.kucheria@linaro.org, nicolas.ferre@atmel.com, linux@maxim.org.za,
        kgene.kim@samsung.com, amit.kachhap@linaro.org, magnus.damm@gmail.com,
        nsekhar@ti.com, daniel.lezcano@linaro.org, mturquette@linaro.org,
        vincent.guittot@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, deepthi@linux.vnet.ibm.com,
        broonie@opensource.wolfsonmicro.com, nicolas.pitre@linaro.org,
        linux@arm.linux.org.uk, jean.pihet@newoldbits.com, venki@google.com,
        ccross@google.com, g.trinabh@gmail.com, kernel@wantstofly.org,
        lethal@linux-sh.org, jon-hunter@ti.com, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <1332274969-15782-1-git-send-email-rob.lee@linaro.org>
In-Reply-To: <1332274969-15782-1-git-send-email-rob.lee@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203202158.08042.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:hhJb0Mw+2YTPwv110ooby54tMD0b7C02LCnFBP/mWt1
 0B6DBmJY9/93QO7rmajb9OHaHPfI/860Jy11o3EF+R3MYf4jOm
 r3FPKbjQTbUNfi+Os8R5z6yfThoafKnFoHOklyR9hP4goJ8lD9
 XpSChZdDxhU0z71hdA8NPZQLetyKDqjuZJZER9skmWTo+DF1NM
 s3S1c4gU/6gctIU+IPf1l7rJrn/G3l5+bd2VQ1dYmjplQ9YMfA
 rlK7iy/lUAv5/FjAPMZDYvaICPvTj7SPgAUpTF808zqP3EuKMQ
 HQvFC5V14y7wp/ROsFkXUOehKxua2/Bm2w6CWXWpwz32I/3sMh
 9XP1r+RFVWNI5qWH0HCCTyq6lG+kgi2CpzTYLwHCX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 March 2012, Robert Lee wrote:
> This patch series moves various functionality duplicated in platform 
> cpuidle drivers to the core cpuidle driver. Also, the platform irq
> disabling was removed as it appears that all calls into 
> cpuidle_call_idle will have already called local_irq_disable().
> 
> These changes have been pulled into linux-next.
> 
> Len, Andrew, can a request be made for Linus to pull these changes?

FWIW, Len seems to be rather inactive on the kernel mailing list right
now and generally not very interested in anything outside of x86 and
acpi. If he doesn't reply in the next few days and Andrew also isn't
interested in handling these patches, I'd suggest you just send the pull
request to Linus, with Len on Cc and explain that you tried to send
them through him but gave up in the end.

	Arnd
