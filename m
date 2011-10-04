Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab1JDL50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 07:57:26 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:49941 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756386Ab1JDL5Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 07:57:24 -0400
MIME-Version: 1.0
In-Reply-To: <877h4qj6fx.fsf@ti.com>
References: <1317361216-28248-1-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1109300107150.32653@utopia.booyaka.com>
	<CAP05o4LJ2P8DCri1Vf-opezP8eNX+Wghm9FBSYwy8Vrct8_YDw@mail.gmail.com>
	<877h4qj6fx.fsf@ti.com>
Date: Tue, 4 Oct 2011 17:27:23 +0530
Message-ID: <CAP05o4K71CuWqePZPa0wc7zRGaXdO4oYosCOSvybgqs0qZjx5Q@mail.gmail.com>
Subject: Re: [PATCH 2/5 v12] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 10:47 PM, Kevin Hilman <khilman@ti.com> wrote:
> "Munegowda, Keshava" <keshava_mgowda@ti.com> writes:
>
> [...]
>
>>>> +
>>>> +static struct omap_hwmod_ocp_if omap34xx_f_cfg__usb_tll_hs = {
>>>> +     .clk            = "usbtll_ick",
>>>> +     .user           = OCP_USER_MPU,
>>>> +     .flags          = OCPIF_SWSUP_IDLE,
>>>> +};
>>>
>>> Does this really need OCPIF_SWSUP_IDLE?  If so, then there is a hardware
>>> bug, and some explanation is needed.
>>
>>
>> it was not allowing enter usbhs pw domain to enter to low power idle mode; so
>> I add a comment here.
>>
>
> When you add this comment, please be sure it describes *why* the power
> domain was not hitting the target power state, and reference any
> relevant eerrata.

I will add the errata description and id

regards
keshava
