Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab1ISDfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 23:35:44 -0400
Received: from ozlabs.org ([203.10.76.45]:43278 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab1ISDfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 23:35:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <aliguori@us.ibm.com>, Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        "Michael S.Tsirkin" <mst@redhat.com>
Subject: Re: [RFC v3] arm: Add platform bus driver for memory mapped virtio device
In-Reply-To: <4E7380FD.1030200@us.ibm.com>
References: <1316191623-3835-1-git-send-email-pawel.moll@arm.com> <4E7380FD.1030200@us.ibm.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 19 Sep 2011 12:59:33 +0930
Message-ID: <874o09ryzm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Sep 2011 12:01:49 -0500, Anthony Liguori <aliguori@us.ibm.com> wrote:
> On 09/16/2011 11:47 AM, Pawel Moll wrote:
> > This patch, based on virtio PCI driver, adds support for memory
> > mapped (platform) virtio  device. This should allow environments
> > like qemu to use virtio-based block&  network devices.
> >
> > One can define and register a platform device which resources
> > will describe memory mapped control registers and "mailbox"
> > interrupt. Such device can be also instantiated using the Device
> > Tree node with compatible property equal "virtio,mmio".
> >
> > Cc: Rusty Russell<rusty@rustcorp.com.au>
> > Cc: Anthony Liguori<aliguori@us.ibm.com>
> > Cc: Michael S.Tsirkin<mst@redhat.com>
> > Signed-off-by: Pawel Moll<pawel.moll@arm.com>
> 
> Have you written a specification for this device?
> 
> Rusty maintains a formal spec for all virtio devices at:
> 
> http://ozlabs.org/~rusty/virtio-spec/
> 
> The spec should be written before merging the code to make sure that there 
> aren't future compatibility problems.

A good idea, but the current spec is for PCI.  I wonder if we should
move the PCI part out to an appendix and make it more general?

Meanwhile, perhaps this would be suitable as an appendix.

Cheers,
Rusty.
