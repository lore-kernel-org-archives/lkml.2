Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab2BWWnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:43:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab2BWWni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:43:38 -0500
Date: Thu, 23 Feb 2012 14:43:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, vgoyal@redhat.com, hughd@google.com, avi@redhat.com,
        nate@cpanel.net, cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-Id: <20120223144336.58742e1b.akpm@linux-foundation.org>
In-Reply-To: <1330036246-21633-1-git-send-email-tj@kernel.org>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 14:30:38 -0800
Tejun Heo <tj@kernel.org> wrote:

> This patchset is combination of the patchset "block, mempool, percpu:
> implement percpu mempool and fix blkcg percpu alloc deadlock" [1] and
> patches to remove blkg->stats_lock.

What's changed since last time?  I scanned the changelogs to see how
earlier issues were addressed and saw no mention of any of it.  eg, is
the code still deadlockable if the allocator is called with __GFP_WAIT?
