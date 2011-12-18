Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab1LRWpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 17:45:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62703 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab1LRWpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 17:45:38 -0500
Date: Sun, 18 Dec 2011 14:45:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wang Sheng-Hui <shhuiw@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy.c: use enum value MPOL_REBIND_ONCE instead
 of 0 in mpol_rebind_policy
In-Reply-To: <4EEC9D54.502@gmail.com>
Message-ID: <alpine.DEB.2.00.1112181444530.1364@chino.kir.corp.google.com>
References: <4EE8A461.2080406@gmail.com> <alpine.DEB.2.00.1112141840550.27595@chino.kir.corp.google.com> <4EEC9D54.502@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 17 Dec 2011, Wang Sheng-Hui wrote:

> > Tip: when proposing patches, it's helpful to run scripts/get_maintainer.pl 
> > on your patch file from git to determine who should be cc'd on the email.
> 
> Thanks for your tip.
> I have tried the script with option -f, and only get the mm, kernel mailing
> lists, no specific maintainer provided. So here I just posted the patch to 
> these 2 lists.
> 

$ ./scripts/get_maintainer.pl -f mm/mempolicy.c
Andrew Morton <akpm@linux-foundation.org> (commit_signer:19/23=83%)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> (commit_signer:8/23=35%)
Stephen Wilson <wilsons@start.ca> (commit_signer:6/23=26%)
Andrea Arcangeli <aarcange@redhat.com> (commit_signer:5/23=22%)
Johannes Weiner <hannes@cmpxchg.org> (commit_signer:3/23=13%)
linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
linux-kernel@vger.kernel.org (open list)

All of those people should be cc'd on patches touching mm/mempolicy.c.
