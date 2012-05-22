Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab2EVOn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:43:26 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55519 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab2EVOnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:43:25 -0400
Date: Tue, 22 May 2012 16:44:43 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, daniel@ffwll.ch
Subject: Re: Regression on GMA965 - display seems to have slow jump changes
 in brightness
Message-ID: <20120522144443.GD4629@phenom.ffwll.local>
Mail-Followup-To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	intel-gfx@lists.freedesktop.org
References: <CAJJYPd=JQdzepw818ZP6OmKK4v38--T+ruKBOG_wn2pUmnVaSw@mail.gmail.com>
 <20120522123058.GB4629@phenom.ffwll.local>
 <CAJJYPdmcJYT1VTnqbkbybut-_NqpFYsuEEzDb9LO-E+ss=wz-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJJYPdmcJYT1VTnqbkbybut-_NqpFYsuEEzDb9LO-E+ss=wz-g@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 04:36:30PM +0200, Zdenek Kabelac wrote:
> 2012/5/22 Daniel Vetter <daniel@ffwll.ch>:
> > On Tue, May 22, 2012 at 02:08:46PM +0200, Zdenek Kabelac wrote:
> >> Hi
> >>
> >> I've updated to 3.4 kernel, and now I'm noticing slight changes in
> >> brightness on colorful images.
> >> It seems the change is mostly visibly on  'darker' images i.e. it's
> >> not really visible on white background.
> >>
> >> When I reboot back to 3.3  kernel - brightness changes are gone - so I
> >> do not suspect hw fault of my T61 display.
> >> I guess once in past there has been already such bug, so this problem
> >> seems to me like reintroducing the same
> >> problem again.
> >>
> >> xorg-x11-server-Xorg-1.12.1-1.fc18.x86_64
> >> with SNA intel driver build from git repo.
> >> T61, 965GM
> >>
> >> Is this a know issue ?
> >> Is bisect needed ?
> >
> > You're the first one to report things, so a bisect would be highly
> > appreciated. Also I'm a bit confused about what you mean by 'changing
> > brightness'. Can you please try to explain this a bit more?
> >
> 
> I've some default gnome picture like this one:
> https://lh6.googleusercontent.com/-96ZhFbfLX_M/ThHsm0ZxBgI/AAAAAAAAFQQ/3ApjzYgulso/s400/gnome-3-login-screen.png
> 
> When I watch the picture for some period of time  I'm noticing slight
> changes in the picture brightness looking like small change in LUT
> table or something like that.
> If the picture is white I'm not noticing any change.
> (Initially I've thought my display dies - but reboot to 3.3 fixed the
> issue immediately).

"for some period", does that mean it takes you a while to notice the
changes (because they're tiny), or are the changes happend just rather slowly?

> Is there any suspecting patch for this chipset I should try to revert ?

Tbh I have no idea. If there's no changes when the picture is white, it
can't be the backlight, we haven't frobbed around with the gamma stuff and
temporal dithering is disabled, too. If you can bisect this it would
greatly help.

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
