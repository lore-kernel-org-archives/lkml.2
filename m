Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab1A1F5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 00:57:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46281 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab1A1F47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 00:56:59 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Jan 2011 14:50:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [BUGFIX][PATCH 3/4] mecg: fix oom flag at THP charge
Message-Id: <20110128145035.d20af975.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110128143912.66f60a22.nishimura@mxp.nes.nec.co.jp>
References: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128122729.1f1c613e.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128143912.66f60a22.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011 14:39:12 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Fri, 28 Jan 2011 12:27:29 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > 
> > Thanks to Johanns and Daisuke for suggestion.
> > =
> > Hugepage allocation shouldn't trigger oom.
> > Allocation failure is not fatal.
> > 
> > Orignal-patch-by: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> IIUC, this patch isn't necessary because we don't go into oom
> in "page_size > PAGE_SIZE" case after [2/4].
> But I think it's not so bad to show explicitly that we don't cause oom in
> THP charge.
> 
> Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 

Thank you for clarification.

-Kame


