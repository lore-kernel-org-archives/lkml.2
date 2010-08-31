Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0HaS1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 14:27:17 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:41895 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751786Ab0HaS1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 14:27:16 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 1Tq9b2YVM1n7IP2BCKX1eMbi66kQ8WIkGxTPSi5a6Cw1TiV
 ccXpaFaGJHdlbMVkfzJE3WreB7GxKc.Y540EU.fcNUh4FmO78eQzWcDowfk5
 ZLi9eaCnY_X3QnObU0Lu_ZwTDqc5YOoj6FyvAEC9wGX1xo0zv_YH8R76NyBA
 iuQYoIE2xARFBBpNHU4nSCUN0eVtG0CO6vMwrTlp9mClpYynq0Y6MqSZVr4p
 2lhujuCoUbuc3p_mEnYmbJ9CW4TKMFpT.qhY43g--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 31 Aug 2010 13:26:17 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 3/3] mm: page allocator: Drain per-cpu lists after direct
 reclaim allocation fails
In-Reply-To: <1283276257-1793-4-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1008311326050.867@router.home>
References: <1283276257-1793-1-git-send-email-mel@csn.ul.ie> <1283276257-1793-4-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux.com>


