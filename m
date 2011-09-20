Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab1ITGUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 02:20:39 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:36452 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab1ITGUi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 02:20:38 -0400
MIME-Version: 1.0
In-Reply-To: <4E777A40.20508@ti.com>
References: <1316092970-2440-1-git-send-email-keshava_mgowda@ti.com>
	<20110919135653.GR32263@sortiz-mobl>
	<CAP05o4+AYs07JLio7NgSUOuzSTqiZA45WPDPqAB55u=02vHYWA@mail.gmail.com>
	<4E777A40.20508@ti.com>
Date: Tue, 20 Sep 2011 11:50:36 +0530
Message-ID: <CAP05o4LB2=0tcAn5BLdKYz0bTVMv5=y+dZHusocO-byDQz758g@mail.gmail.com>
Subject: Re: [PATCH 0/5 v9] mfd: omap: usb: Runtime PM support for EHCI and
 OHCI drivers
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        "parthab@india.ti.com" <parthab@india.ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Hilman, Kevin" <khilman@ti.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 10:52 PM, Cousson, Benoit <b-cousson@ti.com> wrote:
> Hi Keshava,
>
> On 9/19/2011 4:01 PM, Munegowda, Keshava wrote:
>>
>> On Mon, Sep 19, 2011 at 7:26 PM, Samuel Ortiz<sameo@linux.intel.com>
>>  wrote:
>>>
>>> Hi Keshava,
>>>
>>> On Thu, Sep 15, 2011 at 06:52:45PM +0530, Keshava Munegowda wrote:
>>>>
>>>> From: Keshava Munegowda<Keshava_mgowda@ti.com>
>>>>
>>>> The Hwmod structures and Runtime PM features are implemented
>>>> For EHCI and OHCI drivers of OMAP3 and OMAP4.
>>>> The global suspend/resume of EHCI and OHCI
>>>> is validated on OMAP3430 sdp board with these patches.
>>>>
>>>> these patches are rebased to kevin's pm branch and
>>>> usbhs latest mainline kernel patches
>>>
>>> I'm ready to apply this one to my MFD for-next branch. Or do you want it
>>> to go
>>> through Kevin's tree ?
>>>
>>> Cheers,
>>> Samuel
>>
>>
>> Thanks samuel;
>> But, patch 1 and 2 requires benoit causson's ack by;
>> so , I am waiting for benoit response on this.
>
> I made a couple of comments in the v8, and you did address only half of
> them. It will be nice to at least answer the remaining points.
>
> Moreover, Paul is the maintainer of the OMAP3 hwmod data file.
>
> Regards,
> Benoit


Thanks Benoit
    I will reply to your mail which includes your comments with
detailed descriptions.

regards
keshava
