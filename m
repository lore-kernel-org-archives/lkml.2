Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab2JQNcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:32:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979Ab2JQNcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:32:15 -0400
Date: Wed, 17 Oct 2012 09:31:51 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Gerry Reno <greno@verizon.net>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Spang <spang@google.com>, linux-usb@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Michael Spang <spang@chromium.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: USB keyboard backlight powering down.
Message-ID: <20121017133151.GB2934@hansolo.jdub.homelinux.org>
References: <20121016152023.GA25506@redhat.com>
 <CAC5F_1=tiGUtWOsOQ17vEYqVxuoVuoEH_nmEZ3BoL0dsgXJn3w@mail.gmail.com>
 <20121016165436.GA5140@kroah.com>
 <20121016173524.GG5378@xanatos>
 <20121017125538.GA2934@hansolo.jdub.homelinux.org>
 <507EAE24.60407@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507EAE24.60407@verizon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 09:09:56AM -0400, Gerry Reno wrote:
> >> This was the udev bug I was referring to, which I think is causing the
> >> keyboard to have auto-suspend enabled:
> >>
> >> https://bugzilla.redhat.com/show_bug.cgi?id=825284
> >>
> >> udev shouldn't be enabling auto-suspend of USB hids by default, since
> >> many of them don't send a wakeup to come out of suspend when they
> >> should.  For example, most USB mice only send a wakeup even when they
> >> are clicked, not when they are moved.  That causes the user to sit
> >> there, frustrated, as they move their mouse and wonder why their screen
> >> doesn't unblank.  Other keyboards also lose keystrokes, which means if
> >> you pause to compose your thoughts, the first couple letters you type
> >> gets dropped.
> > I know we fixed that bug for F17, F18, and rawhide.  I did it myself.
> > I don't think this is udev related, but we'll double check the version.
> >
> > Gerry, are you using udev-182-3.fc17 or newer on your F17 install?
> >
> > josh
> >
> 
> 
> 
> Installed Packages
> udev.x86_64                                                182-1.fc17                                               
> @anaconda-0
> 
> There is an update available to 182-3 but I haven't installed it.  Didn't know what it might impact.

Well, it would certainly be good to update to it and see if this bug is
fixed for you.  You will probably need to rebuild your initramfs with
the updated udev.

josh
