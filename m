Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2HTMUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 08:20:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35921 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2HTMUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 08:20:01 -0400
Message-ID: <50322B68.8060906@ti.com>
Date: Mon, 20 Aug 2012 14:19:52 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Poddar, Sourav" <sourav.poddar@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv3 0/4] Add device tree data for omap5
References: <1344961473-13675-1-git-send-email-sourav.poddar@ti.com> <CAKdam57L8txFtE9ahy3u3vLW0XRP5z4QaNQKVFj9KaEFZE1qvg@mail.gmail.com> <503229F5.4030405@ti.com> <CAKdam543ATO96rbhgCWKtGUGRQ_+=KSyAk-nGBknjC+BvJSmOw@mail.gmail.com>
In-Reply-To: <CAKdam543ATO96rbhgCWKtGUGRQ_+=KSyAk-nGBknjC+BvJSmOw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 02:17 PM, Poddar, Sourav wrote:
> Hi Benoit,
> 
> On Mon, Aug 20, 2012 at 5:43 PM, Benoit Cousson <b-cousson@ti.com> wrote:
>> On 08/20/2012 02:10 PM, Poddar, Sourav wrote:
>>> Hi All,
>>>
>>> On Tue, Aug 14, 2012 at 9:54 PM, Sourav Poddar <sourav.poddar@ti.com> wrote:
>>>> The following patch series add i2c support for omap5.
>>>> As well as enable I2C based devices like pressure and temperature
>>>> through device tree. Also add onchip keypad dts data.
>>>>
>>>> Cc: Benoit Cousson <b-cousson@ti.com>
>>>> Cc: Felipe Balbi <balbi@ti.com>
>>>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>>>
>>>> Sourav Poddar (4):
>>>>   arm/dts: omap5-evm: Add I2C support
>>>>   arm/dts: omap5-evm: Add tmp102 sensor support
>>>>   arm/dts: omap5-evm: Add keypad data
>>>>   arm/dts: omap5-evm: Add bmp085 sensor support
>>>>
>>>> v2->v3
>>>> - Rebased on 3.6-rc1
>>>> - Add comments for tmp102 and bmp085
>>>>  arch/arm/boot/dts/omap5-evm.dts |   32 +++++++++++++++++++++++++++++++
>>>>  arch/arm/boot/dts/omap5.dtsi    |   40 +++++++++++++++++++++++++++++++++++++++
>>>>  2 files changed, 72 insertions(+), 0 deletions(-)
>>>>
>>> Any comment on this series?
>>
>> Didn't we mentioned updating the trivial-devices.txt in the
>> documentation to list these devices?
>>
> I had posted a patch for updating the Documentation, though I created
> a seperate
> hwmon/tmp102.txt file. There is a comment to add it to trivial devices. So,
> I will post a single patch doing so.

Cool, I'll take it on top of this one then.

Thanks,
Benoit

