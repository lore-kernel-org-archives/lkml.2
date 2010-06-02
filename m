Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab0FBG0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 02:26:04 -0400
Received: from ozlabs.org ([203.10.76.45]:56871 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab0FBGZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 02:25:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] module: module_unload_init() cleanup
Date: Wed, 2 Jun 2010 15:55:54 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>
References: <1275456740.2638.143.camel@edumazet-laptop> <201006021546.34363.rusty@rustcorp.com.au>
In-Reply-To: <201006021546.34363.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006021555.55007.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 03:46:33 pm Rusty Russell wrote:
> On Wed, 2 Jun 2010 03:02:20 pm Eric Dumazet wrote:
> > No need to clear mod->refptr in module_unload_init(), since
> > alloc_percpu() already clears allocated chunks.
> > 
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> Thanks, applied!
> 
> I know it's trivial, but you should have cc'd Nick since this was his patch.

Hmm, and checked for warnings:

kernel/module.c: In function ‘module_unload_init’:
kernel/module.c:529: warning: unused variable ‘cpu’

Fixed,
Rusty.
