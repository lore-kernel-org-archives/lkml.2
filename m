Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1CGWCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 17:02:00 -0500
Received: from kroah.org ([198.145.64.141]:39312 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab1CGWB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 17:01:59 -0500
Date: Mon, 7 Mar 2011 14:01:21 -0800
From: Greg KH <greg@kroah.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>,
        Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/21] staging: ft1000: Fix coding style in
 ft1000_usb_transmit_complete function.
Message-ID: <20110307220121.GA28725@kroah.com>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
 <1299486086-7325-12-git-send-email-marek.belisko@open-nandra.com>
 <20110307155529.GV3416@bicker>
 <AANLkTiknavmcagz63oFmqhgF5nV6xEMmLwU=i129LcVB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTiknavmcagz63oFmqhgF5nV6xEMmLwU=i129LcVB@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 08:25:07PM +0100, Belisko Marek wrote:
> On Mon, Mar 7, 2011 at 4:55 PM, Dan Carpenter <error27@gmail.com> wrote:
> > On Mon, Mar 07, 2011 at 09:21:16AM +0100, Marek Belisko wrote:
> >> -    if (urb->status)
> >> -        printk("%s: TX status %d\n", ft1000dev->net->name, urb->status);
> >> +     if (urb->status)
> >> +             DEBUG("%s: TX status %d\n", ft1000dev->net->name, urb->status);
> >>
> >
> > Why did you change the printk() to a DEBUG()?  That's a behavior change,
> > and it should have been mentioned in the commit message.
> Mea culpa. checkpatch.pl complain about no KERN_... prefix so just fix with
> replace to DEBUG. Will return back to printk.
> @Greg: should resend whole serie or just this patch?

Which ever you feel ok with.

thanks,

greg k-h
