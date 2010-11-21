Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0KUOiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 09:38:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45736 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0KUOiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 09:38:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LTg2bcYsj2UU6Le1zPteBJGpvQHMVLWw/3IvgW/iErCN0QFZN58bc7wE2Dj8Z4CMJU
         rR4UaDm2mxNTEC9e5FdxkC5DNXaTENybM+S41eeolWPGoTm0l20zpOj9r2lKtO6onPDH
         UbC8nkBg8lGz89D8s6EgA2+lWEdx16b+EnLB4=
Date: Sun, 21 Nov 2010 23:38:12 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [RFC 2/2] Prevent promotion of page in madvise_dontneed
Message-ID: <20101121143812.GA13857@barrios-desktop>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com>
 <5d205f8a4df078b0da3681063bbf37382b02dd23.1290349672.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d205f8a4df078b0da3681063bbf37382b02dd23.1290349672.git.minchan.kim@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 11:30:24PM +0900, Minchan Kim wrote:
> If the page is sharred by other processes and it's real working set

Please ignore this last sentense. It's my mistake. I will fix it v2 after
some review. 

-- 
Kind regards,
Minchan Kim
