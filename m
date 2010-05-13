Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab0EMWwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:52:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab0EMWwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:52:15 -0400
Message-ID: <4BEC8235.4060509@redhat.com>
Date: Thu, 13 May 2010 18:50:29 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH -v2 4/5] always lock the root (oldest) anon_vma
References: <20100512133815.0d048a86@annuminas.surriel.com>	<20100512134029.36c286c4@annuminas.surriel.com>	<20100512210216.GP24989@csn.ul.ie>	<4BEB18BB.5010803@redhat.com>	<20100513095439.GA27949@csn.ul.ie>	<20100513103356.25665186@annuminas.surriel.com> <20100513140919.0a037845.akpm@linux-foundation.org>
In-Reply-To: <20100513140919.0a037845.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 05:09 PM, Andrew Morton wrote:

> I'm not very confident in merging all these onto the current MM pile.

My apologies, I built them onto Linus's latest git
tree (where I know I did get all the anon_vma->lock
instances).

Andrew, Mel, want me to make a version of this series
against -mmotm, or does the migrate & compaction code
need to be modified in some non-obvious way that would
require Mel to create a new compaction series on top
of these anon_vma patches?

-- 
All rights reversed
