Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2KHOY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:24:58 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41739 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab2KHOY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:24:57 -0500
Date: Thu, 8 Nov 2012 06:24:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] cgroup: set 'start' with the right value in cgroup_path.
Message-ID: <20121108142452.GB12973@htj.dyndns.org>
References: <1352381798-2357-1-git-send-email-tm@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352381798-2357-1-git-send-email-tm@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 08, 2012 at 09:36:38PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> 'start' is set to buf + buflen and do the '--' immediately.
> Just set it to 'buf + buflen - 1' directly.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>

You're missing S-O-B.  I added it while applying.  Please ack if you
agree.

Heh, I'm not sure how much of an improvement this is but there's
obviously nothing wrong with it either.  Applying to cgroup/for-3.8.

Thanks.

-- 
tejun
