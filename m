Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800Ab2FGNlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:41:44 -0400
Received: from natasha.panasas.com ([67.152.220.90]:60803 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760469Ab2FGNln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:41:43 -0400
Message-ID: <4FD0AF72.9040003@panasas.com>
Date: Thu, 7 Jun 2012 16:41:06 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Richard Weinberger <richard@nod.at>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <jslaby@suse.cz>, <alan@linux.intel.com>
Subject: Re: [uml-devel] um: TTY fixes (?)
References: <1338841657-30358-1-git-send-email-richard@nod.at> <4FCF6748.6020005@panasas.com> <4FD059AC.8050808@panasas.com> <4FD06A22.6040002@nod.at> <4FD07F14.50902@panasas.com> <4FD0802A.1020203@nod.at> <20120607115227.6643d1ad@pyramind.ukuu.org.uk>
In-Reply-To: <20120607115227.6643d1ad@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 01:52 PM, Alan Cox wrote:

>> No, it works fine.
> 
> Not really. You happen to be lucky. Anyway with no tty port the UML code
> will soon cease to function completely so a solution of some sort is
> needed.
>  


This is what I understood. That mainline code moved so far that the current
UML driver was too far behind to properly function and *completely* broke.

If only breakage with new UM-TTY code is old util-linux. And we have a
ready made patch for it.

Would you please reconsider, and point the util-linux users to the fixing
patch.

Because as it stands:

Current code:
util-linux 	-	works
FC12-17		-	Broken (Patch *not* available)
Debain based	-	works

New code:
util-linux	- 	Broken, patch available
FC12-15		-	Works (with issues)
Debain based	-	works

So it is not like I'm sacrificing util-linux People
completely, but I am totally sacrificing FC People by
not committing.

Please reconsider, unless you have a patch for me for FC systems
that I can apply so I can use the old code.

Thanks again for everything, so far
Boaz
