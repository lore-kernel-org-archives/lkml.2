Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2C1P3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:29:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47024 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab2C1P3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:29:05 -0400
Date: Wed, 28 Mar 2012 08:28:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: MyungJoo Ham <myungjoo.ham@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, cw00.choi@samsung.com
Subject: Re: [PATCH v7 0/6] Introduce External Connector Class (extcon)
Message-ID: <20120328152859.GA21001@kroah.com>
References: <1332492784-10526-1-git-send-email-myungjoo.ham@samsung.com>
 <CAJ0PZbTScHq0MMjSWZ0X5qHChhS+6TL-xSnsqEwS34N2VFLaSw@mail.gmail.com>
 <20120328144450.GA19030@kroah.com>
 <201203281524.08021.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203281524.08021.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 03:24:07PM +0000, Arnd Bergmann wrote:
> On Wednesday 28 March 2012, Greg KH wrote:
> > 
> > On Wed, Mar 28, 2012 at 06:39:08PM +0900, MyungJoo Ham wrote:
> > > Dear Arnd,
> > > 
> > > Could you please consider the EXTCON patchset for the current merge window?
> > 
> > Wait, no, the current merge window for new stuff closed a week or so
> > before 3.3 came out.  This needs to be in linux-next before the merge
> > window opens to ensure that things work properly there before it can be
> > accepted into the mainline tree.
> > 
> > So this could go into 3.5 at the earliest.
> 
> Right. I'm also not convinced that arm-soc is the right place for this to
> go, and I had not planned to add the patches there. Unfortunately I also
> haven't followed the last few versions and will have to do at least one
> more review round and Ack/Nak the interfaces. I should probably do that
> once -rc1 is out, so please send me a reminder if you don't hear back from
> me in time.
> 
> Any opinions on which tree this should go through? I could take it into
> arm-soc, but it's not really ARM-only. Maybe having it go through the
> staging tree would be better, leaving MyungJoo in charge afterwards.
> I guess we should also add a MAINTAINERS entry for the new subsystem.

If acks come through, and I'll be glad to review it after -rc1 as well,
I can take it through one of my trees to get merged to Linus for 3.5.

thanks,

greg k-h
