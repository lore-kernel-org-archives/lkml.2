Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2FMM0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:26:30 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41263 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012Ab2FMM03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:26:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120613113133.38c1ca8a@pyramind.ukuu.org.uk>
References: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
 <CAMeQTsZfE8_t6DCr3UWVqnOLyxNuNh7_VxJmqiP+enBBqM0o_A@mail.gmail.com>
 <CAH9NwWc3W6zHCFf9rwKg5NMQaWnh4A=xVVysmG1Y=eUMzu=18Q@mail.gmail.com>
 <CAMeQTsaknGLR2QCWwN8kYKh8y=JJtqN-ZSty6YTKnAOv2Vp3XQ@mail.gmail.com>
 <CAH9NwWdmhmLB5io5RWVQBj6c7zjXT9hFa7OAHVrL6oY8P0kjaw@mail.gmail.com>
 <20120612132736.642a4a5a@pyramind.ukuu.org.uk> <CAMeQTsZZ0ay7YqkzUzkhe6D6FNsQXaDKHfJKB6_6icd=4VemrA@mail.gmail.com>
 <20120612170412.359967ec@pyramind.ukuu.org.uk> <CAH9NwWdF+zukb1r1z6ES6ULeg3dkFzhvhBq1xzjrqjWx-O3cOA@mail.gmail.com>
 <20120613113133.38c1ca8a@pyramind.ukuu.org.uk>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Wed, 13 Jun 2012 14:26:07 +0200
Message-ID: <CAH9NwWfseFA91jtwuuui463t1MtjdmuPaXrPrz8rOc+HZ9WeXw@mail.gmail.com>
Subject: Re: gma500: Cannot find any crtc or sizes - going 1024x768
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/13 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> My company is using these cpu bords for our products:
>> http://www.congatec.com/en/products/qseven/dView/conga-qa6.html
>>
>> With firmware you mean BIOS or VBios or ...? If you tell me what you need, I may
>> ask our supplier for more informations. I can tell you that the
>> following options can be
>> changed in the BIOS regarding gfx - see
>> https://www.dropbox.com/s/btlciurz0ih4fhu/IMG_20120612_143431.jpg
>
> The basic question is:
>
> Does this device use the Intel BIOS way of reporting mode information,
> or the embedded "GCT" style.
>

As far as I can tell from the logs, it seems to use the Intel BIOS way.

[    2.366174] [drm:psb_intel_opregion_setup], Public ACPI methods supported
[    2.366183] [drm:psb_intel_opregion_setup], ASLE supported
[    2.366200] gma500 0000:00:02.0: Enabling MSI failed!
[    2.366287] [drm] internal display is LVDS display
[    2.366363] gma500 0000:00:02.0: SKU values is 0x2a00000.
[    2.366371] gma500 0000:00:02.0: LNC core clk is 200MHz.
[    2.366389] gma500 0000:00:02.0: drm platform config address is 3ddbd010
[    2.366403] ioremap error for 0x3ddbd000-0x3ddbe000, requested 0x10, got 0x0
[    2.366484] gma500 0000:00:02.0: Unable to read GCT!
[    2.366563] gma500 0000:00:02.0: platform_rev_id is 5
[    2.368471] gma500 0000:00:02.0: VBT signature missing


I will ask my contact at congatec what they are really using. I hope
to get some feedback soon.

---
Christian Gmeiner, MSc
