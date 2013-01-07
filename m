Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab3AGRmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:42:20 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:52005 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3AGRmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:42:18 -0500
Date: Mon, 7 Jan 2013 09:42:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Greg Thelen <gthelen@google.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cgroups: move cgroup_event_listener.c to tools/cgroup
Message-ID: <20130107174213.GL3926@htj.dyndns.org>
References: <1357333518-28899-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357333518-28899-1-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 01:05:17PM -0800, Greg Thelen wrote:
> Move the cgroup_event_listener.c tool from Documentation into the new
> tools/cgroup directory.
> 
> This change involves wiring cgroup_event_listener.c into the tools/
> make system so that is can be built with:
>   $ make tools/cgroup
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Applied to cgroup/for-3.9.

Thanks.

-- 
tejun
