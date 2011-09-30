Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1I3RRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:17:34 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:59368 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755261Ab1I3RRb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:17:31 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Munegowda\, Keshava" <keshava_mgowda@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 2/5 v12] arm: omap: usb: ehci and ohci hwmod structures for omap3
Organization: Texas Instruments, Inc.
References: <1317361216-28248-1-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1109300107150.32653@utopia.booyaka.com>
	<CAP05o4LJ2P8DCri1Vf-opezP8eNX+Wghm9FBSYwy8Vrct8_YDw@mail.gmail.com>
Date: Fri, 30 Sep 2011 10:17:22 -0700
In-Reply-To: <CAP05o4LJ2P8DCri1Vf-opezP8eNX+Wghm9FBSYwy8Vrct8_YDw@mail.gmail.com>
	(Keshava Munegowda's message of "Fri, 30 Sep 2011 16:02:06 +0530")
Message-ID: <877h4qj6fx.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Munegowda, Keshava" <keshava_mgowda@ti.com> writes:

[...]

>>> +
>>> +static struct omap_hwmod_ocp_if omap34xx_f_cfg__usb_tll_hs = {
>>> +     .clk            = "usbtll_ick",
>>> +     .user           = OCP_USER_MPU,
>>> +     .flags          = OCPIF_SWSUP_IDLE,
>>> +};
>>
>> Does this really need OCPIF_SWSUP_IDLE?  If so, then there is a hardware
>> bug, and some explanation is needed.
>
>
> it was not allowing enter usbhs pw domain to enter to low power idle mode; so
> I add a comment here.
>

When you add this comment, please be sure it describes *why* the power
domain was not hitting the target power state, and reference any
relevant eerrata.

Thanks,

Kevin
