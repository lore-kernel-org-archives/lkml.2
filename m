Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab2EWAkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:40:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33847 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab2EWAkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:40:46 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7faf6d000001f49-cc-4fbc320c8954
Message-id: <4FBC320C.2040803@samsung.com>
Date: Wed, 23 May 2012 09:40:44 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Oritz <sameo@linux.intel.com>, Liam Girdwood <trg@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>
Subject: Re: [PATCH 2/3] regulator: MAX77686: Add Maxim 77686 regulator driver
References: <1337333539-18371-1-git-send-email-jonghwa3.lee@samsung.com>
 <1337333539-18371-3-git-send-email-jonghwa3.lee@samsung.com>
 <20120520155616.GB9337@opensource.wolfsonmicro.com>
 <4FB9EFBB.20306@samsung.com>
 <20120521095540.GA1999@opensource.wolfsonmicro.com>
In-reply-to: <20120521095540.GA1999@opensource.wolfsonmicro.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jQV0eoz3+BjOPW1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MJZ91C+5zVPzav46tgfE9WxcjJ4eEgInErxW7oGwxiQv31gPZ
	XBxCAtMZJVaffcEOkuAVEJT4MfkeSxcjBwezgLzEkUvZIGFmAXWJSfMWMYPYQgJ9TBJPe1NA
	SngFtCSWtpuAmCwCqhI7vkmCVLAJyEm8bfrGCBIWFYiQ+NXPAWKKAB3w+34lyE5mga1MEouv
	fWMGiQsL+ElcPu4OccskJokzl5pYQMZwCjhIHHy2jXUCo8AsJKfNQjhtFpLTFjAyr2IUTS1I
	LihOSs810itOzC0uzUvXS87P3cQIDrpn0jsYVzVYHGIU4GBU4uG9cX+3vxBrYllxZe4hRgkO
	ZiUR3vXTgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5nyzZ4S8kkJ5YkpqdmlqQWgSTZeLglGpg
	ZF39RDjk3VapIz6ikSd6+/2nrU8L5L2b2H32/u2252e92GaFzTgavfbZnemzRHgvRnCLVBpt
	d+F7zeEyZdkKPUfz74n/Tr4I/3f04p9UwWjfpuALL6e8U2x6Z97GdjqPneGzVtmL3kW1Ouvz
	txzVW6+lW5d0OffkBPbPTEuaEkNWnGHg81lyWImlOCPRUIu5qDgRAKXuudo2AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark,
On 2012년 05월 21일 18:55, Mark Brown wrote:

> On Mon, May 21, 2012 at 04:33:15PM +0900, jonghwa3.lee@samsung.com wrote:
>> On 2012년 05월 21일 00:56, Mark Brown wrote:
>>> On Fri, May 18, 2012 at 06:32:18PM +0900, Jonghwa Lee wrote:
> 
>>>> +	}, {
>>>> +		.name	= "EN32KHz PMIC",
>>>> +		.id	= MAX77686_P32KH,
>>>> +		.ops	= &max77686_fixedvolt_ops,
>>>> +		.type	= REGULATOR_VOLTAGE,
>>>> +		.owner	= THIS_MODULE,
>>>> +	},
> 
>>> These should be managed via the clock API now we have one.
> 
>> I already updated all your comments except only this one. Could you
>> explain more details?
> 
> We now have a generic clock framework in drivers/clk so we should be
> using that to provide drivers for clocks rather than putting them into
> the regulator API which was always a bodge.


I tried to change API to generic version but it got problem because of
overlapping. As you know almost of boards uses private clock API not
generic. So how do you think can i test it without modifying board file?
I'm afraid of changing all clock registering is too expensive.

Thanks.
