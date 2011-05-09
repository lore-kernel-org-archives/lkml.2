Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab1EIJTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 05:19:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49358 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab1EIJTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 05:19:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: CAI Qian <caiqian@redhat.com>
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in all_unreclaimable()
Cc: kosaki.motohiro@jp.fujitsu.com, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <1491537913.283996.1304930866703.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
References: <20110509155612.1648.A69D9226@jp.fujitsu.com> <1491537913.283996.1304930866703.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Message-Id: <20110509182110.167F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  9 May 2011 18:19:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I have tested this for the latest mainline kernel using the
> > > reproducer
> > > attached, the system just hung or deadlock after oom. The whole oom
> > > trace is here.
> > > http://people.redhat.com/qcai/oom.log
> > >
> > > Did I miss anything?
> > 
> > Can you please try commit 929bea7c714220fc76ce3f75bef9056477c28e74?
> As I have mentioned that I have tested the latest mainline which have
> already included that fix. Also, does this problem only for x86? The
> testing was done using x86_64. Not sure if that would be a problem.

No. I'm also using x86_64 and my machine completely works on current
latest linus tree. I confirmed it today.




