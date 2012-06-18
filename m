Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab2FRKOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:14:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab2FRKN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:13:59 -0400
Date: Mon, 18 Jun 2012 13:13:49 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Asias He <asias@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
Message-ID: <20120618101349.GC23134@redhat.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com>
 <1340002390-3950-4-git-send-email-asias@redhat.com>
 <87hau9yse7.fsf@rustcorp.com.au>
 <4FDEE0CB.1030505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDEE0CB.1030505@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 04:03:23PM +0800, Asias He wrote:
> On 06/18/2012 03:46 PM, Rusty Russell wrote:
> >On Mon, 18 Jun 2012 14:53:10 +0800, Asias He <asias@redhat.com> wrote:
> >>This patch introduces bio-based IO path for virtio-blk.
> >
> >Why make it optional?
> 
> request-based IO path is useful for users who do not want to bypass
> the IO scheduler in guest kernel, e.g. users using spinning disk.
> For users using fast disk device, e.g. SSD device, they can use
> bio-based IO path.

OK I guess but then it should be per-device. There could be
a mix of slow and fast disks :)

> -- 
> Asias
> 
