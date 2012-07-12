Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161303Ab2GLQGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:06:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161252Ab2GLQGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:06:08 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] Add vhost-blk support
References: <1342107302-28116-1-git-send-email-asias@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 12 Jul 2012 12:06:01 -0400
In-Reply-To: <1342107302-28116-1-git-send-email-asias@redhat.com> (Asias He's
	message of "Thu, 12 Jul 2012 23:35:01 +0800")
Message-ID: <x498vepklqu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asias He <asias@redhat.com> writes:

> Hi folks,
>
> This patchset adds vhost-blk support. vhost-blk is a in kernel virito-blk
> device accelerator. Compared to userspace virtio-blk implementation, vhost-blk
> gives about 5% to 15% performance improvement.
>
> Asias He (5):
>   aio: Export symbols and struct kiocb_batch for in kernel aio usage
>   eventfd: Export symbol eventfd_file_create()
>   vhost: Make vhost a separate module
>   vhost-net: Use VHOST_NET_FEATURES for vhost-net
>   vhost-blk: Add vhost-blk support

I only saw patches 0 and 1.  Where are the other 4?  If the answer is,
"not on lkml," then please resend them, CC'ing lkml.  I'd like to be
able to see the usage of the aio routines.

Cheers,
Jeff
