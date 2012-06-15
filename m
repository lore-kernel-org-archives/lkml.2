Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab2FOPKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:10:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab2FOPKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:10:41 -0400
Message-ID: <4FDB5067.7080204@suse.cz>
Date: Fri, 15 Jun 2012 17:10:31 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/4] [-next] Makefile: Do not call cc-option before including
 the arch's Makefile
References: <1336855148-18817-1-git-send-email-geert@linux-m68k.org> <20120520092744.GA21341@merkur.ravnborg.org> <4FBF7B34.2080506@suse.cz> <20120525202937.GA22903@merkur.ravnborg.org> <20120606094912.GG9495@gmail.com>
In-Reply-To: <20120606094912.GG9495@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.6.2012 11:49, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
>> On Fri, May 25, 2012 at 02:29:40PM +0200, Michal Marek wrote:
>>> Dne 20.5.2012 11:27, Sam Ravnborg napsal(a):
>>>> On Sat, May 12, 2012 at 10:39:05PM +0200, Geert Uytterhoeven wrote:
>>>>> On architectures that setup CROSS_COMPILE in their arch/*/Makefile
>>>>> (blackfin, h8300, m68k, mips, parisc, score, sh, tile, unicore32, xtensa),
>>>>> cc-option may check against the wrong compiler, causing errors like
>>>>>
>>>>> cc1: error: unrecognized command line option "-fno-ipa-cp-clone"
>>>>>
>>>>> if the host gcc supports -fno-ipa-cp-clone, while the cross compiler
>>>>> doesn't support that option.
>>>>>
>>>>> Move the CONFIG_READABLE_ASM section below the inclusion of the arch's
>>>>> Makefile to fix this.
>>>>>
>>>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>>>> Cc: Andi Kleen <ak@linux.intel.com>
>>>>> Cc: H. Peter Anvin <hpa@zytor.com>
>>>>> Cc: Michal Marek <mmarek@suse.cz>
>>>>> Cc: linux-kbuild@vger.kernel.org
>>>>
>>>> Michal - was this serie ever applied to kbuild?
>>>
>>> The first patch has to go to the tip tree, where the CONFIG_READABLE_ASM
>>> option is introduced.
>> OK - I had not seen this.
>>
>> So tip-folks - please apply this.
> 
> it's now all upstream so you can route it via the kbuild tree I 
> guess?

I applied it to kbuild.git#rc-fixes now.

Michal
