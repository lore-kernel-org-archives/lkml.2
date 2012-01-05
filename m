Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab2AESAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:00:48 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44824 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab2AESAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:00:47 -0500
Date: Thu, 5 Jan 2012 10:00:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] cgroup: fix to allow mounting a hierarchy by name
Message-ID: <20120105180042.GD18486@google.com>
References: <4EF9291D.7030208@cn.fujitsu.com>
 <4EF964F3.8090705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF964F3.8090705@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 02:25:55PM +0800, Li Zefan wrote:
> If we mount a hierarchy with a specified name, the name is unique,
> and we can use it to mount the hierarchy without specifying its
> set of subsystem names. This feature is documented is
> Documentation/cgroups/cgroups.txt section 2.3
> 
> Here's an example:
> 
> 	# mount -t cgroup -o cpuset,name=myhier xxx /cgroup1
> 	# mount -t cgroup -o name=myhier xxx /cgroup2
> 
> But it was broken by commit 32a8cf235e2f192eb002755076994525cdbaa35a
> (cgroup: make the mount options parsing more accurate)
> 
> This fixes the regression.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Applied to cgroup/for-3.3 w/ cc to stable added.

Thank you.

-- 
tejun
