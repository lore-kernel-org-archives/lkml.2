Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab0F2O1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 10:27:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55541 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab0F2O1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 10:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ABz33ObCEsJdkG+TeBTmFPcXY/2BRsJJEFXeSiGYJWG3IFoIfi1Y3XalXSa7jD+IxQ
         ftmccS8AIWZw825FwfbzQoB7a3ZxxZ4Y6naeAYAx26tMlTihbjd8xQA1p8R35qs6+jqY
         2iQwB9s4+2WtMjS4p42qq89P8yERR3hub1PQs=
MIME-Version: 1.0
In-Reply-To: <1277811288-5195-2-git-send-email-mel@csn.ul.ie>
References: <1277811288-5195-1-git-send-email-mel@csn.ul.ie>
	<1277811288-5195-2-git-send-email-mel@csn.ul.ie>
Date: Tue, 29 Jun 2010 23:27:05 +0900
Message-ID: <AANLkTilwzGf2rikXYAe4Evl41lqjk8voVSG4ICfAgUI1@mail.gmail.com>
Subject: Re: [PATCH 01/14] vmscan: Fix mapping use after free
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 8:34 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> From: Nick Piggin <npiggin@suse.de>
>
> Use lock_page_nosync in handle_write_error as after writepage we have no
> reference to the mapping when taking the page lock.
>
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Trivial.
Please modify description of the function if you have a next turn.
"run sleeping lock_page()" -> "run sleeping lock_page_nosync"


-- 
Kind regards,
Minchan Kim
