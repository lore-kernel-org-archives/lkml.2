Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab1ILGgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 02:36:35 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:55714 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321Ab1ILGgd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 02:36:33 -0400
MIME-Version: 1.0
In-Reply-To: <87mxedwoyu.fsf@ti.com>
References: <1315579967-24945-1-git-send-email-keshava_mgowda@ti.com>
	<1315579967-24945-2-git-send-email-keshava_mgowda@ti.com>
	<87mxedwoyu.fsf@ti.com>
Date: Mon, 12 Sep 2011 12:06:31 +0530
Message-ID: <CAP05o4+L=RtVr_653WRukwBtQX+8KyBNStmRjg7sk4tEoNY77w@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm: omap: usb: enable I/O wakeups of ehci and ohci
 hwmods of omap4
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        b-cousson@ti.com, paul@pwsan.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com, Kishon Vijay Abraham <kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 9, 2011 at 11:57 PM, Kevin Hilman <khilman@ti.com> wrote:
> Keshava Munegowda <keshava_mgowda@ti.com> writes:
>
>> From: Kishon Vijay Abraham <kishon@ti.com>
>>
>> For ehci and ohci hwmods, the omap4 I/O wakeup capablity is enabled.
>> for ehci in phy mode,
>>       - the DAT0 and DIR I/O pad is set as wakeup capable
>> for ohci in serial mode
>>       - usbb*_mm_rxdp is set as I/O wakeup for 6 pin serial mode
>>       - usbb*_mm_rxrcv is set as I/O wakeup for 4 pin serial mode
>>       - usbb*_mm_txen is set as I/O wakeup for 3 pin serial mode
>>       - usbb*_mm_txdat is set as I/O wakeup for 2 pin serial mode
>>
>> Signed-off-by: Kishon Vijay Abraham <kishon@ti.com>
>> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>
> What if the end user doesn't want this device to be a wakeup source?
>
> Currently, the IO pad wakeup for these pins is enabled unconditionally.
> While having it enabled as a wakeup source by default is fine, it should
> not generate wakeups if the user has disable them by doing:
>
>    $ echo disabled > /sys/devices/.../power/wakeup

OK, I will do this.

keshava
