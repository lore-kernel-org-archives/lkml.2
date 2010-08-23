Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab0HWRGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:06:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49048 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab0HWRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:06:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NEWnCzb6zA/qE8agHlpMCP+poqRUz56OCqk7C41c1T8xd9qt2oG+pOMbxZ9WZsd/av
         yzgHVhRrJUH9OL7IvjMrlehHjm+PmJFdK9iCzXNhhhzS3FZROoe3V6XOIUqnYQZkQWtC
         3SOYd2puRoo3U4iH5RcFF4LXK75A/DLFlvdkQ=
Date: Tue, 24 Aug 2010 02:06:10 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] compaction: fix COMPACTPAGEFAILED counting
Message-ID: <20100823170610.GB2304@barrios-desktop>
References: <1282580114-2136-1-git-send-email-minchan.kim@gmail.com>
 <alpine.DEB.2.00.1008231140320.9496@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008231140320.9496@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 11:41:49AM -0500, Christoph Lameter wrote:
> On Tue, 24 Aug 2010, Minchan Kim wrote
> 
> > This patch introude new argument 'cleanup' to migrate_pages.
> > Only if we set 1 to 'cleanup', migrate_page will clean up the lists.
> > Otherwise, caller need to clean up the lists so it has a chance to postprocess
> > the pages.
> 
> Could we simply make migrate_pages simply not do any cleanup?
> Caller has to call putback_lru_pages()?
> 
Hmm. maybe I misunderstood your point. 
Your point is that let's make whole caller of migrate_pagse has a responsibility
of clean up the list?

-- 
Kind regards,
Minchan Kim
