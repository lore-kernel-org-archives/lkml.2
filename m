Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab0DHRHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:07:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653Ab0DHRHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:07:21 -0400
Date: Thu, 8 Apr 2010 19:06:19 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 08/14] Memory compaction core
Message-ID: <20100408170619.GP5749@random.random>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
 <1270224168-14775-9-git-send-email-mel@csn.ul.ie>
 <20100408165954.GI25756@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408165954.GI25756@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 05:59:54PM +0100, Mel Gorman wrote:
> On Fri, Apr 02, 2010 at 05:02:42PM +0100, Mel Gorman wrote:
> > This patch is the core of a mechanism which compacts memory in a zone by
> > relocating movable pages towards the end of the zone.
> > 
> 
> When merging compaction and transparent huge pages, Andrea spotted and
> fixed this problem in his tree but it should go to mmotm as well.
> 
> Thanks Andrea.

Thanks Mel for submitting this fix!
