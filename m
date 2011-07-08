Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1GHOtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:49:18 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:40132 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129Ab1GHOtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:49:15 -0400
From: Kevin Hilman <khilman@ti.com>
To: balbi@ti.com
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gadiyar@ti.com, sameo@linux.intel.com, parthab@india.ti.com,
        tony@atomide.com, b-cousson@ti.com, paul@pwsan.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com, kishon@ti.com
Subject: Re: [PATCH 0/6 v3] arm: omap: usb: Runtime PM support for EHCI and OHCI drivers
Organization: Texas Instruments, Inc.
References: <1310122965-23612-1-git-send-email-keshava_mgowda@ti.com>
	<20110708114425.GI4820@legolas.emea.dhcp.ti.com>
Date: Fri, 08 Jul 2011 07:49:09 -0700
In-Reply-To: <20110708114425.GI4820@legolas.emea.dhcp.ti.com> (Felipe Balbi's
	message of "Fri, 8 Jul 2011 14:44:26 +0300")
Message-ID: <87k4bsbzfe.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi <balbi@ti.com> writes:

> Hi Kevin, Paul, Tony, Benoit,
>
> On Fri, Jul 08, 2011 at 04:32:39PM +0530, Keshava Munegowda wrote:
>> The Hwmod structures and Runtime PM features are implemented
>> For EHCI and OHCI drivers of OMAP3 and OMAP4.
>> The global suspend/resume of EHCI and OHCI
>> is validated on OMAP3430 sdp board with these patches.
>> 
>> V3:
>> Set MSTANDBY_SMART_WKUP for idlemode of usbhost
>> Rebased on top of git://gitorious.org/omap-pm/linux.git
>> Branch: for_3.1/3_hwmod_fixes
>> commit 213ca8a3a8d73225f2f5304ab3a68c6eda0f6d1b
>> Author: Benoit Cousson <b-cousson@ti.com>
>> Date:   Fri Jul 1 13:52:03 2011 +0200
>> 
>>     OMAP: hwmod: Move pr_debug to improve the readability
>>     
>>     Sligtly move the pr_debug at the top of the function
>>     to trace the entry even if the first test is failing.
>>     That help understanding that we entered the function
>>     but failed in it.
>>     
>>     Move the _enable last part out of the test to reduce
>>     indentation and improve readability.
>>     
>>     Signed-off-by: Benoit Cousson <b-cousson@ti.com>
>>     Cc: Paul Walmsley <paul@pwsan.com>
>> 
>> Benoit Cousson (1):
>>  arm: omap: usb: ehci and ohci hwmod structures for omap4
>> 
>> Keshava Munegowda (5):
>>   arm: omap: usb: ehci and ohci hwmod structures for omap3
>>   arm: omap: usb: register hwmods of usbhs
>>   arm: omap: usb: device name change for the clk names of usbhs
>>   arm: omap: usb: Runtime PM support
>>   arm: omap: usb: global Suspend and resume support of ehci and ohci
>
> can we get the hwmod stuff in this merge window now ? It has been
> rebased on Benoit's branch.

Not yet.

It's not about rebasing, it's that the data itself has changed, and new
fields have been added to the hwmod (like clkdm.)

Please check the result of the latest auto-generated hwmods against the
stuff that is being submitted.

Kevin
