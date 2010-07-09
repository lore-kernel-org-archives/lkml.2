Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0GINzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:55:55 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:51818 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab0GINzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:55:54 -0400
Date: Fri, 9 Jul 2010 08:54:58 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Minchan Kim <minchan.kim@gmail.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 2/2] vmscan: shrink_slab() require number of lru_pages,
  not page order
In-Reply-To: <AANLkTinwZfaQiTJhP8RcGhlSS-ynEXtbpzorrIZrNyIH@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1007090854420.30663@router.home>
References: <20100708163401.CD34.A69D9226@jp.fujitsu.com> <20100708163934.CD37.A69D9226@jp.fujitsu.com> <AANLkTinwZfaQiTJhP8RcGhlSS-ynEXtbpzorrIZrNyIH@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok. I am convinced.

Acked-by: Christoph Lameter <cl@linux-foundation.org>

