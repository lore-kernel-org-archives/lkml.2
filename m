Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0DRStv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 14:49:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33635 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0DRStt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 14:49:49 -0400
Message-ID: <4BCB5448.3010209@cs.helsinki.fi>
Date: Sun, 18 Apr 2010 21:49:44 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/6] change alloc function in alloc_slab_page
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>  <8b348d9cc1ea4960488b193b7e8378876918c0d4.1271171877.git.minchan.kim@gmail.com>  <20100414091825.0bacfe48.kamezawa.hiroyu@jp.fujitsu.com> <s2x84144f021004140523t3092f6cbge410ab4e15afac3e@mail.gmail.com> <alpine.DEB.2.00.1004161109070.7710@router.home>
In-Reply-To: <alpine.DEB.2.00.1004161109070.7710@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 14 Apr 2010, Pekka Enberg wrote:
> 
>> Minchan, care to send a v2 with proper changelog and reviewed-by attributions?
> 
> Still wondering what the big deal about alloc_pages_node_exact is. Its not
> exact since we can fall back to another node. It is better to clarify the
> API for alloc_pages_node and forbid / clarify the use of -1.

Minchan's patch is a continuation of this patch:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commit;h=6484eb3e2a81807722
