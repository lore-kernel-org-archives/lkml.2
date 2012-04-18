Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2DRIRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:17:04 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51310 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab2DRIQ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:16:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120417183829.GW6652@opensource.wolfsonmicro.com>
References: <1332582590-16382-1-git-send-email-thomas.abraham@linaro.org>
	<1332582590-16382-3-git-send-email-thomas.abraham@linaro.org>
	<4F734460.4060605@samsung.com>
	<CAJuYYwRsHynt6pBHUgk72Z-UjHj3DM=s4pV4dzbb2hTAZOUSAw@mail.gmail.com>
	<20120417183829.GW6652@opensource.wolfsonmicro.com>
Date: Wed, 18 Apr 2012 13:46:58 +0530
Message-ID: <CAJuYYwSg-VkWe=0PFNj2snX4+_fN7Lc1-YU1xdUvTM9uJvha7A@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] regulator: add device tree support for max8997
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Karol Lewandowski <k.lewandowsk@samsung.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        Rajendra Nayak <rnayak@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 18 April 2012 00:08, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Apr 18, 2012 at 12:05:59AM +0530, Thomas Abraham wrote:
>> On 28 March 2012 22:33, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
>
>> >> +    For BUCK's:
>
> No 's here, BTW.

Ok.

>
>> >  - EN32KHz_AP
>> >  - EN32KHz_CP
>> >  - ENVICHG
>> >  - ESAFEOUT1
>> >  - ESAFEOUT2
>> >  - CHARGER
>> >  - CHARGER_CV
>> >  - CHARGER_TOPOFF
>
>> > I wonder if these should be mentioned in documentation too.
>
>> Yes, I missed the above regulators in the documentation. I have
>> included them now and will resubmit this patch.
>
> Please omit the clocks; these are obviously a bodge due to the inability
> to support clocks off-SoC so we shouldn't be enshrining them in the
> device tree bindings.

Thanks for the suggestion. I have removed EN32KHz_AP and EN32KHz_CP
from the list. The rest are either voltage (fixed) or current
regulators.

Regards,
Thomas.
