Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab1CNMzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:55:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770Ab1CNMzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:55:40 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>, Jan Beulich <JBeulich@novell.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, binutils@sourceware.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alan Modra <amodra@gmail.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
References: <20110311165802.GA3508@intel.com>
	<4D7A64670200007800035F4C@vpn.id2.novell.com>
	<AANLkTikG8wa1Em0bEUddbYpYs2TzFFTDb95qWFJ3xSbv@mail.gmail.com>
	<4D7DE39302000078000362E6@vpn.id2.novell.com>
	<20110314095534.GB18058@elte.hu>
	<20110314104131.GG6275@bubble.grove.modra.org>
	<AANLkTi=3AiLaw5Gnis8Ha4eRXirk0s-Cnk2zzN12YDpH__45869.1711457961$1300099861$gmane$org@mail.gmail.com>
	<m3oc5eufrk.fsf@redhat.com>
	<AANLkTikOX_9G-kFEOCHJbnTootY4n4EPSounwjDjPiZc@mail.gmail.com>
	<m3fwqpvrjy.fsf@redhat.com> <20110314121321.GE23257@elte.hu>
X-Yow: CHUBBY CHECKER owns my BUILDING!
Date: Mon, 14 Mar 2011 13:55:10 +0100
In-Reply-To: <20110314121321.GE23257@elte.hu> (Ingo Molnar's message of "Mon,
	14 Mar 2011 13:13:21 +0100")
Message-ID: <m3bp1dvp3l.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Andreas Schwab <schwab@redhat.com> wrote:
>
>> Pekka Enberg <penberg@kernel.org> writes:
>> 
>> > Hi Andreas,
>> >
>> > Pekka Enberg <penberg@kernel.org> writes:
>> >>> So what do you suggest that testers who want to, say, build old Linux
>> >>> kernel versions with new binutils do?
>> >
>> > On Mon, Mar 14, 2011 at 1:02 PM, Andreas Schwab <schwab@redhat.com> wrote:
>> >> The same that testers have to do in order to build old Linux kernel
>> >> versions with current versions of make.
>> >
>> > Are you saying it's OK to screw over binutils users because GNU Make
>> > did that too?
>> 
>> I'm just telling you the facts.
>
> And you are wrong

This is just ridiculous.  You are defining away facts just because they
don't fit your view.

> latest Make does not break reasonably old kernel builds such as
> v2.6.30.

$ git tag --contains 3c955b4 | head -1
v2.6.36

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
