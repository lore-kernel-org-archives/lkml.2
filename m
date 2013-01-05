Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3AEMH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 07:07:28 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:37302 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3AEMHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 07:07:23 -0500
Message-ID: <50E81763.1070501@ahsoftware.de>
Date: Sat, 05 Jan 2013 13:06:59 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Borislav Petkov <bp@alien8.de>, Shawn Guo <shawn.guo@linaro.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, Bernie Thompson <bernie@plugable.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
References: <20121116192606.11799.35711.stgit@localhost.localdomain> <CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com> <20121121125310.00625f55@pyramind.ukuu.org.uk> <CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com> <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com> <CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com> <CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com> <20121227045301.GB17472@x1.alien8.de> <20121228115022.GA28009@S2101-09.ap.freescale.net> <20121228124026.GB12918@x1.alien8.de> <50E6D01D.6040304@ahsoftware.de> <20130104132557.70e0c527@pyramind.ukuu.org.uk> <50E6DAC9.802@ahsoftware.de> <50E81166.6050605@ahsoftware.de> <20130105120729.7677c333@pyramind.ukuu.org.uk>
In-Reply-To: <20130105120729.7677c333@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.01.2013 13:07, schrieb Alan Cox:
>> So to add such an "I am crap" flag my idea would be to add an
>> .fb_handle_damage to struct fb_ops and then call that (if exists)
>> whenever something was changed.
>
> I was thinking much higher level - ie at the printk kind of level
>
>> My patch (for udlfb) follows as an reply to this message. If that patch
>> is ok, it should be applied to smscufx too (I would make it). In regard
>> to udl I don't know, I haven't had a deeper look at it nor used it up to
>> now.
>
> Looks pretty clean as a solution to me.

Thanks and sorry for the two empty lines in the patch. I swear I had a 
look at the patch before sending it out, but haven't seen them.

So should I make the same patch for smscufx  and while beeing there, 
send out at v2 without those 2 empty lines?

Regards,

Alexander


