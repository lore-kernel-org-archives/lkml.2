Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab1BEM1L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 07:27:11 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:65213 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1BEM1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 07:27:10 -0500
From: "Dr. Martin Rogge" <marogge@onlinehome.de>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: scheduling policy    was: Re: 2.6.37 considered stable?
Date: Sat, 5 Feb 2011 13:27:05 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-ck1; KDE/4.5.5; x86_64; ; )
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
References: <201102042123.28734.marogge@onlinehome.de> <1296887529.27896.14.camel@marge.simson.net>
In-Reply-To: <1296887529.27896.14.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102051327.05398.marogge@onlinehome.de>
X-Provags-ID: V02:K0:lZ+ARAfmpdS0wNVVtEhVNU+g0i/H0uN5Mx/yECKXu+M
 Ve/6tIdN3U2+MI48ZrwiP9HRVBTf6pSbyEeuXMNVZTapF6ANRA
 ji6xnNMzYFiXaApyjZ4VlOrAxC6Jjc9gBIizZbYVxlmHt7Bnr7
 D9oNRNZlxDot7hPnK0qNtnRTB72YNM6HmTs+GUFCoXZS+mpgZ2
 HBjNK+nC4inPf1227zSRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:

>> Gene, have you tried schedtool to set the scheduling policy of the
>> process to SCHED_FIFO or even SCHED_ISO?
> 
> /*
>  * Scheduling policies
>  */
> #define SCHED_NORMAL            0
> #define SCHED_FIFO              1
> #define SCHED_RR                2
> #define SCHED_BATCH             3
> /* SCHED_ISO: reserved but not implemented yet */
> #define SCHED_IDLE

When I mentioned SCHED_ISO I was making the mental note "provided you are 
running a scheduler that supports SCHED_ISO" as I do. 

> You only want to run apps RT if they really really need it though.  In
> many cases, running an app RT will reduce performance, and may well
> increase latencies.  (deterministic != quick like a bunny;)

I agree with that statement, and on all machines I own the video applications 
run under SCHED_NORMAL nice 0. However, on machines where the audio/video 
performance is borderline, it may help to tweak the scheduling policy (save 
buying new hardware).

Regarding "quick like a bunny": depending on the KPI (forgive the corporate 
lingo ;-) you are looking at, it means different things. For me as a desktop 
user, it is determined by the "snappiness" and "smoothness" of the user 
interface and all other applications with direct user interaction. Throughput 
KPIs are less relevant, although still important for foreground applications.

A solution that gives me that, to the extent that compiling large projects in 
the background is unnoticable to the user experience, is superior to others. 
Unfortunately, in my experience, auto-this and auto-that is not always the 
answer.

Anyway, all I wanted to do is to encourage Gene to try something out and see 
if it helps.

Martin

