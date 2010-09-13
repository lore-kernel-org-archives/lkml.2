Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab0IMGhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 02:37:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34221 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab0IMGhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 02:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XpeCIO3y5pqKwa3NJlGuL+1SYfizR9huO/CnsX7TeDH9SKr+WzDvx4BuW4n7/Ir4pC
         s5FKDP0k4DxJm3pKLs7c0etyTvgqDb/RtW6cckdqcDvz0U2k4e2BBraP+eGl3EpNJ9Nu
         qfzO3RD5XFanrQUEl6ht8pnoe2264xHcncb10=
Message-ID: <4C8DC6B9.3050701@gmail.com>
Date: Sun, 12 Sep 2010 23:37:45 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Nigel Cunningham <nigel@tuxonice.net>
CC: Randy Dunlap <randy.dunlap@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: 2.6.36-rc3 - Unable to build: "Error: input truncated"
References: <4C8CB5A1.9040500@tuxonice.net>	<201009121934.37033.rjw@sisk.pl>	<4C8D5D41.90104@tuxonice.net> <20100912201152.a4ada04a.randy.dunlap@oracle.com> <4C8DB031.6050008@tuxonice.net> <4C8DB674.5040200@gmail.com> <4C8DC01A.4030206@tuxonice.net>
In-Reply-To: <4C8DC01A.4030206@tuxonice.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2010 11:09 PM, Nigel Cunningham wrote:
> Hi.
>
> On 13/09/10 15:28, Justin P. Mattock wrote:
>> probably the same thing I was hitting last week or similar... bisected
>> resulted in crazy numbers(way back in may) long story short
>> git clean -fx resolved the error over here..(so tied up with other
>> things something as simple as that, I forgot)
>>
>> hope this helps..
>
> 'fraid not.
>
> What I have since noticed, though, is that my currently running (2.6.34)
> .config doesn't trigger it, whereas the one with some changes I made the
> other day does. Looks like I have a couple of ways in which to find out
> the cause :)
>
> Nigel
>


ahh.. I see.. yeah over here it was the same .config lots of commits 
here and there, numerous recompiles of a same module that probably 
triggered my error(stale files and such).. but if your hitting a .config 
change then that's different..(hopefully you remember what you 
changed...can be a bit daunting if going in and feeling generous and 
such..(but then again maybe that's just me..)).

Justin P. Mattock
