Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2EYMYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 08:24:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab2EYMYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 08:24:15 -0400
Message-ID: <4FBF7B34.2080506@suse.cz>
Date: Fri, 25 May 2012 14:29:40 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/4] [-next] Makefile: Do not call cc-option before including
 the arch's Makefile
References: <1336855148-18817-1-git-send-email-geert@linux-m68k.org> <20120520092744.GA21341@merkur.ravnborg.org>
In-Reply-To: <20120520092744.GA21341@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 20.5.2012 11:27, Sam Ravnborg napsal(a):
> On Sat, May 12, 2012 at 10:39:05PM +0200, Geert Uytterhoeven wrote:
>> On architectures that setup CROSS_COMPILE in their arch/*/Makefile
>> (blackfin, h8300, m68k, mips, parisc, score, sh, tile, unicore32, xtensa),
>> cc-option may check against the wrong compiler, causing errors like
>>
>> cc1: error: unrecognized command line option "-fno-ipa-cp-clone"
>>
>> if the host gcc supports -fno-ipa-cp-clone, while the cross compiler
>> doesn't support that option.
>>
>> Move the CONFIG_READABLE_ASM section below the inclusion of the arch's
>> Makefile to fix this.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Cc: Andi Kleen <ak@linux.intel.com>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>> Cc: Michal Marek <mmarek@suse.cz>
>> Cc: linux-kbuild@vger.kernel.org
> 
> Michal - was this serie ever applied to kbuild?

The first patch has to go to the tip tree, where the CONFIG_READABLE_ASM
option is introduced. The remaining patches can go to the individual
arch trees, I see Geert already pushed the m68k one.

Michal
