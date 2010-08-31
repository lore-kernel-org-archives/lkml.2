Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0HaSVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 14:21:55 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:40194 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754657Ab0HaSVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 14:21:54 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: GnxQt6kVM1kxJadOm1EGfxa6jsW4ge7C8i0wVe55aZH8rPu
 xmGwUyov5LVDxfeiU5.vyEY6NHzFdZpTF5aZyHY8fsADWRYV4luwCl38DaGm
 uMbMdxgZHjlJlsGuiTePEJY11HYAwcfWw_t9Px7IZnsjS1ADqXU4zGHTpjDB
 ZIMu0X2NGovpDMXOG8O8TKg7SSH7.4lXG.7WR7gzmbk_pbFzlMF83vlfDs.r
 VPN0i.Ey32cCcqhawxl.HH9dfhBzbtm8U7i0GOw8HOVQDloaJiUZIAx7BsfF
 7_dzq8A--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 31 Aug 2010 13:20:45 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of
 NR_FREE_PAGES when memory is low and kswapd is awake
In-Reply-To: <1283276257-1793-3-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1008311320340.867@router.home>
References: <1283276257-1793-1-git-send-email-mel@csn.ul.ie> <1283276257-1793-3-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux.com>


