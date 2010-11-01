Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0KAHHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 03:07:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51172 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab0KAHHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 03:07:05 -0400
Date: Mon, 1 Nov 2010 16:06:03 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/2] mm: vmstat: Use a single setter function and callback for adjusting percpu thresholds
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
In-Reply-To: <1288169256-7174-3-git-send-email-mel@csn.ul.ie>
References: <1288169256-7174-1-git-send-email-mel@csn.ul.ie> <1288169256-7174-3-git-send-email-mel@csn.ul.ie>
Message-Id: <20101101023816.6068.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> reduce_pgdat_percpu_threshold() and restore_pgdat_percpu_threshold()
> exist to adjust the per-cpu vmstat thresholds while kswapd is awake to
> avoid errors due to counter drift. The functions duplicate some code so
> this patch replaces them with a single set_pgdat_percpu_threshold() that
> takes a callback function to calculate the desired threshold as a
> parameter.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>





