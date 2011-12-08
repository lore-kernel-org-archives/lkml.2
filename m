Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1LHKL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 05:11:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53139 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1LHKLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 05:11:24 -0500
MIME-Version: 1.0
In-Reply-To: <20111206223109.GA1867@archminux>
References: <20111204160728.GA27292@archminux>
	<1323054041.6046.79.camel@linux-s257.site>
	<20111206215137.GA20907@archminux>
	<CAN+gG=EaG1h=seuKQa_SF2O033WWn52USh=tjO9F9O55DgH17Q@mail.gmail.com>
	<20111206223109.GA1867@archminux>
Date: Thu, 8 Dec 2011 11:11:22 +0100
Message-ID: <CAN+gG=FoxDg3O5VSVkZEPGn4cVE=SJ4MUfvCgnYiB8vJGTLKmQ@mail.gmail.com>
Subject: Re: [Dual-LVDS Acer Iconia laptop] i915/DRM issue: one screen stays
 off [3.2-rc4+]
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>, joeyli <jlee@suse.com>,
        Baptiste Jonglez <baptiste@jonglez.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org,
        Mathieu Magnaudet <mathieu.magnaudet@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 6, 2011 at 23:31, Baptiste Jonglez <baptiste@jonglez.org> wrote:
> On Tue, Dec 06, 2011 at 11:12:26PM +0100, Benjamin Tissoires wrote:
>> Hi Baptiste,
>
> Hi,
>
>> On Tue, Dec 6, 2011 at 22:51, Baptiste Jonglez <baptiste@jonglez.org> wrote:
>> > The second screen works fine with the attached patch. It actually is
>> > 6 months old but seems to have been lost in the wild...
>>
>> You don't have the problem of the second backlight still off?
>> On our Iconia, we need to trigger a special DMI command to set it up
>> (SDSS, IIRC).
>
> No, with the patch, it worked out-of-the-box.

mmm, this is weird. We must not have the same bios or device version.
We need to explicitly set the LCD2 up.

>
> I can even control the brightness in
> `/sys/class/backlight/acpi_video0/brightness' (it affects both
> displays at the same time though). But even at 0, it's still perfectly
> readable.

Yes, the acpi can control both brightness. But WMI can control each
brightness. However, we are not sure this is what people want. So we
do not plan to introduce a second brightness control.

>
> Maybe this a bug that got fixed recently? I've actually tried the 3.1
> kernel (and then the 3.2-rc4) because I noticed a lot of commits and
> improvements in the i915 driver recently.

We doubled-checked on 3.2-rc4, and we still need our patch. This is
definitively a bios/hardware configuration problem.

Cheers,
Benjamin

>
>> > Thanks Benjamin!
>>
>> All the credits are from Ajax and somebody else on IRC I don't recall,
>> really sorry. Thanks to them.
>>
>> Cheers,
>> Benjamin.
>
> Regards,
> Baptiste
