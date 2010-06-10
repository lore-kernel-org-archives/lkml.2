Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0FJVEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 17:04:16 -0400
Received: from mail.tmr.com ([64.65.253.246]:44888 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab0FJVEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 17:04:15 -0400
Message-ID: <4C115345.1060805@tmr.com>
Date: Thu, 10 Jun 2010 17:04:05 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jeffrey Merkey <jeffmerkey@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Fwd: EXT3 File System Corruption 2.6.34
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com>	<4C0D5DCD.5010201@sandeen.net>	<AANLkTik1T2nJxsoK9UGIVy6q6pfSxniFfJXJY0InmuUh@mail.gmail.com>	<AANLkTil4FMnGl7llR4N0PkXuNyEClQmTspNK6PT62PAi@mail.gmail.com>	<889B6B31-A1F0-438D-B782-DBB855912854@sandeen.net>	<AANLkTilrmEnLrxRSYNnwr8vFaZi7R9U5vY39NmBWUEMy@mail.gmail.com> <AANLkTil7toVuTbCExPtGMOqzqBVG3hG5JeEqzS6ZZ8T6@mail.gmail.com>
In-Reply-To: <AANLkTil7toVuTbCExPtGMOqzqBVG3hG5JeEqzS6ZZ8T6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeffrey Merkey wrote:
> ---------- Forwarded message ----------
> From: Jeffrey Merkey <jeffmerkey@gmail.com>
> Date: Mon, Jun 7, 2010 at 7:55 PM
> Subject: Re: EXT3 File System Corruption 2.6.34
> To: Eric Sandeen <sandeen@sandeen.net>
> 
> 
>> On Jun 7, 2010, at 6:55 PM, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
>>
>>> ---------- Forwarded message ----------
>>> From: Jeffrey Merkey <jeffmerkey@gmail.com>
>>> Date: Mon, Jun 7, 2010 at 5:54 PM
>>> Subject: Re: EXT3 File System Corruption 2.6.34
>>> To: Eric Sandeen <sandeen@sandeen.net>
>>>
>>>
>>> REPLY TO ALL
>>>
>>> CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
>>>
>>> Whether set this way or not, should not see corruption.
>> Here you are mistaken.  Mount with data=ordered and see.  Writeback can
>> expose stale data.
>>
>> -Eric
>>
> 
> OK.  I will set this up.  You may want to make this option the default
> in the build scripts.  here is a corrupted file.  This was a .gif
> image file I saved THEN AFTER SAVING THE FILE I pulled the power to
> the machine and during recovery the file was FUCKED.  At any rate,
> this does not happen with 2.6.28.
> 
Having bad things happen when power is removed is not much of a surprise, and 
various options can fix that at the cost of speed. The fact that this didn't 
happen with 2.6.28 is bothersome.

I actually take some care to avoid testing behavior in this area, not my normal 
intended mode of operation.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
