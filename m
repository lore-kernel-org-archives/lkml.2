Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab2INMaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:30:24 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46843 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2INMaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:30:21 -0400
Message-ID: <50532357.50401@gmail.com>
Date: Fri, 14 Sep 2012 20:30:15 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?SkEgTWFnYWxsw7Nu?= <jamagallonn@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question on /proc/cpuinfo
References: <505269D5.30601@gmail.com>
In-Reply-To: <505269D5.30601@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 07:18 AM, JA Magallón wrote:
> Hi...
>
> Probably it is a stupid question, but... I wan to count the number of
> processors, cores and threads on a linux system. I do it by reading
> /proc/cpuinfo.
>
...
>
> Since when is it safe to read things the modern way (kernel version ?).
> Is there a better procedure to get this info ?
>

Probably lscpu(1) is better for you, on my laptop it outputs:

% lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                2
On-line CPU(s) list:   0,1
Thread(s) per core:    1
Core(s) per socket:    2
Socket(s):             1
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 23
Stepping:              10
CPU MHz:               2401.000
BogoMIPS:              4788.03
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              3072K
NUMA node0 CPU(s):     0,1

