Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab1GBBRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 21:17:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42689 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1GBBR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 21:17:29 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTin4P7X0gbbShNTQNpV0khq3Bb9PhQ@mail.gmail.com>
References: <BANLkTin4P7X0gbbShNTQNpV0khq3Bb9PhQ@mail.gmail.com>
From: =?UTF-8?B?5L+e6aKQ6LaF?= <yyc1992@gmail.com>
Date: Fri, 1 Jul 2011 21:17:08 -0400
Message-ID: <BANLkTimgadBqULuQXVdr-=e792b6RZLQSg@mail.gmail.com>
Subject: Re: mistake about the cpufreq?
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 4:00 PM, 俞颐超 <yyc1992@gmail.com> wrote:
> The following is what I get when I run the command in
> /sys/devices/system/cpu/cpu0/cpufreq
>
> $ sudo grep "" *
> affected_cpus:0
> bios_limit:800000
> cpuinfo_cur_freq:2800000
> cpuinfo_max_freq:2801000
> cpuinfo_min_freq:800000
> cpuinfo_transition_latency:10000
> related_cpus:0 1
> scaling_available_frequencies:2801000 2800000 2133000 1600000 800000
> scaling_available_governors:conservative ondemand userspace powersave
> performance
> scaling_cur_freq:800000
> scaling_driver:acpi-cpufreq
> scaling_governor:performance
> scaling_max_freq:800000
> scaling_min_freq:800000
> scaling_setspeed:<unsupported>
>
> The problem is basically the scalings is different from cpuinfos. It
> appears when I unplug the power and still there when I have repluged
> the power.
> Does any know what probably the problem is and where can I look for
> more detail information.
>
> some basic info about my computer
>
> $ uname -a
> Linux yuyichao-PC 2.6.39-ARCH #1 SMP PREEMPT Mon Jun 27 21:26:22 CEST
> 2011 x86_64 Intel(R) Core(TM)2 Duo CPU T9600 @ 2.80GHz GenuineIntel
> GNU/Linux
> (The kernel version should be 2.6.39.2)
>
>
> Thanks.
>
> Yichao
>

So after reading the files in cpu-freq/, I saw it was mentioned in
user-guide.txt that the scaling_ ones is what the kernel thinks the
freq is and cpuinfo is the actual freq.
y can these two be different?
