Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2JBKHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 06:07:54 -0400
Received: from smtp.getmail.no ([84.208.15.66]:62107 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab2JBKHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 06:07:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: Mike Galbraith <efault@gmx.de>
Subject: Re: The 10ms averager in fair.c
References: <op.wlf5j0i76426ze@localhost.localdomain>
 <1349064397.6957.26.camel@marge.simpson.net>
 <op.wljhky1q6426ze@millennium.getinternet.no>
 <1349169555.7086.48.camel@marge.simpson.net>
Date: Tue, 02 Oct 2012 10:07:53 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wljkvfkq6426ze@millennium.getinternet.no>
In-reply-to: <1349169555.7086.48.camel@marge.simpson.net>
User-Agent: Opera Mail/12.02 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2012 11:19:15 +0200, Mike Galbraith <efault@gmx.de> wrote:

> On Tue, 2012-10-02 at 08:56 +0200, Uwaysi Bin Kareem wrote:
>
>> What you can do for the time being is just set it to 1nS. If that  
>> doesn`t
>> negatively impact anything, then you know it is bogus.
>
> I already know that there is negative impact.
>
> -Mike
>

You already know? Then please elaborate, what a 10ms smoother is doing in  
a nanosecond resolution scheduler.

Superficially there is no negative impact with Renoise, doom 3, chromium,  
on a shaved+low/latency/low jitter kernel, core 2 duo desktop. Chromium  
actually got faster. Well it felt faster, and that is what I care about.  
You can probably config differently and get more throughput for servers,  
but that does not equate to throughput when talking about displayed frames  
on screen. So please elaborate what you mean by negative impact.

Peace Be With You.
