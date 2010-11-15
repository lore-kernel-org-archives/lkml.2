Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0KOJKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:10:55 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58627 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0KOJKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:10:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: fadvise DONTNEED implementation (or lack thereof)
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
        Ben Gamari <bgamari.foss@gmail.com>, linux-kernel@vger.kernel.org,
        rsync@lists.samba.org, linux-mm@kvack.org,
        Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <1289810825.2109.469.camel@laptop>
References: <AANLkTim59Qx6TsvXnTBL5Lg6JorbGaqx3KsdBDWO04X9@mail.gmail.com> <1289810825.2109.469.camel@laptop>
Message-Id: <20101115180153.BF18.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Nov 2010 18:10:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I wonder what's the problem in Peter's patch 'drop behind'.
> > http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg179576.html
> > 
> > Could anyone tell me why it can't accept upstream?
> 
> Read the thread, its quite clear nobody got convinced it was a good idea
> and wanted to fix the use-once policy, then Rik rewrote all of
> page-reclaim.

If my understand is correct, rsync touch data twice (for a hash calculation
and for a copy). then, currect used-once-heuristics seems still doesn't work.





