Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab1EOQct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:32:49 -0400
Received: from kroah.org ([198.145.64.141]:41475 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab1EOQcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:32:48 -0400
Date: Sun, 15 May 2011 09:32:57 -0700
From: Greg KH <greg@kroah.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>,
        devel@driverdev.osuosl.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Vitaly Wool <vitalywool@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@sify.com>,
        Lee Jones <lee.jones@linaro.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v6] Add ST-Ericsson CG2900 driver
Message-ID: <20110515163257.GE1315@kroah.com>
References: <1305040215-712-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <BANLkTinAtUQ8H1DQpqXxX_U4mLO617L3Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinAtUQ8H1DQpqXxX_U4mLO617L3Eg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 12:20:51PM +0200, Linus Walleij wrote:
> 2011/5/10 Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>:
> 
> > Patch created on next-20110510.
> > Compared to v5 this patch has the following update:
> >  - Updated driver after changes to MFD interfaces in linux-next (from mfd_data
> >   to platform_data).
> >  - Changed platform specific file dependencies (included correct nomadik file).
> 
> Sorry I don't know if all this will work, it's due to all the churn created by
> the current push to get stuff out of the ARM tree so not much to do.
> 
> The Nomadik GPIO file was moved in next but I will take that code move
> out today, because the GPIO maintainer has told me he couldn't
> provide feedback on these patches in time for me to finalize the change
> for kernel 2.6.40. Thus it won't go into 2.6.40 and I must remove it
> from next.
> 
> The MFD changes will *probably* happen, if you're thinking about the
> PRCMU movement etc.
> 
> To merge into the staging tree right now, you need to base it off
> Gregs staging tree, which is where it'll be merged:
> http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-2.6.git;a=summary
> 
> Sorry about all the confusion, I think it's actually nobodys fault,
> it's just reflecting the fact that embedded drivers with deep
> platform dependencies are *really* *hard* to manage in staging.

That's why you should only use staging as a last resort, not as your
primary way of getting code into the kernel, especially for stuff with
a constantly changing in-kernel interface like you have pointed out
here.

Just do the "real work" first and get it merged the real way if at all
possible.

best of luck,

greg k-h
