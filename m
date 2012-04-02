Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab2DBS4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:56:20 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52423 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391Ab2DBS4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:56:18 -0400
Message-ID: <1333392978.2971.25.camel@dabdike>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
 of disks naming
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>,
        Jens Axboe <axboe@kernel.dk>, Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Date: Mon, 02 Apr 2012 11:56:18 -0700
In-Reply-To: <20120402185259.GA16226@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4F7581D4.4040301@cn.fujitsu.com>
	 <4F7582B0.5010609@cn.fujitsu.com> <20120330152606.GB28934@google.com>
	 <20120330152808.GC28934@google.com> <4F78FE89.2070707@cn.fujitsu.com>
	 <20120402072009.GF30360@redhat.com>
	 <20120402185259.GA16226@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 11:52 -0700, Tejun Heo wrote:
> > Probably same. Renaming existing devices will break setups.
> > I think the idea is to avoid using the
> > legacy naming in new drivers *that will be added from now on*.
> 
> Yeap.

So if we're agreed no other devices going forwards should ever use this
interface, is there any point unifying the interface?  No matter how
many caveats you hedge it round with, putting the API in a central place
will be a bit like a honey trap for careless bears.   It might be safer
just to leave it buried in the three current drivers.

James


