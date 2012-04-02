Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab2DBTAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:00:51 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:57691 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab2DBTAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:00:49 -0400
Date: Mon, 2 Apr 2012 12:00:45 -0700
From: Tejun Heo <tj@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>,
        Jens Axboe <axboe@kernel.dk>, Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
 of disks naming
Message-ID: <20120402190045.GC16226@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4F7581D4.4040301@cn.fujitsu.com>
 <4F7582B0.5010609@cn.fujitsu.com>
 <20120330152606.GB28934@google.com>
 <20120330152808.GC28934@google.com>
 <4F78FE89.2070707@cn.fujitsu.com>
 <20120402072009.GF30360@redhat.com>
 <20120402185259.GA16226@dhcp-172-17-108-109.mtv.corp.google.com>
 <1333392978.2971.25.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333392978.2971.25.camel@dabdike>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, James.

On Mon, Apr 02, 2012 at 11:56:18AM -0700, James Bottomley wrote:
> So if we're agreed no other devices going forwards should ever use this
> interface, is there any point unifying the interface?  No matter how
> many caveats you hedge it round with, putting the API in a central place
> will be a bit like a honey trap for careless bears.   It might be safer
> just to leave it buried in the three current drivers.

Yeah, that was my hope but I think it would be easier to enforce to
have a common function which is clearly marked legacy so that new
driver writers can go look for the naming code in the existing ones,
find out they're all using the same function which is marked legacy
and explains what to do for newer drivers.

Thanks.

-- 
tejun
