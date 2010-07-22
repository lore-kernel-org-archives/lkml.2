Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab0GVSg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:36:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab0GVSgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:36:25 -0400
Date: Thu, 22 Jul 2010 11:36:15 -0700
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
Message-ID: <20100722183614.GA5443@suse.de>
References: <20100722182638.GA12712@kroah.com>
 <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 11:31:07AM -0700, Paul Menage wrote:
> On Thu, Jul 22, 2010 at 11:26 AM, Greg KH <gregkh@suse.de> wrote:
> > We really shouldn't be asking userspace to create new root filesystems.
> > So follow along with all of the other in-kernel filesystems, and provide
> > a mount point in sysfs.
> >
> > For cgroupfs, this should be in /sys/fs/cgroup/  This change provides
> > that mount point when the cgroup filesystem is registered in the kernel.
> 
> But cgroups will typically have multiple mounts, with different
> resource controllers/options on each mount. That doesn't really fit in
> with this scheme.

Really?  I see systems mounting it at /cgroups/ in the filesystem today.
Where are you expecting it to be mounted at?

thanks,

greg k-h
