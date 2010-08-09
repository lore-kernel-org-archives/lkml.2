Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0HIUIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:08:39 -0400
Received: from borg.medozas.de ([188.40.89.202]:35783 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526Ab0HIUIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:08:38 -0400
Date: Mon, 9 Aug 2010 22:08:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Patrick McHardy <kaber@trash.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netfilter@vger.kernel.org
Subject: Re: netfilter: add xt_cpu match
In-Reply-To: <AANLkTi=ffogSPifiTg7tofEvbpFcpAsfM_bm2DCASvs1@mail.gmail.com>
Message-ID: <alpine.LSU.2.01.1008092207180.29628@obet.zrqbmnf.qr>
References: <201008042011.o74KBSlB026488@hera.kernel.org> <AANLkTi=ffogSPifiTg7tofEvbpFcpAsfM_bm2DCASvs1@mail.gmail.com>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2010-08-09 21:52, Geert Uytterhoeven wrote:
>>
>> +config NETFILTER_XT_MATCH_CPU
>> +       tristate '"cpu" match support'
>> +       depends on NETFILTER_ADVANCED
>> +       help
>> +         CPU matching allows you to match packets based on the CPU
>> +         currently handling the packet.
>
>Shouldn't this depend on SMP? Or does it make sense to have it on UP, too?

Well one thing to consider is that you certainly would not want to
make one ruleset willingly unloadable on another machine (think
automatic code/rule generators).
