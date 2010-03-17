Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab0CQX4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 19:56:31 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47706 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab0CQX4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 19:56:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 04/11] Allow CONFIG_MIGRATION to be set without CONFIG_NUMA or memory hot-remove
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1003171135390.27268@router.home>
References: <20100317113205.GC12388@csn.ul.ie> <alpine.DEB.2.00.1003171135390.27268@router.home>
Message-Id: <20100318085226.8726.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 18 Mar 2010 08:56:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 17 Mar 2010, Mel Gorman wrote:
> 
> > > If select MIGRATION works, we can remove "depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE"
> > > line from config MIGRATION.
> > >
> >
> > I'm not quite getting why this would be an advantage. COMPACTION
> > requires MIGRATION but conceivable both NUMA and HOTREMOVE can work
> > without it.
> 
> Avoids having to add additional CONFIG_XXX on the page migration "depends"
> line in the future.

Yes, Kconfig mess freqently shot ourself in past days. if we have a chance
to remove unnecessary dependency, we should do. that's my intention of the last mail.



