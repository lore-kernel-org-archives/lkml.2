Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2LTTDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:03:30 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:40949 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab2LTTDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:03:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAD=FV=UeAN103KVLb_z-oF8AXu7m00uZs6jw_BOHTz9RExK4SA@mail.gmail.com>
References: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
	<1355841786-13307-2-git-send-email-gautam.vivek@samsung.com>
	<CAD=FV=Ved4TSr7v413u5_o2cBrfegGrpKe1V2qKwQ36v-MQTHA@mail.gmail.com>
	<CAFp+6iEGhrSh+oFnv1s_Tqdzxh_nhy=NEhCetVF20KVehy3PLw@mail.gmail.com>
	<CAD=FV=UeAN103KVLb_z-oF8AXu7m00uZs6jw_BOHTz9RExK4SA@mail.gmail.com>
Date: Fri, 21 Dec 2012 00:33:19 +0530
Message-ID: <CAFp+6iHcF44BWxq-1avHJM8BvU6c0oSMk=-SRTGHCLNT9-DwrQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] ARM: EXYNOS: Update & move usb-phy types to
 generic include layer
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, jg1.han@samsung.com,
        yulgon.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        Praveen Paneri <p.paneri@samsung.com>, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        balbi@ti.com, kishon@ti.com, Kukjin Kim <kgene.kim@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Rob Herring <rob.herring@calxeda.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Thu, Dec 20, 2012 at 10:23 PM, Doug Anderson <dianders@chromium.org> wrote:
> Vivek,
>
> On Wed, Dec 19, 2012 at 9:51 PM, Vivek Gautam <gautamvivek1987@gmail.com> wrote:
>> Hi Doug,
>>
>>
>> On Thu, Dec 20, 2012 at 3:18 AM, Doug Anderson <dianders@chromium.org> wrote:
>>> Vivek,
>>>
>>> Since you're changing the name, I would have expected to see a removal
>>> of the old enum type in this patch.  I don't see it.  After applying
>>> all of your patches I find that S5P_USB_PHY_HOST and
>>> S5P_USB_PHY_DEVICE are still defined and used.
>>>
>>
>> True that we should have removed the earlier defined enums, infact i
>> did the same
>> in patchset v4 for this series. But since in this patchset i separated
>> out drivers and
>> architecture part, i thought it would be easier to remove them in one
>> shot in a latter commit
>> which will actually touch upon all architecture related code
>> (mach-exynos/setup-usb-phy.c,
>> mach-s5pv210/setup-usb-phy.c, and include/plat/usb-phy.h) once this
>> approach is accepted.
>>
>>> $ git grep S5P_USB_PHY_HOST
>>> arch/arm/mach-exynos/setup-usb-phy.c:   else if (type == S5P_USB_PHY_HOST)
>>> arch/arm/mach-exynos/setup-usb-phy.c:   else if (type == S5P_USB_PHY_HOST)
>>> arch/arm/plat-samsung/include/plat/usb-phy.h:   S5P_USB_PHY_HOST,
>>>
>>> I believe that those usages of the old enum should also be switched
>>> over and the old enum removed.
>>>
>> Sure, those enums need to be removed.
>> If you say i will submit a patch for the same.
>
> It would be nice to add it to the patch series in the next version.  Thanks!
>

Sure i shall add the same to the arch patches in the next version, or
if needed will send a separate patch for this.

> -Doug



-- 
Thanks & Regards
Vivek
