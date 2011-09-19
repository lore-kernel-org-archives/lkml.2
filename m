Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1ISRWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 13:22:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60503 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab1ISRWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:22:39 -0400
Message-ID: <4E777A40.20508@ti.com>
Date: Mon, 19 Sep 2011 19:22:08 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        "parthab@india.ti.com" <parthab@india.ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Hilman, Kevin" <khilman@ti.com>, "paul@pwsan.com" <paul@pwsan.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
Subject: Re: [PATCH 0/5 v9] mfd: omap: usb: Runtime PM support for EHCI and
 OHCI drivers
References: <1316092970-2440-1-git-send-email-keshava_mgowda@ti.com> <20110919135653.GR32263@sortiz-mobl> <CAP05o4+AYs07JLio7NgSUOuzSTqiZA45WPDPqAB55u=02vHYWA@mail.gmail.com>
In-Reply-To: <CAP05o4+AYs07JLio7NgSUOuzSTqiZA45WPDPqAB55u=02vHYWA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keshava,

On 9/19/2011 4:01 PM, Munegowda, Keshava wrote:
> On Mon, Sep 19, 2011 at 7:26 PM, Samuel Ortiz<sameo@linux.intel.com>  wrote:
>> Hi Keshava,
>>
>> On Thu, Sep 15, 2011 at 06:52:45PM +0530, Keshava Munegowda wrote:
>>> From: Keshava Munegowda<Keshava_mgowda@ti.com>
>>>
>>> The Hwmod structures and Runtime PM features are implemented
>>> For EHCI and OHCI drivers of OMAP3 and OMAP4.
>>> The global suspend/resume of EHCI and OHCI
>>> is validated on OMAP3430 sdp board with these patches.
>>>
>>> these patches are rebased to kevin's pm branch and
>>> usbhs latest mainline kernel patches
>>
>> I'm ready to apply this one to my MFD for-next branch. Or do you want it to go
>> through Kevin's tree ?
>>
>> Cheers,
>> Samuel
>
>
> Thanks samuel;
> But, patch 1 and 2 requires benoit causson's ack by;
> so , I am waiting for benoit response on this.

I made a couple of comments in the v8, and you did address only half of 
them. It will be nice to at least answer the remaining points.

Moreover, Paul is the maintainer of the OMAP3 hwmod data file.

Regards,
Benoit
