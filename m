Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1H3SH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:07:56 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42363 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab1H3SHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:07:54 -0400
MIME-Version: 1.0
In-Reply-To: <4E5C8EA3.7060304@gmail.com>
References: <CACk0-C9jZatg+v=7DPJtkp3G1k_eiZbwSPDAgqabMyedmKd9YA@mail.gmail.com>
 <4E5C8EA3.7060304@gmail.com>
From: Vishnupradeep <intermedia.vishnu@gmail.com>
Date: Tue, 30 Aug 2011 23:37:33 +0530
Message-ID: <CACk0-C8E2uaB-Ben5K0e7dzC9RC_WDoXx8mV4B-PN4LPYGs92g@mail.gmail.com>
Subject: Re: linux-3.0.4 compile error on file arch/x86/include/asm/unistd_64.h
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, i am sure. I just downloaded from kernel.org and ran "make"


On Tue, Aug 30, 2011 at 12:47 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 08/30/2011 08:07 AM, Vishnupradeep wrote:
>> CC      net/ipv4/ip_forward.o
>> CC      net/ipv4/ip_options.o
>> CC      net/ipv4/ip_output.o
>> CC      net/ipv4/ip_sockglue.o
>> In file included from
>> /media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/unistd.h:5:0,
>>                  from include/linux/unistd.h:7,
>>                  from
>> /media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/seccomp_64.h:4,
>>                  from
>> /media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/seccomp.h:4,
>>                  from include/linux/seccomp.h:8,
>>                  from include/linux/sched.h:80,
>>                  from
>> /media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/compat.h:8,
>>                  from include/linux/compat.h:18,
>>                  from include/linux/ethtool.h:17,
>>                  from include/linux/netdevice.h:48,
>>                  from include/linux/inetdevice.h:8,
>>                  from net/ipv4/ip_sockglue.c:24:
>> /media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/unistd_64.h:668:2:
>> error: invalid preprocessing directive #Define
>
> There is nothing like "#Define" here. Are you sure you didn't modify the
> file?
>
> --
> js
>
