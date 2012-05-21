Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab2EUBSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 21:18:09 -0400
Received: from ozlabs.org ([203.10.76.45]:45421 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab2EUBSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 21:18:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Baozi <baozich@gmail.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Chen Baozi <chenbaozi@gmail.com>
Subject: Re: [PATCH] virtio: fix typo in comment
In-Reply-To: <1337481874-3472-1-git-send-email-baozich@gmail.com>
References: <1337481874-3472-1-git-send-email-baozich@gmail.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 21 May 2012 10:40:28 +0930
Message-ID: <87aa1249vf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2012 10:44:34 +0800, Chen Baozi <baozich@gmail.com> wrote:
> From: Chen Baozi <chenbaozi@gmail.com>
> 
> - Delete "@request_vqs" and "@free_vqs" comments, since
>   they are no longer in struct virtio_config_ops.
> - According to the macro below, "@val" should be "@v".
> 
> Signed-off-by: Chen Baozi <chenbaozi@gmail.com>

Thanks, applied!

Cheers,
Rusty.
