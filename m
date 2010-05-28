Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab0E1AtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:49:14 -0400
Received: from mail.svr02.mucip.net ([83.170.6.69]:40496 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab0E1AtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:49:13 -0400
X-Submitted: to mailout.mucip.net (Postfix) with ESMTPSA id 144544967
Message-ID: <4BFF1304.2030605@birkenwald.de>
Date: Fri, 28 May 2010 02:49:08 +0200
From: Bernhard Schmidt <berni@birkenwald.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Clock jumps
References: <loom.20100524T171038-56@post.gmane.org>	 <20100525062100.GP22163@redhat.com>	<4BFD5616.6070302@cora.nwra.com>	 <4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de>	 <htmdsk$9kn$1@dough.gmane.org>	 <AANLkTindrSuRdOI30l4P5XMuUVv3j7Zso9fMi1xREb3A@mail.gmail.com>	 <4BFEE8A2.30706@birkenwald.de> <1275004816.1813.15.camel@work-vm>	 <4BFF0F3F.9050800@birkenwald.de> <1275007605.1813.18.camel@work-vm>
In-Reply-To: <1275007605.1813.18.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.05.2010 02:46, john stultz wrote:

[ dropped kvm ml ]

Hi John,

>> Correct, the box isn't rebooted often, but I do have a few dmesg outputs
>> laying around. lpj was always almost the same until the very last boot
>> which screwed up the clock.
>>
>> dmesg:[    0.000000] Linux version 2.6.33 (root@svr02) (gcc version
>> 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Sun Mar 7 23:01:45 CET 2010
>> dmesg:[    0.008005] Calibrating delay loop (skipped), value calculated
>> using timer frequency.. 5226.64 BogoMIPS (lpj=10453296)
>> dmesg:[    0.288002] Total of 2 processors activated (10546.63 BogoMIPS).
>
> Yea. The bogomips/loops per jiffies are actually calculated with a
> different chunk of code (although its interesting it miscalculated in
> both cases).
>
> Could you send the "Detected xxxx.yyy MHz processor." lines as well?

Sure...

dmesg:[    0.000000] Detected 2613.324 MHz processor.
dmesg.0:[    0.000000] Detected 2660.398 MHz processor.
dmesg.1.gz:[    0.000000] Detected 2659.530 MHz processor.
dmesg.2.gz:[    0.000000] Detected 2659.678 MHz processor.
dmesg.3.gz:[    0.000000] Detected 2659.989 MHz processor.
dmesg.4.gz:[    0.000000] Detected 2659.922 MHz processor.

Bernhard
