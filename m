Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875Ab0EZECA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 00:02:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab0EZEB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 00:01:59 -0400
Message-ID: <4BFC9CCF.6000809@redhat.com>
Date: Wed, 26 May 2010 00:00:15 -0400
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

Blah.  I thought I just did that (and wondered why it was
so easy), and then I saw that the MMOTM git tree is old
and does not have the COMPACTION code :(

On to doing this thing again :/

-- 
All rights reversed
