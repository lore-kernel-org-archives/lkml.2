Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2EHTCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 15:02:54 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:42286 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2EHTCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 15:02:53 -0400
Message-ID: <4FA96DDB.8070403@tilera.com>
Date: Tue, 8 May 2012 15:02:51 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <mingo@kernel.org>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <cmetcalf@tilera.com>, <tglx@linutronix.de>
CC: <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:smp/hotplug] tile: Use common threadinfo allocator
References: <20120505150142.311126440@linutronix.de> <tip-d909a81b198a397593495508c4a5755fe95552fb@git.kernel.org>
In-Reply-To: <tip-d909a81b198a397593495508c4a5755fe95552fb@git.kernel.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/2012 8:34 AM, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  d909a81b198a397593495508c4a5755fe95552fb
> Gitweb:     http://git.kernel.org/tip/d909a81b198a397593495508c4a5755fe95552fb
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Sat, 5 May 2012 15:05:47 +0000
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 8 May 2012 13:55:20 +0200
>
> tile: Use common threadinfo allocator
>
> Use the core allocator and deal with the extra cleanup in
> arch_release_thread_info().
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Link: http://lkml.kernel.org/r/20120505150142.311126440@linutronix.de
> ---
>  arch/tile/include/asm/thread_info.h |    6 ++----
>  arch/tile/kernel/process.c          |   23 ++---------------------
>  2 files changed, 4 insertions(+), 25 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

