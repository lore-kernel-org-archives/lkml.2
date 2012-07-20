Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab2GTU4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 16:56:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42128 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab2GTU4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 16:56:23 -0400
From: Anthony Liguori <anthony@codemonkey.ws>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Asias He <asias@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RESEND 5/5] vhost-blk: Add vhost-blk support
In-Reply-To: <20120719130957.GD9303@redhat.com>
References: <1342169711-12386-1-git-send-email-asias@redhat.com> <1342169711-12386-6-git-send-email-asias@redhat.com> <87mx2vrjdl.fsf@codemonkey.ws> <20120719130957.GD9303@redhat.com>
User-Agent: Notmuch/0.13.2+60~g7ecf77d (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 20 Jul 2012 15:56:19 -0500
Message-ID: <87obnaup70.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Thu, Jul 19, 2012 at 08:05:42AM -0500, Anthony Liguori wrote:
>> Of course, the million dollar question is why would using AIO in the
>> kernel be faster than using AIO in userspace?
>
> Actually for me a more important question is how does it compare
> with virtio-blk dataplane?

I'm not even asking for a benchmark comparision.  It's the same API
being called from a kernel thread vs. a userspace thread.  Why would
there be a 60% performance difference between the two?  That doesn't
make any sense.

There's got to be a better justification for putting this in the kernel
than just that we can.

I completely understand why Christoph's suggestion of submitting BIOs
directly would be faster.  There's no way to do that in userspace.

Regards,

Anthony Liguori

>
> -- 
> MST
