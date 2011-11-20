Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1KTUVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 15:21:30 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:44453 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751471Ab1KTUV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 15:21:29 -0500
Message-ID: <4EC960C3.7040305@xenotime.net>
Date: Sun, 20 Nov 2011 12:19:15 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
CC: jidanni@jidanni.org, linux-kernel@vger.kernel.org
Subject: Re: Documentation/input/input.txt.gz has a bug
References: <8762im2n5f.fsf@jidanni.org> <4EC2BEF6.7070906@xenotime.net> <1321447814.22548.18.camel@thorin>
In-Reply-To: <1321447814.22548.18.camel@thorin>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 04:50 AM, Bernd Petrovitsch wrote:
> On Die, 2011-11-15 at 11:35 -0800, Randy Dunlap wrote:
> [...]
>>   Doing a "cat /dev/input/mouse0" (char device 13,32) will verify that
>> a mouse is also emulated; characters should appear if you move it.
>>   Doing a
>> $ cat /dev/input/mouse
> 
> Hmm, how is this written in the other documentation?

There is very little consistency among all of the Documentation/ files
(hopefully there is some consistency within any one file).

I found many of:

a. using a prompt, e.g.:
	$ cat /dev/input/mouse

b. using backquotes:
	`cat /dev/input/mouse`

c. using double quotes:
	"cat /dev/input/mouse"

d. using a colon:
	type (or enter): cat /dev/input/mouse


> Both are fine with me. FWIW in emails and the like, I use backquotes
> usually as in
> ----  snip  ----
> Doing a `cat /dev/input/mouse0` (char device 13,32) will verify that
> a mouse is also emulated; characters should appear if you move it.
> ----  snip  ----

Yes, that's OK also.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
