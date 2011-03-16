Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab1CPPk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:40:57 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:33382 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab1CPPkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:40:51 -0400
Date: Wed, 16 Mar 2011 08:40:47 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 00/02] virtio: Virtio platform driver
Message-ID: <20110316154047.GB21758@ovro.caltech.edu>
References: <20110310070541.27327.52089.sendpatchset@t400s>
 <87d3lriv7e.fsf@rustcorp.com.au>
 <AANLkTi=zjGubKx0vV+hqEYiVFVNTAEoGwxEfL4oprxk8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=zjGubKx0vV+hqEYiVFVNTAEoGwxEfL4oprxk8@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Wed, 16 Mar 2011 08:40:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 02:17:15PM +0900, Magnus Damm wrote:
> Hi Rusty,
> 
> On Wed, Mar 16, 2011 at 12:46 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Thu, 10 Mar 2011 16:05:41 +0900, Magnus Damm <magnus.damm@gmail.com> wrote:
> >> virtio: Virtio platform driver
> >>
> >> [PATCH 01/02] virtio: Break out lguest virtio code to virtio_lguest.c
> >> [PATCH 02/02] virtio: Add virtio platform driver
> >
> > I have no problem with these patches, but it's just churn until we see
> > your actual drivers.
> 
> Well, actually this platform driver is used together with already
> existing drivers, so there are no new virtio drivers to wait for.
> 
> The drivers that have been tested are so far:
> 
> CONFIG_VIRTIO_CONSOLE=y
> CONFIG_VIRTIO_NET=y
> 
> At this point there are four different pieces of code working together
> 
> 1) Virtio platform driver patches (for guest)
> 2) SH4AL-DSP guest kernel patch
> 3) ARM UIO driver patches (for host)
> 4) User space backing code for ARM based on lguest.c
> 
> These patches in this mail thread are 1), and I decided to brush up
> that portion and submit upstream because it's the part that is easiest
> to break out. I intend to post the rest bit by bit over time, but if
> someone is interested then I can post everything at once too.
> 

I'm very interested in the full series of patches. I want to do
something similar to talk between two Linux kernels (x86 and PowerPC)
connected by a PCI bus.

Thanks,
Ira

> > The S/390 devs might be interested, as their bus is very similar too...
> 
> The lguest device code is very similar as well, perhaps it's worth
> refactoring that a bit to build on top of the platform driver. Not
> sure if you see that as a move in the right direction though.
> 
> Thanks for your feedback!
> 
> / magnus
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/virtualization
