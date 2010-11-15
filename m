Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab0KOHJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 02:09:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52286 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab0KOHJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 02:09:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: fadvise DONTNEED implementation (or lack thereof)
Cc: kosaki.motohiro@jp.fujitsu.com, Ben Gamari <bgamari.foss@gmail.com>,
        linux-kernel@vger.kernel.org, rsync@lists.samba.org,
        linux-mm@kvack.org, Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <AANLkTim59Qx6TsvXnTBL5Lg6JorbGaqx3KsdBDWO04X9@mail.gmail.com>
References: <20101114140920.E013.A69D9226@jp.fujitsu.com> <AANLkTim59Qx6TsvXnTBL5Lg6JorbGaqx3KsdBDWO04X9@mail.gmail.com>
Message-Id: <20101115160413.BF0F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Nov 2010 16:09:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Because we have an alternative solution already. please try memcgroup :)
> 
> I think memcg could be a solution of them but fundamental solution is
> that we have to cure it in VM itself.
> I feel it's absolutely absurd to enable and use memcg for amending it.
> 
> I wonder what's the problem in Peter's patch 'drop behind'.
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg179576.html
> 
> Could anyone tell me why it can't accept upstream?

I don't know the reason. And this one looks reasonable to me. I'm curious the above 
patch solve rsync issue or not. 
Minchan, have you tested it yourself?


