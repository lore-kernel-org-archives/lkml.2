Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1HHVhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 17:37:15 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:50758 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751357Ab1HHVhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 17:37:13 -0400
Date: Mon, 8 Aug 2011 14:37:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org
Subject: Re: Linux 3.1-rc1 (i7core_edac build error)
Message-Id: <20110808143711.b5d3a5a2.rdunlap@xenotime.net>
In-Reply-To: <20110808213159.GA22088@liondog.tnic>
References: <CA+55aFwkJdyEpyNY64aAQ5ChrPZ8Kvx9iRUwy1J6_SRaxoN=zA@mail.gmail.com>
	<20110808135931.b234469c.rdunlap@xenotime.net>
	<20110808213159.GA22088@liondog.tnic>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Aug 2011 23:31:59 +0200 Borislav Petkov wrote:

> On Mon, Aug 08, 2011 at 01:59:31PM -0700, Randy Dunlap wrote:
> > on x86_64:
> > 
> > ERROR: "x86_mce_decoder_chain" [drivers/edac/i7core_edac.ko] undefined!
> > 
> > Full kernel (rand)config file is attached.
> 
> This has got to be linux-next because the x86_mce_decoder_chain for
> i7core_edac is not upstream yet, AFAICT.

Agreed.  Too many simultaneous build trees.  Sorry about that.


> If so, then
> 
> http://git.kernel.org/?p=linux/kernel/git/mchehab/edac.git;a=commitdiff;h=cd90cc84c6bf0f40a681900c609c044336a1b12e
> 
> needs to be changed to depend on X86_MCE. Mauro, you want an updated
> patch or you don't rebase your linux-next branch and need a diff ontop?
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.

Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
