Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab2ITOYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:24:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40524 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab2ITOYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:24:50 -0400
Date: Thu, 20 Sep 2012 15:24:45 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Wen Congyang <wency@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, khlebnikov@openvz.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace: don't call page_to_pfn() if page is NULL
Message-ID: <20120920142445.GZ11157@csn.ul.ie>
References: <505AB1FF.8020104@cn.fujitsu.com>
 <1348148904.13080.63.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1348148904.13080.63.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 09:48:24AM -0400, Steven Rostedt wrote:
> Mel,
> 
> As you were the original author of this code, can I get your Acked-by?
> 

Sure. Problem as described is valid and the patch looks ok

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
SUSE Labs
