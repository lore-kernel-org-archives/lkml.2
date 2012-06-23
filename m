Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab2FWC7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 22:59:14 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57728 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2FWC7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 22:59:13 -0400
Message-ID: <4FE530F7.1060108@gmail.com>
Date: Fri, 22 Jun 2012 22:59:03 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: undisclosed-recipients:";
	Kamezawa Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Aaditya Kumar <aaditya.kumar.30@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	undisclosed-recipients:;Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
						^-missing end of address
Subject: Re: Accounting problem of MIGRATE_ISOLATED freed page
References: <4FE169B1.7020600@kernel.org> <4FE16E80.9000306@gmail.com> <4FE18187.3050103@kernel.org> <4FE23069.5030702@gmail.com> <4FE26470.90401@kernel.org> <CAHGf_=pjoiHQ9vxXXe-GtbkYRzhxdDhu3pf6pwDsCe5pBQE8Nw@mail.gmail.com> <4FE27F15.8050102@kernel.org> <CAHGf_=pDw4axwG2tQ+B5hPks-sz2S5+G1Kk-=HSDmo=DSXOkEw@mail.gmail.com> <4FE2A937.6040701@kernel.org> <4FE2FCFB.4040808@jp.fujitsu.com> <4FE3C4E4.2050107@kernel.org> <4FE414A2.3000700@kernel.org>
In-Reply-To: <4FE414A2.3000700@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One more.


> +/*
> + * NOTE:
> + * Don't use set_pageblock_migratetype(page, MIGRATE_ISOLATE) direclty.
> + * Instead, use {un}set_pageblock_isolate.
> + */
>  void set_pageblock_migratetype(struct page *page, int migratetype)
>  {
>         if (unlikely(page_group_by_mobility_disabled))

I don't think we need this comment. please just add BUG_ON.

