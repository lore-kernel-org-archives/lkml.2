Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab2FQCEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 22:04:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35553 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab2FQCEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 22:04:24 -0400
Date: Sun, 17 Jun 2012 10:04:10 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>, Wanpeng Li <liwp.linux@gmail.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm/vmscan: cleanup comment error in balance_pgdat
Message-ID: <20120617020355.GA2168@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1339896438-5412-1-git-send-email-liwp.linux@gmail.com>
 <alpine.DEB.2.00.1206161852010.797@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206161852010.797@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 06:53:02PM -0700, David Rientjes wrote:
>On Sun, 17 Jun 2012, Wanpeng Li wrote:
>
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>> 
>> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
>
>I think it would be better to do per-subsystem audits like this in a 
>single patch, i.e. one patch for mm/*, one patch for net/*, etc, get it 

thank you David

>acked, and then ask for it to be merged after an -rc1 release to avoid 
>lots of conflicts with other people's work.

You mean trivial maintainer only pull trivial patches for -rc1 release ?

Regards,
Wanpeng Li
