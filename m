Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab2K1Vx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:53:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51107 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2K1VxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:53:23 -0500
Date: Wed, 28 Nov 2012 13:53:16 -0800
From: Tejun Heo <tj@kernel.org>
To: Greg Thelen <gthelen@google.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cgroup: list_del_init() on removed events
Message-ID: <20121128215316.GC24683@htj.dyndns.org>
References: <1354139445-6685-1-git-send-email-gthelen@google.com>
 <1354139445-6685-2-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354139445-6685-2-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 01:50:45PM -0800, Greg Thelen wrote:
> Use list_del_init() rather than list_del() to remove events from
> cgrp->event_list.  No functional change.  This is just defensive
> coding.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Applied 1-2 to cgroup/for-3.8.  Thanks!

-- 
tejun
