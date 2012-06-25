Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab2FYESW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 00:18:22 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49526 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2FYESV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 00:18:21 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-96-4fe7e68af8f1
To: undisclosed-recipients:;
Message-ID: <4FE7E68A.6080200@kernel.org>
Date: Mon, 25 Jun 2012 13:18:18 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        undisclosed-recipients:";
	KOSAKI Motohiro" <kosaki.motohiro@gmail.com>,
        Aaditya Kumar <aaditya.kumar.30@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	undisclosed-recipients:;KOSAKI Motohiro <kosaki.motohiro@gmail.com>
						^-missing end of address
Subject: Re: Accounting problem of MIGRATE_ISOLATED freed page
References: <4FE169B1.7020600@kernel.org> <4FE16E80.9000306@gmail.com> <4FE18187.3050103@kernel.org> <4FE23069.5030702@gmail.com> <4FE26470.90401@kernel.org> <CAHGf_=pjoiHQ9vxXXe-GtbkYRzhxdDhu3pf6pwDsCe5pBQE8Nw@mail.gmail.com> <4FE27F15.8050102@kernel.org> <CAHGf_=pDw4axwG2tQ+B5hPks-sz2S5+G1Kk-=HSDmo=DSXOkEw@mail.gmail.com> <4FE2A937.6040701@kernel.org> <4FE2FCFB.4040808@jp.fujitsu.com> <4FE3C4E4.2050107@kernel.org> <4FE414A2.3000700@kernel.org> <4FE5482C.3010501@jp.fujitsu.com> <4FE7B861.6020906@kernel.org>
In-Reply-To: <4FE7B861.6020906@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 10:01 AM, Minchan Kim wrote:

<snip>



>> I'm glad if this function can be static...Hm. With easy grep, I think it
>> can be...
> 
> 
> Yes. :)
> 

 
Unfortunately, It seems we are too late.
http://lkml.org/lkml/2012/6/14/361

Akpm doesn't accept above patch at the moment but will do sooner or later.

-- 
Kind regards,
Minchan Kim
