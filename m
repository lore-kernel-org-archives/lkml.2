Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2JBRZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:25:30 -0400
Received: from smtp.getmail.no ([84.208.15.66]:34599 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab2JBRZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:25:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
In-reply-to: <1349146202.7086.23.camel@marge.simpson.net>
References: <op.wlf5j0i76426ze@localhost.localdomain>
 <1349064397.6957.26.camel@marge.simpson.net>
 <op.wlh4u2xj6426ze@millennium.getinternet.no>
 <1349146202.7086.23.camel@marge.simpson.net>
Subject: Re: The 10ms averager in fair.c + granularity
To: linux-kernel@vger.kernel.org
Date: Tue, 02 Oct 2012 19:25:26 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wlkaootc6426ze@localhost.localdomain>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 10 ms averager is not the only strange thing. Obviously there are some  
good things in this scheduler, since it performs quite well. But I am not  
criticising the good.

But the documentation makes a distinction between desktop and server with  
the "resolution" parameter.
I tried some values and "echo 4500000000 > sched_min_granularity_ns" which  
would be strongly tuned towards server, only reduced jitter in doom 3.  
Which means it is a good value for desktop.

So that doesn`t seem to cohere with what is stated aswell. Anyway.. One  
needs to get really deep into the code to understand why it is so. So you  
know, I don know. I am going to take a look at it, and there probably  
won`t be any patch anytime soon.

Peace Be With You.
