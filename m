Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab2ILUna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:43:30 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:54705 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268Ab2ILUn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:43:28 -0400
Message-ID: <5050F3DB.1050202@metafoo.de>
Date: Wed, 12 Sep 2012 22:43:07 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Greg Ungerer <gerg@snapgear.com>
CC: dedekind1@gmail.com, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@ti.com>, Greg Ungerer <gerg@uclinux.org>,
        Julia Lawall <julia.lawall@lip6.fr>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Make the managed clk functions generically available
References: <1347202862-1617-1-git-send-email-lars@metafoo.de>  <20120909235059.GA2643@sirena.org.uk>  <20120910001524.GL13739@n2100.arm.linux.org.uk>  <20120910002020.GB16249@opensource.wolfsonmicro.com>  <20120910003913.GM13739@n2100.arm.linux.org.uk> <504F4E36.20309@metafoo.de> <1347375033.27206.3.camel@sauron.fi.intel.com> <504FE633.2090304@snapgear.com>
In-Reply-To: <504FE633.2090304@snapgear.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 03:32 AM, Greg Ungerer wrote:
> On 12/09/12 00:50, Artem Bityutskiy wrote:
>> On Tue, 2012-09-11 at 16:44 +0200, Lars-Peter Clausen wrote:
>>> On 09/10/2012 02:39 AM, Russell King - ARM Linux wrote:
>>>> On Mon, Sep 10, 2012 at 08:20:21AM +0800, Mark Brown wrote:
>>>>> [...]
>>>>> OK, that's what I'd thought was going on - it was the fact that you'd
>>>>> just acked the patch rather than asked for it to go to the patch
>>>>> tracker
>>>>> or something which made me wonder if things had changed.
>>>>
>>>> I kind'a forgot because it's been soo long since I took any of those
>>>> patches...
>>>
>>> Ok, what's the plan? Should I add this patch to the patch tracker?
>>
>> I'd propose to send it to Linus for v3.6 even.
> 
> If we do this can we make a decision quickly on it.
> 
> I need to fix a regression on some ColdFire parts for 3.6. I either need
> to use this clk patch, which fixes my problem, or a specific patch for the
> ColdFire clk code http://marc.info/?l=linux-m68k&m=134725225823437&w=2
> 

I wouldn't mind having this merged sooner rather than later, there is at least
one driver in next which is currently broken due to the missing devm_clk_get.
Russell what's your plan for the patch? Maybe under the given circumstances it
makes sense to let it go through the m68k tree.

- Lars
