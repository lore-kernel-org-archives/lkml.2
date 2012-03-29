Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2C2FNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 01:13:31 -0400
Received: from ozlabs.org ([203.10.76.45]:39155 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab2C2FNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 01:13:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        jens.axboe@oracle.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: add helper function to support mass of disks naming
In-Reply-To: <20120328105819.GD6194@redhat.com>
References: <4F72B5B3.6020602@cn.fujitsu.com> <20120328105819.GD6194@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 29 Mar 2012 15:10:01 +1030
Message-ID: <87ehscyq8u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 12:58:21 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Wed, Mar 28, 2012 at 02:54:43PM +0800, Ren Mingxin wrote:
> >  Hi,
> > 
> > The current virtblk's naming algorithm just supports 26^3
> > disks. If there are mass of virtblks(exceeding 26^3), there
> > will be disks with the same name.
> > 
> > According to "sd_format_disk_name()", I add function
> > "virtblk_name_format()" for virtblk to support mass of
> > disks.
> > 
> > Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
> 
> Nod. This is basically what 3e1a7ff8a0a7b948f2684930166954f9e8e776fe
> did. Except, maybe we should move this function into block core
> instead of duplicating it? Where would be a good place to put it?
> Jens, care to comment?

Indeed.

Cheers,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
