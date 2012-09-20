Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab2ITGZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:25:54 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44278 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2ITGZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:25:53 -0400
X-AuditID: 9c930179-b7bfcae0000020b4-e1-505ab6eea84e
Date: Thu, 20 Sep 2012 15:28:32 +0900
From: Minchan Kim <minchan@kernel.org>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, khlebnikov@openvz.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace: don't call page_to_pfn() if page is NULL
Message-ID: <20120920062832.GG13234@bbox>
References: <505AB1FF.8020104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505AB1FF.8020104@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 02:04:47PM +0800, Wen Congyang wrote:
> When allocating memory fails, page is NULL. page_to_pfn() will
> cause the kernel panicked if we don't use sparsemem vmemmap.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>

Nice catch.
I think it's a candidate of stable.

Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
