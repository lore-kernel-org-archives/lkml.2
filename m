Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab2CEVIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:08:41 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:32948 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2CEVIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:08:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.194.65 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Mon, 5 Mar 2012 13:08:36 -0800
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] blkcg: accumulated blkcg updates
Message-ID: <20120305210836.GD1263@google.com>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
 <20120305210726.GC1263@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305210726.GC1263@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 01:07:26PM -0800, Tejun Heo wrote:
> Hello,
> 
> Vivek reported two different crashes.  Patch 17.5 added and patch 27
> updated to address both issues.  Andrew reminded me a deeper problem
> with percpu mempool approach and I'll go with Vivek's delayed
> allocation patch.  For now, I'm dropping the stats patches.
> 
> I posted the two updated patches but holding off reposting all patches
> which now generate conflicts due to the updates.  git branches are
> updated.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-stacking
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git unified-blkg
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-kill-pn
> 
> Note that blkcg-stats is dropped for now.  I'll repost the series
> later when Jens is ready to pull.

Ooh, the commit ID of blkcg-stacking, which is on top of all other
pending commits is fcddfec4ea9067ae6c963682dcdb5ddf783a3ff9.

Vivek, can you please verify the crashes you were seeing are gone now?

Thanks.

-- 
tejun
