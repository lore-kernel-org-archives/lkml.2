Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0EFCbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 22:31:41 -0400
Received: from ozlabs.org ([203.10.76.45]:52339 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab0EFCbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 22:31:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH RFC] virtio: put last seen used index into ring itself
Date: Thu, 6 May 2010 12:01:34 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20100505205814.GA7090@redhat.com>
In-Reply-To: <20100505205814.GA7090@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005061201.35223.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010 06:28:14 am Michael S. Tsirkin wrote:
> Rusty,
> this is a simplified form of a patch you posted in the past.
> I have a vhost patch that, using this feature, shows external
> to host bandwidth grow from 5 to 7 GB/s, by avoiding
> an interrupt in the window after previous interrupt
> was sent and before interrupts were disabled for the vq.
> With vhost under some external to host loads I see
> this window being hit about 30% sometimes.

Fascinating.  So you use this to guess if the guest is still processing?
I haven't thought about it hard, but is that racy?

Obviously happy to apply this when you finalize it.

Thanks!
Rusty.
