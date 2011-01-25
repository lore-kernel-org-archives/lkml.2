Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1AYIih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:38:37 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47760 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1AYIig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:38:36 -0500
Date: Tue, 25 Jan 2011 17:31:16 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        stable@kernel.org, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 1/3] memcg: fix account leak at failure of memsw
 acconting.
Message-Id: <20110125173116.49490683.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110125150042.fa7a9a9a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110125145720.cd0cbe16.kamezawa.hiroyu@jp.fujitsu.com>
	<20110125150042.fa7a9a9a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 15:00:42 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> This is required for 2.6.36-stable and later.
> ==
> Commit 4b53433468c87794b523e4683fbd4e8e8aca1f63 removes
> a cancel of charge at case: 
> memory charge-> success.
> mem+swap charge-> failure.
> 
> This leaks usage of memory. Fix it.
> 
> This patch is required for stable tree since 2.6.36.
> 
> CC: stable@kernel.org
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Nice catch.

Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
