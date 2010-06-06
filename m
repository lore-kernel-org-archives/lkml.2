Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab0FFHwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 03:52:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41701 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab0FFHwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 03:52:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RXzVKziueeLEPRf4SpHbjaRwPN3/YZJDte9Jm+ajuANVjC7G6LRFFuU2log7XGbpFM
         09cL2RysrrHbcnkDAqu0jDu61UqefiNCtubo5pBZLNSwfBcR3X9UuSraos3j7HMKlfFG
         QMtubV1XIbQXBlFP3X8JyItTet/1Nsxrb1hBM=
MIME-Version: 1.0
In-Reply-To: <AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com>
References: <20100603193045.GA7188@elte.hu>
	<20100603231153.GA11302@elte.hu>
	<20100603232302.GA16184@elte.hu>
	<AANLkTikZP3bmckpfb_jUdG7qZO5W9DgpZ79ugtSZaEpt@mail.gmail.com>
	<20100604071354.GA14451@elte.hu>
	<AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
	<20100604083423.GD15181@elte.hu>
	<AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com>
	<1275653210.27810.39762.camel@twins>
	<AANLkTinyjBa0KYfFz3_EFbC65hoQFwFINlTDYjCe-wM3@mail.gmail.com>
	<1275731653.27810.41078.camel@twins>
	<20100605092851.6ee15f13@infradead.org>
	<AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com>
Date: Sun, 6 Jun 2010 09:52:08 +0200
Message-ID: <AANLkTimKknOurmCffOpHjc1FjrP2MKf10pBwEEbLJPg_@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Vitaly Wool <vitalywool@gmail.com>
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Cc: Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/5 Arve Hjønnevåg <arve@android.com>:
> On Sat, Jun 5, 2010 at 9:28 AM, Arjan van de Ven <arjan@infradead.org> wrote:
>> On Sat, 05 Jun 2010 11:54:13 +0200
>> Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> On Fri, 2010-06-04 at 17:10 -0700, Arve Hjønnevåg wrote:
>>> > > Trusted processes are assumed to be sane and idle when there is
>>> > > nothing for them to do, allowing the machine to go into deep idle
>>> > > states.
>>> > >
>>> >
>>> > Neither the kernel nor our trusted user-space code currently meets
>>> > this criteria.
>>>
>>> Then both need fixing. Really, that's the only sane approach.
>>
>> fwiw... in MeeGo we're seeing quite good idle times (> 1 seconds)
>> without really bad hacks.
>>
>
> We clearly have different standards for what we consider good. We
> measure time suspended in minutes or hours, not seconds, and waking up
> every second or two causes a noticeable decrease in battery life on
> the hardware we have today.

Are you stating that the existing Android implementation enters the
suspended state for hours for any of the existing designs?

~Vitaly
