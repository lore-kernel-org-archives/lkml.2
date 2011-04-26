Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab1DZFvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:51:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50110 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1DZFvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:51:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 2/2] use oom_killer_disabled in page fault oom path
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20110426053150.GA11949@darkstar>
References: <20110426053150.GA11949@darkstar>
Message-Id: <20110426145320.F387.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 26 Apr 2011 14:51:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently oom_killer_disabled is only used in __alloc_pages_slowpath,
> For page fault oom case it is not considered. One use case is
> virtio balloon driver, when memory pressure is high, virtio ballooning
> will cause oom killing due to such as page fault oom.
> 
> Thus add oom_killer_disabled checking in pagefault_out_of_memory.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

Thank you.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



