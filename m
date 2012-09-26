Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab2IZSYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:24:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33355 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab2IZSYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:24:07 -0400
Date: Wed, 26 Sep 2012 11:24:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] workqueue: remove WORKER_PREP from rescuer
Message-ID: <20120926182402.GD12544@google.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
 <1348680043-5077-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348680043-5077-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 01:20:34AM +0800, Lai Jiangshan wrote:
> There is no reason to use WORKER_PREP, remove it from rescuer.
> 
> And there is no reason to set it so early in alloc_worker(),
> move "worker->flags = WORKER_PREP" to start_worker().

Merge this with the patch to add RESCUER to NOT_RUNNING?

-- 
tejun
