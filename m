Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab0ETKIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 06:08:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab0ETKIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 06:08:50 -0400
Date: Thu, 20 May 2010 13:04:47 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into
	ring itself
Message-ID: <20100520100447.GC5717@redhat.com>
References: <20100505205814.GA7090@redhat.com> <201005191709.16401.rusty@rustcorp.com.au> <4BF39C12.7090407@redhat.com> <201005201431.51142.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005201431.51142.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 02:31:50PM +0930, Rusty Russell wrote:
> Can we do better?  The obvious idea is to try to get rid of last_used and
> used, and use the ring itself.  We would use an invalid entry to mark the
> head of the ring.
> 
> Any other thoughts?
> Rusty.

We also need a way to avoid interrupts at least while we are
processing the ring.

-- 
MST
