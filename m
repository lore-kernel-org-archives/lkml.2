Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab2JWB4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 21:56:36 -0400
Received: from smtp.getmail.no ([84.208.15.66]:61133 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab2JWB4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 21:56:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: linux-kernel@vger.kernel.org
Date: Tue, 23 Oct 2012 01:56:57 +0200
Subject: Jitter
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wmlt47ws6426ze@millennium.getinternet.no>
User-Agent: Opera Mail/12.02 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As those who have seen my posts on LKML, I am all about jitter.
10 years ago I said why not do an OpenGL desktop, and now we have wayland.
10 years ago, I said, don`t do excessive buffering, and now we have  
"fighting bufferbloat".
10 years ago, I talked about how responsive vintage computers was, without  
"OS".

And I have taken that further, and now work with low-jitter for the  
desktop. Low latency all the way, or atleast down to 0.2ms max latency and  
jitter.

In the mean time, the masses are unaware of jitter, unless it is very  
noticable such as recent discussions on "microstutter".
Most still advise to "not turn off services" in windows, yet show me  
benchmarks of "motherboards" with DPC latency of 50-300uS. I am already  
running at 5uS in windows here. And it is not "the motherboard". This is  
about OS-jitter.

And in linux, I am running with even less jitter, now trying rt-patch only  
at "low latency" preemption yet, but still. And even in the linuxcommunity  
many seem not to understand. Those who do are much higher then on windows  
though. And while many also make completely absurd statements and attack  
what I am doing, I am very happily running what feels like a high  
performance computer. With a lot of activity being there on the next  
frame, and ultrasmooth framerates in OpenGL. Indeed optimizing and  
removing jitter, seeing improvements on what goes on, on the highest  
performing bus in the computer, seems to improve general desktop computing.

I think I have tried most things now, and unless you want to wait 10 years  
for people to catch on, you should consider low-jitter aswell.

And I am also interested in any patches that currently are not mainline. -  
Please repost in this thread if you have any. Or any other information, or  
ongoing development. If it is not all in the RT patch, that is.

Peace Be With You.
