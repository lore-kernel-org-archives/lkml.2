Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab1H3A1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 20:27:19 -0400
Received: from ozlabs.org ([203.10.76.45]:47146 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab1H3A1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 20:27:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: wanlong.gao@gmail.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio: fix size computation according to the definition of struct vring_used in vring_size
In-Reply-To: <4E5B460F.7070707@gmail.com>
References: <4E584365.1010806@gmail.com> <1314413399.1913.1.camel@Allen> <4E58BA41.6050503@gmail.com> <4E58BE42.8030700@gmail.com> <87fwkl2ajr.fsf@rustcorp.com.au> <4E5B460F.7070707@gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 30 Aug 2011 09:42:30 +0930
Message-ID: <87hb4z7o5t.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011 15:55:59 +0800, Wang Sheng-Hui <shhuiw@gmail.com> wrote:
> Patch regerated to use sizeof(__u16) instead of 16 in vring_init.
> Please check it.

Applied.

Thanks,
Rusty.
