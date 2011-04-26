Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab1DZF0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:26:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48415 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1DZF0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:26:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 26 Apr 2011 14:19:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH 2/2] use oom_killer_disabled in page fault oom path
Message-Id: <20110426141949.d9b9aede.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110426053150.GA11949@darkstar>
References: <20110426053150.GA11949@darkstar>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 13:31:50 +0800
Dave Young <hidave.darkstar@gmail.com> wrote:

> Currently oom_killer_disabled is only used in __alloc_pages_slowpath,
> For page fault oom case it is not considered. One use case is
> virtio balloon driver, when memory pressure is high, virtio ballooning
> will cause oom killing due to such as page fault oom.
> 
> Thus add oom_killer_disabled checking in pagefault_out_of_memory.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


