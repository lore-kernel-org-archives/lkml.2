Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab2AVOpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 09:45:12 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:41849 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897Ab2AVOpK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 09:45:10 -0500
MIME-Version: 1.0
In-Reply-To: <201201220857.36170.maciej.rutecki@gmail.com>
References: <CAC9WiBgRDEf_-F4qk+0TD83Gpaw2BxGD+UyaX8aQNuGUCWGVBw@mail.gmail.com>
	<201201220857.36170.maciej.rutecki@gmail.com>
Date: Sun, 22 Jan 2012 15:45:09 +0100
Message-ID: <CAC9WiBh5asB_=c7xsbDNamkyXKDOsE756UxCUeEEuRZmC_v-5g@mail.gmail.com>
Subject: Re: 3.2.1 unable to use my cd/dvd drive
From: Francis Moreau <francis.moro@gmail.com>
To: maciej.rutecki@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Jan 22, 2012 at 8:57 AM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> On sobota, 14 stycznia 2012 o 19:33:42 Francis Moreau wrote:
>> Hello,
>>
>> I'm not sure that's related to the upgrade to 3.2.1 (actually I don't
>> think so) but I'm unable to burn some DVD rw now.
>>
>> I tried several DVDs but failing each time with:
>>
>> [17418.653910] end_request: I/O error, dev sr0, sector 0
>> [17418.654664] sr 1:0:0:0: [sr0] Unhandled sense code
>> [17418.654669] sr 1:0:0:0: [sr0]  Result: hostbyte=DID_OK
>> driverbyte=DRIVER_SENSE
>> [17418.654673] sr 1:0:0:0: [sr0]  Sense Key : Medium Error [current]
>> [17418.654679] sr 1:0:0:0: [sr0]  Add. Sense: Unable to recover
>> table-of-contents
>> [17418.654686] sr 1:0:0:0: [sr0] CDB: Read(10): 28 00 00 00 04 00 00 00 02
>> 00 [17418.654697] end_request: I/O error, dev sr0, sector 4096
>>
>> Related drivers I'm using: sg, sr_mod, libata, sd_mod, scsi_mod
>>
>> Could anybody tell me what's going on ?
>
> It is regression? Which last kernel works OK?
>

As mentionned previously, I don't think it's a regression...

[ /me testing ... ]

It fails the same way with 2.6.39, 3.1. So it's not a regression.

And windows does the job.

Thanks
-- 
Francis
