Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab0CSGVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 02:21:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39482 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab0CSGVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 02:21:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped anonymous pages
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100318111436.GK12388@csn.ul.ie>
References: <20100318094720.872F.A69D9226@jp.fujitsu.com> <20100318111436.GK12388@csn.ul.ie>
Message-Id: <20100319152103.876F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 19 Mar 2010 15:21:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > then, this logic depend on SLAB_DESTROY_BY_RCU, not refcount.
> > So, I think we don't need your [1/11] patch.
> > 
> > Am I missing something?
> > 
> 
> The refcount is still needed. The anon_vma might be valid, but the
> refcount is what ensures that the anon_vma is not freed and reused.

please please why do we need both mechanism. now cristoph is very busy and I am
de fact reviewer of page migration and mempolicy code. I really hope to understand
your patch.



