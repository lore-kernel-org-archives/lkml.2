Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab2FLNzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:55:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62732 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2FLNzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:55:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120612132736.642a4a5a@pyramind.ukuu.org.uk>
References: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
	<CAMeQTsZfE8_t6DCr3UWVqnOLyxNuNh7_VxJmqiP+enBBqM0o_A@mail.gmail.com>
	<CAH9NwWc3W6zHCFf9rwKg5NMQaWnh4A=xVVysmG1Y=eUMzu=18Q@mail.gmail.com>
	<CAMeQTsaknGLR2QCWwN8kYKh8y=JJtqN-ZSty6YTKnAOv2Vp3XQ@mail.gmail.com>
	<CAH9NwWdmhmLB5io5RWVQBj6c7zjXT9hFa7OAHVrL6oY8P0kjaw@mail.gmail.com>
	<20120612132736.642a4a5a@pyramind.ukuu.org.uk>
Date: Tue, 12 Jun 2012 15:55:50 +0200
Message-ID: <CAMeQTsZZ0ay7YqkzUzkhe6D6FNsQXaDKHfJKB6_6icd=4VemrA@mail.gmail.com>
Subject: Re: gma500: Cannot find any crtc or sizes - going 1024x768
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 2:27 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Works much better with this patch applied - I see a linux desktop on
>> the panel :)
>
> Yay..
>
>> Is there a way to overwrite the found modeline?
>
> You can set modelines via the video interfaces and also by passing it as
> a boot parameter. The mode setting X server will also let you set modes.
>
>
> video=640x400@60
>
> or similar should work - you can set all kinds of bits this way.
>
>
> If there is a way to identify the platform and that is needed to get it
> right then we can also hardcode a DMI match or similar for the device
> eventually.

Was there a special reason for 0x4108 to be left out in the IS_MRST macro?
To me it looks like the bitmask should have been updated in commit:

gma500: Add the E6xx PCI identifier we are missing
56125db1eecf8d34d84f7925686110d90724edf0

If this is the case, I'll send a proper patch since this also applies to
stable 3.3.x and 3.4.x

Patrik
