Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab0LAK3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:29:19 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35342 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab0LAK3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:29:18 -0500
Date: Wed, 1 Dec 2010 11:28:51 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] mm: migration: Cleanup migrate_pages API by matching
 types for offlining and sync
Message-ID: <20101201102851.GN15564@cmpxchg.org>
References: <1290440635-30071-1-git-send-email-mel@csn.ul.ie>
 <1290440635-30071-6-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290440635-30071-6-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 03:43:53PM +0000, Mel Gorman wrote:
> With the introduction of the boolean sync parameter, the API looks a
> little inconsistent as offlining is still an int. Convert offlining to a
> bool for the sake of being tidy.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
