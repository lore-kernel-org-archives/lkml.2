Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab1HQAb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 20:31:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61587 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1HQAb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 20:31:58 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=6-3U9yaARtIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=_215YmrjArjZZLGXAsUA:9 a=-lb6ABCIPENFWEz99l4A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 1/8] perf: Separate out trace-cmd parse-events
 from perf files
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <4E4B0667.8090107@gmail.com>
References: <20110805205921.909038487@goodmis.org>
	 <20110805211300.324726820@goodmis.org>  <4E4945F8.2080004@gmail.com>
	 <1313425364.15704.9.camel@gandalf.stny.rr.com> <4E4B0667.8090107@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 16 Aug 2011 20:31:54 -0400
Message-ID: <1313541114.15704.35.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 18:08 -0600, David Ahern wrote:

> > They are based off of v3.0. You can get these patches from my repo as
> > described in the 0/8 announce email.
> 
> Unfortunately I hastily deleted the 0/8 thread while on vacation last
> week (gmail on Android thing), so I apologize for shifting the discussion.

Understood.

> 
> With a little bit of hacking on top of your patches I was able to get
> the trace-cmd plugins working with perf. e.g.,
>         qemu-kvm 11971 [001] 30401.777391: kvm_apic_accept_irq: apicid 0
> vec 239 (Fixed|edge)
>         qemu-kvm 11971 [001] 30401.777405: kvm_inj_virq: irq 239
>         qemu-kvm 11971 [001] 30401.777415: kvm_entry: vcpu 0
>         qemu-kvm 11971 [001] 30401.777430: kvm_exit: reason APIC_ACCESS
> rip 0xffffffff8101dbe4 info 10b0 0

That's awesome!

> 
> So, what is the next step for making this a reality -- i.e., getting the
> common code into a lib in tools?

Yeah, once everyone agrees with everything. I personally prefer things
to be in tools/lib/... and have all other tools depend on it. For the
names of these libraries, I'm game for anything.

Arnaldo, what's your preference, as you were the one that suggested that
it not be called libperf?

But I think this is a great step forward in making ftrace and perf work
better together :)

-- Steve


