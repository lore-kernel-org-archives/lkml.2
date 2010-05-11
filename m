Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab0EKP5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:57:17 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40434 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab0EKP5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:57:13 -0400
Date: Tue, 11 May 2010 10:56:00 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm,migration: Avoid race between shift_arg_pages()
 and rmap_walk() during migration by not migrating temporary stacks
In-Reply-To: <20100511151142.GS26611@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1005111055070.1500@router.home>
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie> <1272529930-29505-3-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1005012055010.2663@router.home> <20100504094522.GA20979@csn.ul.ie> <alpine.DEB.2.00.1005101239400.13652@router.home>
 <20100510175654.GL26611@csn.ul.ie> <alpine.DEB.2.00.1005110857350.1500@router.home> <20100511151142.GS26611@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010, Mel Gorman wrote:

> Or just identify the temporary stack from the migration side instead of
> adding to the cost of exec?

Adding one off checks to a generic mechanism isnt really clean
programming. Using the provided means of disabling a generic mechanism is.

