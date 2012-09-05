Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058Ab2IEXLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:11:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62289 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759819Ab2IEXLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:11:21 -0400
Date: Wed, 5 Sep 2012 16:11:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] workqueue: fix possible deadlock in idle worker
 rebinding
Message-ID: <20120905231116.GD29092@google.com>
References: <20120905061233.GA3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120905061632.GB3195@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905061632.GB3195@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 11:16:32PM -0700, Tejun Heo wrote:
> Currently, rebind_workers() and idle_worker_rebind() are two-way
> interlocked.  rebind_workers() waits for idle workers to finish
> rebinding and rebound idle workers wait for rebind_workers() to finish
> rebinding busy workers before proceeding.

Applied to wq/for-3.6-fixes.

Thanks.

-- 
tejun
