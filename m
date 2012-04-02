Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2DBSxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:53:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59249 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2DBSxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:53:17 -0400
Date: Mon, 2 Apr 2012 11:52:59 -0700
From: Tejun Heo <tj@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Ren Mingxin <renmx@cn.fujitsu.com>, Jens Axboe <axboe@kernel.dk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
 of disks naming
Message-ID: <20120402185259.GA16226@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4F7581D4.4040301@cn.fujitsu.com>
 <4F7582B0.5010609@cn.fujitsu.com>
 <20120330152606.GB28934@google.com>
 <20120330152808.GC28934@google.com>
 <4F78FE89.2070707@cn.fujitsu.com>
 <20120402072009.GF30360@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402072009.GF30360@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 02, 2012 at 10:20:09AM +0300, Michael S. Tsirkin wrote:
> Pleae don't rename virtio disks, it is way too late for that:
> virtio block driver was merged around 2007, it is not new by
> any measure, and there are many systems out there using
> the current naming scheme.

There's no point in renaming device nodes of already deployed drivers.
It'll cause a lot of pain.

> > And how about the rssd in the patch 3 then?
> 
> Probably same. Renaming existing devices will break setups.
> I think the idea is to avoid using the
> legacy naming in new drivers *that will be added from now on*.

Yeap.

Thanks.

-- 
tejun
