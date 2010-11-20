Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0KTXoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 18:44:39 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54675 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab0KTXoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 18:44:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bjNYfLueHLsq+8qnjp5S8f1RTUUAhj4fIihl6uMktRW68qEZu46VlSAL/YJRWeHWu6
         ZQ0L55kktmJqTNfiB0QGqLeXSrhIAvQVp/9pOqaxIG+hr6ogx6wytyj2ted+Qz5dnfJx
         YH4cfeaHHshlEqxUViYAQ6g/EGxUjmpr9oIeM=
MIME-Version: 1.0
In-Reply-To: <4CE7CF95.2040608@teksavvy.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
	<AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com>
	<AANLkTincYS7G1yb2ukT67qvpjwQmptXzQZabLQLYrEqn@mail.gmail.com>
	<AANLkTi=U7F7MS48dC=GgGqh=cm8YrtVhrm6sDXOma6Fc@mail.gmail.com>
	<AANLkTiki3d3Ft3-XJwFg8DUzUYcz3xPoYTzLZokLf+dv@mail.gmail.com>
	<4CE7CF95.2040608@teksavvy.com>
Date: Sun, 21 Nov 2010 07:44:36 +0800
Message-ID: <AANLkTik96z6cFYcAgRRsSwmCrAX7=Ckro5xRRhWaUVUM@mail.gmail.com>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
From: huang ying <huang.ying.caritas@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 9:39 PM, Mark Lord <kernel@teksavvy.com> wrote:
> On 10-11-20 02:11 AM, huang ying wrote:
>>
>> I think the BIOS error should be reported to hardware vendor instead
>> of software vendor. Do you think so?
>
> If you (and the code) are absolutely certain that a particular error
> instance
> is totally due to the BIOS, then stick the words "BIOS ERROR" into the
> printk().
>
> Problem solved.
>
> And in the even that the diagnosis is wrong, the rest of us will still
> have the complete picture of what happened from dmesg, rather than seeing
> random kernel errors (from other code) happen later without knowing there
> was some kind of BIOS or hardware fault that triggered it.
>
> Having them all in one place is rather useful.
> And you can still configure rsyslogd to _also_ send the BIOS/hardware
> errors to a separate destination, if that turns out to be useful.

I have no objection to report hardware errror with printk too. But we
need a user space hardware error daemon too, which needs a
tool-oriented interface. Do you think printk is a good interface for
tool to extract and parse error records? I think it is mainly human
oriented.

Best Regards,
Huang Ying
