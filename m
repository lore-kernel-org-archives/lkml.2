Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0IUUrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 16:47:42 -0400
Received: from kroah.org ([198.145.64.141]:39869 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407Ab0IUUrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 16:47:41 -0400
Date: Tue, 21 Sep 2010 13:26:21 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, axboe@kernel.dk
Subject: Re: [PATCH] SYSFS: Allow boot time switching between deprecated
 and modern sysfs layout v2
Message-ID: <20100921202621.GA25112@kroah.com>
References: <1283957657-17740-1-git-send-email-andi@firstfloor.org>
 <AANLkTimwX_RQfdqbotgdZax-=MLATi7WjsBjkZ+86aaw@mail.gmail.com>
 <20100908193910.2d27a33b@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908193910.2d27a33b@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 07:39:10PM +0200, Andi Kleen wrote:
> On Wed, 8 Sep 2010 17:27:37 +0200
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > On Wed, Sep 8, 2010 at 16:54, Andi Kleen <andi@firstfloor.org> wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > >
> > > I have some systems which need legacy sysfs due to old udev
> > > versions, and it's a big hazzle to compile separate kernels for
> > > them.
> > 
> > It's not udev, it's other tools making wrong assumptions like that
> > directories can not be a symlink to a directory, or that a device is
> > always the same parent device. It's also not udev which fails on newer
> > installations, it's the lack of information in the non-extensible
> > deprecated layout which makes all sorts of tools fail. So please
> > work-off the text from the old help text instead of blaming the wrong
> > things here. :)
> 
> Ok. I can either send out a new patch or Greg can change the description
> of v2 to dish out the blame in a Kay approved matter when he merges it.
> What you guys prefer.

Heh, I've edited the wording a bit now.

thanks,

greg k-h
