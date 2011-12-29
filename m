Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1L2Deu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 22:34:50 -0500
Received: from ozlabs.org ([203.10.76.45]:54182 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1L2Des (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 22:34:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the rr tree
In-Reply-To: <20111228181640.d299620c8e66237509fbba37@canb.auug.org.au>
References: <20111228181640.d299620c8e66237509fbba37@canb.auug.org.au>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 29 Dec 2011 13:50:06 +1030
Message-ID: <87k45ggj2x.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Dec 2011 18:16:40 +1100, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
Non-text part: multipart/signed
> Hi Rusty,
> 
> After merging the rr tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> drivers/net/virtio_net.c: In function 'virtnet_open':
> drivers/net/virtio_net.c:732:3: warning: passing argument 1 of 'queue_delayed_work' from incompatible pointer type [enabled by default]
> include/linux/workqueue.h:352:12: note: expected 'struct workqueue_struct *' but argument is of type 'struct workqueue_struct **'

Oops, thanks.  Fixed.

Cheers,
Rusty.
