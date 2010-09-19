Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab0ISERW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 00:17:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab0ISERE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 00:17:04 -0400
Date: Sat, 18 Sep 2010 21:04:53 -0700
From: Greg KH <gregkh@suse.de>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [000/129] 2.6.35.5 -stable review
Message-ID: <20100919040453.GB30907@suse.de>
References: <20100918191317.GA11386@kroah.com> <20100918210800.GA2886@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100918210800.GA2886@joi.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 11:08:00PM +0200, Marcin Slusarz wrote:
> On Sat, Sep 18, 2010 at 12:13:17PM -0700, Greg KH wrote:
> > [Note, I do still have patches that people have sent me for inclusion in
> > the .35-stable tree in my queue, but I figured this series was already
> > big enough that it should go out now.  If you notice, I _did_ apply all
> > patches that went through Linus's tree with a stable@kernel.org marking
> > on it, so people might consider using that method instead...]
> > 
> > This is the start of the stable review cycle for the 2.6.35.5 release.
> > There are 129 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let us know.  If anyone is a maintainer of the proper subsystem, and
> > wants to add a Signed-off-by: line to the patch, please respond with it.
> > 
> > Responses should be made by @date (day, month date, time)@ UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.35.5-rc1.gz
> > and the diffstat can be found below.
> 
> Greg,
> please consider applying patch 615661f3948a066fd22a36fe8ea0c528b75ee373 
> "drm/nv50: initialize ramht_refs list for faked 0 channel"
> for .35-stable.

See the note above.

Why has this not been sent to stable@kernel.org previously?  Remember to
read Documentation/stable_kernel_rules.txt for how to get a patch into
the stable tree.  Please get the maintainer of the driver to forward
this to that email address and I'll queue it up for the next stable
kernel rounds.

thanks,

greg k-h
