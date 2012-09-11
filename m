Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab2IKKC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:02:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33665 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab2IKKC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:02:26 -0400
Message-ID: <504F0C11.8050500@ti.com>
Date: Tue, 11 Sep 2012 12:01:53 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: <tony@atomide.com>, <balbi@ti.com>, <linux@arm.linux.org.uk>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <rnayak@ti.com>, <hvaibhav@ti.com>, <peter.ujfalusi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] arm/dts: omap: add dt data for MUSB
References: <1347345381-4390-1-git-send-email-kishon@ti.com> <504EF587.3080903@ti.com> <CAAe_U6JoW36bWSamHkRV66JX5fZ3QkLQv=4XJr-MuaFgaRjOaA@mail.gmail.com> <504F0053.6000808@ti.com> <CAAe_U6Kanxmvw5mWzGQ-7Jig6K75FA7UwxUipKfp4gURtntrRg@mail.gmail.com>
In-Reply-To: <CAAe_U6Kanxmvw5mWzGQ-7Jig6K75FA7UwxUipKfp4gURtntrRg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 11:16 AM, ABRAHAM, KISHON VIJAY wrote:
> Hi,
> 
> On Tue, Sep 11, 2012 at 2:41 PM, Benoit Cousson <b-cousson@ti.com> wrote:
>> On 09/11/2012 10:44 AM, ABRAHAM, KISHON VIJAY wrote:
>>> Hi Benoit,
>>>
>>> On Tue, Sep 11, 2012 at 1:55 PM, Benoit Cousson <b-cousson@ti.com> wrote:
>>>> On 09/11/2012 08:36 AM, Kishon Vijay Abraham I wrote:
>>>>> No major change from the previous version. Just removed the
>>>>> omap-usb2 dt data and sent that as a separate patch.
>>>>
>>>> Well, I think you'd better keep them in the same series :-)
>>>>
>>>>> Rebased on
>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git musb
>>>>
>>>> Since it is DTS stuf, you should rebase that on top of the latest
>>>> lo/devel-dt branch. All the latest DTS patches an in there for 3.7.
>>>
>>> The ocp2scp data is not in linux-omap :-( And omap-usb2 has to be a
>>> child of ocp2scp. So I used arm-soc tree to which ocp2scp stuff was
>>> pulled into.
>>
>> Mmm, but from what tree? It did not go through Tony?
>> What arm-soc branch exactly?
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git for-next
> (or) ocp2scp


OK, here it is:

+
+               ocp2scp {
+                       compatible = "ti,omap-ocp2scp";
+                       #address-cells = <1>;
+                       #size-cells = <1>;
+                       ranges;
+                       ti,hwmods = "ocp2scp_usb_phy";
+               };


In order to be consistent with the OMAP4 data now, you should update it
to add the reg, and IRQ if applicable.

But for that we do need a proper base with ocp2scp + devel-dt.

Regards,
Benoit

