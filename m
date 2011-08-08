Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1HHVcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 17:32:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46267 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab1HHVcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 17:32:05 -0400
Date: Mon, 8 Aug 2011 23:31:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org
Subject: Re: Linux 3.1-rc1 (i7core_edac build error)
Message-ID: <20110808213159.GA22088@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-edac@vger.kernel.org
References: <CA+55aFwkJdyEpyNY64aAQ5ChrPZ8Kvx9iRUwy1J6_SRaxoN=zA@mail.gmail.com>
 <20110808135931.b234469c.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110808135931.b234469c.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 01:59:31PM -0700, Randy Dunlap wrote:
> on x86_64:
> 
> ERROR: "x86_mce_decoder_chain" [drivers/edac/i7core_edac.ko] undefined!
> 
> Full kernel (rand)config file is attached.

This has got to be linux-next because the x86_mce_decoder_chain for
i7core_edac is not upstream yet, AFAICT.

If so, then

http://git.kernel.org/?p=linux/kernel/git/mchehab/edac.git;a=commitdiff;h=cd90cc84c6bf0f40a681900c609c044336a1b12e

needs to be changed to depend on X86_MCE. Mauro, you want an updated
patch or you don't rebase your linux-next branch and need a diff ontop?

Thanks.

-- 
Regards/Gruss,
    Boris.
