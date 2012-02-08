Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab2BHPtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 10:49:17 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:32937 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab2BHPtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 10:49:15 -0500
Message-ID: <4F329953.9010608@ti.com>
Date: Wed, 8 Feb 2012 16:48:35 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>, <balbi@ti.com>,
        <linux-i2c@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <khali@linux-fr.org>, <ben-linux@fluff.org>, <w.sang@pengutronix.de>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] I2C: OMAP: fix build breakage when CONFIG_OF is not set
References: <1328698612-18661-1-git-send-email-coelho@ti.com>  <20120208105957.GB16334@legolas.emea.dhcp.ti.com>  <1328699077.20197.51.camel@cumari>  <CAM=Q2cvZWdUk-v4-EWUJzAf4br-4+tO2s3qS_dn4KhHp+mm2+g@mail.gmail.com> <1328700319.20197.54.camel@cumari>
In-Reply-To: <1328700319.20197.54.camel@cumari>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luca,

On 2/8/2012 12:25 PM, Luciano Coelho wrote:
> On Wed, 2012-02-08 at 16:42 +0530, Shubhrajyoti Datta wrote:
>> On Wed, Feb 8, 2012 at 4:34 PM, Luciano Coelho<coelho@ti.com>  wrote:
>>> On Wed, 2012-02-08 at 12:59 +0200, Felipe Balbi wrote:
>>>> On Wed, Feb 08, 2012 at 12:56:52PM +0200, Luciano Coelho wrote:
>>>>> Since commit 6145197be6cc0583fa1a2f4ec1079d366137061e, building
>>>>
>>>> we generally like to see the commit subject here too. And adding the
>>>> abbreviated commit instead of the full sha1, wouldn't hurt either ;-)
>>>
>>> Ok, different practices. :)
>>
>> However  there was already a discurssion.
>> Anyways thanks for the patch.
>> http://permalink.gmane.org/gmane.linux.ports.arm.omap/69796
>>
>>
>>>
>>> I'll send v2.
>> I think there was already a fix for this.
>>
>> http://www.spinics.net/lists/linux-omap/msg63151.html
>>
>> Anyways thanks for the patch.
>
> Ah, okay.  Thanks for the info, I hadn't seen these.

Yeah, it looks like the OMAP fixes missed -rc2, but Tony sent the pull 
request [1].

Regards,
Benoit

[1] http://www.spinics.net/lists/linux-omap/msg63564.html
