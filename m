Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2JBHXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 03:23:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62557 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab2JBHXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 03:23:47 -0400
Date: Tue, 2 Oct 2012 09:23:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Joonsoo Kim <js1304@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        emilgoode@gmail.com
Subject: Re: [GIT PULL] workqueue changes for v3.7-rc1
Message-ID: <20121002072342.GA9393@gmail.com>
References: <20121002070010.GB6144@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002070010.GB6144@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

>       timer: Generalize timer->base flags handling
>       timer: Relocate declarations of init_timer_on_stack_key()
>       timer: Clean up timer initializers
>       timer: Implement TIMER_IRQSAFE

Note that I pushed these timer changes to Linus already and 
Linus pulled them via 2fff56641be9, so the diffstat might not 
match on Linus's side.

Thanks,

	Ingo
