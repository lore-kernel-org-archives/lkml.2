Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1KGJhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 04:37:22 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:43111 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752212Ab1KGJhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 04:37:19 -0500
X-Authenticated: #7756412
X-Provags-ID: V01U2FsdGVkX190Ay0J0KJ0H/ZZqMbI3ZhiFCLTh9EMim6OqNLt2I
	BUeVCwDDPZseK5
Message-ID: <4EB7A6CC.5030502@gmx.net>
Date: Mon, 07 Nov 2011 10:37:16 +0100
From: Arne Jansen <sensille@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrea Gelmini <andrea.gelmini@gmail.com>
CC: Chris Mason <chris.mason@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs pull request
References: <20111106183851.GA4339@shiny> <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
In-Reply-To: <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.11.2011 20:29, Andrea Gelmini wrote:
> 2011/11/6 Chris Mason <chris.mason@oracle.com>:
> 
> Hi Chris,
>    and thanks a lot for your work.
> 
>> Arne Jansen and Jan Schmidt have improved the scrubber and provided
>> utilities to walk btrfs' many backrefs.  The scrubber is much faster
>> thanks to extensive btree readahead and instead of just telling you a
>> specific block is bad, it tells you which btree or which file was
>> impacted by that bad block.
> 
>    Using your for-linus branch, on latest Linus' git tree, with latest
> git tools,
>    I've got this:
> 
> root@Q45:/home/gelma/dev/prg/btrfs# ./btrfs scrub start -Br /dev/md126
> ERROR: scrubbing /dev/md126 failed for device id 1 (Cannot allocate memory)
> scrub canceled for 11827b37-1ba0-4b3e-883d-2746987724ca
> 	scrub started at Sun Nov  6 20:23:46 2011 and was aborted after 0 seconds
> 	total bytes scrubbed: 0.00 with 0 errors
> root@Q45:/home/gelma/dev/prg/btrfs# ./btrfs scrub start -Br /home/
> ERROR: scrubbing /home/ failed for device id 1 (Cannot allocate memory)
> scrub canceled for 11827b37-1ba0-4b3e-883d-2746987724ca
> 	scrub started at Sun Nov  6 20:25:01 2011 and was aborted after 0 seconds
> 	total bytes scrubbed: 0.00 with 0 errors

On what platform are you running this? Can you please try this after
a fresh boot? Maybe there's an allocation that can't be served with
a badly fragmented memory.

Thanks,
Arne

> 
> Thanks a lot for your time,
> Andrea
>>
