Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab0CSGVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 02:21:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50009 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab0CSGV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 02:21:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 04/11] Allow CONFIG_MIGRATION to be set without CONFIG_NUMA or memory hot-remove
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20100318112414.GL12388@csn.ul.ie>
References: <20100318085226.8726.A69D9226@jp.fujitsu.com> <20100318112414.GL12388@csn.ul.ie>
Message-Id: <20100319152106.8775.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 19 Mar 2010 15:21:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Mar 18, 2010 at 08:56:23AM +0900, KOSAKI Motohiro wrote:
> > > On Wed, 17 Mar 2010, Mel Gorman wrote:
> > > 
> > > > > If select MIGRATION works, we can remove "depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE"
> > > > > line from config MIGRATION.
> > > > >
> > > >
> > > > I'm not quite getting why this would be an advantage. COMPACTION
> > > > requires MIGRATION but conceivable both NUMA and HOTREMOVE can work
> > > > without it.
> > > 
> > > Avoids having to add additional CONFIG_XXX on the page migration "depends"
> > > line in the future.
> > 
> > Yes, Kconfig mess freqently shot ourself in past days. if we have a chance
> > to remove unnecessary dependency, we should do. that's my intention of the last mail.
> > 
> 
> But if the depends line is removed, it could be set without NUMA, memory
> hot-remove or compaction enabled. That wouldn't be very useful. I'm
> missing something obvious.

Perhaps I'm missing something. 

my point is, force enabling useless config is not good idea (yes, i agree). but config 
selectability doesn't cause any failure. IOW, usefulness and dependency aren't 
related so much. personally I dislike _unnecessary_ dependency.

If my opinion cause any bad thing, I'll withdraw it. of course.



