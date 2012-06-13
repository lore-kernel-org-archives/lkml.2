Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab2FMJZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 05:25:26 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52721 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2FMJZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 05:25:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9NwWdF+zukb1r1z6ES6ULeg3dkFzhvhBq1xzjrqjWx-O3cOA@mail.gmail.com>
References: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
 <CAMeQTsZfE8_t6DCr3UWVqnOLyxNuNh7_VxJmqiP+enBBqM0o_A@mail.gmail.com>
 <CAH9NwWc3W6zHCFf9rwKg5NMQaWnh4A=xVVysmG1Y=eUMzu=18Q@mail.gmail.com>
 <CAMeQTsaknGLR2QCWwN8kYKh8y=JJtqN-ZSty6YTKnAOv2Vp3XQ@mail.gmail.com>
 <CAH9NwWdmhmLB5io5RWVQBj6c7zjXT9hFa7OAHVrL6oY8P0kjaw@mail.gmail.com>
 <20120612132736.642a4a5a@pyramind.ukuu.org.uk> <CAMeQTsZZ0ay7YqkzUzkhe6D6FNsQXaDKHfJKB6_6icd=4VemrA@mail.gmail.com>
 <20120612170412.359967ec@pyramind.ukuu.org.uk> <CAH9NwWdF+zukb1r1z6ES6ULeg3dkFzhvhBq1xzjrqjWx-O3cOA@mail.gmail.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Wed, 13 Jun 2012 11:25:03 +0200
Message-ID: <CAH9NwWdT7RhDfgLiF15m2yAExmb-Gsq1TCOGbvJEQ9Lzd3DH8A@mail.gmail.com>
Subject: Re: gma500: Cannot find any crtc or sizes - going 1024x768
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/12 Christian Gmeiner <christian.gmeiner@gmail.com>:
> 2012/6/12 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>>> Was there a special reason for 0x4108 to be left out in the IS_MRST macro?
>>> To me it looks like the bitmask should have been updated in commit:
>>>
>>> gma500: Add the E6xx PCI identifier we are missing
>>> 56125db1eecf8d34d84f7925686110d90724edf0
>>>
>>> If this is the case, I'll send a proper patch since this also applies to
>>> stable 3.3.x and 3.4.x
>>
>> Firstly it should never matter - there are no Moorestown devices in
>> circulation. E600T is very similar to Oaktrail.
>>
>> So the real question here seems to be why does the IS_MRST macro matter.
>> What weird firmware is involved here ?
>
> My company is using these cpu bords for our products:
> http://www.congatec.com/en/products/qseven/dView/conga-qa6.html
>
> With firmware you mean BIOS or VBios or ...? If you tell me what you need, I may
> ask our supplier for more informations. I can tell you that the
> following options can be
> changed in the BIOS regarding gfx - see
> https://www.dropbox.com/s/btlciurz0ih4fhu/IMG_20120612_143431.jpg
>

Here are some more informations. There seems to be a scaling problem.
If i compare gma500 and the vesa framebuffer driver I see that gma500 shows
the desktop "scaled" up --> not the whole desktop is on the screen. It
gets better
if i remove the video="..." parameter from kernel cmdline, but it
still is too big for
the screen.

I really would love to get this beast up an running... so I will
provide as much informations
as needed - just ask :)

---
Christian Gmeiner, MSc
