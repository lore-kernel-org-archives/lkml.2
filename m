Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab2FLV6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:58:22 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58252 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2FLV6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:58:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120612170412.359967ec@pyramind.ukuu.org.uk>
References: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
 <CAMeQTsZfE8_t6DCr3UWVqnOLyxNuNh7_VxJmqiP+enBBqM0o_A@mail.gmail.com>
 <CAH9NwWc3W6zHCFf9rwKg5NMQaWnh4A=xVVysmG1Y=eUMzu=18Q@mail.gmail.com>
 <CAMeQTsaknGLR2QCWwN8kYKh8y=JJtqN-ZSty6YTKnAOv2Vp3XQ@mail.gmail.com>
 <CAH9NwWdmhmLB5io5RWVQBj6c7zjXT9hFa7OAHVrL6oY8P0kjaw@mail.gmail.com>
 <20120612132736.642a4a5a@pyramind.ukuu.org.uk> <CAMeQTsZZ0ay7YqkzUzkhe6D6FNsQXaDKHfJKB6_6icd=4VemrA@mail.gmail.com>
 <20120612170412.359967ec@pyramind.ukuu.org.uk>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Tue, 12 Jun 2012 23:58:00 +0200
Message-ID: <CAH9NwWdF+zukb1r1z6ES6ULeg3dkFzhvhBq1xzjrqjWx-O3cOA@mail.gmail.com>
Subject: Re: gma500: Cannot find any crtc or sizes - going 1024x768
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/12 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> Was there a special reason for 0x4108 to be left out in the IS_MRST macro?
>> To me it looks like the bitmask should have been updated in commit:
>>
>> gma500: Add the E6xx PCI identifier we are missing
>> 56125db1eecf8d34d84f7925686110d90724edf0
>>
>> If this is the case, I'll send a proper patch since this also applies to
>> stable 3.3.x and 3.4.x
>
> Firstly it should never matter - there are no Moorestown devices in
> circulation. E600T is very similar to Oaktrail.
>
> So the real question here seems to be why does the IS_MRST macro matter.
> What weird firmware is involved here ?

My company is using these cpu bords for our products:
http://www.congatec.com/en/products/qseven/dView/conga-qa6.html

With firmware you mean BIOS or VBios or ...? If you tell me what you need, I may
ask our supplier for more informations. I can tell you that the
following options can be
changed in the BIOS regarding gfx - see
https://www.dropbox.com/s/btlciurz0ih4fhu/IMG_20120612_143431.jpg


---
Christian Gmeiner, MSc
