Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab2HEIPK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 04:15:10 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:10195 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab2HEIPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 04:15:07 -0400
Message-ID: <501E2BC5.5020709@c-s.fr>
Date: Sun, 05 Aug 2012 10:16:05 +0200
From: LEROY christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Huge performance degradation for UDP between 2.4.17 and 2.6
References: <501A722D.1070900@c-s.fr> <1343916836.9299.189.camel@edumazet-glaptop>
In-Reply-To: <1343916836.9299.189.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Antivirus: avast! (VPS 120805-0, 05/08/2012), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/08/2012 16:13, Eric Dumazet a écrit :
> On Thu, 2012-08-02 at 14:27 +0200, leroy christophe wrote:
>> Hi
>>
>> I'm having a big issue with UDP. Using a powerpc board (MPC860).
>>
>> With our board running kernel 2.4.17, I'm able to send 160000 voice
>> packets (UDP, 96 bytes per packet) in 11 seconds.
>> With the same board running either Kernel 2.6.35.14 or Kernel 3.4.7, I
>> need 55 seconds to send the same amount of packets.
>>
>>
>> Is there anything to tune in order to get same output rate as with
>> Kernel 2.4 ?
> kernel size is probably too big for your old / slow cpu.
>
> Maybe you added too many features on your 3.4.7 kernel. (netfilter ?
> SLUB debugging ...)
>
> Its hard to say, 2.4.17 had less features and was faster.
>

Thanks for your answer.
Yes I have netfilter as I need it. However, I tried without it and still 
need about 37 seconds to send the 160000 packets I was sending in 11 
seconds with 2.4.17

I don't think there is any problem with size of the kernel. I still have 
plenty of memory available.

All debugging is turned off, and I'm not using SLUB but SLOB.
I have 32Mbytes of RAM. Would SLUB be more performant than SLOB ?

Christophe
