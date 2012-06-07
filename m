Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912Ab2FGKPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:15:23 -0400
Received: from natasha.panasas.com ([67.152.220.90]:57473 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2FGKPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:15:18 -0400
Message-ID: <4FD07F14.50902@panasas.com>
Date: Thu, 7 Jun 2012 13:14:44 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: <user-mode-linux-devel@lists.sourceforge.net>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <jslaby@suse.cz>, <alan@linux.intel.com>
Subject: Re: [uml-devel] um: TTY fixes (?)
References: <1338841657-30358-1-git-send-email-richard@nod.at> <4FCF6748.6020005@panasas.com> <4FD059AC.8050808@panasas.com> <4FD06A22.6040002@nod.at>
In-Reply-To: <4FD06A22.6040002@nod.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 12:22 PM, Alan Cox wrote:
> On 06/07/2012 11:45 AM, Richard Weinberger wrote:

>> 
>> We cannot push this patch to Linus or -stable.
>> The problem is that will break other things.
>> E.g. login on non-tty0 terminals will break if the distro uses
>> util-linux's login.
>> 


I don't understand. Current code does not work at all even for
tty0. as well as ttyX. Since 3-4 Kernels ago. I've been running with
your patch for a long time.

I really don't get it. You have not broken anything new. Only
not fixed all of the problems. Current code does not work for "non-tty0
terminals" as well right?

<>
>> Breaking existing applications is a no-go, sorry.

> Being insecure should also be a no-no.

> 
> Not sure what Jiri thinks but for the moment I think we need to push it
> with a module option as to whether hangup on console is enabled or not.
> 
> I don't want to just break the existing user space, but leaving other
> vendors systems insecure just to cover Fedora's backside is also not
> entirely fair either.

I don't see Alan's comment at all. This is not a regression it was always
like that. Ever since Fedora was working on UML, But these fixes are real
live regression crashes.

And I don't see the all "leaving other vendors systems insecure". It just
a freaking UML tty. You need to be root 5 times before you have access
to all these, and it's only the UML that's compromised not the "all system"
And surely the current plain tty0 crash is much less secure then this thing.

> Thanks,
> //richard
> 


Please let us work, I don't see the point of leaving something terminally
broken, ever.

Thanks
Boaz
