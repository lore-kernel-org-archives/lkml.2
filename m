Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab1AKPVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:21:15 -0500
Received: from mail201c2.megamailservers.com ([69.49.111.102]:58614 "EHLO
	mail201c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755817Ab1AKPVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:21:13 -0500
X-Greylist: delayed 4749 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2011 10:21:13 EST
X-Authenticated-User: daniel.gaisler.com
Message-ID: <4D2C6260.80403@gaisler.com>
Date: Tue, 11 Jan 2011 15:00:00 +0100
From: Daniel Hellstrom <daniel@gaisler.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [GIT PATCH] TTY/serial merge for .38
References: <20110106215404.GA30624@kroah.com> <AANLkTi=mCKWKTcP7JVdwVkk4OVEGDNHYgb5-W+1NJmtQ@mail.gmail.com> <20110107234149.GA18421@suse.de>
In-Reply-To: <20110107234149.GA18421@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CSC: 0
X-CHA: v=1.1 cv=7mdt3cZwcPjaoOsfh2HHasJqDel8T9IFNftJhWNFW5M= c=1 sm=1
		a=MHLHY0zIDWcA:10 a=8nJEP1OIZ-IA:10 a=jXKJviUpWSOlMmIvGrHOfw==:17
		a=oiANwhMaPnJIHX5ALfUA:9 a=1hwapEwxcVuVELjSyw3qU05_E_oA:4 a=wPNLvfGTeEIA:10
		a=0kPLrQdw3YYA:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

>On Fri, Jan 07, 2011 at 02:44:14PM -0800, Linus Torvalds wrote:
>  
>
>>On Thu, Jan 6, 2011 at 1:54 PM, Greg KH <gregkh@suse.de> wrote:
>>    
>>
>>>Here is the big tty and serial merge for .38.  I'll be sending another
>>>smaller one that just moves drivers around after .38-rc1 is out, as is
>>>the norm for file moves to handle issues with other trees syncing up
>>>properly.
>>>      
>>>
>>Merged. However, the drivers/serial/apbuart.c file conflicted, and
>>both sides of the merge had some insanity in them.
>>
>>So I did an "evil merge" - a merge that actually changed the code to
>>match neither side - and it looks better to me. But maybe that's just
>>the drugs I'm taking talking.
>>
>>So people should check it out. In particular, look at the interaction
>>of "drivers: serial: apbuart: Handle OF failures gracefully" and the
>>"Added support for ampopts in APBUART driver. Used in AMP systems"
>>commit.
>>    
>>
>
>The merge looks ok to me, but I don't have this hardware, so I can't
>test it.  Thomas, can you verify this is ok?
>  
>

The code looks good and I have tested on the APBUART hardware - it works.

Thanks,
Daniel Hellstrom

