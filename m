Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab1DGWAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:00:15 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:39632 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab1DGWAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:00:13 -0400
Message-ID: <4D9E33DF.2020707@ahsoftware.de>
Date: Thu, 07 Apr 2011 23:59:59 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Alexander Clouter <alex@digriz.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: Differentiate SheevaPlugs and DockStars on the
 basis of the memory size.
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de> <1302122121-3652-2-git-send-email-holler@ahsoftware.de> <alpine.LFD.2.00.1104061739100.28032@xanadu.home> <4D9CED15.2010806@ahsoftware.de> <alpine.LFD.2.00.1104061850410.28032@xanadu.home> <4D9CF5B3.9020007@ahsoftware.de> <toa078-0do.ln1@chipmunk.wormnet.eu> <4D9E2D1C.7070102@ahsoftware.de> <20110407214457.GH26616@chipmunk>
In-Reply-To: <20110407214457.GH26616@chipmunk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.04.2011 23:44, schrieb Alexander Clouter:
> * Alexander Holler<holler@ahsoftware.de>  [2011-04-07 23:31:08+0200]:
>>
>> Requiring a machine ID and the needed stuff to handle that for a
>> board which just is using two GPIOs different than another board is
>> why the ARM tree exploded. And requiring a machine ID just to follow
>> the rule that a machine ID is much better than some pretty unique hw
>> feature is in my humble opinion senseless and that the resulting code
>> is more readable and better to maintain is a myth.
>>
> It's something that most people agree with you on too.  However, I am
> guessing it's around as no one else *at the time* of it's conception
> could think of a better way.
>
> Now this is why there is a lot of work being done on device-tree.
>
>> Sorry that I wanted to help there. Will not try it again.
>>
> Yeah, as obviously no tries to help anyone improve around here:

That is future, I've tried to help with the existing stuff. Maybe I 
should have suggested just to remove all boards now which never will get 
support for DT. Linux might get happy.

And than I get called that I'm writing an abomination, which would have 
been nice with just the change of one line.

Sorry guys, this isn't what motivates people, at least not without the 
needed compensations to tolerate such manners.

Regards,

Alexander
