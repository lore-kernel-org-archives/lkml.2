Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab2FNPVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:21:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63287 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2FNPVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:21:07 -0400
MIME-Version: 1.0
In-Reply-To: <4fd9db8d.c4e2440a.6bf6.4a46@mx.google.com>
References: <4fd9db8d.c4e2440a.6bf6.4a46@mx.google.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 14 Jun 2012 11:20:45 -0400
Message-ID: <CAHGf_=oUYKaGfYHzpZdTwxSPKLPa46gB7bVZR+R0JogofrPWZw@mail.gmail.com>
Subject: Re: [PATCH] mm: fix page reclaim comment error
To: "[A" <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 8:38 AM, [A <liwp.linux@gmail.com> wrote:
> From: Wanpeng Li <liwp.linux@gmail.com>
>
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>
> Since there are five lists in LRU cache, the array nr in get_scan_count
> should be:
>
> nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
> nr[2] = file inactive pages to scan; nr[3] = file active pages to scan
>
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
