Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1G0LPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 07:15:14 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:39326 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492Ab1G0LPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 07:15:11 -0400
MIME-Version: 1.0
In-Reply-To: <20110727095328.GC26275@sortiz-mobl>
References: <1311340170-28773-1-git-send-email-keshava_mgowda@ti.com>
	<20110727095328.GC26275@sortiz-mobl>
Date: Wed, 27 Jul 2011 16:45:09 +0530
Message-ID: <CAP05o4KrWZLGaPYL+ArXD2XPN6yvH+0NJMFAcT1UsnM59CrWUQ@mail.gmail.com>
Subject: Re: [PATCH] mfd: omap-usb-host: fix clock API usage on usbhs_disable()
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        parthab@india.ti.com, kishon@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks samuel


regards
keshava

On Wed, Jul 27, 2011 at 3:23 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Keshava,
>
> On Fri, Jul 22, 2011 at 06:39:30PM +0530, Keshava Munegowda wrote:
>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>>
>> usbhs_disable function was invoking clk_enable() instead of
>> clk_disable(), thus only increasing the clock usage counter and
>> preventing this particular clock from being ever turned off.
>> Because of this, the power domain of omap4 the USB Host subsystem
>> would never reach lower power states.This patch calls clk_disable()
>> in usbhs_disable function
> I applied this patch now, thanks.
>
> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
>
