Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab1ETEL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:11:59 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44912 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871Ab1ETEL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:11:58 -0400
X-Sasl-enc: 8SQFbrj66VMnYTWWLggwsZmgDASSCa2XolKFmfaShGFs 1305864716
Date: Thu, 19 May 2011 21:12:44 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfmooney@gmail.com>
Cc: matt mooney <mfm@muteddisk.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: replace usbip_u{dbg,err,info} and printk
 with dev_ and pr_
Message-ID: <20110520041244.GA986@kroah.com>
References: <2db81796703063c0816d0d99040c6fbd6da50007.1305847719.git.mfm@muteddisk.com>
 <20110520000013.GA8908@kroah.com>
 <BANLkTik=S-FRB25gNHcb0OLMW5dhqLE1eA@mail.gmail.com>
 <20110520002401.GA17623@kroah.com>
 <BANLkTi=FZ57TrOa48qxkO6Myf0pwgtPp7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=FZ57TrOa48qxkO6Myf0pwgtPp7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 07:30:39PM -0700, matt mooney wrote:
> On Thu, May 19, 2011 at 5:24 PM, Greg KH <greg@kroah.com> wrote:
> > On Thu, May 19, 2011 at 05:17:45PM -0700, matt mooney wrote:
> >> On Thu, May 19, 2011 at 5:00 PM, Greg KH <greg@kroah.com> wrote:
> >> > Also, the merge window for the .40 tree for the staging tree is now
> >> > closed, so I'll only take bugfixes for the usbip code for now.
> >>
> >> The userspace code isn't getting merged in .40, is it? Because my
> >> patch "staging: usbip: userspace: stub_driver.c: update kernel module
> >> name" actually relies on a change in my own tree, so I made a mistake
> >> by thinking that it was needed right away to get the userspace tools
> >> working.
> >
> > It's in my tree, so yes.  You can send me patches to fix the problem, as
> > I would recommend :)
> 
> Can I send you a 10 patch series (or 9 if you apply the patch in this
> thread)? The changes I have that fix that are towards the end. The
> problem is a lot of my changes rely on the patch sent in this thread
> and one that follows it, so to avoid any conflicts it is easiest (at
> least for me :) to just send the whole series. They have been tested
> and pretty much leave usbip in the state it was originally in.

I don't know, I would have to see the patches.  Please send them on.

thanks,

greg k-h
