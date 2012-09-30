Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab2I3HWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 03:22:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56059 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab2I3HWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 03:22:13 -0400
Date: Sun, 30 Sep 2012 16:22:07 +0900
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 11/12] workqueue: add WQ_CPU_INTENSIVE to
 system_long_wq
Message-ID: <20120930072207.GA10383@mtj.dyndns.org>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
 <1348680043-5077-12-git-send-email-laijs@cn.fujitsu.com>
 <20120926183833.GI12544@google.com>
 <50655A98.3090507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50655A98.3090507@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Fri, Sep 28, 2012 at 04:06:48PM +0800, Lai Jiangshan wrote:
> But does we need a stand-alone workqueue for work_on_cpu() as it is original
> introduced? (2d3854a3)

Given how work_on_cpu() is used currently, I don't think we need that.
What we need to do is removing the remaining flush_scheduled_work()
users and trigger WARN if somebody tries to flush one of the system
workqueues.

Thanks.

-- 
tejun
