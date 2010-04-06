Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab0DFPnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:43:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61761 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab0DFPnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CO88mSko+kMT915mLHs/Baq1JN/TAA+CuOk3fxOwNdcOJcLSOtxnFXtOYagzq+GZCs
         HnztcV1VbwG6lwj6UR+gd/V7XK88KGifEy2soF+cmYs8L0SMnfwk/75GLAS7nrVFoH+u
         u8tXSVa1gYMrSAqKInEdfEDHKZghCTwdALV5A=
MIME-Version: 1.0
In-Reply-To: <1270224168-14775-15-git-send-email-mel@csn.ul.ie>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
	 <1270224168-14775-15-git-send-email-mel@csn.ul.ie>
Date: Wed, 7 Apr 2010 00:37:50 +0900
Message-ID: <s2m28c262361004060837za9d8d7deo7eed2ffe720a3f17@mail.gmail.com>
Subject: Re: [PATCH 14/14] mm,migration: Allow the migration of PageSwapCache 
	pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 3, 2010 at 1:02 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> PageAnon pages that are unmapped may or may not have an anon_vma so are
> not currently migrated. However, a swap cache page can be migrated and
> fits this description. This patch identifies page swap caches and allows
> them to be migrated but ensures that no attempt to made to remap the pages
> would would potentially try to access an already freed anon_vma.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Thanks for your effort, Mel.

-- 
Kind regards,
Minchan Kim
