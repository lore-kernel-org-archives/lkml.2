Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1JZVgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 17:36:35 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36595 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab1JZVge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 17:36:34 -0400
Date: Wed, 26 Oct 2011 14:36:29 -0700
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET block:for-3.2/core] rescue cfq from RCU death sprial
 :)
Message-ID: <20111026213629.GJ24261@google.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319593719-19132-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Tue, Oct 25, 2011 at 06:48:26PM -0700, Tejun Heo wrote:
> This patchset contains the following 13 patches.
> 
>  0001-ida-make-ida_simple_get-put-IRQ-safe.patch
>  0002-block-cfq-move-cfqd-cic_index-to-q-id.patch
>  0003-block-misc-ioc-cleanups.patch
>  0004-block-make-ioc-get-put-interface-more-conventional-a.patch
>  0005-block-misc-updates-to-blk_get_queue.patch
>  0006-block-cfq-misc-updates-to-cfq_io_context.patch
>  0007-block-cfq-move-ioc-ioprio-cgroup-changed-handling-to.patch
>  0008-block-cfq-fix-race-condition-in-cic-creation-path-an.patch
>  0009-block-cfq-fix-cic-lookup-locking.patch
>  0010-block-cfq-unlink-cfq_io_context-s-immediately.patch
>  0011-block-cfq-remove-delayed-unlink.patch
>  0012-block-cfq-kill-ioc_gone.patch
>  0013-block-cfq-kill-cic-key.patch

0001 removed (realized it's not necessary anymore) and sent out
separately.  0004 and 0010 updated to address issues Vivek pointed
out.  Both don't affect other patches.

git branch is updated to reflect the changes including dropping of ide
related changes from the previous patchset.  You won't be able to pull
this directly as I couldn't use commits for the previous patchset from
the block tree (they're not there yet).

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-cfq-sync

When you want the whole series reposted, let me know.

Thanks.

-- 
tejun
