Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab0CQQjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:39:14 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46207 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab0CQQjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:39:12 -0400
Date: Wed, 17 Mar 2010 11:37:20 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 04/11] Allow CONFIG_MIGRATION to be set without CONFIG_NUMA
 or memory hot-remove
In-Reply-To: <20100317113205.GC12388@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1003171135390.27268@router.home>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie> <1268412087-13536-5-git-send-email-mel@csn.ul.ie> <20100317110748.4C94.A69D9226@jp.fujitsu.com> <20100317113205.GC12388@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010, Mel Gorman wrote:

> > If select MIGRATION works, we can remove "depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE"
> > line from config MIGRATION.
> >
>
> I'm not quite getting why this would be an advantage. COMPACTION
> requires MIGRATION but conceivable both NUMA and HOTREMOVE can work
> without it.

Avoids having to add additional CONFIG_XXX on the page migration "depends"
line in the future.

