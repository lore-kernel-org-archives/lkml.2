Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab0DFVAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:00:12 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:37125 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab0DFVAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:00:04 -0400
Date: Tue, 6 Apr 2010 13:58:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: john cooper <john.cooper@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Marc Haber <mh+qemu-devel@zugschlus.de>
Subject: Re: linux-next: Tree for April 1 (virtio_blk warning)
Message-Id: <20100406135859.ed1fa4c4.randy.dunlap@oracle.com>
In-Reply-To: <4BBB7A44.2020300@redhat.com>
References: <20100401172317.80b6d961.sfr@canb.auug.org.au>
	<20100401091312.85775242.randy.dunlap@oracle.com>
	<201004061210.48840.rusty@rustcorp.com.au>
	<4BBB7A44.2020300@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BBBA0B3.0107:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Apr 2010 14:15:32 -0400 john cooper wrote:

> Rusty Russell wrote:
> > On Fri, 2 Apr 2010 02:43:12 am Randy Dunlap wrote:
> >> On Thu, 1 Apr 2010 17:23:17 +1100 Stephen Rothwell wrote:
> >>
> >>> Hi all,
> >>>
> >>> Changes since 20100331:
> >>
> >> drivers/block/virtio_blk.c:228:13: warning: multi-character character constant
> >>
> >> due to:
> >>
> >> 	if (cmd == 'VBID') {
> > 
> > John?  That looks suspiciously like untested code.
> 
> It does work as advertised although gcc is obliged to squawk
> at multi-byte character constants due to portability concerns.

Thanks.  I wasn't aware of that gcc extension.

> Note I'd intended that only as an example for the benefit of
> completeness in the associated patch set, and to stick out
> like a sore thumb of sorts.  Marc Haber had suggested exposing
> the id string to the guest userland via /sys which is what I
> had expected to displace the loose ioctl example above.  In
> fact that discussion is what prodded revisiting this issue in
> the first place.
> 
> Unsure whether Marc (cc'ed here) is still planning to pursue
> that interface so unless I hear something to the contrary in
> the next day or so I'll package up a suitable ioctl interface
> and forward a patch.  It doesn't hurt to provide ioctl access
> to the info in addition to exposing it via /sys, but I'd
> hoped the latter would overshadow the need to do so.

---
~Randy
