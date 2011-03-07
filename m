Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab1CGR3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 12:29:51 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:50200 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab1CGR3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 12:29:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NVG1Umvk2/Dw/gqeVZnWWNgBUIowY08GIPgBNwmJC5BlbC+72Q/+oFQHWAFgk8SAHi
         /qyJJY3d2vft97qxTiU6E6OiNgaj8kDxYiQ2e1WkuHsg2ewMYWb4JHblO4++HSutyA4H
         n3qnBd7igNzj4CN9REHGK7MpXg4k+iIZUX2OA=
MIME-Version: 1.0
In-Reply-To: <op.vry7kwq83ri7v4@arend-laptop>
References: <AANLkTinhThfS587rkX4y1UbJLQzQKEWGfrFArUVGD3Ew@mail.gmail.com>
	<op.vryqz6qt3ri7v4@arend-laptop>
	<AANLkTinbrbkUO-ycAsX4cLEoM6avPeiYEZZ-zKtavfqq@mail.gmail.com>
	<op.vry7kwq83ri7v4@arend-laptop>
Date: Mon, 7 Mar 2011 18:29:47 +0100
Message-ID: <AANLkTinWOFPUqmv6PbQMy6xnsAptGKUjoAHoxB65LCy9@mail.gmail.com>
Subject: Re: brcm80211: the system freezes if booted with laptop wifi switch
 to OFF
From: Francis Moreau <francis.moro@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 2:54 PM, Arend van Spriel <arend@broadcom.com> wrote:
>
> I don't know what the origin is of your kernel so please provide some
> details on that.

What kind of information do you need ?

As you probably noticed the kernel I'm running is 2.6.38-rc6.

Revelant part of lscpi:

12:00.0 Network controller: Broadcom Corporation Device 4727 (rev 01)
	Subsystem: Dell Device 0010
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at fbb00000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: brcm80211
	Kernel modules: brcm80211


> The patch itself can be found in the linuxdriver email
> archive:
>
> http://driverdev.linuxdriverproject.org/pipermail/devel/2011-January/011381.html
>

Do you want me to give it a try ?

> Not sure whether it applies to whatever you have. I just tried your scenario
> with my driver and hardware and no freezes during boot.

My scenario is:

   - set the switch to OFF
   - insmod the module
   - bring up/configure the interface

Thanks
-- 
Francis
