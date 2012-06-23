Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2FWC2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 22:28:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38461 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab2FWC2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 22:28:09 -0400
References: <20120619232857.GH5996@aftab.osrc.amd.com> <1340182778.21745.75.camel@twins> <20120620095616.GB10012@aftab.osrc.amd.com> <1340186931.21745.90.camel@twins> <20120620101943.GE10012@aftab.osrc.amd.com> <1340187720.21745.97.camel@twins> <20120620102747.GF10012@aftab.osrc.amd.com> <1340188391.21745.99.camel@twins> <20120620110914.GA10771@aftab.osrc.amd.com> <4FE4C010.3020005@zytor.com> <20120623015458.GB22572@khazad-dum.debian.net>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120623015458.GB22572@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 22 Jun 2012 19:26:52 -0700
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <peterz@infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <561ca4ba-6e2d-4b58-9dba-4ca51afad204@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not quite.

Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

>On Fri, 22 Jun 2012, H. Peter Anvin wrote:
>> On 06/20/2012 04:09 AM, Borislav Petkov wrote:
>> > Yeah, both should be workable. Let's see what Intel wants to do:
>hpa,
>> > Fenghua?
>> 
>> What we want to do is to have a unified binary blob (which would be
>> about half that size) but the format may be affected by Fenghua's
>> ongoing work so we're not quite ready to rev the format now just to
>do
>> it again.
>
>Any reason why you can't just take a single file with one binary
>microcode
>appended back-to-back after the other (i.e. exactly what
>/dev/cpu/microcode
>accepts)?
>
>You'd only be able to release that memory after all cores were brought
>online [and any microcode that did get used to update a core was copied
>somewhere else for future use], but that's hardly a big problem.
>
>-- 
>  "One disk to rule them all, One disk to find them. One disk to bring
>  them all and in the darkness grind them. In the Land of Redmond
>  where the shadows lie." -- The Silicon Valley Tarot
>  Henrique Holschuh

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
