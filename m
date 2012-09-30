Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab2I3Hcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 03:32:33 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:59920 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2I3Hcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 03:32:32 -0400
Date: Sun, 30 Sep 2012 16:32:25 +0900
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] workqueue: simplify is_chained_work()
Message-ID: <20120930073225.GB10383@mtj.dyndns.org>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
 <1348680043-5077-5-git-send-email-laijs@cn.fujitsu.com>
 <20120926182837.GE12544@google.com>
 <50657342.6000008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50657342.6000008@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 28, 2012 at 05:52:02PM +0800, Lai Jiangshan wrote:
> Main reason: I think the readability of your is the same as mine,
> and your add two lines.
> 
> Tiny reason: my code uses only one return. (I don't always keep one return,
> but I try to keep it if it is still clean)
> 
> Is there any other reason to change it?

I don't like that the same condition is tested twice but technical
advantages on issues like this are usually too small to be used as the
sole basis to choose one over another and it usually comes down to
preferences.  For little things without clear technical advantage,
following maintainer's taste tends to lead to higher consistency.  So,
yeah, I'd appreciate if you change it on the next posting or will
probably just change it while applying it.

Thanks.

-- 
tejun
