Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0FBGQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 02:16:37 -0400
Received: from ozlabs.org ([203.10.76.45]:53037 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab0FBGQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 02:16:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] module: module_unload_init() cleanup
Date: Wed, 2 Jun 2010 15:46:33 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>
References: <1275456740.2638.143.camel@edumazet-laptop>
In-Reply-To: <1275456740.2638.143.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021546.34363.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 03:02:20 pm Eric Dumazet wrote:
> No need to clear mod->refptr in module_unload_init(), since
> alloc_percpu() already clears allocated chunks.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Thanks, applied!

I know it's trivial, but you should have cc'd Nick since this was his patch.

Cheers,
Rusty.
