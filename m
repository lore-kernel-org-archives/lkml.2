Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab1KBJYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 05:24:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab1KBJYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 05:24:15 -0400
Message-ID: <4EB10C3D.6090906@suse.cz>
Date: Wed, 02 Nov 2011 10:24:13 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthias Schniedermeyer <ms@citd.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sam Ravnborg <sam@ravnborg.org>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] config: Add 'make kvmconfig'
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com> <20111027193448.GA3514@merkur.ravnborg.org> <20111028070336.GF12995@elte.hu> <CAMuHMdUSyNcbmmXjFqSVQmsSqGS5xKFt4DSnskkg80UyWoJjLQ@mail.gmail.com> <20111028075432.GB8626@elte.hu> <20111028120856.GA29174@citd.de> <20111028122902.GA25323@elte.hu> <20111028130535.GA2752@citd.de> <20111102084124.GB18771@elte.hu> <4EB1084F.4020206@suse.cz> <20111102091747.GH18903@elte.hu>
In-Reply-To: <20111102091747.GH18903@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.11.2011 10:17, Ingo Molnar wrote:
> * Michal Marek <mmarek@suse.cz> wrote:
>> On 2.11.2011 09:41, Ingo Molnar wrote:
>>> Yeah. Note that it's more like an 'add' operation, not a modify 
>>> operation, thus:
>>>
>>> 	make addconfig=kvm
>>>
>>> or:
>>>
>>> 	make addconfig kvm
>>>
>>> would be intuitive and would work well too.
>>>
>>> Sam, Michal, which one would you prefer? The latter might have the 
>>> advantage that it's additive, enabling future usages like:
>>>
>>> 	make addconfig kvm debug
>>
>> The problem is that neither of these fit into the make command syntax:
>>
>>     make addconfig kvm debug
>>
>> tells make to build three different targets, and
>>
>>     make addconfig=kvm
>>
>> tells make to create a variable named addconfig with the value kvm 
>> and build the default target. And BTW, you or someone else 
>> reassured me earlier in the thread that this is going to be needed 
>> for the kvm case solely, so why are you inventing something generic 
>> now? :)
> 
> Because we are trying to find *something* that is both usable and 
> which you guys are willing to ack.
> 
> So what's your suggestion? Is 'make kvmconfig' OK?

As I said, make kvmconfig is fine with me, if it's just this single case.

Michal

