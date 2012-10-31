Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282Ab2KABB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 21:01:57 -0400
Received: from ozlabs.org ([203.10.76.45]:48839 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378Ab2KABBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 21:01:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Joe Perches <joe@perches.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] virtio: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
In-Reply-To: <a32fa314ea4f0318869f62d0942d3f1f936219d6.1351411048.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com> <a32fa314ea4f0318869f62d0942d3f1f936219d6.1351411048.git.joe@perches.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 01 Nov 2012 10:24:03 +1030
Message-ID: <87ip9q5hb8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
> and reducing object size is good.
> Convert if (printk_ratelimit()) dev_printk to dev_<level>_ratelimited.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.

Thanks,
Rusty.
