Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750915Ab1HDE0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 00:26:10 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:55350 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1HDE0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 00:26:03 -0400
Date: Thu, 04 Aug 2011 00:25:55 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] APEI patches for Linux 3.1
In-reply-to: <CA+55aFxE6b=idv+fF5h1U3EnDqHSCK2b6+36sResmhJKvAZQ3A@mail.gmail.com>
Message-id: <alpine.LFD.2.02.1108032351430.29492@x980>
References: <alpine.LFD.2.02.1108031137590.22067@x980>
 <CA+55aFxST2J+LDMB=1ctnw2WGxV+a-cm3FE-1AjwnXMNDkt32g@mail.gmail.com>
 <alpine.LFD.2.02.1108031523080.22067@x980>
 <CA+55aFxE6b=idv+fF5h1U3EnDqHSCK2b6+36sResmhJKvAZQ3A@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Aug 2011, Linus Torvalds wrote:

> ...I'm not seeing any
> reason to pull this thing. The merge window is not for development,
> and you're simply not making me get the warm and fuzzies about this
> late pull request.

I appologize for the the multiple late pull requests.
I was off the grid for a vacation and returned too late to be early.

I split APEI onto its own branch and I doubly botched it --
both in the .git/remotes file and in the script pointing to the repo...
I guess the good news is the next time I run the script it will be 
correct:-)

Please judge apei-release on its own merits rather than
the sloppily-addressed envelope I sent it in on Wednesday.
I know it isn't a capability that you use, but for the enterprise
folks that need it, this batch is an improvement over Linux 3.0.

The code hasn't changed much in months -- most of it
was ready for the 3.0 merge window.  There were a couple of
build fixes recently based-on linux-next feedback,
and I also re-based to add more "Acked-by" notations.
Finally, I merged it up to your tree so you'd not be irritated
with trivial but annoying text merge conflicts on your
vacation.  (typical case of multiple people appending
to shared lists in Kconfig files, if you're interested)

FWIW, I've built 200 x86_64 kernels and 393 i386 kernels
and booted on both architectures on multiple machines.
Though I don't have the capability to verify correctness
of the the APEI features, and must rely on Ying for that.

please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git apei-release

thanks,
-Len

