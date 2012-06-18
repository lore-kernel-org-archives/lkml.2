Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab2FRKSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:18:40 -0400
Received: from ozlabs.org ([203.10.76.45]:49239 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab2FRKSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:18:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Asias He <asias@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
In-Reply-To: <4FDEE0CB.1030505@redhat.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com> <1340002390-3950-4-git-send-email-asias@redhat.com> <87hau9yse7.fsf@rustcorp.com.au> <4FDEE0CB.1030505@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 18 Jun 2012 19:35:22 +0930
Message-ID: <87zk81x7dp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012 16:03:23 +0800, Asias He <asias@redhat.com> wrote:
> On 06/18/2012 03:46 PM, Rusty Russell wrote:
> > On Mon, 18 Jun 2012 14:53:10 +0800, Asias He <asias@redhat.com> wrote:
> >> This patch introduces bio-based IO path for virtio-blk.
> >
> > Why make it optional?
> 
> request-based IO path is useful for users who do not want to bypass the 
> IO scheduler in guest kernel, e.g. users using spinning disk. For users 
> using fast disk device, e.g. SSD device, they can use bio-based IO path.

Users using a spinning disk still get IO scheduling in the host though.
What benefit is there in doing it in the guest as well?

Cheers,
Rusty.
