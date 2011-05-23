Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1EWPv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:51:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755211Ab1EWPv5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:51:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110523112454.GA17547@htj.dyndns.org>
References: <BANLkTin3T8msxSSbTLJOvC5WLNFGspPEcg@mail.gmail.com>
 <20110519093026.GA627@htj.dyndns.org> <BANLkTinP7txzE2U+8qnJR2JVcGpGybnLrA@mail.gmail.com>
 <20110523112454.GA17547@htj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 May 2011 08:51:35 -0700
Message-ID: <BANLkTinppQGEyiERCjFG0LYgTZGXbtApBw@mail.gmail.com>
Subject: Re: [PATCH] block: move bd_set_size() above rescan_partitions() in __blkdev_get()
To: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 4:24 AM, Tejun Heo <tj@kernel.org> wrote:
>
> 02e352287a4 (block: rescan partitions on invalidated devices on
> -ENOMEDIA too) relocated partition rescan above explicit bd_set_size()
> to simplify condition check.  As rescan_partitions() does its own bdev
> size setting, this doesn't break anything; however,
> rescan_partitions() prints out the following messages when adjusting
> bdev size, which can be confusing.

Applied,

               Linus
