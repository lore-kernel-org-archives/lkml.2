Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0LFTBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 14:01:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:55066 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab0LFTBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 14:01:18 -0500
Message-ID: <4CFD324B.8050800@oracle.com>
Date: Mon, 06 Dec 2010 10:58:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, trapdoor6@gmail.com,
        Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        brueckner@linux.vnet.ibm.com, mchehab@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild and kconfig fixes for 2.6.37-rc5
References: <20101204135732.GA12774@sepie.suse.cz>	<AANLkTimeyo==XJWUaUs8EzJvA8azkk3sw9FXQhMjuo6M@mail.gmail.com>	<20101205081108.9bdb7504.randy.dunlap@oracle.com>	<AANLkTimm1Xn4wwNAoDJ4hjnOmBOnxBgcsCzVEJTEag97@mail.gmail.com>	<AANLkTimXRBz7-mz_E_xdc85pGi7ExMy67XfDVF7jEt+Y@mail.gmail.com>	<4CFD258B.4030604@oracle.com> <AANLkTi=uMk74hYa-2aoVgj-F1h=+zGC2T=m4i__OwwQM@mail.gmail.com>
In-Reply-To: <AANLkTi=uMk74hYa-2aoVgj-F1h=+zGC2T=m4i__OwwQM@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/10 10:56, Arnaud Lacombe wrote:
> Hi,
> 
> On Mon, Dec 6, 2010 at 1:03 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On 12/06/10 10:01, Catalin Marinas wrote:
>> [...]
>>> This could be simplified to only show the first option of every '&&'
>>> expression, something like below:
>>>
>>> warning: I2C_ISCH selects MFD_CORE...
>>> warning: GPIO_SCH selects MFD_CORE...
>>>
>>> But I couldn't figure out whether the expression reduction code in
>>> kbuild reorders the options or not.
>>
> This was the purpose of a patch I send a month or two ago, though, you
> defeated it with cases the code was not taking into account. I updated
> it since, but did not post it. I'll post it on linux-kbuild@ and
> continue the discussion there.
> 
>> I'm pretty sure that I have seen cases where the faulty kconfig is not the
>> first one listed, so all of them need to be available.
>>
> do you have an example ?

Not at hand, but I'll be on the lookout for one.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
