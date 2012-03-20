Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094Ab2CTWsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:48:53 -0400
Received: from na3sys009aob129.obsmtp.com ([74.125.149.136]:38200 "EHLO
	na3sys009amx259.postini.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758911Ab2CTWsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:48:51 -0400
From: Kevin Hilman <khilman@ti.com>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Robert Lee <rob.lee@linaro.org>, len.brown@intel.com,
        akpm@linux-foundation.org, rjw@sisk.pl, robherring2@gmail.com,
        Baohua.Song@csr.com, amit.kucheria@linaro.org, nicolas.ferre@atmel.com,
        linux@maxim.org.za, kgene.kim@samsung.com, amit.kachhap@linaro.org,
        magnus.damm@gmail.com, nsekhar@ti.com, daniel.lezcano@linaro.org,
        mturquette@linaro.org, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        deepthi@linux.vnet.ibm.com, broonie@opensource.wolfsonmicro.com,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk,
        jean.pihet@newoldbits.com, venki@google.com, ccross@google.com,
        g.trinabh@gmail.com, kernel@wantstofly.org, lethal@linux-sh.org,
        jon-hunter@ti.com, tony@atomide.com, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v8 0/8] Consolidate cpuidle functionality
Organization: Texas Instruments, Inc.
References: <1332274969-15782-1-git-send-email-rob.lee@linaro.org>
	<201203202158.08042.arnd.bergmann@linaro.org>
Date: Tue, 20 Mar 2012 15:48:45 -0700
In-Reply-To: <201203202158.08042.arnd.bergmann@linaro.org> (Arnd Bergmann's
	message of "Tue, 20 Mar 2012 21:58:07 +0000")
Message-ID: <873992zy5u.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd.bergmann@linaro.org> writes:

> On Tuesday 20 March 2012, Robert Lee wrote:
>> This patch series moves various functionality duplicated in platform 
>> cpuidle drivers to the core cpuidle driver. Also, the platform irq
>> disabling was removed as it appears that all calls into 
>> cpuidle_call_idle will have already called local_irq_disable().
>> 
>> These changes have been pulled into linux-next.
>> 
>> Len, Andrew, can a request be made for Linus to pull these changes?
>
> FWIW, Len seems to be rather inactive on the kernel mailing list right
> now and generally not very interested in anything outside of x86 and
> acpi. If he doesn't reply in the next few days and Andrew also isn't
> interested in handling these patches, I'd suggest you just send the pull
> request to Linus, with Len on Cc and explain that you tried to send
> them through him but gave up in the end.

FWIW, I have not had good luck getting response for proposed core
CPUidle changes either:

        http://lkml.org/lkml/2011/9/19/374

Maybe it's time that drivers/cpuidle gets a maintainer.  With lots of
discussions of scheduler changes that affect load estimation, I suspect
we're all going to have a bit of CPUidle work to do in the
not-so-distant future.
 
Kevin
