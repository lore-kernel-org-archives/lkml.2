Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab0GWCIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 22:08:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab0GWCIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 22:08:17 -0400
Date: Thu, 22 Jul 2010 22:07:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Jan Safranek <jsafrane@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
Message-ID: <20100723020714.GA11236@redhat.com>
References: <20100722182638.GA12712@kroah.com>
 <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
 <20100722183614.GA5443@suse.de>
 <20100722193741.GA2688@redhat.com>
 <20100722211856.GA1297@suse.de>
 <AANLkTinFQtwrCC82T9KlKskDV8fn-zYgimyH2wguHkqY@mail.gmail.com>
 <20100722231401.GA11538@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100722231401.GA11538@suse.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 04:14:01PM -0700, Greg KH wrote:
> On Fri, Jul 23, 2010 at 01:08:12AM +0200, Kay Sievers wrote:
> > On Thu, Jul 22, 2010 at 23:18, Greg KH <gregkh@suse.de> wrote:
> > >> For my testing I now always use /cgroup/ and create directories under it
> > >> /cgroup/blkio /cgroup/cpu etc and mount controllers on respective
> > >> directories.
> > >
> > > Lennart and Kay, is this what systemd is doing?  I really don't think we
> > > should be adding a root /cgroup/ mount point to the system for something
> > > like this.
> > 
> > Already solved. Systemd always mounts an empty tmpfs at the 'cgroup'
> > mountpoint, and stuff is free to create subdirs there. Systemd itself
> > mount 'systemd' there.
> 
> Ah, that makes it easier.  Paul and Vivek, any objection to this patch
> going in now?
> 

This sounds reasonable to me also.

Jan, I know you have been working in this area and raised concenrs about
cgroup mount point in the past. Does it look good to you?

Vivek
