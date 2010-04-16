Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab0DPQOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:14:14 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:39203 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822Ab0DPQON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:14:13 -0400
Date: Fri, 16 Apr 2010 11:10:01 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/6] change alloc function in alloc_slab_page
In-Reply-To: <s2x84144f021004140523t3092f6cbge410ab4e15afac3e@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1004161109070.7710@router.home>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>  <8b348d9cc1ea4960488b193b7e8378876918c0d4.1271171877.git.minchan.kim@gmail.com>  <20100414091825.0bacfe48.kamezawa.hiroyu@jp.fujitsu.com>
 <s2x84144f021004140523t3092f6cbge410ab4e15afac3e@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010, Pekka Enberg wrote:

> Minchan, care to send a v2 with proper changelog and reviewed-by attributions?

Still wondering what the big deal about alloc_pages_node_exact is. Its not
exact since we can fall back to another node. It is better to clarify the
API for alloc_pages_node and forbid / clarify the use of -1.

