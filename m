Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab2EJBKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 21:10:01 -0400
Received: from ozlabs.org ([203.10.76.45]:52368 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295Ab2EJBKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 21:10:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH] virtio-mmio: Devices parameter parsing
In-Reply-To: <1336584616-7802-1-git-send-email-pawel.moll@arm.com>
References: <1336584616-7802-1-git-send-email-pawel.moll@arm.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 10 May 2012 10:14:55 +0930
Message-ID: <87d36cdfug.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 May 2012 18:30:16 +0100, Pawel Moll <pawel.moll@arm.com> wrote:
> This patch adds an option to instantiate guest virtio-mmio devices
> basing on a kernel command line (or module) parameter, for example:
> 
> 	virtio_mmio.devices=0x100@0x100b0000:48
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
> 
> Hi Rusty,
> 
> As the param changes are in now, could you queue this
> long-time-forgotten patch for 3.5?

Finally, thanks!

> PS. Congratulations once again and see you in HK.

Thanks, and looking forward to it!

Cheers,
Rusty. 
