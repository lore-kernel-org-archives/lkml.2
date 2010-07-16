Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965069Ab0GPK2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 06:28:20 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33981 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965058Ab0GPK2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 06:28:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Jul 2010 19:23:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Subject: Re: [PATCH 7/7] memcg: add mm_vmscan_memcg_isolate tracepoint
Message-Id: <20100716192334.197b3f38.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100716191739.737E.A69D9226@jp.fujitsu.com>
References: <20100716191006.7369.A69D9226@jp.fujitsu.com>
	<20100716191739.737E.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010 19:18:18 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 
> Memcg also need to trace page isolation information as global reclaim.
> This patch does it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

