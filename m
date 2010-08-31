Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0HaSTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 14:19:06 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:31401 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754603Ab0HaSTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 14:19:05 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: dZA6WbUVM1nTZdZIEhDt_ro4tRKIKvlIDBt6vmsGdLd_f9o
 BRnKjAL4Y4TWy9jbTP75hQAw5YWPnSP4AyAJY7QYJuAMbnI6qwb7HBFvd6DI
 u6QQWPMQWbQFQ5gv1LpcrcLTJYU.9DD.QXAljcGsUYvtxJ0K8S2q3Z4A34tW
 z3IbkQH.Wt.Z5N8inkOJJg_ucmT.PCI5YhqJfkqqLktYCoi.mAMeVbqhAf7v
 dPTHDPYqKneNkRJRjFhsD1WTSOUCy2vBenX8EVA--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 31 Aug 2010 13:17:44 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/3] mm: page allocator: Update free page counters after
 pages are placed on the free list
In-Reply-To: <1283276257-1793-2-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1008311317160.867@router.home>
References: <1283276257-1793-1-git-send-email-mel@csn.ul.ie> <1283276257-1793-2-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I already did a

Reviewed-by: Christoph Lameter <cl@linux.com>

I believe?


