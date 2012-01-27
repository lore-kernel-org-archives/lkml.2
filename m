Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab2A0SML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:12:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50880 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab2A0SMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:12:10 -0500
Date: Fri, 27 Jan 2012 10:00:12 -0800
From: Greg KH <gregkh@suse.de>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Dima Zavin <dima@android.com>, Kashyap Gada <gada.kashyap@gmail.com>,
        rebecca@android.com, rschultz@google.com, jgennis@google.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Staging: android: Add KERN_ facility level in printk
 () in pmem.c
Message-ID: <20120127180012.GA28500@suse.de>
References: <1327116249-18274-1-git-send-email-gada.kashyap@gmail.com>
 <CAPz4a6AUAMxcMkVkgc9UJ1tok36jNE5hZzJc_9n5EJqRQCcz2w@mail.gmail.com>
 <20120123173100.GA26943@suse.de>
 <1327686693.3077.12.camel@lorien.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327686693.3077.12.camel@lorien.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 10:51:33AM -0700, Shuah Khan wrote:
> On Mon, 2012-01-23 at 09:31 -0800, Greg KH wrote:
> > On Mon, Jan 23, 2012 at 09:22:27AM -0800, Dima Zavin wrote:
> > > We really should just get rid of pmem.c altogether. We will remove it
> > > from our android common tree too. We don't actually use it anymore in
> > > any of our products. There are some legacy users of it, like Qualcomm,
> > > but I'm sure they have a bunch of patches on top of it and thus are
> > > maintaining it separately anyway.
> > 
> > Ok, I'll be glad to drop it if you all don't use it anymore and it's not
> > needed.  That makes life a lot easier for me :)
> > 
> > thanks,
> > 
> > greg k-h
> 
> Done. I sent a patch to remove pmem driver yesterday.
> 
> https://lkml.org/lkml/2012/1/26/368

And yet you failed to cc: me so that I can accept it :(

Please, the scripts/get_maintainer.pl tool is there for you to use, not
just admire from afar...

I'll go dig it out of lkml and queue it up,

greg k-h
