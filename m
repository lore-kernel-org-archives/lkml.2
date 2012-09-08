Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab2IHOmz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 10:42:55 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:54031 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754435Ab2IHOmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 10:42:53 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1209080950170.28681@xanadu.home>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <504B0D6B.9010908@ti.com> <alpine.LFD.2.02.1209080950170.28681@xanadu.home>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Sat, 8 Sep 2012 20:12:31 +0530
Message-ID: <CAMQu2gzEWf_T0MjOMZgDUiEUa8J5bEmmwHxQd61SCjSXe-==1Q@mail.gmail.com>
Subject: Re: [PATCH v3 00/31] AArch64 Linux kernel port
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 8, 2012 at 7:29 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Sat, 8 Sep 2012, Santosh Shilimkar wrote:
>
>> Mostly I was looking at the series from SOC boot and CPU PM
>> point of view and boot part seems to just fine.
>>
>> As per discussion at LPC, I have gone through the SMC
>> proposal which ARM has published. In general the boot part
>> with SMC seems to be doable and can be standardized across SOCs.
>> The part which will be conflicting is the CPU power management.
>> That seems to be the harder one and the document is at too
>> infancy stage from the details point of view. Some bits about
>> save, restore are related to switcher kind of architecture, which
>> may not be the requirement for all the SoCs.
>
> I've reviewed an earlier draft of that document.  Although the examples
> in the latest document appear to be geared towards switcher usage, my
> suggestions to the ARM folks was to take into account the CPU hotplug
> scenario instead.  The provided examples remained switcher centric, but
> the API in the published document is now much more generic than it used
> to be.  I think it should cover all usage scenarios now.
>
Thanks for the background Nicolas.

Regards,
Santosh
