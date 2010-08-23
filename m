Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab0HWPkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:40:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab0HWPkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:40:20 -0400
Date: Mon, 23 Aug 2010 08:38:05 -0700
From: Greg KH <gregkh@suse.de>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com
Subject: Re: Ubuntu 10.10 Kernel compile error
Message-ID: <20100823153805.GC18649@suse.de>
References: <AANLkTinAqJdEPpTFsmY8rWYqy84qGsWVbL9VphOur+PT@mail.gmail.com> <AANLkTim_Mu8PiOM+kD3y3Zejr+u=Fqutk9d7SafDEsdH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim_Mu8PiOM+kD3y3Zejr+u=Fqutk9d7SafDEsdH@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 01:09:01PM +0300, Anca Emanuel wrote:
> CC to apw@canonical.com, if there are orher people, let me know.
> 
> On Sun, Aug 22, 2010 at 3:24 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> > Steps to reproduce on Ubuntu 10.10
> >
> > 1. sudo apt-get install git-core kernel-package fakeroot
> > build-essential ncurses-dev
> > 2. git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> > 3. cd linux-2.6
> > 4. cp /boot/config-`uname -r` .config
> > 5. yes '' | make oldconfig
> > 6. make nconfig
> > and select to not make the staging drivers
> > 7. make-kpkg clean
> > 8. CONCURRENCY_LEVEL=`getconf _NPROCESSORS_ONLN` fakeroot make-kpkg
> > --initrd --append-to-version=-c kernel_image kernel_headers
> >
> > result:
> >
> > dpkg-gencontrol: error: package linux-image-2.6.36-rc1-c+ not in control info
> > make[2]: *** [debian/stamp/binary/linux-image-2.6.36-rc1-c+] Error 255
> > make[2]: Leaving directory `/home/username/linux-2.6'
> > make[1]: *** [debian/stamp/binary/pre-linux-image-2.6.36-rc1-c+] Error 2
> > make[1]: Leaving directory `/home/username/linux-2.6'
> > make: *** [kernel_image] Error 2
> >
> 
> yes you have some patches, why don't you upstream them ?
> Gregh, what is so hard to publish some compiler paches ? only becouse
> you are suse ?

Yes, that is exactly why.  (where's the sarcasm key...)

> It is rc2 time an you did not publish, or asked Linus to pull the
> fixes in your tree

I was busy with other kernel work and didn't get a chance to do so.  It
should happen later this week.

thanks,

greg k-h
