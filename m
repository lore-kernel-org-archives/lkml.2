Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1CGIjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:39:03 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48560 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1CGIjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:39:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 5/8] Use correct numa policy node for transparent hugepages
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1299182391-6061-6-git-send-email-andi@firstfloor.org>
References: <1299182391-6061-1-git-send-email-andi@firstfloor.org> <1299182391-6061-6-git-send-email-andi@firstfloor.org>
Message-Id: <20110307173838.8A10.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  7 Mar 2011 17:38:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andi Kleen <ak@linux.intel.com>
> 
> Pass down the correct node for a transparent hugepage allocation.
> Most callers continue to use the current node, however the hugepaged
> daemon now uses the previous node of the first to be collapsed page
> instead. This ensures that khugepaged does not mess up local memory
> for an existing process which uses local policy.
> 
> The choice of node is somewhat primitive currently: it just
> uses the node of the first page in the pmd range. An alternative
> would be to look at multiple pages and use the most popular
> node. I used the simplest variant for now which should work
> well enough for the case of all pages being on the same node.
> 
> Acked-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



