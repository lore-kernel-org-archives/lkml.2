Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab1CVUzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:55:38 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:43413 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab1CVUzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:55:35 -0400
X-ASG-Debug-ID: 1300827333-01de284cf8a7630001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D890CC1.7070602@fusionio.com>
Date: Tue, 22 Mar 2011 21:55:29 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Lina Lu <lulina_nuaa@foxmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-throttle: Reset group slice when limits are changed
References: <20110315175456.GC2587@redhat.com> <20110322203319.GL3757@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] blk-throttle: Reset group slice when limits are changed
In-Reply-To: <20110322203319.GL3757@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1300827333
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58670
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-22 21:33, Vivek Goyal wrote:
> On Tue, Mar 15, 2011 at 01:54:56PM -0400, Vivek Goyal wrote:
>> Lina reported that if throttle limits are initially very high and then
>> dropped, then no new bio might be dispatched for a long time. And the
>> reason being that after dropping the limits we don't reset the existing
>> slice and do the rate calculation with new low rate and account the bios
>> dispatched at high rate. To fix it, reset the slice upon rate change.
> 
> Hi Jens,
> 
> Can you please apply this patch too.

Yep, applied. Thanks for the reminder :-)

-- 
Jens Axboe

