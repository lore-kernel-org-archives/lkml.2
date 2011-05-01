Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1EAH1c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 03:27:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42478 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1EAH1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 03:27:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC 2/8] compaction: make isolate_lru_page with filter aware
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <BANLkTina+YuDgACZfDV8T_Lnipo50J6zVA@mail.gmail.com>
References: <20110428084820.GH12437@cmpxchg.org> <BANLkTina+YuDgACZfDV8T_Lnipo50J6zVA@mail.gmail.com>
Message-Id: <20110501162857.75DC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Sun,  1 May 2011 16:27:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > With the suggested flags argument from 1/8, this would look like:
> >
> >        flags = ISOLATE_BOTH;
> >        if (!cc->sync)
> >                flags |= ISOLATE_CLEAN;
> >
> > ?
> 
> Yes. I will change it.
> 
> >
> > Anyway, nice change indeed!
> 
> Thanks!

Yeah. That's very nice.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



