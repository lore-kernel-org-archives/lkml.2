Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab0GVTMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:12:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:34179 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab0GVTMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:12:30 -0400
Date: Thu, 22 Jul 2010 12:12:00 -0700
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
Message-ID: <20100722191200.GA5609@suse.de>
References: <20100722182638.GA12712@kroah.com>
 <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
 <20100722183614.GA5443@suse.de>
 <AANLkTimbcuzH6_bBhYX0U6vqftYgRwE0ZTmcbaRNzXef@mail.gmail.com>
 <20100722185301.GA528@suse.de>
 <AANLkTik07hZot_x0p7xJuY8s4f8pGRd2Mn1+jYfHH2iq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik07hZot_x0p7xJuY8s4f8pGRd2Mn1+jYfHH2iq@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 12:07:43PM -0700, Paul Menage wrote:
> On Thu, Jul 22, 2010 at 11:53 AM, Greg KH <gregkh@suse.de> wrote:
> >
> > If you are using /dev/cgroup/ that's nice, but I don't think that people
> > are expecting a whole filesystem under a /dev/ subdirectory.
> 
> Sure - as I said that's just for historical reasons from when we
> migrated from cpusets which were traditionally mounted at /dev/cpuset,
> so it involved less change. There's no particular reason to mount it
> there (although having said that, what about /dev/pts and /dev/shm?).

Yeah, /dev/pts and /dev/shm are long-time users of the /dev filesystem.
I don't know if we want to encourage that as a mount point, do you?

What are the different names you are giving to your mount points now for
cgroupfs so I can get an idea of how it is used currently?

thanks,

greg k-h
