Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab2H2AZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 20:25:56 -0400
Received: from smtp.getmail.no ([84.208.15.66]:57824 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab2H2AZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 20:25:55 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: jdow@earthlink.net, linux-kernel@vger.kernel.org
Subject: Re: System-drivers ported to Windows XP?
References: <op.wjrltbl46426ze@millennium.getinternet.no>
 <503D4B37.1030202@earthlink.net>
Date: Wed, 29 Aug 2012 02:25:54 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wjr0tgbs6426ze@millennium.getinternet.no>
In-reply-to: <503D4B37.1030202@earthlink.net>
User-Agent: Opera Mail/12.01 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a list of drivers here, many of them dated 2001.  
http://paradoxuncreated.com/Blog/wordpress/?p=1608 (MS making me upset as  
usual.)
I am really just looking for better drivers, and thought maybe someone  
knew if more current opensource versions existed. I have not found  
anything online though, so therefore I ask here.

I have also thought about the ReactOS project, and wonder if they have  
more current drivers, seeing as they work on the project currently, I am  
discussing in their forum now, but communication is going slow.

Peace Be With You.

On Wed, 29 Aug 2012 00:50:31 +0200, jdow <jdow@earthlink.net> wrote:

> You might look into the ASIO drivers. Although for very heavy audio use
> 64 byte buffers are a more reliable than the ultra-short buffers you seem
> to be using. 100 channels with 7 ms latency through an audio matrix is
> a commercial product for XP and Win 7 for quite some time now. (Although
> Win 7 has some security policies that reduce performance gains that come
> through priority elevation somewhat.)
>
> SoundMan and Richmond are key words that will lead you to it via Google.
>
> {^_^}
>
> On 2012/08/28 12:01, Uwaysi Bin Kareem wrote:
>> Some may remember me as commenting on the excellent state of the  
>> linux-kernel,
>> after I achieved 0.3ms reliable latency for audio-streams.
>>
>> I have now decided to try and get as close as possible on Windows XP  
>> though.
>> However some of the drivers on my windows XP install, is from 2001.  
>> Windows
>> update is ofcourse not giving me the available ones from 2012, and they  
>> are hard
>> to track down.
>>
>> I was wondering if anyone had ported generic-system drivers, which then  
>> would
>> probably be more optimized, than the 2001-ones, to windows XP?
>>
>> If anyone wants to read about my findings on Windows XP, please read:
>> http://paradoxuncreated.com/Blog/wordpress/?p=1506
>>
>> Peace Be With You.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"  
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
