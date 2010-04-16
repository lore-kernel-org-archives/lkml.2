Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab0DPQOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:14:35 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:39353 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758539Ab0DPQOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:14:32 -0400
Date: Fri, 16 Apr 2010 11:13:10 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andrea Arcangeli <aarcange@redhat.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Interleave policy on 2M pages (was Re: [RFC][BUGFIX][PATCH 1/2]
 memcg: fix charge bypass route of migration)
In-Reply-To: <20100415081743.GP32034@random.random>
Message-ID: <alpine.DEB.2.00.1004161111380.7710@router.home>
References: <20100413134207.f12cdc9c.nishimura@mxp.nes.nec.co.jp> <20100415120516.3891ce46.kamezawa.hiroyu@jp.fujitsu.com> <20100415154324.834dace9.nishimura@mxp.nes.nec.co.jp> <20100415155611.da707913.kamezawa.hiroyu@jp.fujitsu.com>
 <20100415081743.GP32034@random.random>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010, Andrea Arcangeli wrote:

> 2) add alloc_pages_vma for numa awareness in the huge page faults

How do interleave policies work with alloc_pages_vma? So far the semantics
is to spread 4k pages over different nodes. With 2M pages this can no
longer work the way is was.

