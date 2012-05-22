Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab2EVOgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:36:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45149 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab2EVOgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:36:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120522123058.GB4629@phenom.ffwll.local>
References: <CAJJYPd=JQdzepw818ZP6OmKK4v38--T+ruKBOG_wn2pUmnVaSw@mail.gmail.com>
	<20120522123058.GB4629@phenom.ffwll.local>
Date: Tue, 22 May 2012 16:36:30 +0200
Message-ID: <CAJJYPdmcJYT1VTnqbkbybut-_NqpFYsuEEzDb9LO-E+ss=wz-g@mail.gmail.com>
Subject: Re: Regression on GMA965 - display seems to have slow jump changes in brightness
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org
Cc: daniel@ffwll.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/22 Daniel Vetter <daniel@ffwll.ch>:
> On Tue, May 22, 2012 at 02:08:46PM +0200, Zdenek Kabelac wrote:
>> Hi
>>
>> I've updated to 3.4 kernel, and now I'm noticing slight changes in
>> brightness on colorful images.
>> It seems the change is mostly visibly on  'darker' images i.e. it's
>> not really visible on white background.
>>
>> When I reboot back to 3.3  kernel - brightness changes are gone - so I
>> do not suspect hw fault of my T61 display.
>> I guess once in past there has been already such bug, so this problem
>> seems to me like reintroducing the same
>> problem again.
>>
>> xorg-x11-server-Xorg-1.12.1-1.fc18.x86_64
>> with SNA intel driver build from git repo.
>> T61, 965GM
>>
>> Is this a know issue ?
>> Is bisect needed ?
>
> You're the first one to report things, so a bisect would be highly
> appreciated. Also I'm a bit confused about what you mean by 'changing
> brightness'. Can you please try to explain this a bit more?
>

I've some default gnome picture like this one:
https://lh6.googleusercontent.com/-96ZhFbfLX_M/ThHsm0ZxBgI/AAAAAAAAFQQ/3ApjzYgulso/s400/gnome-3-login-screen.png

When I watch the picture for some period of time  I'm noticing slight
changes in the picture brightness looking like small change in LUT
table or something like that.
If the picture is white I'm not noticing any change.
(Initially I've thought my display dies - but reboot to 3.3 fixed the
issue immediately).

Is there any suspecting patch for this chipset I should try to revert ?

Zdenek
