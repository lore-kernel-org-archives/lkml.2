Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1GaA6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:58:20 -0400
Received: from science.horizon.com ([71.41.210.146]:10869 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751904Ab1GaA6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:58:14 -0400
Date: 30 Jul 2011 20:58:13 -0400
Message-ID: <20110731005813.11215.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com, tytso@mit.edu
In-Reply-To: <CA+55aFwdA_6W1GZZG76wVvmDQnEMj3hYBt6Md7GcFE02OkqiVA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Guys, if your argument is that you cannot possibly distinguish the
> Intel implementation from "true" randomness, then WHAT THE HELL are
> you complaining about?
>
> We don't even care. "True randomness" and "something we cannot
> possibly even test and distinguish from true randomess" are 100%
> equivalent. Stop with the idiotic "we cannot test it" crap. If it
> really is indistinguishable from true randomness, nobody will ever
> care.

Did you READ what I wrote beyond the first paragraph?

Because the LAST paragraph included a description of a
testable and verifiable hardware RNG.  To repeat:

>> A much more verifiable way would be to provide access to the raw hardware
>> generator, and enough hardware documentation to predict how its output
>> varies with environmental conditions (temperature, supply voltage, clock
>> speed, x-rays, ...) and lot-to-lot.  It would be extremely difficult
>> to produce a deterministic (i.e. back-door-able) generator with the
>> same sensitivities.

(Apologies for the bad grammar of "much more verifiable".)


The problem is not that's it's theoretically impossible to distinguish
them, but that it's PRACTICALLY impossible to distinguish true randomness
from a good counterfeiting effort.  As long as you're limited to
black-box testing.

That's counterfeiting, not incompetence.  The Intel RNG, if implemented
as described in their documentation, is quite well engineered.
(The basic architecture is essentially the same as /dev/urandom.)


I was just saying that it would be very easy to add a deliberate back
door, and the interface they provide fails to include any way to detect
such a thing.

> Seriously. This whole discussion just makes me convinced that security
> people are so far removed from reality that it's not even relevant any
> more.

The real world matters enormously.  Because that's where security
exploits happen, not in some mathematical abstraction that can be
proved secure.

I can build an RNG that nobody else can distinguish from truly random
until I start forging your signature on kernel releases.

Isn't that a bit LATE to be noticing the problem?
