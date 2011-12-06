Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1LFWM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:12:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49430 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab1LFWM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:12:27 -0500
MIME-Version: 1.0
In-Reply-To: <20111206215137.GA20907@archminux>
References: <20111204160728.GA27292@archminux>
	<1323054041.6046.79.camel@linux-s257.site>
	<20111206215137.GA20907@archminux>
Date: Tue, 6 Dec 2011 23:12:26 +0100
Message-ID: <CAN+gG=EaG1h=seuKQa_SF2O033WWn52USh=tjO9F9O55DgH17Q@mail.gmail.com>
Subject: Re: [Dual-LVDS Acer Iconia laptop] i915/DRM issue: one screen stays
 off [3.2-rc4+]
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: joeyli <jlee@suse.com>, Baptiste Jonglez <baptiste@jonglez.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org,
        Mathieu Magnaudet <mathieu.magnaudet@enac.fr>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Baptiste,

On Tue, Dec 6, 2011 at 22:51, Baptiste Jonglez <baptiste@jonglez.org> wrote:
> On Mon, Dec 05, 2011 at 11:00:41AM +0800, joeyli wrote:
>> Add Cc. to platform-driver-x86 and linux-acpi
>>
>> Hi Baptiste
>>
>> 於 日，2011-12-04 於 17:07 +0100，Baptiste Jonglez 提到：
>> > Hi,
>> >
>> > I've got a lot of troubles with a dual-LVDS Acer laptop (it doesn't
>> > have a keyboard, but two displays with touchscreens)
>> >
>> > The Intel GPU is integrated into the Core i5-480M CPU: it's a bit
>> > older than Sandybridge, as it seems to be based on the Arrandale
>> > micro-architecture.
>> >
>> > In the BIOS, both displays work fine; but as soon as the kernel boots
>> > up, the second display (i.e. the one where you usually find a
>> > keyboard) is turned off. The main display works as expected.
>> >
>> > xrandr reports two LVDS displays: LVDS1, which is connected, and
>> > LVDS2, which is marked as "disconnected". No matter what I tried, I
>> > can't bring that second display up.
>> >
>> > During the boot, just after the drm is set up, the following message
>> > shows up:
>> >
>> >   [drm:intel_dsm_pci_probe] *ERROR* failed to get supported _DSM functions
>> >
>> > (attached is the relevant part of dmesg [1])
>
> The second screen works fine with the attached patch. It actually is
> 6 months old but seems to have been lost in the wild...

You don't have the problem of the second backlight still off?
On our Iconia, we need to trigger a special DMI command to set it up
(SDSS, IIRC).

>
> Thanks Benjamin!

All the credits are from Ajax and somebody else on IRC I don't recall,
really sorry. Thanks to them.

Cheers,
Benjamin.

>
> There is still the issue of unhandled acer-wmi events, but it's far
> less incapacitating. I wonder what's the best way to report events to
> userspace, though (e.g. for the "keyboard" button, userspace might
> want to know when it is pressed in order to display a virtual keyboard
> or any other fancy stuff)
>
> Joey, if you need more logs for acer-wmi, I'll be happy to provide.
>
>
> Baptiste
