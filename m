Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102Ab2EYWIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:08:22 -0400
Received: from mail1.windriver.com ([147.11.146.13]:56655 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258Ab2EYWIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:08:18 -0400
Message-ID: <4FC002C9.1040301@windriver.com>
Date: Fri, 25 May 2012 18:08:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Avi Kivity <avi@redhat.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: triage for April 19, 2012
References: <20120420020013.GA19964@windriver.com> <CAMuHMdUUgysVqz226jhK42nvYNaX7yvexpqRjOPx0QpvzUwVXg@mail.gmail.com>
In-Reply-To: <CAMuHMdUUgysVqz226jhK42nvYNaX7yvexpqRjOPx0QpvzUwVXg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-05-25 04:59 PM, Geert Uytterhoeven wrote:
> On Fri, Apr 20, 2012 at 4:00 AM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> The parisc got borked by some kvm header shuffle it seems?
>> Now complaining about "file 'asm-generic/kvm_para.h' is not exported"
>> [ http://kisskb.ellerman.id.au/kisskb/buildresult/6137786/ ]
> 
> Not only parisc.
> 
> This breakage has now entered mainline:
> 
> parisc deconfig http://kisskb.ellerman.id.au/kisskb/buildresult/6365677/
> m68k allmodconfig: http://kisskb.ellerman.id.au/kisskb/buildresult/6365681/

See also this thread:

http://www.spinics.net/lists/kvm/msg72785.html

Paul.


> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
