Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab2IKJMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:12:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45469 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab2IKJL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:11:56 -0400
Message-ID: <504F0053.6000808@ti.com>
Date: Tue, 11 Sep 2012 11:11:47 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <linux@arm.linux.org.uk>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <rnayak@ti.com>, <hvaibhav@ti.com>,
        <peter.ujfalusi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] arm/dts: omap: add dt data for MUSB
References: <1347345381-4390-1-git-send-email-kishon@ti.com> <504EF587.3080903@ti.com> <CAAe_U6JoW36bWSamHkRV66JX5fZ3QkLQv=4XJr-MuaFgaRjOaA@mail.gmail.com>
In-Reply-To: <CAAe_U6JoW36bWSamHkRV66JX5fZ3QkLQv=4XJr-MuaFgaRjOaA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 10:44 AM, ABRAHAM, KISHON VIJAY wrote:
> Hi Benoit,
> 
> On Tue, Sep 11, 2012 at 1:55 PM, Benoit Cousson <b-cousson@ti.com> wrote:
>> On 09/11/2012 08:36 AM, Kishon Vijay Abraham I wrote:
>>> No major change from the previous version. Just removed the
>>> omap-usb2 dt data and sent that as a separate patch.
>>
>> Well, I think you'd better keep them in the same series :-)
>>
>>> Rebased on
>>> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git musb
>>
>> Since it is DTS stuf, you should rebase that on top of the latest
>> lo/devel-dt branch. All the latest DTS patches an in there for 3.7.
> 
> The ocp2scp data is not in linux-omap :-( And omap-usb2 has to be a
> child of ocp2scp. So I used arm-soc tree to which ocp2scp stuff was
> pulled into.

Mmm, but from what tree? It did not go through Tony?
What arm-soc branch exactly?

In that case we need to merge Tony's devel-dt into arm-soc to have a
common base or ask Tony to rebase on top of arm-soc.

I added a bunch of change inside OMAP4.dtsi, so we can expect some nice
conflicts.
That's why it is better to push DTS patches using a single channel.


Tony,
What will make more sense to avoid merge conflict later?


Regards,
Benoit


