Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab1CGI0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:26:54 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:34737 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab1CGI0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:26:50 -0500
X-ASG-Debug-ID: 1299486409-03d6a54f6315a70001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D7496C5.6010900@fusionio.com>
Date: Mon, 7 Mar 2011 09:26:45 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH]cfq-iosched: give busy sync queue no dispatch limit
References: <1299225689.2337.4.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [PATCH]cfq-iosched: give busy sync queue no dispatch limit
In-Reply-To: <1299225689.2337.4.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299486409
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57296
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-04 09:01, Shaohua Li wrote:
> If there are a sync and an async queue and the sync queue's think time is small,
> we can ignore the sync queue's dispatch quantum. Because the sync queue will
> always preempt the async queue, we don't need to care about async's latency.
> This can fix a performance regression of aiostress test, which is introduced by
> commit f8ae6e3eb825. The issue should exist even without the commit, but the
> commit amplifies the impact.
> 
> The initial post does the same optimization for RT queue too, but since I have
> no real workload for it, Vivek suggests to drop it.

Thanks, applied.

-- 
Jens Axboe

