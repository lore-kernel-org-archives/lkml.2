Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab1C2CzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 22:55:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41691 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1C2CzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 22:55:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: Very aggressive memory reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Chinner <david@fromorbit.com>,
        John Lepikhin <johnlepikhin@gmail.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, linux-mm@kvack.org
In-Reply-To: <BANLkTimHPFMUOCFAruF5J4OMHSkZsMsAgA@mail.gmail.com>
References: <20110328215344.GC3008@dastard> <BANLkTimHPFMUOCFAruF5J4OMHSkZsMsAgA@mail.gmail.com>
Message-Id: <20110329115546.C08C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 29 Mar 2011 11:55:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Recently, We had a similar issue.
> http://www.spinics.net/lists/linux-mm/msg12243.html
> But it seems to not merge. I don't know why since I didn't follow up the thread.
> Maybe Cced guys can help you.
> 
> Is it a sudden big cache drop at the moment or accumulated small cache
> drop for long time?
> What's your zones' size?
> 
> Please attach the result of cat /proc/zoneinfo for others.

If my remember is correct, 2.6.38 is included Mel's anti agressive 
reclaim patch. And original report seems to be using 2.6.37.x. 

John, can you try 2.6.38?



