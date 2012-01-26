Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab2AZP2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:28:04 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33628 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2AZP2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 10:28:03 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Date: Thu, 26 Jan 2012 16:28:00 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH v2 2/2] regulator: add device tree support for max8997
In-reply-to: <20120125133254.GJ3687@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <4F217100.6020105@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1326353738-26864-1-git-send-email-thomas.abraham@linaro.org>
 <1326353738-26864-3-git-send-email-thomas.abraham@linaro.org>
 <4F1FD1A5.1060305@samsung.com>
 <20120125112602.GB2991@opensource.wolfsonmicro.com>
 <4F1FEF55.8030604@samsung.com>
 <20120125133254.GJ3687@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.01.2012 14:32, Mark Brown wrote:
> On Wed, Jan 25, 2012 at 01:02:29PM +0100, Karol Lewandowski wrote:
>> On 25.01.2012 12:26, Mark Brown wrote:
>
>> However, I still find it little problematic that dt and non-dt
>> versions behave differently when given the same set of parameters
>> (previously apply_uV wasn't the default and required explicit flag).
>
> Well, they're different things.  Device tree isn't Linux specific at
> all.

There is no official platform-agnostic regulator API, nor DT-bindings
document I'm aware of.  Thus, I don't see why, while transitioning to
DT, should we lose ability to describe certain hardware configurations.

On 25.01.2012 12:22, Mark Brown wrote:
 > The big problem there seems like specifying voltages in the first
 > place, if we know what device it is we should already know what's
 > going on.

Driver which handles said regulator might know what's going on, but
that might not be case for its consumers.  Should we limit ability to
query given parameter just because its value is hardcoded in hardware?


My understanding of this whole device tree effort was to provide
ability to describe hardware properties which can't be queried from
hardware itself.

Consequently, if it's property of hardware that it provides fixed
voltage somewhere shouldn't it be possible to describe this fact
in DT?

If device tree isn't good place for it then which one is?

Regards,
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
