Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab1BIBqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 20:46:46 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39012 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab1BIBqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:46:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qlBy8nEZKsuIX2Ox5ReGG76JuQanZRmwYAyrn6HD/r2RjA0zc/q2xxyu4jAG9sPhz/
         uVgBm/ft/yUAIIsXmbHlkZK7U/Ze3Bo7999d6ulR+ZMbItJ27bQVpR5lSdycu/53omXe
         pDlcQ9ykIAO4u3rj/uFs2++lQGg7wAdyEbwx0=
MIME-Version: 1.0
In-Reply-To: <1297174680.13327.107.camel@laptop>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<20110208101730.GB7020@liondog.tnic>
	<1297161712.13327.100.camel@laptop>
	<20110208121108.GA4824@zhy>
	<20110208133457.GA5813@zhy>
	<1297172906.13327.104.camel@laptop>
	<1297174680.13327.107.camel@laptop>
Date: Wed, 9 Feb 2011 09:46:44 +0800
Message-ID: <AANLkTikb8-4+5xmuHQ-woA30Xtmaf95aKifnPSx8yTCJ@mail.gmail.com>
Subject: Re: lockdep: possible reason: unannotated irqs-off. (was: Re: Linux 2.6.38-rc4)
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, tglx <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 10:18 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-02-08 at 14:48 +0100, Peter Zijlstra wrote:
>>
>> Well that and modifying softirq bits for a lockdep annotation really
>> feels wrong.
>
> How about we revert it for this release and try again later?

No problem.

I'll take another look at this issue later.

Thanks,
Yong
