Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab1L1RzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 12:55:19 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45291 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab1L1RzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 12:55:14 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1112280939390.3320@eggly.anvils>
References: <20111222150836.af172886.akpm@linux-foundation.org>
	<20111222232036.GP17084@google.com>
	<20111222152427.c944c747.akpm@linux-foundation.org>
	<20111222233843.GR17084@google.com>
	<20111222154427.89b245c7.akpm@linux-foundation.org>
	<20111222234639.GS17084@google.com>
	<20111223004244.GU17084@google.com>
	<alpine.LSU.2.00.1112232058550.3225@eggly.anvils>
	<20111225010238.GA6013@htj.dyndns.org>
	<alpine.LSU.2.00.1112280010550.1398@eggly.anvils>
	<20111228164836.GP17712@google.com>
	<alpine.LSU.2.00.1112280939390.3320@eggly.anvils>
Date: Wed, 28 Dec 2011 09:55:12 -0800
X-Google-Sender-Auth: FCW029m0KOpL7No_U3TR66Q-ytU
Message-ID: <CAOS58YOzUcZz41+H+7dk5FteHy+Ufrtpk9dvdPqX6eie-GHi0Q@mail.gmail.com>
Subject: Re: [PATCH block/for-3.3/core] block: an exiting task should be
 allowed to create io_context
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 28, 2011 at 9:50 AM, Hugh Dickins <hughd@google.com> wrote:
> "It's the tmpfs swapping test that I've been running, with variations,
> for years.  System booted with mem=700M and 1.5G swap, two repetitious
> make -j20 kernel builds (of a 2.6.24 kernel: I stuck with that because
> the balance of built to unbuilt source grows smaller with later kernels),
> one directly in a tmpfs, the other in a 1k-block ext2 (that I drive with
> ext4's CONFIG_EXT4_USE_FOR_EXT23) on /dev/loop0 on a 450MB tmpfs file."
>
> I doubt much of that (quoted from an older mail to someone else about
> one of the many other bugs it's found) is relevant: maybe just plenty
> of file I/O and swapping.

Plain -j4 build isn't triggering anything.  I'll try to replicate the condition.

Thanks.

-- 
tejun
