Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1JLIO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 04:14:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39998 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab1JLIO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 04:14:56 -0400
Message-ID: <4E954C78.1070501@ti.com>
Date: Wed, 12 Oct 2011 10:14:48 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: "Kristo, Tero" <t-kristo@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv9 03/18] TEMP: OMAP3xxx: hwmod data: add PRM hwmod
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com> <1316781986-30642-4-git-send-email-t-kristo@ti.com> <alpine.DEB.2.00.1110101320180.5205@utopia.booyaka.com> <4E934D79.4080000@ti.com> <alpine.DEB.2.00.1110101416530.5205@utopia.booyaka.com> <4E936F0E.9050203@ti.com> <alpine.DEB.2.00.1110101631450.5205@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1110101631450.5205@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 12:35 AM, Paul Walmsley wrote:
> On Tue, 11 Oct 2011, Cousson, Benoit wrote:
>
>> On 10/10/2011 10:42 PM, Paul Walmsley wrote:
>>
>>> If it's the "3xxx" that you're objecting to in the name, we could call it
>>> "prm2" or "prmxyz" - the '3xxx' just seemed like the most logical
>>> approach.  The name of the hwmod class in the patch is still "prm", of
>>> course.
>>
>> Yes, but that's different, the number is supposed to represent the instance
>> number in the IP naming convention. So prm2 != prmv2.
>
> Heh, that works as long as there's no "prmv" IP block ;-)
>
>>> Thoughts?
>>
>> In fact the device name does not have to match the hwmod name. So we can just
>> create an "omap2_prm" omap_device for OMAP2, "omap3_prm" omap_device for
>> OMAP3...
>> That will allow the relevant PRM  driver to be bound to the proper device.
>
> We can, we'd just need to add this extra mapping layer, so it doesn't
> become a nasty special-case hack for each IP block that this applies to.
>
> Sounds like something for 3.3 (if ever...)

Yeah, since PRM and CM are critical pieces for the hwmod to DT 
migration, having them DT adapted for 3.3 will be very nice.

Benoit

