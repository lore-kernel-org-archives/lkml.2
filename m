Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab1EIFkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 01:40:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46126 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab1EIFka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 01:40:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] getdelays: show average CPU/IO/SWAP/RECLAIM delays
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Dave Chinner <david@fromorbit.com>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <20110502140257.GA12780@localhost>
References: <20110502140257.GA12780@localhost>
Message-Id: <20110509144202.163D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  9 May 2011 14:40:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I find it very handy to show the average delays in milliseconds.
> 
> Example output (on 100 concurrent dd reading sparse files):
> 
> CPU             count     real total  virtual total    delay total  delay average
>                   986     3223509952     3207643301    38863410579         39.415ms
> IO              count    delay total  delay average
>                     0              0              0ms
> SWAP            count    delay total  delay average
>                     0              0              0ms
> RECLAIM         count    delay total  delay average
>                  1059     5131834899              4ms
> dd: read=0, write=0, cancelled_write=0
> 
> CC: Mel Gorman <mel@linux.vnet.ibm.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  Documentation/accounting/getdelays.c |   33 +++++++++++++++----------
>  1 file changed, 20 insertions(+), 13 deletions(-)

Cool.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




