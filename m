Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab2FRF1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 01:27:17 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18201 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2FRF1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 01:27:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 17 Jun 2012 22:24:30 -0700
Message-ID: <4FDEB9ED.8070608@nvidia.com>
Date: Mon, 18 Jun 2012 10:47:33 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "axel.lin@gmail.com" <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>
Subject: Re: [PATCH] regulator: tps62360: Simplify tps62360_set_voltage_time_sel
 implementation
References: <1339137332.16616.0.camel@phoenix> <20120617200342.GO4267@opensource.wolfsonmicro.com> <CAF+7xWnS7+hxgoVbxYghi3Zj007U4tAsNZ6XnwkWEWdyK12+uA@mail.gmail.com>
In-Reply-To: <CAF+7xWnS7+hxgoVbxYghi3Zj007U4tAsNZ6XnwkWEWdyK12+uA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 June 2012 10:49 AM, Axel Lin wrote:
> 2012/6/18 Mark Brown<broonie@opensource.wolfsonmicro.com>:
>> On Fri, Jun 08, 2012 at 02:35:32PM +0800, Axel Lin wrote:
>>
> This make me think if we should change the unit of ramp_delay
> to uV/uS rather than mV/uS. So we can avoid truncate issue.
>
Yes, we should have the ramp delay in uV/uS. many times, the ramp delay 
come as 0.025mV/uS  which will not be possible if we do mv/us.

