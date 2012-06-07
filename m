Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759869Ab2FGKft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:35:49 -0400
Received: from natasha.panasas.com ([67.152.220.90]:57827 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759783Ab2FGKfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:35:48 -0400
Message-ID: <4FD083E3.5080900@panasas.com>
Date: Thu, 7 Jun 2012 13:35:15 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: <user-mode-linux-devel@lists.sourceforge.net>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <jslaby@suse.cz>, <alan@linux.intel.com>
Subject: Re: [uml-devel] um: TTY fixes (?)
References: <1338841657-30358-1-git-send-email-richard@nod.at> <4FCF6748.6020005@panasas.com> <4FD059AC.8050808@panasas.com> <4FD06A22.6040002@nod.at> <4FD07F14.50902@panasas.com> <4FD0802A.1020203@nod.at>
In-Reply-To: <4FD0802A.1020203@nod.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 01:19 PM, Richard Weinberger wrote:

> 
> No, it works fine.
> 


OK Sorry I missed that part. So you are saying that these patches
fix Fedora, but completely break other systems which now work?

I saw in your cover letter that Debian was fine with or without
->hangup() so I assumed all other system are more like Debian.

>> I don't see Alan's comment at all. This is not a regression it was always
>> like that. Ever since Fedora was working on UML, But these fixes are real
>> live regression crashes.
>>
>> And I don't see the all "leaving other vendors systems insecure". It just
>> a freaking UML tty. You need to be root 5 times before you have access
>> to all these, and it's only the UML that's compromised not the "all system"
>> And surely the current plain tty0 crash is much less secure then this thing.
> 
> The "TTY problem" is not UML specific.
> 


Exactly my point, so it is not anything your UM-only patches can do anything
about it. right?

> Thanks,
> //richard
> 


I guess I will have to carry these longer. Can I fix my FC12 and FC15 so they
don't crash with mainline?

Thanks
Boaz
