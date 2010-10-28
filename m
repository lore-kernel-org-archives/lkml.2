Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab0J1BQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 21:16:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44857 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab0J1BQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 21:16:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 28 Oct 2010 10:10:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] mm: vmstat: Use a single setter function and
 callback for adjusting percpu thresholds
Message-Id: <20101028101053.f68ad2c4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1288169256-7174-3-git-send-email-mel@csn.ul.ie>
References: <1288169256-7174-1-git-send-email-mel@csn.ul.ie>
	<1288169256-7174-3-git-send-email-mel@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010 09:47:36 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> reduce_pgdat_percpu_threshold() and restore_pgdat_percpu_threshold()
> exist to adjust the per-cpu vmstat thresholds while kswapd is awake to
> avoid errors due to counter drift. The functions duplicate some code so
> this patch replaces them with a single set_pgdat_percpu_threshold() that
> takes a callback function to calculate the desired threshold as a
> parameter.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


