Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0CRAed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 20:34:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55648 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0CRAeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 20:34:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 18 Mar 2010 09:30:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped 
 anonymous pages
Message-Id: <20100318093042.b6b77d8f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1003171139280.27268@router.home>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie>
	<1268412087-13536-3-git-send-email-mel@csn.ul.ie>
	<28c262361003141728g4aa40901hb040144c5a4aeeed@mail.gmail.com>
	<20100315143420.6ec3bdf9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100315112829.GI18274@csn.ul.ie>
	<1268657329.1889.4.camel@barrios-desktop>
	<20100315142124.GL18274@csn.ul.ie>
	<20100316084934.3798576c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100317111234.d224f3fd.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361003162000w34cc13ecnbd32840a0df80f95@mail.gmail.com>
	<20100317121551.b619f55b.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1003171139280.27268@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 11:41:10 -0500 (CDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Wed, 17 Mar 2010, KAMEZAWA Hiroyuki wrote:
> 
> > Ah, my point is "how use-after-free is detected ?"
> 
> The slab layers do not check for use after free conditions if
> SLAB_DESTROY_BY_RCU is set. It is legal to access the object after a
> kfree() etc as long as the RCU period has not passed.
> 
> > Then, my question is
> > "Does use-after-free check for SLAB_DESTROY_BY_RCU work correctly ?"
> 
> Use after free checks are not performed for SLAB_DESTROY_BY_RCU slabs.
> 
Thank you for kindly clarification. I have no more concerns.

Thanks,
-Kame


