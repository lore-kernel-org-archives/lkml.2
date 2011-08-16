Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab1HPXz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 19:55:58 -0400
Received: from tundra.namei.org ([65.99.196.166]:38906 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab1HPXz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 19:55:58 -0400
Date: Wed, 17 Aug 2011 09:49:15 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Matt Fleming <matt@console-pimps.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tomoyo: remove tomoyo_gc_thread()->daemonize()
In-Reply-To: <20110816183405.GA3257@redhat.com>
Message-ID: <alpine.LRH.2.00.1108170949010.15656@tundra.namei.org>
References: <20110816183405.GA3257@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Aug 2011, Oleg Nesterov wrote:

> daemonize() is only needed when a user-space task does kernel_thread().
> 
> tomoyo_gc_thread() is kthread_create()'ed and thus it doesn't need
> the soon-to-be-deprecated daemonize().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
