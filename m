Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946044Ab2JLSRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:17:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60557 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945991Ab2JLSRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:17:39 -0400
Message-ID: <50785EBF.3060508@gmail.com>
Date: Fri, 12 Oct 2012 20:17:35 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Sebastian Hesselbarh <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, mturquette@ti.com
Subject: Re: [RFC] Common clock framework for external clock generators
References: <4FAB15DB.5050702@googlemail.com> <5076847A.3010705@gmail.com> <5076ED22.3060803@gmail.com>
In-Reply-To: <5076ED22.3060803@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.10.2012 18:00, Sebastian Hesselbarth wrote:
> On 10/11/2012 10:34 AM, Daniel Mack wrote:
>>> I recently read about the newly introduced common clock framework (ccf)
>>> and wondered if this could be also used for external, e.g. i2c attached,
>>> clock generators.
>>>
>>> Based on my current understanding of the framework I wrote such a
>>> driver and now I want to present it here for clarification of some
>>> remarks I have regarding the framework itself.
>>
>> May I kindly ask what happened to this driver? Are you planning to do
>> another spin for submission?
> 
> Daniel,
> 
> the driver is still on my list but moved more and more downwards as I
> got caught by mach-dove DT integration. There is still some work to do,
> namely regmap and DT. It is used by some off-mainline tree for SolidRun 
> CuBox quite successfully since then. Does any of you work rely on
> a working si5351 driver?

Yes, it does actually. I can hack around it for now, but at some point,
a proper driver is needed. And yours looks quite feature complete, so it
would be easiest to finish this one :)

Do you still have access to hardware you wrote the driver for? Let me
know if you need any help around here.



Thanks,
Daniel

