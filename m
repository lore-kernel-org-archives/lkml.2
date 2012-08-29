Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab2H2SlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 14:41:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33678 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2H2Sk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 14:40:58 -0400
Date: Wed, 29 Aug 2012 11:40:57 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9 V3] workqueue: single pass rebind_workers
Message-ID: <20120829184057.GD2258@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com>
 <1346259120-6216-9-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346259120-6216-9-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Thu, Aug 30, 2012 at 12:51:59AM +0800, Lai Jiangshan wrote:
> busy_worker_rebind_fn() can't return until all idle workers are rebound,
> the code of busy_worker_rebind_fn() ensure this.
> 
> So we can change the order of the code of rebind_workers(),
> and make it is a single pass to do the rebind_workers().
> 
> It makes the code much clean and better readability.

But, yeah, I do like this approach better.  Would it be possible to do
this without overloading manager_mutex?

Thanks.

-- 
tejun
