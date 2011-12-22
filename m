Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1LVPic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:38:32 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41441 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1LVPi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:38:29 -0500
Date: Thu, 22 Dec 2011 07:38:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 3/4] cgroup: only need to check oldcgrp==newgrp once
Message-ID: <20111222153822.GB17084@google.com>
References: <1324527518-24461-1-git-send-email-msb@chromium.org>
 <1324527518-24461-3-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324527518-24461-3-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 08:18:37PM -0800, Mandeep Singh Baines wrote:
> In cgroup_attach_proc it is now sufficient to only check that
> oldcgrp==newcgrp once. Now that we are using threadgroup_lock()
> during the migrations, oldcgrp will not change.
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: containers@lists.linux-foundation.org
> Cc: cgroups@vger.kernel.org
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>

Applied 1-3 to cgroup/for-3.3.  I edited out mention of check_fetched
rename in the commit description of the first patch and applied
Acked-by from Li to all three.  Li, let's stick to ack/nack.

Thanks.

-- 
tejun
