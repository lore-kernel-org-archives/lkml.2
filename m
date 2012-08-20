Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab2HTMSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 08:18:05 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:44758 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578Ab2HTMSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 08:18:01 -0400
MIME-Version: 1.0
In-Reply-To: <503229F5.4030405@ti.com>
References: <1344961473-13675-1-git-send-email-sourav.poddar@ti.com>
	<CAKdam57L8txFtE9ahy3u3vLW0XRP5z4QaNQKVFj9KaEFZE1qvg@mail.gmail.com>
	<503229F5.4030405@ti.com>
Date: Mon, 20 Aug 2012 17:47:59 +0530
Message-ID: <CAKdam543ATO96rbhgCWKtGUGRQ_+=KSyAk-nGBknjC+BvJSmOw@mail.gmail.com>
Subject: Re: [PATCHv3 0/4] Add device tree data for omap5
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Mon, Aug 20, 2012 at 5:43 PM, Benoit Cousson <b-cousson@ti.com> wrote:
> On 08/20/2012 02:10 PM, Poddar, Sourav wrote:
>> Hi All,
>>
>> On Tue, Aug 14, 2012 at 9:54 PM, Sourav Poddar <sourav.poddar@ti.com> wrote:
>>> The following patch series add i2c support for omap5.
>>> As well as enable I2C based devices like pressure and temperature
>>> through device tree. Also add onchip keypad dts data.
>>>
>>> Cc: Benoit Cousson <b-cousson@ti.com>
>>> Cc: Felipe Balbi <balbi@ti.com>
>>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>>
>>> Sourav Poddar (4):
>>>   arm/dts: omap5-evm: Add I2C support
>>>   arm/dts: omap5-evm: Add tmp102 sensor support
>>>   arm/dts: omap5-evm: Add keypad data
>>>   arm/dts: omap5-evm: Add bmp085 sensor support
>>>
>>> v2->v3
>>> - Rebased on 3.6-rc1
>>> - Add comments for tmp102 and bmp085
>>>  arch/arm/boot/dts/omap5-evm.dts |   32 +++++++++++++++++++++++++++++++
>>>  arch/arm/boot/dts/omap5.dtsi    |   40 +++++++++++++++++++++++++++++++++++++++
>>>  2 files changed, 72 insertions(+), 0 deletions(-)
>>>
>> Any comment on this series?
>
> Didn't we mentioned updating the trivial-devices.txt in the
> documentation to list these devices?
>
I had posted a patch for updating the Documentation, though I created
a seperate
hwmon/tmp102.txt file. There is a comment to add it to trivial devices. So,
I will post a single patch doing so.

> Otherwise it it fine. You can add the documentation and I'll take these
> patches as well along with the others.
>
> Regards,
> Benoit
