Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0EIQtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 12:49:43 -0400
Received: from mail.tmr.com ([64.65.253.246]:38907 "EHLO posidon.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab0EIQtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 12:49:40 -0400
Message-ID: <4BE6E79B.5080608@tmr.com>
Date: Sun, 09 May 2010 12:49:31 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100504 NOT Firefox/3.5.3 SeaMonkey/2.0.5
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: microblaze-uclinux@itee.uq.edu.au
Subject: Re: Microblaze - The fist year
References: <4BC461AD.6090504@monstr.eu> <4BC46DC6.5050309@lumino.de> <4BC4713F.6030702@monstr.eu> <4BC57478.3080902@lumino.de>
In-Reply-To: <4BC57478.3080902@lumino.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Schnell wrote:
> On 04/13/2010 03:27 PM, Michal Simek wrote:
>>
>> yes, futex is there. You can check it in
>> arch/microblaze/include/asm/futex.h
> Great ! I'll check how this is done.
>>
>>> Does Microblaze MMU Linux support SMP ?
>>
>> It is possible to connect several MicroBlazes but the problem is
>> missing cache coherency modul. I hope that Xilinx will release any
>> version which will support it.
>> We haven't done any significant work to support it but it is expected
>> solution which will happen.
>
> Besides cache coherency, another problem might be doing FUTEX. here (I
> suppose) SMP safe atomic user space operations are necessary. many
> simple RISK (load/store-) CPUs don't provide these (new ARMs provide
> "load-locked / store-conditional" on that behalf as an extension to the
> load/store paradigm. I suppose these can be done in an SMP-safe way,
> supposedly using the hardware that provides cache coherency).
>
I wonder if you could make this work with some variant of NUMA 
configuration. I don't predict anything about being practical even if it 
works, just a thought.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
