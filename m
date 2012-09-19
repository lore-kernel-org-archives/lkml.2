Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab2ISRmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:42:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47682 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753Ab2ISRmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:42:18 -0400
Date: Wed, 19 Sep 2012 10:42:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] workqueue: Keep activate-order equals to
 queue_work()-order
Message-ID: <20120919174213.GK8474@google.com>
References: <1347957414-6692-1-git-send-email-laijs@cn.fujitsu.com>
 <1347957414-6692-2-git-send-email-laijs@cn.fujitsu.com>
 <20120918170519.GB8474@google.com>
 <20120918170802.GC8474@google.com>
 <50599AC4.303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50599AC4.303@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, Sep 19, 2012 at 06:13:24PM +0800, Lai Jiangshan wrote:
> From 314d43f087c85b11a29be0555f32deeb742bf18e Mon Sep 17 00:00:00 2001
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date: Tue, 18 Sep 2012 16:26:30 +0800
> Subject: [PATCH] workqueue: use common cwq_set_max_active() for
>  workqueue_set_max_active()
> 
> workqueue_set_max_active() may increase ->max_active without activating
> delayed works. And it may cause the activation order doesn't equal to
> to queue_work()-order.
> 
> To make things consist, we use common cwq_set_max_active() logic which
> immediately makes use of the newly increased max_mactive if there are
> delayed work items and also keep activation ordering.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied 1-2 to wq/for-3.7 with minor updates to comments and
descriptions.

Thanks for doing this!

-- 
tejun
