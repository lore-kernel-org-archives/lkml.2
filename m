Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab2BPWnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:43:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54205 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab2BPWnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:43:03 -0500
Date: Thu, 16 Feb 2012 14:42:58 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED2 11/11] blkcg: unify blkg's for blkcg policies
Message-ID: <20120216224258.GN24986@google.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-12-git-send-email-tj@kernel.org>
 <20120202003730.GC19837@google.com>
 <20120214013347.GK12117@google.com>
 <20120215170229.GE27312@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215170229.GE27312@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 15, 2012 at 12:02:29PM -0500, Vivek Goyal wrote:
> - Cleanup in-place policy data update logic.
> 
> - Do not kill all the groups upon one policy switch. Keep the group around
>   and just kill the policy data of associated policy.
>
> - Get rid if locking complexity and rcu around group removal. Replace with
>   double lock dancing stuff.

Yeap, just sent out this one and fix for stacking.  I'll probably do
the in-place policy update thing next.

> - Fix the per cpu alloc stat alloc mess. This is anyway needed
>   irrespective of cleanup.

I'll ping Andrew again on the mempool thing on more time.

Thanks.

-- 
tejun
