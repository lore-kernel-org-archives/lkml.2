Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab0LaB3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 20:29:05 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:44466 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab0LaB3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 20:29:04 -0500
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2010 20:29:04 EST
Message-ID: <4D1D2FF8.2070806@shikadi.net>
Date: Fri, 31 Dec 2010 11:20:56 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.23) Gecko/20091130 Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: Why do programs freeze with big network transfers?
References: <ifhc54$efg$1@dough.gmane.org> <1293695919.7150.18.camel@edumazet-laptop>
In-Reply-To: <1293695919.7150.18.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> After a few seconds of data going over the network, X-Windows freezes.  No
>> screen updates, the mouse cursor won't move, for all intents and purposes the
>> system has frozen solid.  I'm playing music with XMMS2 and that keeps going,
>> but occasionally even that stops too.  After a minute (between 45 and 65
>> seconds) everything unfreezes and keeps going as per normal.  Less than 10
>> seconds later everything freezes again for another minute!  This keeps going
>> until the file transfer has finished.
>
> This rings a bell here, could you try to apply commit
>
> 482964e56e1320cb7952faa1932d8ecf59c4bf75
> (net: Fix the condition passed to sk_wait_event())
>
> This commit was included in 2.6.36, so you could also try 2.6.36.2
> kernel.

Just booted into 2.6.36.2 and it looks like the problem has indeed been fixed! 
  I've been able to perform the same transfer that would previously cause a 
freeze 100% of the time and it went through fine.

Many thanks for your help!

Cheers,
Adam.
