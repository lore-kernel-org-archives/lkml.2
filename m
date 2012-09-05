Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab2IEBSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 21:18:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36853 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab2IEBR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 21:17:58 -0400
Date: Tue, 4 Sep 2012 18:17:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] workqueue: UNBOUND -> REBIND morphing in
 rebind_workers() should be atomic
Message-ID: <20120905011754.GE2836@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
 <1346516916-1991-2-git-send-email-laijs@cn.fujitsu.com>
 <20120904233901.GC9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <5046A561.9050903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5046A561.9050903@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, Sep 05, 2012 at 09:05:37AM +0800, Lai Jiangshan wrote:
> Thank you for accepting this one.

Thanks a lot for bearing with me.  I was at kernel summit / plumbers
last week so my reviews were shaky.  My apologies.

> I'm waiting for your comments on the other patches.
> I need to rebase the other patches(on top of wq/for-3.7 and this merged one),
> but I think it is not good to seed to new version patchset without considering
> your comments. so I'm still waiting. Or should I rebase them at first?

Let's get the fixes down first.  The fixes and restructuring need to
be routed separately, so we need to separate them into different patch
serieses.  Once the fix part is done, I'll pull the fixes into for-3.7
on which restructuring can happen.

Thanks.

-- 
tejun
