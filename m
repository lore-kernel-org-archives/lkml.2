Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab2IEBPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 21:15:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35583 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2IEBPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 21:15:20 -0400
Date: Tue, 4 Sep 2012 18:15:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10 V4] workqueue: merge the role of rebind_hold to
 idle_done
Message-ID: <20120905011516.GD2836@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
 <1346516916-1991-11-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346516916-1991-11-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2012 at 12:28:28AM +0800, Lai Jiangshan wrote:
> Currently is single pass, we can wait on idle_done instead wait on rebind_hold.
> So we can remove rebind_hold and make the code simpler.

As I wrote before, in general, I do like this approach; however, the
implementation in this series seems to make the code longer, which
kinda defeats its purpose of simplifying the implementation.  It could
be because the series is mixing fixes with restructuring.  Can you
please re-spin the restructuring part once fixes are settled?  Let's
see if that actually makes things simpler.

Thanks!

-- 
tejun
