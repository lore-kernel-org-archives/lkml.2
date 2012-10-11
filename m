Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2JKQAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:00:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40368 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2JKQAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:00:40 -0400
Message-ID: <5076ED22.3060803@gmail.com>
Date: Thu, 11 Oct 2012 18:00:34 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>
CC: Sebastian Hesselbarh <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, mturquette@ti.com
Subject: Re: [RFC] Common clock framework for external clock generators
References: <4FAB15DB.5050702@googlemail.com> <5076847A.3010705@gmail.com>
In-Reply-To: <5076847A.3010705@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 10:34 AM, Daniel Mack wrote:
>> I recently read about the newly introduced common clock framework (ccf)
>> and wondered if this could be also used for external, e.g. i2c attached,
>> clock generators.
>>
>> Based on my current understanding of the framework I wrote such a
>> driver and now I want to present it here for clarification of some
>> remarks I have regarding the framework itself.
>
> May I kindly ask what happened to this driver? Are you planning to do
> another spin for submission?

Daniel,

the driver is still on my list but moved more and more downwards as I
got caught by mach-dove DT integration. There is still some work to do,
namely regmap and DT. It is used by some off-mainline tree for SolidRun 
CuBox quite successfully since then. Does any of you work rely on
a working si5351 driver?

Sebastian
