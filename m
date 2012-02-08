Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab2BHPy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 10:54:27 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:34716 "HELO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757128Ab2BHPyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 10:54:24 -0500
MIME-Version: 1.0
In-Reply-To: <4F329953.9010608@ti.com>
References: <1328698612-18661-1-git-send-email-coelho@ti.com>
	<20120208105957.GB16334@legolas.emea.dhcp.ti.com>
	<1328699077.20197.51.camel@cumari>
	<CAM=Q2cvZWdUk-v4-EWUJzAf4br-4+tO2s3qS_dn4KhHp+mm2+g@mail.gmail.com>
	<1328700319.20197.54.camel@cumari>
	<4F329953.9010608@ti.com>
Date: Wed, 8 Feb 2012 17:54:23 +0200
Message-ID: <CAKd1q9owoor5aShGb=LpDvkzmQvKASb8R9HPZtcyhvsY4+OqHg@mail.gmail.com>
Subject: Re: [PATCH] I2C: OMAP: fix build breakage when CONFIG_OF is not set
From: "Coelho, Luciano" <coelho@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>, balbi@ti.com,
        linux-i2c@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

Ok, thanks. Good to know that the fixes are already queued.

On 2/8/12, Cousson, Benoit <b-cousson@ti.com> wrote:
> Hi Luca,
>
> On 2/8/2012 12:25 PM, Luciano Coelho wrote:
>> On Wed, 2012-02-08 at 16:42 +0530, Shubhrajyoti Datta wrote:
>>> On Wed, Feb 8, 2012 at 4:34 PM, Luciano Coelho<coelho@ti.com>  wrote:
>>>> On Wed, 2012-02-08 at 12:59 +0200, Felipe Balbi wrote:
>>>>> On Wed, Feb 08, 2012 at 12:56:52PM +0200, Luciano Coelho wrote:
>>>>>> Since commit 6145197be6cc0583fa1a2f4ec1079d366137061e, building
>>>>>
>>>>> we generally like to see the commit subject here too. And adding the
>>>>> abbreviated commit instead of the full sha1, wouldn't hurt either ;-)
>>>>
>>>> Ok, different practices. :)
>>>
>>> However  there was already a discurssion.
>>> Anyways thanks for the patch.
>>> http://permalink.gmane.org/gmane.linux.ports.arm.omap/69796
>>>
>>>
>>>>
>>>> I'll send v2.
>>> I think there was already a fix for this.
>>>
>>> http://www.spinics.net/lists/linux-omap/msg63151.html
>>>
>>> Anyways thanks for the patch.
>>
>> Ah, okay.  Thanks for the info, I hadn't seen these.
>
> Yeah, it looks like the OMAP fixes missed -rc2, but Tony sent the pull
> request [1].
>
> Regards,
> Benoit
>
> [1] http://www.spinics.net/lists/linux-omap/msg63564.html
>


-- 
Cheers,
Luca.
