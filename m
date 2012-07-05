Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964779Ab2GENhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:37:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40122 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab2GENhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:37:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120705124141.GB4111@opensource.wolfsonmicro.com>
References: <1341460705-10868-1-git-send-email-yadi.brar@samsung.com>
	<1341460705-10868-4-git-send-email-yadi.brar@samsung.com>
	<20120705124141.GB4111@opensource.wolfsonmicro.com>
Date: Thu, 5 Jul 2012 19:07:14 +0530
Message-ID: <CAKew6eWqEcyGGGr-WfJwe0xmk46qK67-4U+MGk5ts4_8Ps0BFg@mail.gmail.com>
Subject: Re: [PATCH 4/6] mfd: max77686: Add device tree support.
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 6:11 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jul 05, 2012 at 09:28:23AM +0530, Yadwinder Singh Brar wrote:
>
>> +     regulator_name {
>> +             standard regulator constraints....
>> +     };
>> +     refer Documentation/devicetree/bindings/regulator/regulator.txt
>
>> +  The names of regulator should be as follow:
>> +
>> +     -LDOn   :       for LDOs, where n can lie in range 1 to 26.
>> +                     example: LDO1, LDO2, LDO26.
>> +     -BUCKn  :       for BUCKs, where n can lie in range 1 to 9.
>> +                     example: BUCK1, BUCK5, BUCK9.
>
> You need to update this to use the regulator-compatible property.

Yes. I missed it. I will update Documentation.

Thanks.
