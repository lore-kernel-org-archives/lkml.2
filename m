Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab2F1A6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 20:58:39 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58154 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab2F1A6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 20:58:37 -0400
X-AuditID: 9c93016f-b7cc1ae00000555f-96-4febac35ce5c
Message-ID: <4FEBAC42.3030800@kernel.org>
Date: Thu, 28 Jun 2012 09:58:42 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel,gmane.comp.file-systems.ceph.devel
To: David Rientjes <rientjes@google.com>
CC: Rik van Riel <riel@redhat.com>, Jim Schutt <jaschut@sandia.gov>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: excessive CPU utilization by isolate_freepages?
References: <4FEB8237.6030402@sandia.gov> <4FEB9E73.5040709@kernel.org> <4FEBA520.4030205@redhat.com> <alpine.DEB.2.00.1206271745170.9552@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206271745170.9552@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 09:52 AM, David Rientjes wrote:

> On Wed, 27 Jun 2012, Rik van Riel wrote:
> 
>>> > > I doubt compaction try to migrate continuously although we have no free
>>> > > memory.
>>> > > Could you apply this patch and retest?
>>> > > 
>>> > > https://lkml.org/lkml/2012/6/21/30
>> > 
> Not sure if Jim is using memcg; if not, then this won't be helpful.
> 


It doesn't related to memcg.
if compaction_alloc can't find suitable migration target, it returns NULL.
Then, migrate_pages should be exit.

-- 
Kind regards,
Minchan Kim
