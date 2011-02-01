Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab1BAJen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 04:34:43 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:47760 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab1BAJem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 04:34:42 -0500
Date: Tue, 1 Feb 2011 10:34:30 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] memcg: fix event counting breakage by recent THP update
Message-ID: <20110201093430.GF19534@cmpxchg.org>
References: <20110201091208.b2088800.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201091208.b2088800.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 09:12:08AM +0900, KAMEZAWA Hiroyuki wrote:
> 
> Thanks to Johannes for catching this.
> And sorry for my patch, I'd like to consinder some debug check..
> =
> Changes in commit e401f1761c0b01966e36e41e2c385d455a7b44ee
> adds nr_pages to support multiple page size in memory_cgroup_charge_statistics.
> 
> But counting the number of event nees abs(nr_pages) for increasing
> counters. This patch fixes event counting.
> 
> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
