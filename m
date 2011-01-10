Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1AJVM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:12:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49868
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754731Ab1AJVMZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:12:25 -0500
Date: Mon, 10 Jan 2011 13:12:57 -0800 (PST)
Message-Id: <20110110.131257.212413498.davem@davemloft.net>
To: gwingerde@gmail.com
Cc: eric.dumazet@gmail.com, torvalds@linux-foundation.org,
        alex.arnautu96@gmail.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: Kernel 2.6.37-rc5 rc7 Oops
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D2B7550.5000008@gmail.com>
References: <1293652965.7150.13.camel@edumazet-laptop>
	<20110110.000650.124002380.davem@davemloft.net>
	<4D2B7550.5000008@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gertjan van Wingerde <gwingerde@gmail.com>
Date: Mon, 10 Jan 2011 22:08:32 +0100

> On 01/10/11 09:06, David Miller wrote:
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Date: Wed, 29 Dec 2010 21:02:45 +0100
>> 
>>> Le mercredi 29 décembre 2010 à 11:23 -0800, Linus Torvalds a écrit :
>>>> On Wed, Dec 29, 2010 at 4:26 AM, Alex Arnautu <alex.arnautu96@gmail.com> wrote:
>>>>>
>>>>> I get an oops with 2.6.37-rc5 and 2.6.37-rc7-git1.
>>>>> http://www.fotoshack.us/fotos/19044P271210_15.14_[01].jpg
>>>>
>>>> Hmm. Davem added to the list of people involved. This _may_ be fixed
>>>> by the "always clone skbs" commit in -rc8 (commit 173021072), but
>>>> David can make a better judgment call.
>>>>
>>>
>>> Very unlikely, as commit 173021072 only fix a bug in case mirred is
>>> used.
>> 
>> This should be taken to the wireless list (now CC:'d) as the rt2xxx
>> driver and the wireless stack are both in that backtrace.
> 
> Hmmm, the jpg images of the oops don't seem to be available anymore
> (a 404 not found is returned on the URL.
> Does anybody still have the backtrace? Otherwise it will be very hard to look
> into this.

You must have copy-and-paste'd it wrong, the URL works perfectly fine
for me.

I also put up a copy at:

http://vger.kernel.org/~davem/crash.jpg
