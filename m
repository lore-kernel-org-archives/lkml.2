Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab1LUAN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:13:59 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47311 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab1LUANx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:13:53 -0500
Date: Tue, 20 Dec 2011 16:13:47 -0800
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 5/5] cgroup: separate out cgroup_attach_proc error
 handling code
Message-ID: <20111221001347.GQ10752@google.com>
References: <1324422873-31001-1-git-send-email-msb@chromium.org>
 <1324422873-31001-6-git-send-email-msb@chromium.org>
 <20111220233502.GN10752@google.com>
 <20111221000231.GX13529@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221000231.GX13529@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 04:02:31PM -0800, Mandeep Singh Baines wrote:
> > Hmm... maybe goto out_free_group_list?  Duplicating cleanup on success
> > and failure paths can lead future updaters forget one of them.  The
> > exit path in this function isn't pretty but I don't think the proposed
> > patch improves it either.
> > 
> 
> Should I drop the patch or add the goto? Its 5/5 so easy enough to drop
> since nothing else depends on it.

Yeah, let's drop it for now.  Thanks.

-- 
tejun
