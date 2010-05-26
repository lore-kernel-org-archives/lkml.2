Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0EZFqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 01:46:15 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44650 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0EZFqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 01:46:14 -0400
References: <20100512133815.0d048a86@annuminas.surriel.com> 
	<20100512134029.36c286c4@annuminas.surriel.com> <20100512210216.GP24989@csn.ul.ie> 
	<4BEB18BB.5010803@redhat.com> <20100513095439.GA27949@csn.ul.ie> 
	<20100513103356.25665186@annuminas.surriel.com> <20100513140919.0a037845.akpm@linux-foundation.org> 
	<4BFC9CCF.6000809@redhat.com> <20100525211520.16e3a034.akpm@linux-foundation.org>
From: james toy <nil@0xabadba.be>
In-Reply-To: <20100525211520.16e3a034.akpm@linux-foundation.org>
Mime-Version: 1.0 (iPhone Mail 7E18)
Date: Wed, 26 May 2010 01:46:03 -0400
Message-ID: <2073679454094428814@unknownmsgid>
Subject: Re: [PATCH -v2 4/5] always lock the root (oldest) anon_vma
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, james toy <toyj@union.edu>,
       james toy <mail@wfys.org>, James Toy <0xbaadface@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll get after this asap; sorry.  I'm finishing my last trimester of
my B.S.  I'll send a message when it's back up with the offending patch.

=jt

On May 26, 2010, at 0:15, Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Wed, 26 May 2010 00:00:15 -0400 Rik van Riel <riel@redhat.com>
> wrote:
>
>> On 05/13/2010 05:09 PM, Andrew Morton wrote:
>>
>>> I'm not very confident in merging all these onto the current MM
>>> pile.
>>
>> Blah.  I thought I just did that (and wondered why it was
>> so easy), and then I saw that the MMOTM git tree is old
>> and does not have the COMPACTION code :(
>>
>
> Oh.  James's mmotm->git bot might have broken.
