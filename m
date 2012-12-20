Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2LTTS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:18:29 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:62367 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2LTTSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:18:10 -0500
Date: Thu, 20 Dec 2012 11:18:03 -0800
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: remove redundant check
Message-ID: <20121220191803.GA14527@htj.dyndns.org>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
 <1356030701-16284-23-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356030701-16284-23-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 02:11:31PM -0500, Sasha Levin wrote:
> We already know that 'event' is non-NULL, remove the redundant check.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

I don't know.  I kinda like that test there.  It's not an error path
and tearing down everything which could have been allocated.  If the
test not being used is bothering, convert return -ENOMEM to goto fail?

-- 
tejun
