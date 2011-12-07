Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab1LGLEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 06:04:05 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59163 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab1LGLEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 06:04:04 -0500
MIME-Version: 1.0
In-Reply-To: <20111207065106.GE32368@legolas.emea.dhcp.ti.com>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
	<1309427470-605-4-git-send-email-balbi@ti.com>
	<CAMP44s3hFyAK+1W6eU30RNn3=cPDRGKXW+E+sDoWNrNhU0ZpPA@mail.gmail.com>
	<20111207065106.GE32368@legolas.emea.dhcp.ti.com>
Date: Wed, 7 Dec 2011 13:04:03 +0200
Message-ID: <CAMP44s0psqeMEh8vgYSfV=MAqSOJ6+EpWndXpc89qfGHMX_f=w@mail.gmail.com>
Subject: Re: [regression] Re: [PATCH 3/7] mfd: twl4030-irq: drop the kthread
From: Felipe Contreras <felipe.contreras@gmail.com>
To: balbi@ti.com
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 8:51 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Dec 06, 2011 at 05:28:58PM +0200, Felipe Contreras wrote:
>> On Thu, Jun 30, 2011 at 12:51 PM, Felipe Balbi <balbi@ti.com> wrote:
>> > ... and use threaded IRQ infrastructure. Later
>> > patches will come dropping both workqueues and
>> > setting the nested thread flag.
>>
>> There's something wrong. When I boot my Nokia N900 with this, as soon
>> as I press a key from the keyboard the whole device hangs. I don't see
>> anything on the console framebuffer, and with a jig I can't boot from
>> MMC, so there isn't much more I can provide at the moment.
>
> Funny, this booted fine on my beagle and MMC card uses a twl GPIO for
> card detection. Maybe it's something fairly obvious that I missed :-(

Did you try typing anything? That's where the problem happened on my side.

I'll try to flash a system to NAND, since I can't seem to just get the
MMC to work when the cover is open and the device is connected to the
jig to see if I can see something from serial console.

You don't have any idea about what to try?

-- 
Felipe Contreras
