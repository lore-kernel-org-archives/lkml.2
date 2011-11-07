Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1KGJ5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 04:57:52 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:37748 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753263Ab1KGJ5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 04:57:50 -0500
X-Authenticated: #7756412
X-Provags-ID: V01U2FsdGVkX18TlFwSKw0T/HvH9tIH2c/uBZytHmTaPTc2S2QBW5
	rewZFYF2ZspEGn
Message-ID: <4EB7AB9C.8010402@gmx.net>
Date: Mon, 07 Nov 2011 10:57:48 +0100
From: Arne Jansen <sensille@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.ru>
CC: Andrea Gelmini <andrea.gelmini@gmail.com>,
        Chris Mason <chris.mason@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs pull request
References: <20111106183851.GA4339@shiny>	<CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>	<4EB7A6CC.5030502@gmx.net> <20111107154936.7c60be38@natsu>
In-Reply-To: <20111107154936.7c60be38@natsu>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.11.2011 10:49, Roman Mamedov wrote:
> On Mon, 07 Nov 2011 10:37:16 +0100
> Arne Jansen <sensille@gmx.net> wrote:
> 
>>>    I've got this:
>>>
>>> root@Q45:/home/gelma/dev/prg/btrfs# ./btrfs scrub start -Br /dev/md126
>>> ERROR: scrubbing /dev/md126 failed for device id 1 (Cannot allocate memory)
>>> scrub canceled for 11827b37-1ba0-4b3e-883d-2746987724ca
>>> 	scrub started at Sun Nov  6 20:23:46 2011 and was aborted after 0 seconds
>>> 	total bytes scrubbed: 0.00 with 0 errors
>>> root@Q45:/home/gelma/dev/prg/btrfs# ./btrfs scrub start -Br /home/
>>> ERROR: scrubbing /home/ failed for device id 1 (Cannot allocate memory)
>>> scrub canceled for 11827b37-1ba0-4b3e-883d-2746987724ca
>>> 	scrub started at Sun Nov  6 20:25:01 2011 and was aborted after 0 seconds
>>> 	total bytes scrubbed: 0.00 with 0 errors
>>
>> On what platform are you running this? Can you please try this after
>> a fresh boot? Maybe there's an allocation that can't be served with
>> a badly fragmented memory.
> 
> If so, shouldn't there also be a corresponding dmesg warning about "Unable to allocate....", which would confirm or rule this out?
> So before following the "did you try turning it off and on again" advice (and throwing away useful debug info), I'd suggest checking/saving dmesg first.
> 

You're right of course. The advice was not meant as a fix, but as a
means to gather more information.
