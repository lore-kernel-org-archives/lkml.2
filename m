Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541Ab2JZOsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:48:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56008 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933415Ab2JZOsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:48:52 -0400
Date: Fri, 26 Oct 2012 07:48:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: insert warn_on_once() into
 wq_worker_waking_up()
Message-ID: <20121026144847.GU11442@htj.dyndns.org>
References: <1351260229-2098-1-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351260229-2098-1-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 11:03:49PM +0900, Joonsoo Kim wrote:
> Recently, workqueue code has gone through some changes and we found some bugs
> related to this. To prevent futher bugs in advance, add WARN_ON_ONCE() in
> wq_worker_waking_up(). When worker is not WORKER_NOT_RUNNIG state,
> it should be binded to it's associated cpu and executed in that cpu.
> Add code for checking this.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>

Applied to wq/for-3.8 w/ some commit message updates.

Thanks.

-- 
tejun
