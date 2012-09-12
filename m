Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288Ab2ILBcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 21:32:03 -0400
Received: from dnvwsmailout1.mcafee.com ([161.69.31.173]:17874 "EHLO
	DNVWSMAILOUT1.mcafee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab2ILBcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 21:32:01 -0400
Message-ID: <504FE633.2090304@snapgear.com>
Date: Wed, 12 Sep 2012 11:32:35 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@ti.com>, Greg Ungerer <gerg@uclinux.org>,
        Julia Lawall <julia.lawall@lip6.fr>, <linux-m68k@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: Make the managed clk functions generically available
References: <1347202862-1617-1-git-send-email-lars@metafoo.de>  <20120909235059.GA2643@sirena.org.uk>  <20120910001524.GL13739@n2100.arm.linux.org.uk>  <20120910002020.GB16249@opensource.wolfsonmicro.com>  <20120910003913.GM13739@n2100.arm.linux.org.uk> <504F4E36.20309@metafoo.de> <1347375033.27206.3.camel@sauron.fi.intel.com>
In-Reply-To: <1347375033.27206.3.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/12 00:50, Artem Bityutskiy wrote:
> On Tue, 2012-09-11 at 16:44 +0200, Lars-Peter Clausen wrote:
>> On 09/10/2012 02:39 AM, Russell King - ARM Linux wrote:
>>> On Mon, Sep 10, 2012 at 08:20:21AM +0800, Mark Brown wrote:
>>>> [...]
>>>> OK, that's what I'd thought was going on - it was the fact that you'd
>>>> just acked the patch rather than asked for it to go to the patch tracker
>>>> or something which made me wonder if things had changed.
>>>
>>> I kind'a forgot because it's been soo long since I took any of those
>>> patches...
>>
>> Ok, what's the plan? Should I add this patch to the patch tracker?
>
> I'd propose to send it to Linus for v3.6 even.

If we do this can we make a decision quickly on it.

I need to fix a regression on some ColdFire parts for 3.6. I either need
to use this clk patch, which fixes my problem, or a specific patch for the
ColdFire clk code http://marc.info/?l=linux-m68k&m=134725225823437&w=2

Regards
Greg


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
