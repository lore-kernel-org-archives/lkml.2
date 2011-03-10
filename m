Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1CJWUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:20:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752388Ab1CJWUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:20:38 -0500
Date: Thu, 10 Mar 2011 14:20:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v4] memcg: fix leak on wrong LRU with FUSE
Message-Id: <20110310142029.5d108e37.akpm@linux-foundation.org>
In-Reply-To: <20110310150428.f175758c.nishimura@mxp.nes.nec.co.jp>
References: <20110308135612.e971e1f3.kamezawa.hiroyu@jp.fujitsu.com>
	<20110308181832.6386da5f.nishimura@mxp.nes.nec.co.jp>
	<20110309150750.d570798c.kamezawa.hiroyu@jp.fujitsu.com>
	<20110309164801.3a4c8d10.kamezawa.hiroyu@jp.fujitsu.com>
	<20110309100020.GD30778@cmpxchg.org>
	<20110310083659.fd8b1c3f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110310144752.289483d4.kamezawa.hiroyu@jp.fujitsu.com>
	<20110310150428.f175758c.nishimura@mxp.nes.nec.co.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 15:04:28 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> I hope this can fix the original BZ case.

Do you recall the buzilla bug number?

Thanks.
