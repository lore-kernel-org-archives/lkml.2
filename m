Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab1K0Tdv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 14:33:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52799 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1K0Tdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 14:33:49 -0500
Date: Sun, 27 Nov 2011 11:33:44 -0800
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: build failure after merge of the cgroup tree
Message-ID: <20111127193336.GD4266@google.com>
References: <20111125145022.d5578c15eb900e2628a072b2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111125145022.d5578c15eb900e2628a072b2@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 25, 2011 at 02:50:22PM +1100, Stephen Rothwell wrote:
> I don't know how to fix this up (the obvious fix will cause us to have
> nested rcu_read_lock()s and I have no idea if that is allowed).  Can you
> please provide me with a merge resolution?   I am also wondering why such
> closely related work is happening in 2 different trees.

Sorry about all the conflicts.  There have been major updates to both
freezer and cgroup and cgroup_freezer happens to receive changes from
both subsystem changes.  I dropped cgroup changes for now as Linus
doesn't seem to be too happy with the current approach.  Once an
agreeable approach is found, I'll pull in pm-freezer branch into
cgroup and then put cgroup changes on top of them.  That should remove
most of merging headaches.

Thanks.

-- 
tejun
