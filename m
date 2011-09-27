Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab1I0I0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 04:26:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42484 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1I0I0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 04:26:14 -0400
Message-ID: <4E8188A1.5000206@gmail.com>
Date: Tue, 27 Sep 2011 10:26:09 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110918 Thunderbird/7.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Jiri Slaby <jslaby@suse.cz>, Greg KH <greg@kroah.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] TTY: serial, fix locking imbalance
References: <1314818699-10873-1-git-send-email-jslaby@suse.cz> <20110922224653.GB21296@kroah.com> <4E7CD560.8010706@suse.cz> <20110923190840.GA31009@suse.de> <4E7CDC30.8070607@gmail.com> <20110923220440.GC30017@suse.de> <4E7E187B.4060507@gmail.com> <20110926233659.GA22611@suse.de>
In-Reply-To: <20110926233659.GA22611@suse.de>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2011 01:36 AM, Greg KH wrote:
> On Sat, Sep 24, 2011 at 07:50:51PM +0200, Jiri Slaby wrote:
>> On 09/24/2011 12:04 AM, Greg KH wrote:
>>> On Fri, Sep 23, 2011 at 09:21:20PM +0200, Jiri Slaby wrote:
>>>> But if there are more trees depending on the tree, then OK, I will live
>>>> with that ;).
>>>
>>> For the tty tree, I really doubt it, but I am not sure (rumor has it
>>> that some people are basing on it, but that might just be rumor.)
>>
>> Ok, for the other uart patches I have, it would be convenient for me to
>> have the possibility of rebase. Would you mind if I add something like
>> uart-cleanup tree to the -next tree and will have the patches there
>> until I send them to you?
> 
> linux-next is for stuff that people are confident will show up in the
> next release, not for general "let's throw it out there to see if it
> works" type thing.

No, it's not definitely a stuff like that. It's all tested and working
with my testbed. It just may need some tuning for some specific hardware
or cases. Especially I have no possibility to test drivers for
architectures other than x86. I only (cross-)compile-test them.

>> Just for the purpose of fine tuning (and rebasing) if something needs to
>> be fixed in them. The code is so complex, that I'm afraid I omitted some
>> semi-hidden dependency. And it would be great to fix patches like when I
>> used to work with the -mm tree.
> 
> Perhaps you should just work with Andrew and put these in -mm for now
> until you feel comfortable that it's all worked out and no rebasing
> would be needed anymore?

Yes, I can try that as I'm not sure Andrew will agree. Let's see. And
also note that -mm is a part of -next already. That's why I was thinking
about a separate tree.

thanks,
-- 
js
