Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab2EUUU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:20:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53572 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab2EUUU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:20:57 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: a3at.mail@gmail.com
In-Reply-To: <CAAW1UO_8N-10gLzKp4gV-P3JGOsk-_QnZiedWjhw3rWe33fKjQ@mail.gmail.com>
References: <CAAW1UO_8N-10gLzKp4gV-P3JGOsk-_QnZiedWjhw3rWe33fKjQ@mail.gmail.com>
Date: Tue, 22 May 2012 00:20:56 +0400
X-Google-Sender-Auth: wFZsmSaMgjwok9vXMk3mWyLf038
Message-ID: <CAAW1UO_8orU0eUuRy7pBpZAL5GKKvoDmZYAat6m5kOyRhqU5_A@mail.gmail.com>
Subject: Re: wrong count of CPU usage
From: Azat Khuzhin <dohardgopro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anybody?

BTW I restart server and CPU usage counting fine now, as I expected
But maybe this is a bug in kernel, that after a while it count CPU usage wrong?

On Wed, May 16, 2012 at 6:33 PM, Azat Khuzhin <dohardgopro@gmail.com> wrote:
> Hi all
>
> I have machine that have uptime 212 days, kernel version: Linux
> 2.6.35.14-97.fc14.x86_64 #1 SMP Sat Sep 17 00:15:37 UTC 2011 x86_64
> x86_64 x86_64 GNU/Linux
> Before top (1) utility shows some activity per process, as it should
> be (sort by %CPU column)
>
> But from some time, no activity in top (1) per process at all
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>     1 root      20   0 19420 1548 1240 S  0.0  0.0  17:48.09 init
>     2 root      20   0     0    0    0 S  0.0  0.0   0:09.72 kthreadd
>     3 root      20   0     0    0    0 S  0.0  0.0  20:34.76 ksoftirqd/0
>
> But load avg > 10
> top (1) shows some activity on cores (I mean not processes, that
> created by kernel)
> top - 09:58:26 up 212 days,  7:06,  8 users,  load average: 13.27, 12.20, 11.37
> Tasks: 815 total,   9 running, 803 sleeping,   2 stopped,   1 zombie
> Cpu0  : 47.5%us,  8.0%sy,  0.3%ni, 26.4%id, 16.9%wa,  0.0%hi,  0.9%si,  0.0%st
> Cpu1  : 39.7%us,  5.2%sy,  0.0%ni, 48.0%id,  6.8%wa,  0.0%hi,  0.3%si,  0.0%st
> Cpu2  : 29.8%us,  3.1%sy,  0.0%ni, 59.7%id,  7.4%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu3  : 15.9%us,  2.8%sy,  0.0%ni, 77.3%id,  3.7%wa,  0.0%hi,  0.3%si,  0.0%st
> Cpu4  : 39.3%us,  5.2%sy,  0.0%ni, 37.4%id, 17.8%wa,  0.0%hi,  0.3%si,  0.0%st
> Cpu5  : 29.6%us,  4.0%sy,  0.0%ni, 62.3%id,  3.7%wa,  0.0%hi,  0.3%si,  0.0%st
> Cpu6  : 20.4%us,  5.0%sy,  0.0%ni, 74.3%id,  0.0%wa,  0.0%hi,  0.3%si,  0.0%st
> Cpu7  : 17.3%us,  2.8%sy,  0.0%ni, 76.8%id,  3.1%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu8  : 32.8%us,  6.5%sy,  0.0%ni, 31.6%id, 29.1%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu9  : 27.6%us,  3.1%sy,  0.0%ni, 69.3%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu10 :  6.8%us,  2.5%sy,  0.0%ni, 87.9%id,  2.8%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu11 :  8.7%us,  1.9%sy,  0.0%ni, 89.4%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu12 : 27.3%us,  2.8%sy,  0.0%ni, 52.8%id, 17.1%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu13 : 18.2%us,  3.7%sy,  0.0%ni, 77.5%id,  0.6%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu14 : 21.4%us,  3.8%sy,  0.0%ni, 74.8%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
> Cpu15 : 10.0%us,  1.9%sy,  0.0%ni, 87.9%id,  0.3%wa,  0.0%hi,  0.0%si,  0.0%st
>
> So seems like after some time kernel not updating /proc/PID/stat properly
>
> I wrote shell script (attach), that count CPU usage, and it also shows 0
> This script base on 14, 15 columns from /proc/PID/stat (as man proc
> says, that it utime and stime clocks, and /proc/stat summary), but for
> newly created processes
>
> Summarize
> /proc/PID/stat seems not change counters utime, stime
> /proc/stat updated
>
> --
> Azat Khuzhin



-- 
Azat Khuzhin
