Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab2DJPxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:53:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab2DJPxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:53:36 -0400
Date: Tue, 10 Apr 2012 18:53:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Avi Kivity <avi@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>,
        rusty@rustcorp.com.au, axboe@kernel.dk,
        James.Bottomley@HansenPartnership.com, asamymuthupa@micron.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_blk: Add help function to format mass of disks
Message-ID: <20120410155308.GB20551@redhat.com>
References: <1334042885-8330-1-git-send-email-renmx@cn.fujitsu.com>
 <4F84329A.60703@redhat.com>
 <20120410133406.GA18899@redhat.com>
 <20120410154943.GB11614@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410154943.GB11614@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 08:49:43AM -0700, Tejun Heo wrote:
> Hello, guys.
> 
> On Tue, Apr 10, 2012 at 04:34:06PM +0300, Michael S. Tsirkin wrote:
> > > Why not use 'base' below?  neither unit nor base change.
> > 
> > Yes it's a bit strange, it was the same in Tejun's patch.
> > Tejun, any idea?
> 
> It was years ago, so I don't recall much.  I think I wanted to use a
> variable name which signifies its role - I worked out the rather
> convoluted base number logic on paper first and I probably wanted to
> keep the distinctions.  I don't think it really matters at this point
> tho.  Just make sure those functions are marked deprecated so that no
> one else copies them.
> 
> Thanks.

I guess I'll keep it same so it's easier to deduplicate
if someon wants to.

> -- 
> tejun
