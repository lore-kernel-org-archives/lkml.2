Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab2DAVmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:42:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51774 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab2DAVms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:42:48 -0400
Date: Sun, 1 Apr 2012 14:42:43 -0700
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET] block: modularize blkcg config and stat file
 handling
Message-ID: <20120401214243.GA12536@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332975091-10950-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 03:51:10PM -0700, Tejun Heo wrote:
> and is on top of
> 
>   block/for-3.5/core eb7d8c07f9 "cfq: fix cfqg ref handling..."
> + [1] cgroup-cftypes d954ca6469 "cgroup: implement cgroup_rm_cftypes()"
> 
> Note that the cgroup branch is temporary and the merge between the two
> branches aren't trivial.  I'll prepare a proper merged branch once the
> cgroup/for-3.5 branch is settled.
> 
> This patchset is also available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-files

The above branch has been updated on top of block/for-3.5/core +
cgroup/for-3.5.  Ready to be pulled.

Thanks.

-- 
tejun
