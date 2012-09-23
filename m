Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab2IWLwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 07:52:54 -0400
Received: from ares07.inai.de ([5.9.24.206]:46148 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab2IWLwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 07:52:53 -0400
Date: Sun, 23 Sep 2012 13:52:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
cc: =?UTF-8?Q?JA_Magall=C3=B3n?= <jamagallonn@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question on /proc/cpuinfo
In-Reply-To: <50532357.50401@gmail.com>
Message-ID: <alpine.LNX.2.01.1209231351220.9625@nerf07.vanv.qr>
References: <505269D5.30601@gmail.com> <50532357.50401@gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2012-09-14 14:30, Cong Wang wrote:
> On 09/14/2012 07:18 AM, JA Magallón wrote:
>> Hi...
>>
>> Probably it is a stupid question, but... I wan to count the number of
>> processors, cores and threads on a linux system. I do it by reading
>> /proc/cpuinfo.
>
> Probably lscpu(1) is better for you, on my laptop it outputs:

Programmatically (for scripts), you want to count the number
of /sys/devices/system/cpu/cpu[0-9]*. Grepping around output
meant for humans (cpuinfo, lscpu) is always a bad idea.
