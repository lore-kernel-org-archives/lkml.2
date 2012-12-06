Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab2LFB6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 20:58:08 -0500
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:49968 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097Ab2LFB6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 20:58:06 -0500
Message-ID: <50BFFBAE.4010300@marvell.com>
Date: Thu, 06 Dec 2012 09:58:06 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Qiao Zhou <zhouqiao@marvell.com>, Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Documentation: add docs for 88pm80x dt
References: <1354686120-26169-1-git-send-email-qingx@marvell.com> <20121205225538.731E73E0E22@localhost>
In-Reply-To: <20121205225538.731E73E0E22@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Dec 2012 01:57:56.0707 (UTC) FILETIME=[1C7A4B30:01CDD355]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 06:55 AM, Grant Likely wrote:
> On Wed,  5 Dec 2012 13:42:00 +0800, Qing Xu <qingx@marvell.com> wrote:
>> From: Qing Xu <qingx@marvell.com>
>>
>> Signed-off-by: Qing Xu <qingx@marvell.com>
> No commit text?
>
> This patch needs to be squashed together with the patch that changes the
> driver. There is no value in separating them.
>
>> ---
>>   Documentation/devicetree/bindings/mfd/88pm80x.txt |   52 +++++++++++++++++++++
>>   1 files changed, 52 insertions(+), 0 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/mfd/88pm80x.txt
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/88pm80x.txt b/Documentation/devicetree/bindings/mfd/88pm80x.txt
>> new file mode 100644
>> index 0000000..8a0ed07
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mfd/88pm80x.txt
>> @@ -0,0 +1,52 @@
>> +* Marvell 88pm80x Power Management IC
>> +
>> +Required parent device properties:
>> +- compatible : "marvell,88pm80x"
>> +- reg : the I2C slave address for the 88pm80x chip
>> +- interrupts : IRQ line for the 88pm80x chip
>> +- interrupt-controller: describes the 88pm80x as an interrupt controller (has its own domain)
>> +- #interrupt-cells : should be 1.
>> +	- The cell is the 88pm80x local IRQ number
>> +
>> +Optional parent device properties:
>> +- marvell,88pm80x-irqmode: inicates whether interrupt status is cleared by read
>> +- marvell,88pm80x-poweraddr: 88pm80x are multi-chips solution. <reg> stores the I2C address
>> +				of one chip, and this property stores the I2C address of
>> +				power related chip.
>> +- marvell,88pm80x-gpadcaddr: 88pm80x are multi-chips solution. <reg> stores the I2C address
>> +				of one chip, and this property stores the I2C address of
>> +				gpadc related chip.
> If it is multichip, then I would expect either a separate node for each
> chip and these properties use phandles (instead of i2c addresses) to
> point to the other chip nodes.
>
> Alternately, if the cluster is described using a single node, then you
> can put all three i2c addresses into the 'reg' property.
>
> g.

combined to one patch. please help review again. Thanks!



