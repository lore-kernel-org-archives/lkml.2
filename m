Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965053Ab0GPK1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 06:27:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33942 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965019Ab0GPK1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 06:27:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Jul 2010 19:22:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Subject: Re: [PATCH 6/7] vmscan: convert mm_vmscan_lru_isolate to
 DEFINE_EVENT
Message-Id: <20100716192250.80118098.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100716191649.737B.A69D9226@jp.fujitsu.com>
References: <20100716191006.7369.A69D9226@jp.fujitsu.com>
	<20100716191649.737B.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010 19:17:36 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> TRACE_EVENT() is a bit old fashion and we need to use
> DECLARE_EVENT_CLASS for introducing memcg isolate pages
> tracepoint.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


