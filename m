Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab0HFId3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 04:33:29 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50979 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab0HFId1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 04:33:27 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Fri, 06 Aug 2010 10:34:57 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 3/3] lib: vsprintf: added a put_dec() test and benchmark
 tool
In-reply-to: <201008060710.06304.vda.linux@googlemail.com>
To: Michal Nazarewicz <mina86@mina86.com>,
        Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Message-id: <op.vg0csju97p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com>
 <0543dae0f66ba8e0ce42ce3adf1fe31704eb240d.1280872240.git.mina86@mina86.com>
 <b3cd8c92d68f3ca7104be13841f1f66f7db9f7e1.1280872240.git.mina86@mina86.com>
 <201008060710.06304.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Aug 2010 07:10:06 +0200, Denys Vlasenko <vda.linux@googlemail.com> wrote:

> On Friday 06 August 2010 00:38, Michal Nazarewicz wrote:
>> This commit adds a test application for the put_dec() and
>> family of functions that are used by the previous two commits.
>>
>> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
>
>> +put-dec-test: put-dec-test.c
>> +	exec $(CC) $(CFLAGS) -o $@ $<
>
> (1) Why exec?

Micro Makefile optimisation -- saves us a fork().

I'll try to fix the benchmark over the weekend and will post updated
version.  Thanks for the comments.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
