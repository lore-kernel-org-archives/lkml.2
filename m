Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1GHRu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:50:59 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:54712 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883Ab1GHRu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:50:57 -0400
From: Partha Basak <p-basak2@ti.com>
References: <1310122965-23612-1-git-send-email-keshava_mgowda@ti.com>
	<20110708114425.GI4820@legolas.emea.dhcp.ti.com> <87k4bsbzfe.fsf@ti.com>
In-Reply-To: <87k4bsbzfe.fsf@ti.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acw9fjri09sjcJ8nT36e2a9HllpW2QAGLMyA
Date: Fri, 8 Jul 2011 23:20:54 +0530
Message-ID: <c1ed0c50a398ed5296dea561c9a30a6d@mail.gmail.com>
Subject: RE: [PATCH 0/6 v3] arm: omap: usb: Runtime PM support for EHCI and
 OHCI drivers
To: Kevin Hilman <khilman@ti.com>, Felipe Balbi <balbi@ti.com>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anand Gadiyar <gadiyar@ti.com>, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com,
        Benoit Cousson <b-cousson@ti.com>, paul@pwsan.com, johnstul@us.ibm.com,
        Vishwanath Sripathy <vishwanath.bs@ti.com>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Kevin Hilman [mailto:khilman@ti.com]
>Sent: Friday, July 08, 2011 8:19 PM
>To: balbi@ti.com
>Cc: Keshava Munegowda; linux-usb@vger.kernel.org; linux-
>omap@vger.kernel.org; linux-kernel@vger.kernel.org; gadiyar@ti.com;
>sameo@linux.intel.com; parthab@india.ti.com; tony@atomide.com; b-
>cousson@ti.com; paul@pwsan.com; johnstul@us.ibm.com;
>vishwanath.bs@ti.com; kishon@ti.com
>Subject: Re: [PATCH 0/6 v3] arm: omap: usb: Runtime PM support for EHCI
>and OHCI drivers
>
>Felipe Balbi <balbi@ti.com> writes:
>
>> Hi Kevin, Paul, Tony, Benoit,
>>
>> On Fri, Jul 08, 2011 at 04:32:39PM +0530, Keshava Munegowda wrote:
>>> The Hwmod structures and Runtime PM features are implemented
>>> For EHCI and OHCI drivers of OMAP3 and OMAP4.
>>> The global suspend/resume of EHCI and OHCI
>>> is validated on OMAP3430 sdp board with these patches.
>>>
>>> V3:
>>> Set MSTANDBY_SMART_WKUP for idlemode of usbhost
>>> Rebased on top of git://gitorious.org/omap-pm/linux.git
>>> Branch: for_3.1/3_hwmod_fixes
>>> commit 213ca8a3a8d73225f2f5304ab3a68c6eda0f6d1b
>>> Author: Benoit Cousson <b-cousson@ti.com>
>>> Date:   Fri Jul 1 13:52:03 2011 +0200
>>>
>>>     OMAP: hwmod: Move pr_debug to improve the readability
>>>
>>>     Sligtly move the pr_debug at the top of the function
>>>     to trace the entry even if the first test is failing.
>>>     That help understanding that we entered the function
>>>     but failed in it.
>>>
>>>     Move the _enable last part out of the test to reduce
>>>     indentation and improve readability.
>>>
>>>     Signed-off-by: Benoit Cousson <b-cousson@ti.com>
>>>     Cc: Paul Walmsley <paul@pwsan.com>
>>>
>>> Benoit Cousson (1):
>>>  arm: omap: usb: ehci and ohci hwmod structures for omap4
>>>
>>> Keshava Munegowda (5):
>>>   arm: omap: usb: ehci and ohci hwmod structures for omap3
>>>   arm: omap: usb: register hwmods of usbhs
>>>   arm: omap: usb: device name change for the clk names of usbhs
>>>   arm: omap: usb: Runtime PM support
>>>   arm: omap: usb: global Suspend and resume support of ehci and ohci
>>
>> can we get the hwmod stuff in this merge window now ? It has been
>> rebased on Benoit's branch.
>
>Not yet.
>
>It's not about rebasing, it's that the data itself has changed, and new
>fields have been added to the hwmod (like clkdm.)
>
>Please check the result of the latest auto-generated hwmods against the
>stuff that is being submitted.

Not all the patches sent by Benoit are accepted by Paul.
Can you point to a git-tree which we should compare against?
>
>Kevin
