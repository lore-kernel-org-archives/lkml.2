Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3AHSIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:08:37 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41857 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765Ab3AHSIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:08:35 -0500
Date: Tue, 8 Jan 2013 10:08:28 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Thelen <gthelen@google.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cgroups: fix cgroup_event_listener error handling
Message-ID: <20130108180828.GA3926@htj.dyndns.org>
References: <1357333518-28899-1-git-send-email-gthelen@google.com>
 <1357333518-28899-2-git-send-email-gthelen@google.com>
 <20130107174427.GM3926@htj.dyndns.org>
 <xr93a9sklqme.fsf@gthelen.mtv.corp.google.com>
 <50EBBC9C.7060909@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EBBC9C.7060909@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 02:28:44PM +0800, Li Zefan wrote:
> > cgroups: fix cgroup_event_listener error handling
> > 
> > The error handling in cgroup_event_listener.c did not correctly deal
> > with either an error opening either <control_file> or
> > cgroup.event_control.  Due to an uninitialized variable the program
> > exit code was undefined if either of these opens failed.
> > 
> > This patch simplifies and corrects cgroup_event_listener.c error
> > handling by:
> > 1. using err*() rather than printf(),exit()
> > 2. depending on process exit to close open files
> > 
> > With this patch failures always return non-zero error.
> > 
> > Signed-off-by: Greg Thelen <gthelen@google.com>
> 
> Acked-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.9.

Thanks.

-- 
tejun
