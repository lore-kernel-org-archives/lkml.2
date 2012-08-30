Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2H3JRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 05:17:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51673 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab2H3JRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 05:17:40 -0400
Date: Thu, 30 Aug 2012 02:17:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9 V3] workqueue: add
 non_manager_role_manager_mutex_unlock()
Message-ID: <20120830091739.GA10874@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com>
 <1346259120-6216-5-git-send-email-laijs@cn.fujitsu.com>
 <20120829182510.GB2258@dhcp-172-17-108-109.mtv.corp.google.com>
 <503F2F51.8000301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503F2F51.8000301@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Thu, Aug 30, 2012 at 05:16:01PM +0800, Lai Jiangshan wrote:
> gcwq_unbind_fn() is unsafe even it is called from a work item.
> so we need non_manager_role_manager_mutex_unlock().
> 
> If rebind_workers() is called from a work item, it is safe when there is
> no CPU_INTENSIVE items. but we can't disable CPU_INTENSIVE items,
> so it is still unsafe, we need non_manager_role_manager_mutex_unlock() too.

Can you please elaborate?  Why is it not safe if there are
CPU_INTENSIVE items?

Thanks.

-- 
tejun
