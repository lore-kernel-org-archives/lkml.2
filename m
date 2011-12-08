Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1LHSuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:50:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44864 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1LHSt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:49:56 -0500
Date: Thu, 8 Dec 2011 10:49:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the memblock tree
Message-ID: <20111208184952.GA12108@google.com>
References: <20111206143808.3fa5f3785538a37c9686734d@canb.auug.org.au>
 <20111208075405.911cefd2ee3c2ed81cdc5f4b@canb.auug.org.au>
 <CAOS58YOSp6VOJ6WCOyYf3KEJ=_p9ZG4LXmK8YiDgn4Y7DbVHKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YOSp6VOJ6WCOyYf3KEJ=_p9ZG4LXmK8YiDgn4Y7DbVHKA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 07, 2011 at 01:30:44PM -0800, Tejun Heo wrote:
> Still trying to restore my cross build setup. I think I will be able
> to send update series later today.

Made the following changes,

* Fix the CONFIG_HAVE typo bug.

* Remove 7 space -> tab conversion in arch/score/Kconfig to ease
  conflict resolution.

* Merge resolution in arch/arm/mm/init.c was incorrect.  Both sort()
  and memblock_init() calls should be removed.  Fixed.

memblock-kill-early_node_map is now 7bd0b0f0da.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git memblock-kill-early_node_map

Merge result can be verified against the following branch (d8b950f4c3)

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git memblock-kill-early_node_map-next

Thanks.

-- 
tejun
