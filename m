Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab1JYDl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 23:41:56 -0400
Received: from ozlabs.org ([203.10.76.45]:36965 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab1JYDlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 23:41:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        virtualization@lists.linux-foundation.org
Cc: Pawel Moll <pawel.moll@arm.com>, Anthony Liguori <aliguori@us.ibm.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4] virtio: Add platform bus driver for memory mapped virtio device
In-Reply-To: <1319461623-16420-1-git-send-email-pawel.moll@arm.com>
References: <1319461560.3668.16.camel@hornet.cambridge.arm.com> <1319461623-16420-1-git-send-email-pawel.moll@arm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 25 Oct 2011 11:43:39 +1030
Message-ID: <87pqhlq3ek.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Oct 2011 14:07:03 +0100, Pawel Moll <pawel.moll@arm.com> wrote:
> This patch, based on virtio PCI driver, adds support for memory
> mapped (platform) virtio device. This should allow environments
> like qemu to use virtio-based block & network devices even on
> platforms without PCI support.
> 
> One can define and register a platform device which resources
> will describe memory mapped control registers and "mailbox"
> interrupt. Such device can be also instantiated using the Device
> Tree node with compatible property equal "virtio,mmio".
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Anthony Liguori <aliguori@us.ibm.com>
> Cc: Michael S.Tsirkin <mst@redhat.com>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

Applied.

Thanks!
Rusty.
