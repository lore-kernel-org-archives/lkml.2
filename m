Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1HIKBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 06:01:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab1HIKBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 06:01:49 -0400
Message-ID: <4E41055F.9010900@redhat.com>
Date: Tue, 09 Aug 2011 07:01:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org
Subject: Re: Linux 3.1-rc1 (i7core_edac build error)
References: <CA+55aFwkJdyEpyNY64aAQ5ChrPZ8Kvx9iRUwy1J6_SRaxoN=zA@mail.gmail.com> <20110808135931.b234469c.rdunlap@xenotime.net> <20110808213159.GA22088@liondog.tnic>
In-Reply-To: <20110808213159.GA22088@liondog.tnic>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 08-08-2011 18:31, Borislav Petkov escreveu:
> On Mon, Aug 08, 2011 at 01:59:31PM -0700, Randy Dunlap wrote:
>> on x86_64:
>>
>> ERROR: "x86_mce_decoder_chain" [drivers/edac/i7core_edac.ko] undefined!
>>
>> Full kernel (rand)config file is attached.
> 
> This has got to be linux-next because the x86_mce_decoder_chain for
> i7core_edac is not upstream yet, AFAICT.
> 
> If so, then
> 
> http://git.kernel.org/?p=linux/kernel/git/mchehab/edac.git;a=commitdiff;h=cd90cc84c6bf0f40a681900c609c044336a1b12e
> 
> needs to be changed to depend on X86_MCE. Mauro, you want an updated
> patch or you don't rebase your linux-next branch and need a diff ontop?

I don't think that anyone, except for -next, is cloning from my tree,
and there are just a few new patches there, so I'm not caring a lot of 
not doing rebase on this tree, but incremantal patches is better.

Thanks,
Mauro
