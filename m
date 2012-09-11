Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab2IKJQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:16:38 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:52631 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244Ab2IKJQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:16:36 -0400
MIME-Version: 1.0
In-Reply-To: <504F0053.6000808@ti.com>
References: <1347345381-4390-1-git-send-email-kishon@ti.com>
	<504EF587.3080903@ti.com>
	<CAAe_U6JoW36bWSamHkRV66JX5fZ3QkLQv=4XJr-MuaFgaRjOaA@mail.gmail.com>
	<504F0053.6000808@ti.com>
Date: Tue, 11 Sep 2012 14:46:35 +0530
Message-ID: <CAAe_U6Kanxmvw5mWzGQ-7Jig6K75FA7UwxUipKfp4gURtntrRg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] arm/dts: omap: add dt data for MUSB
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: tony@atomide.com, balbi@ti.com, linux@arm.linux.org.uk,
        rob.herring@calxeda.com, grant.likely@secretlab.ca, rnayak@ti.com,
        hvaibhav@ti.com, peter.ujfalusi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 11, 2012 at 2:41 PM, Benoit Cousson <b-cousson@ti.com> wrote:
> On 09/11/2012 10:44 AM, ABRAHAM, KISHON VIJAY wrote:
>> Hi Benoit,
>>
>> On Tue, Sep 11, 2012 at 1:55 PM, Benoit Cousson <b-cousson@ti.com> wrote:
>>> On 09/11/2012 08:36 AM, Kishon Vijay Abraham I wrote:
>>>> No major change from the previous version. Just removed the
>>>> omap-usb2 dt data and sent that as a separate patch.
>>>
>>> Well, I think you'd better keep them in the same series :-)
>>>
>>>> Rebased on
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git musb
>>>
>>> Since it is DTS stuf, you should rebase that on top of the latest
>>> lo/devel-dt branch. All the latest DTS patches an in there for 3.7.
>>
>> The ocp2scp data is not in linux-omap :-( And omap-usb2 has to be a
>> child of ocp2scp. So I used arm-soc tree to which ocp2scp stuff was
>> pulled into.
>
> Mmm, but from what tree? It did not go through Tony?
> What arm-soc branch exactly?

git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git for-next
(or) ocp2scp

Thanks
Kishon
>
> In that case we need to merge Tony's devel-dt into arm-soc to have a
> common base or ask Tony to rebase on top of arm-soc.
>
> I added a bunch of change inside OMAP4.dtsi, so we can expect some nice
> conflicts.
> That's why it is better to push DTS patches using a single channel.
>
>
> Tony,
> What will make more sense to avoid merge conflict later?
>
>
> Regards,
> Benoit
>
>
