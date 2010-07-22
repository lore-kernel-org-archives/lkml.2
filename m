Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab0GVVUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:20:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab0GVVUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:20:12 -0400
Date: Thu, 22 Jul 2010 14:19:58 -0700
From: Greg KH <gregkh@suse.de>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
Message-ID: <20100722211958.GB1297@suse.de>
References: <20100722182638.GA12712@kroah.com>
 <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
 <20100722183614.GA5443@suse.de>
 <AANLkTimbcuzH6_bBhYX0U6vqftYgRwE0ZTmcbaRNzXef@mail.gmail.com>
 <20100722185301.GA528@suse.de>
 <AANLkTik07hZot_x0p7xJuY8s4f8pGRd2Mn1+jYfHH2iq@mail.gmail.com>
 <20100722191200.GA5609@suse.de>
 <AANLkTi=8TTeGG3OTbP4zzNAe_rDaNNL8D0Yxp7DixohK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=8TTeGG3OTbP4zzNAe_rDaNNL8D0Yxp7DixohK@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 12:18:13PM -0700, Paul Menage wrote:
> On Thu, Jul 22, 2010 at 12:12 PM, Greg KH <gregkh@suse.de> wrote:
> > I don't know if we want to encourage that as a mount point, do you?
> 
> No.

Heh.

> > What are the different names you are giving to your mount points now for
> > cgroupfs so I can get an idea of how it is used currently?
> >
> 
> We don't particularly care about the names of the individual
> sub-mounts, since it's all programatically controlled. We just specify
> which subsystems we want grouped together (and a catch-all remainder
> hierarchy) and the system picks the name of one of the subsystems in
> the hierarchy to act as a unique mountpoint name (since each subsystem
> can only be in one hierarchy). So e.g. /dev/cgroup/cpuset, or
> /dev/cgroup/io

Thanks for the info.  But in the end, I really don't want to see a
/cgroup/ mountpoint added to people's systems if at all possible.

Any suggestions from your side?

thanks,

greg k-h
