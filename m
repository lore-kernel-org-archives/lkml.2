Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2A0J6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 04:58:11 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32415 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2A0J6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 04:58:09 -0500
Date: Fri, 27 Jan 2012 10:58:08 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH v2 2/2] regulator: add device tree support for max8997
In-reply-to: <20120126161744.GB19703@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <4F227530.3050708@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1326353738-26864-1-git-send-email-thomas.abraham@linaro.org>
 <1326353738-26864-3-git-send-email-thomas.abraham@linaro.org>
 <4F1FD1A5.1060305@samsung.com>
 <20120125112602.GB2991@opensource.wolfsonmicro.com>
 <4F1FEF55.8030604@samsung.com>
 <20120125133254.GJ3687@opensource.wolfsonmicro.com>
 <4F217100.6020105@samsung.com>
 <20120126161744.GB19703@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On 25.01.2012 12:22, Mark Brown wrote:
>>> The big problem there seems like specifying voltages in the first
>>> place, if we know what device it is we should already know what's
>>> going on.
>
>> Driver which handles said regulator might know what's going on, but
>> that might not be case for its consumers.  Should we limit ability to
>> query given parameter just because its value is hardcoded in hardware?
>
> I'm sorry, this makes no sense.  Setting a value in the constraints is
> not going to have any impact on the value reported by the driver, it
> never has.

... with the exception of fixed regulator, that is. This is from where I 
got my flawed understanding.

Looking at other drivers I see that's indeed special case not practiced 
elsewhere.

Thanks for explaining this.

Regards,
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
